# SirLocked: nạp code vào repo cuối kỳ (phase 3, đợt update-01)

Repo này chỉ dùng để chuyển code. Đợt này tên là **update-01**: nạp **một lượt**, chia thành **4 phần** theo thứ tự **Kiệt → Cầu → Hoàng → Khoa**. Mỗi người đưa phần của mình vào repo cuối kỳ [`tranhuuanhkhoa/SirLocked`](https://github.com/tranhuuanhkhoa/SirLocked), commit bằng tài khoản của mình, mở PR vào `develop` rồi **tự merge PR đó**. **Khoa** làm cuối cùng: merge phần của mình rồi merge `develop` vào `main`.

- **Gốc:** `develop` hiện tại của repo cuối kỳ, đã có phần ngày 1 của Kiệt ([PR #33](https://github.com/tranhuuanhkhoa/SirLocked/pull/33)). Repo này giữ bản đó ở nhánh `day-01-1-kiet`.
- **Đích:** sau phần của Khoa, `develop` giống hệt bản gộp mới nhất của nhóm (`gop/tong-hop-2026-11-19`, commit `34eaad9d`, 19/11/2026), trừ 2 tài liệu chứa địa chỉ VPS và SSH. Code còn có thể sửa tiếp; lần nạp sau sẽ là đợt `update-02`. Hai tài liệu đó không đưa lên repo cuối kỳ (repo này để công khai). Các script `scripts/deploy-server.sh` và `scripts/set-*.sh` vẫn có, nhưng không còn địa chỉ server mặc định: khi chạy phải tự đặt `SERVER=<user>@<địa-chỉ>` và `PORT=<cổng-ssh>`.
- Các phần ngày 2 và ngày 3 trước đây (`day-02-*`, `day-03-*`) **không dùng nữa**.

## Tiến độ

- Chưa ai nạp. Bắt đầu từ **Kiệt**.

## 4 phần

| # | Người | Nội dung | Nhánh tạo trong repo cuối kỳ | File | Dòng (+/−) |
|---|---|---|---|---|---|
| 1 | Kiệt | Web người chơi: trang, game, giao diện, ảnh; báo cáo phân tích | `feature/phase3-update-01-kiet-player-web-app` | 550 | +55.434 / −4.127 |
| 2 | Cầu | Backend (service, model, API), trang admin, bản thiết kế tính năng | `feature/phase3-update-01-cau-backend-admin` | 443 | +56.006 / −5.602 |
| 3 | Hoàng | Toàn bộ test tự động (unit, integration, giao diện) và script chạy | `feature/phase3-update-01-hoang-tests-scripts` | 247 | +58.258 / −1.473 |
| 4 | Khoa | Studio AI, công cụ, dữ liệu vụ án, tài liệu | `feature/phase3-update-01-khoa-ai-studio-tools-docs` | 417 | +58.678 / −165 |

Mỗi phần khoảng 59–62 nghìn dòng thay đổi. Danh sách file của từng phần (A = thêm, M = sửa, D = xóa) nằm trong [`danh-sach/update-01-*.txt`](danh-sach/), có thể dùng khi viết `CHANGELOG.md` cá nhân.

## Chuẩn bị (mỗi người làm một lần)

1. Bật đường dẫn dài **trước khi clone**. Repo có file nằm rất sâu, và Windows sẽ báo `Filename too long` nếu thiếu bước này:
   ```bash
   git config --global core.longpaths true
   ```
2. Kiểm tra tên và email git là của chính mình, vì commit sẽ đứng tên theo đó:
   ```bash
   git config --global user.name
   git config --global user.email
   ```
3. Clone hai repo, đặt ở thư mục có đường dẫn ngắn (ví dụ `D:\sl`). Ai đã clone từ lần trước thì chỉ cần `git pull` trong thư mục `SirLocked-handoff`.
   ```bash
   git clone https://github.com/tranhuuanhkhoa/SirLocked.git
   git clone --single-branch -b main https://github.com/Binni1001/SirLocked-handoff.git
   ```

## Đến lượt mình: 3 bước

Người sau chỉ bắt đầu khi người trước **đã tự merge PR của mình** vào `develop`.

**Bước 1: chạy script** trong thư mục `SirLocked` (repo cuối kỳ), thay `kiet` bằng tên mình.

PowerShell:
```powershell
cd D:\sl\SirLocked
powershell -ExecutionPolicy Bypass -File ..\SirLocked-handoff\nap.ps1 -Ten kiet -Push
```

Git Bash:
```bash
cd /d/sl/SirLocked
bash ../SirLocked-handoff/nap.sh kiet --push
```

Script tự làm những việc sau:
1. Kéo `develop` mới nhất.
2. Kiểm tra `develop` đã có đủ phần của người trước. Nếu chưa, script dừng lại.
3. Tạo nhánh đúng tên.
4. Đưa đúng phần code của mình vào, kể cả các file cần xóa.
5. Commit với message `phase3-update-01(<ten>): <noi dung>`.
6. Kiểm tra lại kết quả khớp từng file.
7. Đẩy nhánh lên GitHub.

Nếu muốn xem trước khi đẩy, bỏ `-Push` / `--push`. Script sẽ in sẵn lệnh `git push` để chạy sau.

**Bước 2: mở PR.** Script in ra link dạng `https://github.com/tranhuuanhkhoa/SirLocked/compare/develop...<nhanh>?expand=1`. Base là `develop`, tiêu đề giữ nguyên message commit. Với GitHub CLI:
```bash
gh pr create --repo tranhuuanhkhoa/SirLocked --base develop --head <nhanh> --fill
```

**Bước 3: tự merge PR của mình.** Trên trang PR, bấm **Merge pull request** và chọn **Create a merge commit**. Không chọn Squash hay Rebase. Với GitHub CLI:
```bash
gh pr merge <so-PR> --repo tranhuuanhkhoa/SirLocked --merge
```
Merge xong thì **báo người tiếp theo** trong nhóm.

- **CI có thể đỏ ở các PR giữa chừng.** Code được chia theo mảng, nên khi mới có một phần thì backend hoặc frontend có thể chưa build được. Cứ merge theo thứ tự. Sau phần của Khoa, `develop` có đủ code.
- Không sửa thêm gì trên `develop` trong lúc nạp. Nếu sửa, script của người sau sẽ báo "develop chưa khớp".

## Việc riêng của Khoa: đưa `develop` vào `main`

Sau khi tự merge PR của mình vào `develop`:

1. **Kiểm tra `develop` đã đủ 4 phần.** Chạy trong thư mục `SirLocked`:
   ```bash
   git fetch origin develop
   git fetch handoff update-01-4-khoa
   git diff --stat origin/develop handoff/update-01-4-khoa
   ```
   Lệnh **không in ra gì** nghĩa là đủ. Nếu lệnh liệt kê file thì còn PR của ai đó chưa merge: **dừng lại, chưa merge vào `main`**.
2. Mở PR từ `develop` vào `main`, rồi merge bằng **Create a merge commit**:
   ```bash
   gh pr create --repo tranhuuanhkhoa/SirLocked --base main --head develop --title "phase3-update-01: merge develop into main" --body "Phase 3 update-01: du 4 phan Kiet, Cau, Hoang, Khoa."
   gh pr merge <so-PR> --repo tranhuuanhkhoa/SirLocked --merge
   ```
3. Báo nhóm đã xong.

## Khi gặp lỗi

| Thông báo | Nghĩa là | Cách xử lý |
|---|---|---|
| `DUNG LAI: develop chua khop voi phan truoc` | Người trước chưa merge PR của mình, hoặc ai đó đã sửa `develop` | Nhắc người trước merge rồi chạy lại. Nếu đã merge rồi mà vẫn lỗi, báo Kiệt |
| `Thu muc dang co thay doi chua commit` | Repo trên máy đang có file sửa dở | Commit, hoặc bỏ thay đổi đó (`git stash push -m tam`), rồi chạy lại |
| `Filename too long` | Chưa bật longpaths | Chạy `git config --global core.longpaths true`, xóa thư mục clone rồi clone lại |
| `Push chua thanh cong` | Đăng nhập GitHub hoặc mạng bị lỗi lúc đẩy | Chạy lại đúng lệnh `git push -u origin <nhanh>` script in ra, rồi mở PR |
| `fatal: a branch named ... already exists` | Đã chạy script cho lượt này rồi | Nếu chưa push: `git checkout develop` rồi `git branch -D <nhanh>` và chạy lại. Nếu đã push: chỉ cần mở PR |

## Các nhánh trong repo này

- `main`: hướng dẫn này, `nap.ps1`, `nap.sh`, `danh-sach/`.
- `day-01-1-kiet`: `develop` hiện tại của repo cuối kỳ (gốc của lượt này).
- `update-01-N-<ten>`: trạng thái đầy đủ của repo **sau** phần thứ N. Mỗi nhánh nối tiếp nhánh trước. Nhánh cuối `update-01-4-khoa` là bản đích.
- `base`, `day-01-*` còn lại, `day-02-*`, `day-03-*`: của kế hoạch 3 ngày cũ, giữ để tra cứu.

Cả 4 lượt đã được chạy thử trên bản sao của repo cuối kỳ (Git Bash và PowerShell): script tạo đúng nhánh và commit, chặn lượt chạy sai thứ tự, và sau lượt của Khoa `develop` khớp hoàn toàn bản đích.
