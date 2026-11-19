# Nap phan code cua minh vao repo cuoi ky (Windows PowerShell), mot luot duy nhat.
# Cach dung (chay trong ban clone cua tranhuuanhkhoa/SirLocked):
#   powershell -ExecutionPolicy Bypass -File D:\duong\toi\SirLocked-handoff\nap.ps1 -Ten kiet
# Them -Push de day nhanh len GitHub ngay sau khi kiem tra xong.
param(
  [Parameter(Mandatory = $true)][ValidateSet('kiet', 'cau', 'hoang', 'khoa')][string]$Ten,
  [switch]$Push
)
$ErrorActionPreference = 'Stop'

$HandoffUrl = if ($env:SIRLOCKED_HANDOFF_URL) { $env:SIRLOCKED_HANDOFF_URL } else { 'https://github.com/Binni1001/SirLocked-handoff.git' }
$FinalRepo = 'tranhuuanhkhoa/SirLocked'
$Order = @('kiet', 'cau', 'hoang', 'khoa')
$Slug = @{ kiet = 'player-web-app'; cau = 'backend-admin'; hoang = 'tests-scripts'; khoa = 'ai-studio-tools-docs' }
$Title = @{
  kiet = 'player web app: pages, game, styles and assets'
  cau = 'backend services, admin pages and feature specs'
  hoang = 'automated tests and run scripts'
  khoa = 'AI studio, tools, case data and documents'
}

# git in tien do va canh bao ra stderr; Windows PowerShell coi do la loi neu de 'Stop'.
# Vi vay chi dua vao ma thoat cua git.
function Invoke-Git {
  $ErrorActionPreference = 'Continue'
  & git.exe @args 2>&1 | ForEach-Object { "$_" }
  if ($LASTEXITCODE -ne 0) { throw "Lenh git that bai: git $args" }
}
function GitOut {
  $ErrorActionPreference = 'Continue'
  $out = & git.exe @args 2>$null
  if ($LASTEXITCODE -ne 0) { throw "Lenh git that bai: git $args" }
  return ($out -join "`n").Trim()
}

$Idx = [array]::IndexOf($Order, $Ten)
$Slice = "final-$($Idx + 1)-$Ten"
# develop hien tai cua repo cuoi ky da co phan ngay 1 cua Kiet (PR #33) = nhanh day-01-1-kiet.
if ($Idx -gt 0) { $Prev = "final-$Idx-$($Order[$Idx - 1])" } else { $Prev = 'day-01-1-kiet' }
$Branch = "feature/phase3-final-$Ten-$($Slug[$Ten])"
$Msg = "phase3-final($Ten): $($Title[$Ten])"

# Repo co duong dan file dai (tai nguyen ai-generated); Windows can bat longpaths.
Invoke-Git config core.longpaths true
if (GitOut status --porcelain) { throw 'Thu muc dang co thay doi chua commit. Commit hoac bo di truoc.' }

if (@(GitOut remote) -split "`n" -notcontains 'handoff') { Invoke-Git remote add handoff $HandoffUrl }

Write-Host '== Lay code moi nhat'
Invoke-Git fetch origin
Invoke-Git fetch handoff $Slice $Prev
Invoke-Git checkout develop
Invoke-Git pull --ff-only origin develop

if ((GitOut rev-parse 'HEAD^{tree}') -ne (GitOut rev-parse "handoff/$Prev^{tree}")) {
  Write-Host "DUNG LAI: develop chua khop voi phan truoc ($Prev)."
  Write-Host 'Nhac nguoi truoc tu merge PR cua ho vao develop roi chay lai.'
  exit 1
}

Invoke-Git checkout -b $Branch
Write-Host "== Dua code phan $Slice vao"
Invoke-Git restore "--source=handoff/$Slice" --staged --worktree ':/'
Invoke-Git commit -q -m $Msg

if ((GitOut rev-parse 'HEAD^{tree}') -ne (GitOut rev-parse "handoff/$Slice^{tree}")) {
  throw "LOI: ket qua khong khop voi $Slice. Bao lai cho Kiet."
}
Invoke-Git show --stat --format='%h %an <%ae>' HEAD | Select-Object -Last 1
Write-Host "OK: nhanh $Branch khop dung phan $Slice."

if ($Push) {
  # Chay git push truc tiep (khong chuyen huong) de trinh dang nhap GitHub hien len duoc.
  $ErrorActionPreference = 'Continue'
  & git.exe push -u origin $Branch
  if ($LASTEXITCODE -ne 0) {
    Write-Host "Push chua thanh cong. Chay lai lenh nay: git push -u origin $Branch"
    exit 1
  }
}
else { Write-Host "Kiem tra xong thi day len: git push -u origin $Branch" }
Write-Host "Mo PR vao develop: https://github.com/$FinalRepo/compare/develop...$($Branch)?expand=1"
Write-Host "Sau do tu merge PR (Create a merge commit) va bao nguoi tiep theo."
