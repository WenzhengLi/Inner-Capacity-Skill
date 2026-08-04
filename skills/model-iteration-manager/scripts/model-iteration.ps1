[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('start', 'status', 'sync', 'record-review', 'mark-generated', 'validate', 'activate')]
    [string]$Action,

    [string]$ModelVersion,
    [string]$DialogueVersion,
    [string]$SkillPath,
    [string]$PreGenerationSnapshotPath,
    [string[]]$ApprovedModelId = @(),
    [string[]]$RejectedModelId = @(),
    [string[]]$DeferredModelId = @(),
    [string]$ApprovalEvidence,
    [switch]$ConfirmActivation,
    [string]$ProjectRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Set-ObjectProperty {
    param([object]$Object, [string]$Name, [object]$Value)
    $Object | Add-Member -NotePropertyName $Name -NotePropertyValue $Value -Force
}

function Save-Json {
    param([object]$Value, [string]$Path)
    $Value | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $Path -Encoding UTF8
}

function Get-ProjectPath {
    param([string]$Path, [switch]$MustExist)
    if ([string]::IsNullOrWhiteSpace($Path)) { throw 'Path is required.' }
    if ([IO.Path]::IsPathRooted($Path)) {
        $candidate = [IO.Path]::GetFullPath($Path)
    } else {
        $candidate = [IO.Path]::GetFullPath((Join-Path $script:ResolvedProjectRoot $Path))
    }
    $prefix = $script:ResolvedProjectRoot.TrimEnd('\') + '\'
    if ($candidate -ne $script:ResolvedProjectRoot -and -not $candidate.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Path escapes project root: $Path"
    }
    if ($MustExist -and -not (Test-Path -LiteralPath $candidate)) {
        throw "Required path does not exist: $candidate"
    }
    return $candidate
}

function Get-RelativeProjectPath {
    param([string]$AbsolutePath)
    $rootUri = [Uri]($script:ResolvedProjectRoot.TrimEnd('\') + '\')
    $pathUri = [Uri]$AbsolutePath
    return [Uri]::UnescapeDataString($rootUri.MakeRelativeUri($pathUri).ToString()).Replace('/', '\')
}

function Get-IterationDirectory {
    param([string]$Version, [switch]$MustExist)
    if ([string]::IsNullOrWhiteSpace($Version)) { throw 'ModelVersion is required.' }
    $normalized = $Version.Trim().TrimStart('v')
    if ($normalized -notmatch '^\d+(\.\d+){1,2}$') {
        throw "ModelVersion must look like 2.0 or 3.0.0: $Version"
    }
    $path = Get-ProjectPath "user-space\model-iterations\v$normalized"
    if ($MustExist -and -not (Test-Path -LiteralPath $path)) {
        throw "Iteration does not exist: v$normalized"
    }
    return $path
}

function Get-Manifest {
    param([string]$IterationDirectory)
    $path = Join-Path $IterationDirectory 'iteration.json'
    if (-not (Test-Path -LiteralPath $path)) { throw "Missing iteration manifest: $path" }
    return Get-Content -Raw -LiteralPath $path | ConvertFrom-Json
}

function Save-Manifest {
    param([object]$Manifest, [string]$IterationDirectory)
    Set-ObjectProperty $Manifest 'updated_at' ([DateTimeOffset]::Now.ToString('o'))
    Save-Json $Manifest (Join-Path $IterationDirectory 'iteration.json')
}

function Test-FilledMarkdown {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return $false }
    $content = Get-Content -Raw -LiteralPath $Path
    return (-not [string]::IsNullOrWhiteSpace($content)) -and ($content -notmatch 'PENDING_AUTOMATION')
}

function Test-SkillFrontmatter {
    param([string]$Path)
    $lines = @(Get-Content -LiteralPath $Path)
    if ($lines.Count -lt 4 -or $lines[0].Trim() -ne '---') { return $false }
    $end = -1
    for ($i = 1; $i -lt $lines.Count; $i++) {
        if ($lines[$i].Trim() -eq '---') { $end = $i; break }
    }
    if ($end -lt 2) { return $false }
    $keys = @()
    for ($i = 1; $i -lt $end; $i++) {
        if ($lines[$i] -match '^([A-Za-z0-9_-]+):') { $keys += $Matches[1] }
    }
    $actual = @($keys | Sort-Object -Unique)
    $expected = @('description', 'name')
    return (($actual -join ',') -eq ($expected -join ','))
}

$skillRoot = Split-Path $PSScriptRoot -Parent
$skillsRoot = Split-Path $skillRoot -Parent
$defaultProjectRoot = Split-Path $skillsRoot -Parent
if ([string]::IsNullOrWhiteSpace($ProjectRoot)) { $ProjectRoot = $defaultProjectRoot }
$script:ResolvedProjectRoot = (Resolve-Path -LiteralPath $ProjectRoot).Path

$statePath = Get-ProjectPath 'user-space\state.json' -MustExist
$state = Get-Content -Raw -LiteralPath $statePath | ConvertFrom-Json

$ApprovedModelId = @($ApprovedModelId | ForEach-Object { @($_ -split ',') } | ForEach-Object { $_.Trim() } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
$RejectedModelId = @($RejectedModelId | ForEach-Object { @($_ -split ',') } | ForEach-Object { $_.Trim() } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
$DeferredModelId = @($DeferredModelId | ForEach-Object { @($_ -split ',') } | ForEach-Object { $_.Trim() } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })

if ($Action -eq 'start') {
    $iterationDir = Get-IterationDirectory $ModelVersion
    if (Test-Path -LiteralPath $iterationDir) { throw "Iteration already exists; refusing overwrite: $iterationDir" }

    $templateDir = Get-ProjectPath 'templates\user-space\model-iterations\iteration-template' -MustExist
    New-Item -ItemType Directory -Path $iterationDir | Out-Null
    Copy-Item -Path (Join-Path $templateDir '*') -Destination $iterationDir -Recurse

    $normalized = $ModelVersion.Trim().TrimStart('v')
    Get-ChildItem -LiteralPath $iterationDir -File | ForEach-Object {
        if ($_.Extension -in @('.md', '.json')) {
            $content = Get-Content -Raw -LiteralPath $_.FullName
            $content = $content.Replace('{{MODEL_VERSION}}', $normalized)
            Set-Content -LiteralPath $_.FullName -Value $content -Encoding UTF8
        }
    }

    $manifest = [ordered]@{
        schema_version = 1
        model_version = $normalized
        status = 'evidence_collecting'
        created_at = [DateTimeOffset]::Now.ToString('o')
        updated_at = [DateTimeOffset]::Now.ToString('o')
        previous_user_model_path = 'user-space\USER_MODEL.md'
        previous_analysis_skill_path = $state.analysis_skill_path
        previous_dialogue_skill_path = $state.conversation_skill_path
        artifacts = [ordered]@{
            evidence = 'EVIDENCE.md'
            existing_models = 'EXISTING_MODELS.md'
            expansion_candidates = 'EXPANSION_CANDIDATES.md'
            candidates_json = 'candidates.json'
            model_review = 'MODEL_REVIEW.md'
            generation_plan = 'GENERATION_PLAN.md'
            validation = 'VALIDATION.md'
        }
        review = [ordered]@{
            status = 'pending'
            approved_model_ids = @()
            rejected_model_ids = @()
            deferred_model_ids = @()
            approval_evidence = $null
            reviewed_at = $null
        }
        generation = [ordered]@{
            status = 'pending'
            dialogue_version = $null
            skill_path = $null
            pre_generation_snapshot_path = $null
            generated_at = $null
        }
        validation = [ordered]@{
            status = 'pending'
            checks = @()
            validated_at = $null
        }
        activation = [ordered]@{
            status = 'pending'
            activated_at = $null
        }
    }
    Save-Json $manifest (Join-Path $iterationDir 'iteration.json')

    Set-ObjectProperty $state 'pending_model_iteration_path' (Get-RelativeProjectPath $iterationDir)
    Set-ObjectProperty $state 'iteration_status' 'evidence_collecting'
    Save-Json $state $statePath
    Write-Output "Started model iteration v$normalized at $iterationDir"
    exit 0
}

if ([string]::IsNullOrWhiteSpace($ModelVersion)) {
    if ($state.PSObject.Properties.Name -contains 'pending_model_iteration_path' -and -not [string]::IsNullOrWhiteSpace([string]$state.pending_model_iteration_path)) {
        $pendingName = Split-Path ([string]$state.pending_model_iteration_path) -Leaf
        $ModelVersion = $pendingName.TrimStart('v')
    } else {
        throw 'ModelVersion is required because no pending iteration is recorded.'
    }
}

$iterationDir = Get-IterationDirectory $ModelVersion -MustExist
$manifest = Get-Manifest $iterationDir

if ($Action -eq 'status') {
    $manifest | ConvertTo-Json -Depth 20
    exit 0
}

if ($Action -eq 'sync') {
    $evidenceReady = Test-FilledMarkdown (Join-Path $iterationDir 'EVIDENCE.md')
    $modelsReady = Test-FilledMarkdown (Join-Path $iterationDir 'EXISTING_MODELS.md')
    $candidateDocReady = Test-FilledMarkdown (Join-Path $iterationDir 'EXPANSION_CANDIDATES.md')
    $candidateData = Get-Content -Raw -LiteralPath (Join-Path $iterationDir 'candidates.json') | ConvertFrom-Json
    $candidatesReady = $candidateDocReady -and @($candidateData.candidates).Count -gt 0

    if (-not $evidenceReady) { $manifest.status = 'evidence_collecting' }
    elseif (-not $modelsReady) { $manifest.status = 'evidence_collecting' }
    elseif (-not $candidatesReady) { $manifest.status = 'existing_models_ready' }
    else { $manifest.status = 'awaiting_user_review' }

    Save-Manifest $manifest $iterationDir
    Set-ObjectProperty $state 'iteration_status' $manifest.status
    Save-Json $state $statePath
    Write-Output "Iteration status synchronized: $($manifest.status)"
    exit 0
}

if ($Action -eq 'record-review') {
    if ([string]::IsNullOrWhiteSpace($ApprovalEvidence)) { throw 'ApprovalEvidence must contain the user explicit words.' }
    if ($ApprovedModelId.Count -eq 0) { throw 'At least one ApprovedModelId is required.' }

    $candidatePath = Join-Path $iterationDir 'candidates.json'
    $candidateData = Get-Content -Raw -LiteralPath $candidatePath | ConvertFrom-Json
    $allIds = @($candidateData.candidates | ForEach-Object { [string]$_.id })
    $requested = @($ApprovedModelId + $RejectedModelId + $DeferredModelId | Sort-Object -Unique)
    foreach ($id in $requested) {
        if ($allIds -notcontains $id) { throw "Unknown candidate id: $id" }
    }

    foreach ($candidate in @($candidateData.candidates)) {
        if ($ApprovedModelId -contains [string]$candidate.id) { $candidate.status = 'approved' }
        elseif ($RejectedModelId -contains [string]$candidate.id) { $candidate.status = 'rejected' }
        elseif ($DeferredModelId -contains [string]$candidate.id) { $candidate.status = 'deferred' }
    }
    Save-Json $candidateData $candidatePath

    $now = [DateTimeOffset]::Now.ToString('o')
    $manifest.review.status = 'approved'
    $manifest.review.approved_model_ids = @($ApprovedModelId)
    $manifest.review.rejected_model_ids = @($RejectedModelId)
    $manifest.review.deferred_model_ids = @($DeferredModelId)
    $manifest.review.approval_evidence = $ApprovalEvidence
    $manifest.review.reviewed_at = $now
    $manifest.status = 'model_stack_approved'

    $review = @"
# Model Review $($manifest.model_version)

- review_status: approved
- reviewed_at: $now
- approval_evidence: $ApprovalEvidence

## Approved for trial

$($ApprovedModelId -join "`n")

## Rejected

$($RejectedModelId -join "`n")

## Deferred

$($DeferredModelId -join "`n")

Approval means trial use, not proven user ownership. Behavioral evidence is still required.
"@
    Set-Content -LiteralPath (Join-Path $iterationDir 'MODEL_REVIEW.md') -Value $review -Encoding UTF8
    Save-Manifest $manifest $iterationDir
    Set-ObjectProperty $state 'iteration_status' 'model_stack_approved'
    Save-Json $state $statePath
    Write-Output 'Recorded explicit user model review.'
    exit 0
}

if ($Action -eq 'mark-generated') {
    if ($manifest.review.status -ne 'approved') { throw 'User model review is not approved.' }
    if ([string]::IsNullOrWhiteSpace($DialogueVersion)) { throw 'DialogueVersion is required.' }
    $skillAbsolute = Get-ProjectPath $SkillPath -MustExist
    $skillRelative = Get-RelativeProjectPath $skillAbsolute
    $previousAbsolute = Get-ProjectPath ([string]$manifest.previous_dialogue_skill_path) -MustExist
    $isInPlaceRewrite = $skillAbsolute.Equals($previousAbsolute, [StringComparison]::OrdinalIgnoreCase)
    $snapshotRelative = $null
    if (-not [string]::IsNullOrWhiteSpace($PreGenerationSnapshotPath)) {
        $snapshotAbsolute = Get-ProjectPath $PreGenerationSnapshotPath -MustExist
        $snapshotRelative = Get-RelativeProjectPath $snapshotAbsolute
    }
    if ($isInPlaceRewrite -and [string]::IsNullOrWhiteSpace($snapshotRelative)) {
        throw 'PreGenerationSnapshotPath is required when rewriting the current dialogue Skill in place.'
    }
    $manifest.generation.status = 'generated'
    $manifest.generation.dialogue_version = $DialogueVersion.Trim().TrimStart('v')
    $manifest.generation.skill_path = $skillRelative
    Set-ObjectProperty $manifest.generation 'pre_generation_snapshot_path' $snapshotRelative
    $manifest.generation.generated_at = [DateTimeOffset]::Now.ToString('o')
    $manifest.status = 'skill_generated'
    Save-Manifest $manifest $iterationDir
    Set-ObjectProperty $state 'iteration_status' 'skill_generated'
    Save-Json $state $statePath
    Write-Output "Recorded generated Skill: $($manifest.generation.skill_path)"
    exit 0
}

if ($Action -eq 'validate') {
    $checks = New-Object System.Collections.Generic.List[object]
    $failures = New-Object System.Collections.Generic.List[string]

    foreach ($artifact in @('EVIDENCE.md', 'EXISTING_MODELS.md', 'EXPANSION_CANDIDATES.md', 'GENERATION_PLAN.md')) {
        $ok = Test-FilledMarkdown (Join-Path $iterationDir $artifact)
        $checks.Add([ordered]@{ check = "$artifact completed"; passed = $ok })
        if (-not $ok) { $failures.Add("Incomplete artifact: $artifact") }
    }

    $candidateData = Get-Content -Raw -LiteralPath (Join-Path $iterationDir 'candidates.json') | ConvertFrom-Json
    foreach ($candidate in @($candidateData.candidates)) {
        $sourceOk = -not [string]::IsNullOrWhiteSpace([string]$candidate.source_path) -and (Test-Path -LiteralPath (Get-ProjectPath ([string]$candidate.source_path)))
        $checks.Add([ordered]@{ check = "source:$($candidate.id)"; passed = $sourceOk })
        if (-not $sourceOk) { $failures.Add("Invalid source path for candidate: $($candidate.id)") }
    }

    $reviewOk = $manifest.review.status -eq 'approved' -and @($manifest.review.approved_model_ids).Count -gt 0 -and -not [string]::IsNullOrWhiteSpace([string]$manifest.review.approval_evidence)
    $checks.Add([ordered]@{ check = 'explicit user review'; passed = $reviewOk })
    if (-not $reviewOk) { $failures.Add('Explicit user review missing.') }

    $generatedOk = $manifest.generation.status -eq 'generated' -and -not [string]::IsNullOrWhiteSpace([string]$manifest.generation.skill_path)
    $checks.Add([ordered]@{ check = 'generation recorded'; passed = $generatedOk })
    if (-not $generatedOk) { $failures.Add('Generated Skill not recorded.') }

    if ($generatedOk) {
        $skillAbsolute = Get-ProjectPath ([string]$manifest.generation.skill_path) -MustExist
        $frontmatterOk = Test-SkillFrontmatter $skillAbsolute
        $checks.Add([ordered]@{ check = 'Skill frontmatter'; passed = $frontmatterOk })
        if (-not $frontmatterOk) { $failures.Add('Skill frontmatter must contain only name and description.') }

        $previousAbsolute = Get-ProjectPath ([string]$manifest.previous_dialogue_skill_path) -MustExist
        $isInPlaceRewrite = $skillAbsolute.Equals($previousAbsolute, [StringComparison]::OrdinalIgnoreCase)
        $snapshotPath = if ($manifest.generation.PSObject.Properties.Name -contains 'pre_generation_snapshot_path') { [string]$manifest.generation.pre_generation_snapshot_path } else { '' }
        $snapshotOk = -not $isInPlaceRewrite
        if ($isInPlaceRewrite -and -not [string]::IsNullOrWhiteSpace($snapshotPath)) {
            $snapshotOk = Test-Path -LiteralPath (Get-ProjectPath $snapshotPath)
        }
        $checks.Add([ordered]@{ check = 'pre-generation snapshot for in-place rewrite'; passed = $snapshotOk })
        if (-not $snapshotOk) { $failures.Add('In-place dialogue Skill rewrite requires a valid pre-generation snapshot.') }
    }

    $previousOk = Test-Path -LiteralPath (Get-ProjectPath ([string]$manifest.previous_dialogue_skill_path))
    $checks.Add([ordered]@{ check = 'previous dialogue preserved'; passed = $previousOk })
    if (-not $previousOk) { $failures.Add('Previous dialogue Skill is missing.') }

    $now = [DateTimeOffset]::Now.ToString('o')
    # Windows PowerShell 5 can throw "Argument types do not match" when the
    # array subexpression operator wraps a generic List[object]. Convert it
    # explicitly so validation behaves consistently across PowerShell versions.
    $manifest.validation.checks = $checks.ToArray()
    $manifest.validation.validated_at = $now
    if ($failures.Count -eq 0) {
        $manifest.validation.status = 'passed'
        $manifest.status = 'validated_ready_for_activation'
    } else {
        $manifest.validation.status = 'failed'
        $manifest.status = 'validation_failed'
    }

    $validationLines = @(
        "# Iteration Validation $($manifest.model_version)"
        ''
        "- validation_status: $($manifest.validation.status)"
        "- validated_at: $now"
        ''
        '## Checks'
        ''
    )
    foreach ($check in $checks) {
        $mark = if ($check.passed) { 'x' } else { ' ' }
        $validationLines += "- [$mark] $($check.check)"
    }
    if ($failures.Count -gt 0) {
        $validationLines += @('', '## Failures', '') + @($failures | ForEach-Object { "- $_" })
    }
    Set-Content -LiteralPath (Join-Path $iterationDir 'VALIDATION.md') -Value $validationLines -Encoding UTF8
    Save-Manifest $manifest $iterationDir
    Set-ObjectProperty $state 'iteration_status' $manifest.status
    Save-Json $state $statePath

    if ($failures.Count -gt 0) {
        $failures | ForEach-Object { Write-Error $_ }
        exit 1
    }
    Write-Output 'Iteration validation passed; ready for activation.'
    exit 0
}

if ($Action -eq 'activate') {
    if (-not $ConfirmActivation) { throw 'Activation requires -ConfirmActivation after user authorization.' }
    if ($manifest.status -ne 'validated_ready_for_activation' -or $manifest.validation.status -ne 'passed') {
        throw 'Iteration is not validated and ready for activation.'
    }

    $skillAbsolute = Get-ProjectPath ([string]$manifest.generation.skill_path) -MustExist
    $skillRelative = Get-RelativeProjectPath $skillAbsolute
    $now = [DateTimeOffset]::Now.ToString('o')
    Set-ObjectProperty $state 'user_model_version' ([string]$manifest.model_version)
    Set-ObjectProperty $state 'conversation_skill_path' $skillRelative
    Set-ObjectProperty $state 'user_skill_path' $skillRelative
    Set-ObjectProperty $state 'conversation_skill_version' ([string]$manifest.generation.dialogue_version)
    Set-ObjectProperty $state 'conversation_skill_generated_at' ([string]$manifest.generation.generated_at)
    Set-ObjectProperty $state 'conversation_skill_reviewed_at' ([string]$manifest.review.reviewed_at)
    Set-ObjectProperty $state 'model_review_completed' $true
    Set-ObjectProperty $state 'model_reviewed_at' ([string]$manifest.review.reviewed_at)
    Set-ObjectProperty $state 'active_model_iteration_path' (Get-RelativeProjectPath $iterationDir)
    Set-ObjectProperty $state 'pending_model_iteration_path' $null
    Set-ObjectProperty $state 'iteration_status' 'active'
    Save-Json $state $statePath

    $manifest.activation.status = 'active'
    $manifest.activation.activated_at = $now
    $manifest.status = 'active'
    Save-Manifest $manifest $iterationDir
    Write-Output "Activated model iteration v$($manifest.model_version) with dialogue $skillRelative"
    exit 0
}

throw "Unhandled action: $Action"
