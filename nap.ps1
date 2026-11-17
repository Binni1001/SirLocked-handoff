# Nap mot phan code vao repo cuoi ky (Windows PowerShell).
# Cach dung (chay trong ban clone cua tranhuuanhkhoa/SirLocked):
#   powershell -ExecutionPolicy Bypass -File D:\duong\toi\SirLocked-handoff\nap.ps1 -Ngay 1 -Ten kiet
# Them -Push de day nhanh len GitHub ngay sau khi kiem tra xong.
param(
  [Parameter(Mandatory = $true)][ValidateSet(1, 2, 3)][int]$Ngay,
  [Parameter(Mandatory = $true)][ValidateSet('kiet', 'cau', 'hoang', 'khoa')][string]$Ten,
  [switch]$Push
)
$ErrorActionPreference = 'Stop'

$HandoffUrl = 'https://github.com/Binni1001/SirLocked-handoff.git'
$FinalRepo = 'tranhuuanhkhoa/SirLocked'
$Order = @('kiet', 'cau', 'hoang', 'khoa')
$Slug = @{ 1 = 'foundation-ui-economy'; 2 = 'gameplay-puzzles-cutscenes-audio'; 3 = 'admin-payments-ai-studio-pixel-cases' }
$Title = @{ 1 = 'foundation, case board UI and economy'; 2 = 'gameplay, puzzles, cutscenes and audio'; 3 = 'admin, payments, AI studio and pixel cases' }

function Invoke-Git {
  & git.exe @args
  if ($LASTEXITCODE -ne 0) { throw "Lenh git that bai: git $args" }
}
function GitOut {
  $out = & git.exe @args
  if ($LASTEXITCODE -ne 0) { throw "Lenh git that bai: git $args" }
  return ($out -join "`n").Trim()
}

$Idx = [array]::IndexOf($Order, $Ten)
$Slice = "day-0$Ngay-$($Idx + 1)-$Ten"
if ($Idx -gt 0) { $Prev = "day-0$Ngay-$Idx-$($Order[$Idx - 1])" }
elseif ($Ngay -gt 1) { $Prev = "day-0$($Ngay - 1)-4-khoa" }
else { $Prev = 'base' }
$Branch = "feature/phase3-day-0$Ngay-$Ten-$($Slug[$Ngay])"
$Msg = "phase3-day-0$Ngay($Ten): $($Title[$Ngay])"

# Repo co duong dan file dai (tai nguyen ai-generated); Windows can bat longpaths.
Invoke-Git config core.longpaths true
if (GitOut status --porcelain) { throw 'Thu muc dang co thay doi chua commit. Commit hoac bo di truoc.' }

& git.exe remote get-url handoff *> $null
if ($LASTEXITCODE -ne 0) { Invoke-Git remote add handoff $HandoffUrl }

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

if ($Push) { Invoke-Git push -u origin $Branch }
else { Write-Host "Kiem tra xong thi day len: git push -u origin $Branch" }
Write-Host "Mo PR vao develop: https://github.com/$FinalRepo/compare/develop...$($Branch)?expand=1"
Write-Host "Sau do tu merge PR (Create a merge commit) va bao nguoi tiep theo."
