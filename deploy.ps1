<#
  部署個人網站（beck-resume）
  流程：把 OneDrive「桌面\私人用\beck-resume.html」複製成 public\index.html → git push
        → GitHub Actions 部署 GitHub Pages ＋ Cloudflare Workers Builds 自動部署（兩邊同時）
  用法：右鍵「用 PowerShell 執行」，或跟 Claude 說「部署個人網站」
#>

$ErrorActionPreference = "Stop"
$Repo = $PSScriptRoot
$OD   = Join-Path $env:USERPROFILE "OneDrive - 珍食堡實業股份有限公司"
$Src  = Join-Path $OD "桌面\私人用\beck-resume.html"
$Dst  = Join-Path $Repo "public\index.html"

Write-Host "=== 個人網站 部署 ===" -ForegroundColor Cyan

if (-not (Test-Path $Src)) {
  Write-Host "找不到原始檔：$Src" -ForegroundColor Red
  Write-Host "（請確認 OneDrive 已同步下來；若檔案改名或搬家，改本腳本的 `$Src）" -ForegroundColor Yellow
  exit 1
}

# 1) 同步原始檔到 public\index.html（public\ 內其他檔案不動）
Write-Host "[1/2] 複製 beck-resume.html -> public\index.html" -ForegroundColor Yellow
Copy-Item $Src $Dst -Force

# 2) commit + push
Write-Host "[2/2] 推上 GitHub..." -ForegroundColor Yellow
Push-Location $Repo
git add -A
$changed = git status --porcelain
if ([string]::IsNullOrWhiteSpace($changed)) {
  Write-Host "沒有變更，不需要部署。" -ForegroundColor Green
  Pop-Location
  exit 0
}
git commit -m ("更新個人網站 " + (Get-Date -Format "yyyy-MM-dd HH:mm")) | Out-Null
git push
Pop-Location

Write-Host ""
Write-Host "完成！兩邊會在 1-2 分鐘內自動部署：" -ForegroundColor Green
Write-Host "  GitHub Pages : https://beck0404.github.io/beck-resume/" -ForegroundColor Green
Write-Host "  Cloudflare   : https://beck-resume.beck810404.workers.dev" -ForegroundColor Green
