# SirLocked: nạp code vào repo cuối kỳ (phase 3)

Repo này chỉ dùng để chuyển code. Nó chứa sẵn **12 phần code** (3 ngày × 4 người). Mỗi người lần lượt đưa phần của mình vào repo cuối kỳ [`tranhuuanhkhoa/SirLocked`](https://github.com/tranhuuanhkhoa/SirLocked), commit bằng tài khoản của mình rồi mở PR vào `develop`. **Khoa** là người merge.

- **Gốc:** `develop` hiện tại của repo cuối kỳ (PR #32, 14/10/2026). Repo này giữ bản đó ở nhánh `base`.
- **Đích:** sau phần cuối cùng, `develop` giống hệt bản đầy đủ mới nhất (nhánh làm việc `feat/claude-vu-an`, 17/11/2026), không thừa không thiếu một file.
- Các phần có khối lượng gần bằng nhau, khoảng 15–21 nghìn dòng mỗi phần.

## Lịch nạp

Thứ tự mỗi ngày: **Kiệt → Cầu → Hoàng → Khoa**. Người sau chỉ bắt đầu khi PR của người trước **đã được merge**.

### Ngày 1 (17/11/2026): foundation, case board UI and economy
| # | Người | Nhánh tạo trong repo cuối kỳ | File | Dòng (+/−) |
|---|---|---|---|---|
| 1 | Kiệt | `feature/phase3-day-01-kiet-foundation-ui-economy` | 85 | +15.928 / −690 |
| 2 | Cầu | `feature/phase3-day-01-cau-foundation-ui-economy` | 81 | +16.624 / −90 |
| 3 | Hoàng | `feature/phase3-day-01-hoang-foundation-ui-economy` | 71 | +18.455 / −168 |
| 4 | Khoa | `feature/phase3-day-01-khoa-foundation-ui-economy` | 67 | +16.900 / −187 |

### Ngày 2 (18/11/2026): gameplay, puzzles, cutscenes and audio
| # | Người | Nhánh | File | Dòng (+/−) |
|---|---|---|---|---|
| 1 | Kiệt | `feature/phase3-day-02-kiet-gameplay-puzzles-cutscenes-audio` | 120 | +19.098 / −166 |
| 2 | Cầu | `feature/phase3-day-02-cau-gameplay-puzzles-cutscenes-audio` | 92 | +17.111 / −2.307 |
| 3 | Hoàng | `feature/phase3-day-02-hoang-gameplay-puzzles-cutscenes-audio` | 200 | +15.273 / −750 |
| 4 | Khoa | `feature/phase3-day-02-khoa-gameplay-puzzles-cutscenes-audio` | 212 | +14.789 / −933 |

### Ngày 3 (19/11/2026): admin, payments, AI studio and pixel cases
| # | Người | Nhánh | File | Dòng (+/−) |
|---|---|---|---|---|
| 1 | Kiệt | `feature/phase3-day-03-kiet-admin-payments-ai-studio-pixel-cases` | 90 | +17.938 / −1.832 |
| 2 | Cầu | `feature/phase3-day-03-cau-admin-payments-ai-studio-pixel-cases` | 92 | +21.120 / −653 |
| 3 | Hoàng | `feature/phase3-day-03-hoang-admin-payments-ai-studio-pixel-cases` | 275 | +11.957 / −3.215 |
| 4 | Khoa | `feature/phase3-day-03-khoa-admin-payments-ai-studio-pixel-cases` | 97 | +19.086 / −535 |

Danh sách file của từng phần (A = thêm, M = sửa, D = xóa) nằm trong thư mục [`danh-sach/`](danh-sach/). Có thể dùng danh sách này khi viết `CHANGELOG.md` cá nhân.

## Chuẩn bị (mỗi người làm một lần)

1. Chấp nhận lời mời vào repo này. Repo để riêng tư, Kiệt sẽ mời qua email GitHub.
2. Bật đường dẫn dài **trước khi clone**. Repo có file nằm rất sâu, và Windows sẽ báo `Filename too long` nếu thiếu bước này:
   ```bash
   git config --global core.longpaths true
   ```
3. Kiểm tra tên và email git là của chính mình, vì commit sẽ đứng tên theo đó:
   ```bash
   git config --global user.name
   git config --global user.email
   ```
4. Clone hai repo, đặt ở thư mục có đường dẫn ngắn (ví dụ `D:\sl`):
   ```bash
   git clone https://github.com/tranhuuanhkhoa/SirLocked.git
   git clone --single-branch -b main https://github.com/Binni1001/SirLocked-handoff.git
   ```
   Repo handoff chỉ cần nhánh `main` (script và hướng dẫn). Code từng phần sẽ được script tự tải về.

## Đến lượt mình: 3 bước

**Bước 1: chạy script** trong thư mục `SirLocked` (repo cuối kỳ). Thay số ngày và tên cho đúng lượt của mình.

PowerShell:
```powershell
cd D:\sl\SirLocked
powershell -ExecutionPolicy Bypass -File ..\SirLocked-handoff\nap.ps1 -Ngay 1 -Ten kiet -Push
```

Git Bash:
```bash
cd /d/sl/SirLocked
bash ../SirLocked-handoff/nap.sh 1 kiet --push
```

Script tự làm những việc sau:
1. Kéo `develop` mới nhất.
2. Kiểm tra `develop` đã có đủ phần của người trước. Nếu chưa, script dừng lại.
3. Tạo nhánh đúng tên.
4. Đưa đúng phần code của mình vào, kể cả các file cần xóa.
5. Commit với message `phase3-day-0X(<ten>): <chu de>`.
6. Kiểm tra lại kết quả khớp từng file.
7. Đẩy nhánh lên GitHub.

Nếu muốn xem trước khi đẩy, bỏ `-Push` / `--push`. Script sẽ in sẵn lệnh `git push` để chạy sau.

**Bước 2: mở PR.** Script in ra link dạng `https://github.com/tranhuuanhkhoa/SirLocked/compare/develop...<nhanh>?expand=1`.
- Base là `develop`.
- Tiêu đề giữ nguyên message commit.
- Gán Khoa làm reviewer.

**Bước 3: báo nhóm** đã mở PR, rồi chờ Khoa merge. Người tiếp theo chỉ chạy script sau khi PR đã merge.

## Việc của Khoa (merge)

- Merge từng PR **theo đúng thứ tự** Kiệt → Cầu → Hoàng → Khoa, mỗi lần một PR, chọn **Create a merge commit**.
- Phần của Khoa là phần cuối mỗi ngày: Khoa tự mở PR rồi tự merge.
- **CI có thể đỏ ở các PR giữa chừng.** Code đầy đủ được chia nhỏ theo file, nên khi mới có một phần thì backend hoặc frontend có thể chưa build được. Cứ merge theo thứ tự. Sau phần cuối ngày 3, `develop` có đủ code và CI phải xanh trở lại.
- Không sửa thêm gì trên `develop` trong 3 ngày này. Nếu sửa, script của người sau sẽ báo "develop chưa khớp".

## Khi gặp lỗi

| Thông báo | Nghĩa là | Cách xử lý |
|---|---|---|
| `DUNG LAI: develop chua khop voi phan truoc` | PR của người trước chưa được merge, hoặc ai đó đã sửa `develop` | Chờ Khoa merge rồi chạy lại. Nếu đã merge rồi mà vẫn lỗi, báo Kiệt |
| `Thu muc dang co thay doi chua commit` | Repo trên máy đang có file sửa dở | Commit, hoặc bỏ thay đổi đó (`git stash push -m tam`), rồi chạy lại |
| `Filename too long` | Chưa bật longpaths | Chạy `git config --global core.longpaths true`, xóa thư mục clone rồi clone lại |
| `fatal: a branch named ... already exists` | Đã chạy script cho lượt này rồi | Nếu chưa push: `git checkout develop` rồi `git branch -D <nhanh>` và chạy lại. Nếu đã push: chỉ cần mở PR |
| `Repository not found` khi tải handoff | Chưa chấp nhận lời mời vào repo này | Kiểm tra email GitHub |

## Các nhánh trong repo này

- `main`: hướng dẫn này, `nap.ps1`, `nap.sh`, `danh-sach/`.
- `base`: `develop` của repo cuối kỳ trước khi nạp (PR #32).
- `day-0X-N-<ten>`: trạng thái đầy đủ của repo **sau** phần thứ N trong ngày X. Mỗi nhánh nối tiếp nhánh trước. Nhánh cuối `day-03-4-khoa` giống hệt bản đầy đủ.

Toàn bộ 12 lượt đã được chạy thử trên bản sao của repo cuối kỳ: script tạo đúng nhánh và commit, chặn lượt chạy sai thứ tự, và sau lượt cuối `develop` khớp hoàn toàn bản đầy đủ.
