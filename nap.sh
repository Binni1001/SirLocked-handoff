#!/usr/bin/env bash
# Nap mot phan code vao repo cuoi ky.
# Cach dung (chay trong ban clone cua tranhuuanhkhoa/SirLocked):
#   bash /duong/toi/SirLocked-handoff/nap.sh <ngay 1|2|3> <kiet|cau|hoang|khoa>
# Them --push de day nhanh len GitHub ngay sau khi kiem tra xong.
set -euo pipefail

HANDOFF_URL="https://github.com/Binni1001/SirLocked-handoff.git"
FINAL_REPO="tranhuuanhkhoa/SirLocked"
ORDER=(kiet cau hoang khoa)
declare -A SLUG=(
  [1]="foundation-ui-economy"
  [2]="gameplay-puzzles-cutscenes-audio"
  [3]="admin-payments-ai-studio-pixel-cases"
)
declare -A TITLE=(
  [1]="foundation, case board UI and economy"
  [2]="gameplay, puzzles, cutscenes and audio"
  [3]="admin, payments, AI studio and pixel cases"
)

DAY="${1:?Thieu ngay (1, 2 hoac 3)}"
WHO="${2:?Thieu ten (kiet, cau, hoang, khoa)}"
PUSH="${3:-}"
[[ -n "${SLUG[$DAY]:-}" ]] || { echo "Ngay phai la 1, 2 hoac 3"; exit 1; }

IDX=-1
for i in "${!ORDER[@]}"; do [[ "${ORDER[$i]}" == "$WHO" ]] && IDX=$i; done
(( IDX >= 0 )) || { echo "Ten phai la mot trong: ${ORDER[*]}"; exit 1; }

SLICE="day-0${DAY}-$((IDX + 1))-${WHO}"
if (( IDX > 0 )); then
  PREV="day-0${DAY}-${IDX}-${ORDER[$((IDX - 1))]}"
elif (( DAY > 1 )); then
  PREV="day-0$((DAY - 1))-4-khoa"
else
  PREV="base"
fi
BRANCH="feature/phase3-day-0${DAY}-${WHO}-${SLUG[$DAY]}"
MSG="phase3-day-0${DAY}(${WHO}): ${TITLE[$DAY]}"

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
  echo "Doi Khoa merge PR cua nguoi truoc vao develop roi chay lai."
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
