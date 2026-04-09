param(
    [string]$Registry = "ghcr.io/absmach/magistrala",
    [string]$Tag = "latest",
    [ValidateSet("api", "core", "full")]
    [string]$Profile = "api",
    [string]$GoArch = "amd64",
    [string]$GoArm = "",
    [string]$BuildTags = "",
    [switch]$Push,
    [switch]$IncludeCli
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    throw "docker command not found in PATH"
}

$mgMessageBrokerType = if ($env:MG_MESSAGE_BROKER_TYPE) { $env:MG_MESSAGE_BROKER_TYPE } else { "msg_fluxmq" }
$mgEsType = if ($env:MG_ES_TYPE) { $env:MG_ES_TYPE } else { "es_fluxmq" }
if ([string]::IsNullOrWhiteSpace($BuildTags)) {
    $BuildTags = "$mgMessageBrokerType $mgEsType"
}

$version = if ($env:VERSION) { $env:VERSION } else { $Tag }
$commit = if ($env:COMMIT) { $env:COMMIT } else { (git rev-parse HEAD).Trim() }
$time = if ($env:TIME) { $env:TIME } else { Get-Date -Format "yyyy-MM-dd_HH:mm:ss" }

$coreServices = @(
    "auth",
    "users",
    "clients",
    "groups",
    "channels",
    "domains",
    "notifications",
    "notifiers-api",
    "journal",
    "re",
    "alarms",
    "reports",
    "certs",
    "fluxmq"
)

$apiServices = @(
    "auth",
    "users",
    "clients",
    "groups",
    "channels",
    "domains",
    "notifications",
    "notifiers-api",
    "journal",
    "re",
    "alarms",
    "reports",
    "certs",
    "bootstrap",
    "timescale-reader"
)

$addonServices = @(
    "bootstrap",
    "provision",
    "postgres-writer",
    "postgres-reader",
    "timescale-writer",
    "timescale-reader"
)

$services = @()
switch ($Profile) {
    "api" { $services += $apiServices }
    "core" { $services += $coreServices }
    "full" { $services += $coreServices; $services += $addonServices }
}

if ($IncludeCli) {
    $services += "cli"
}

Write-Host "Registry      : $Registry"
Write-Host "Tag           : $Tag"
Write-Host "Profile       : $Profile"
Write-Host "Push          : $Push"
Write-Host "Include CLI   : $IncludeCli"
Write-Host "GOARCH/GOARM  : $GoArch/$GoArm"
Write-Host "Build tags    : $BuildTags"
Write-Host "Services ($($services.Count)): $($services -join ', ')"
Write-Host ""

foreach ($svc in $services) {
    $image = "${Registry}/${svc}:$Tag"
    Write-Host "==> Building $image"

    $args = @(
        "build",
        "--build-arg", "SVC=$svc",
        "--build-arg", "GOARCH=$GoArch",
        "--build-arg", "GOARM=$GoArm",
        "--build-arg", "VERSION=$version",
        "--build-arg", "COMMIT=$commit",
        "--build-arg", "TIME=$time",
        "--build-arg", "BUILD_TAGS=$BuildTags",
        "--tag", $image,
        "-f", "docker/Dockerfile",
        "."
    )

    & docker @args
    if ($LASTEXITCODE -ne 0) {
        throw "docker build failed for $svc"
    }

    if ($Push) {
        Write-Host "==> Pushing $image"
        & docker push $image
        if ($LASTEXITCODE -ne 0) {
            throw "docker push failed for $svc"
        }
    }
}

Write-Host ""
Write-Host "Done. Built $($services.Count) image(s)."
