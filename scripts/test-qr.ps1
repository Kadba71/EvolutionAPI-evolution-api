param(
  [Parameter(Mandatory=$true)][string]$Domain,
  [Parameter(Mandatory=$true)][string]$ApiKey,
  [string[]]$Tags = @(
    'v2.3.7','v2.3.6','v2.3.5','v2.3.4','v2.3.3','v2.3.2','v2.3.1','v2.3.0',
    'v2.2.3','v2.2.2','v2.2.1','v1.8.7','v1.8.6','v1.8.5','v1.8.4','v1.8.3'
  ),
  [int]$TimeoutSeconds = 600
)

$ErrorActionPreference = 'Stop'

function Write-Info($msg){ Write-Host "[INFO] $msg" -ForegroundColor Cyan }
function Write-Ok($msg){ Write-Host "[ OK ] $msg" -ForegroundColor Green }
function Write-Warn($msg){ Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Err($msg){ Write-Host "[ERR ] $msg" -ForegroundColor Red }

$repoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$dockerfilePath = Join-Path $repoRoot 'Dockerfile'

function Update-DockerTag([string]$tag){
  Write-Info "Pin Docker image to atendai/evolution-api:$tag"
  $content = Get-Content -Path $dockerfilePath -Raw
  $updated = $content -replace "FROM\s+atendai/evolution-api:[^\r\n]+","FROM atendai/evolution-api:$tag"
  if($updated -ne $content){
    Set-Content -Path $dockerfilePath -Value $updated -Encoding UTF8
  } else {
    Write-Warn "No change detected in Dockerfile; ensuring line exists"
  }
}

function Publish-Changes([string]$tag){
  Push-Location $repoRoot
  git add $dockerfilePath | Out-Null
  git commit -m "chore(test-qr): pin atendai/evolution-api:$tag for QR test" | Out-Null
  git push | Out-Null
  Pop-Location
  Write-Ok "Pushed tag $tag; Railway should redeploy automatically"
}

function Wait-Service([int]$timeout){
  $sw = [System.Diagnostics.Stopwatch]::StartNew()
  do {
    try {
      $resp = Invoke-RestMethod -Method Get -Uri "$Domain/" -TimeoutSec 30
      if($resp.version){
        Write-Ok "Service up. Version: $($resp.version)"
        return $true
      } else {
        Write-Info "Service responding without version; retrying..."
      }
    } catch {
      Start-Sleep -Seconds 5
    }
  } while($sw.Elapsed.TotalSeconds -lt $timeout)
  return $false
}

function New-Instance([string]$name){
  $body = @{ instanceName = $name; token = "token-$name"; qrcode = $true } | ConvertTo-Json
  $headers = @{ apikey = $ApiKey }
  try {
    Invoke-RestMethod -Method Post -Uri "$Domain/instance/create" -Headers $headers -ContentType 'application/json' -Body $body -TimeoutSec 60 | Out-Null
    Write-Ok "Instance created: $name"
    return $true
  } catch {
    Write-Warn "Create instance failed (may already exist): $($_.Exception.Message)"
    return $false
  }
}

function Get-QR([string]$name){
  $headers = @{ apikey = $ApiKey }
  try {
    $resp = Invoke-RestMethod -Method Get -Uri "$Domain/instance/connect/$name" -Headers $headers -TimeoutSec 60
    Write-Ok "QR response received"
    $json = $resp | ConvertTo-Json -Depth 6
    Write-Host $json
    return $true
  } catch {
    Write-Err "QR fetch failed: $($_.Exception.Message)"
    return $false
  }
}

foreach($tag in $Tags){
  Write-Host "`n===== Testing tag: $tag =====" -ForegroundColor Magenta
  try {
    Update-DockerTag -tag $tag
    Publish-Changes -tag $tag
    Write-Info "Waiting service to be available ($TimeoutSeconds s)"
    if(-not (Wait-Service -timeout $TimeoutSeconds)){
      Write-Err "Service did not come up in time for $tag"
      continue
    }
    $iname = ("qrtest-" + ($tag -replace '\.','_') + "-" + (Get-Random))
    New-Instance -name $iname | Out-Null
    if(Get-QR -name $iname){
      Write-Ok "Tag $tag produced a QR. Instance: $iname"
      break
    } else {
      Write-Warn "Tag $tag did not return QR; moving on"
    }
  } catch {
    Write-Err "Unexpected error on tag ${tag}: $($_.Exception.Message)"
  }
}
