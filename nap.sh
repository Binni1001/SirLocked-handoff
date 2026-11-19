#!/usr/bin/env bash
# Nap phan code cua minh vao repo cuoi ky, dot cap nhat update-01.
# Cach dung (chay trong ban clone cua tranhuuanhkhoa/SirLocked):
#   bash /duong/toi/SirLocked-handoff/nap.sh <kiet|cau|hoang|khoa>
# Them --push de day nhanh len GitHub ngay sau khi kiem tra xong.
set -euo pipefail

HANDOFF_URL="${SIRLOCKED_HANDOFF_URL:-https://github.com/Binni1001/SirLocked-handoff.git}"
FINAL_REPO="tranhuuanhkhoa/SirLocked"
ORDER=(kiet cau hoang khoa)
declare -A SLUG=([kiet]="player-web-app" [cau]="backend-admin" [hoang]="tests-scripts" [khoa]="ai-studio-tools-docs")
declare -A TITLE=(
  [kiet]="player web app: pages, game, styles and assets"
  [cau]="backend services, admin pages and feature specs"
  [hoang]="automated tests and run scripts"
  [khoa]="AI studio, tools, case data and documents"
)

WHO="${1:?Thieu ten (kiet, cau, hoang, khoa)}"
PUSH="${2:-}"

IDX=-1
for i in "${!ORDER[@]}"; do [[ "${ORDER[$i]}" == "$WHO" ]] && IDX=$i; done
(( IDX >= 0 )) || { echo "Ten phai la mot trong: ${ORDER[*]}"; exit 1; }

SLICE="update-01-$((IDX + 1))-${WHO}"
# develop hien tai cua repo cuoi ky da co phan ngay 1 cua Kiet (PR #33) = nhanh day-01-1-kiet.
if (( IDX > 0 )); then PREV="update-01-${IDX}-${ORDER[$((IDX - 1))]}"; else PREV="day-01-1-kiet"; fi
BRANCH="feature/phase3-update-01-${WHO}-${SLUG[$WHO]}"
MSG="phase3-update-01(${WHO}): ${TITLE[$WHO]}"

git rev-parse --show-toplevel >/dev/null
# Repo co duong dan file dai (tai nguyen ai-generated); Windows can bat longpaths.
git config core.longpaths true
[[ -z "$(git status --porcelain)" ]] || { echo "Thu muc dang co thay doi chua commit. Commit hoac bo di truoc."; exit 1; }

git remote get-url handoff >/dev/null 2>&1 || git remote add handoff "$HANDOFF_URL"
echo "== Lay code moi nhat"
git fetch origin
git fetch handoff "$SLICE" "$PREV"

git checkout develop
git pull --ff-only origin develop

if [[ "$(git rev-parse 'HEAD^{tree}')" != "$(git rev-parse "handoff/$PREV^{tree}")" ]]; then
  echo "DUNG LAI: develop chua khop voi phan truoc ($PREV)."
  echo "Nhac nguoi truoc tu merge PR cua ho vao develop roi chay lai."
  exit 1
fi

git checkout -b "$BRANCH"
echo "== Dua code phan $SLICE vao"
git restore --source="handoff/$SLICE" --staged --worktree :/
git commit -q -m "$MSG"

if [[ "$(git rev-parse 'HEAD^{tree}')" != "$(git rev-parse "handoff/$SLICE^{tree}")" ]]; then
  echo "LOI: ket qua khong khop voi $SLICE. Bao lai cho Kiet."; exit 1
fi
git show --stat --format='%h %an <%ae>%n%s' HEAD | tail -1
echo "OK: nhanh $BRANCH khop dung phan $SLICE."

if [[ "$PUSH" == "--push" ]]; then
  git push -u origin "$BRANCH"
else
  echo "Kiem tra xong thi day len: git push -u origin $BRANCH"
fi
echo "Mo PR vao develop: https://github.com/${FINAL_REPO}/compare/develop...${BRANCH}?expand=1"
echo "Sau do tu merge PR (Create a merge commit) va bao nguoi tiep theo."
