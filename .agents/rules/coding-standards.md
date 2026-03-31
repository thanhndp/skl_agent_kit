# Coding Standards & Best Practices

## Planning
- Luôn bắt đầu bằng plan mode cho tasks phức tạp
- Phỏng vấn user trước khi implement — hiểu rõ requirements
- Tạo plan theo phase, mỗi phase có tests riêng (unit, integration)

## Context Management
- Thực hiện manual `/compact` ở ~50% context usage — tránh "agent dumb zone"
- Dùng `/clear` để reset context khi chuyển task hoàn toàn mới
- Break tasks đủ nhỏ để hoàn thành trong dưới 50% context

## Code Quality
- 1 file = 1 responsibility — tách nếu quá lớn
- Dùng relative links giữa các docs
- Giữ heading hierarchy đúng thứ tự (đừng nhảy từ `##` sang `####`)
- Comments giải thích WHY, không giải thích WHAT

## Commit & Version Control
- Commit ít nhất 1 lần/giờ — ngay khi task hoàn thành
- Co-authored commit messages khi AI tham gia
- Dùng `/rename` cho sessions quan trọng, `/resume` để tiếp tục sau

## Windows Batch Files (.bat)

### KHÔNG dùng tiếng Việt có dấu trong file .bat
- `cmd.exe` parser đếm offset theo byte đơn (ANSI), nhưng ký tự UTF-8 có dấu chiếm 2-3 bytes
- Hậu quả: parser nhảy sai vị trí, cắt nhầm giữa từ → lỗi `'xxx' is not recognized as an internal or external command`
- Lỗi này xảy ra **ngay cả khi đã có `chcp 65001`** — vì `chcp` chỉ ảnh hưởng hiển thị, không sửa parser
- **Quy tắc:** Mọi text trong `.bat` phải dùng **ASCII thuần / tiếng Việt không dấu**
- File `.sh` (Bash) không bị lỗi này — có thể giữ tiếng Việt có dấu

### KHÔNG dùng `pause` trong file .bat
- `pause` chặn tiến trình chờ người dùng bấm phím từ Console (`CON`)
- Khi AI agent hoặc CI/CD gọi script ngầm, không có Console → **tiến trình treo vĩnh viễn**
- **Quy tắc:** Xóa `pause`, hoặc chỉ dùng có điều kiện: `if "%~1"=="" pause`

### Hỗ trợ non-interactive mode cho script tương tác
- Lệnh `set /p` (bat) và `read -p` (sh) chờ input → treo nếu chạy tự động
- **Quy tắc:** Luôn hỗ trợ truyền tham số dòng lệnh (CLI args) làm fallback:
```bat
:: .bat — ưu tiên arg, fallback sang hỏi user
if "%~1" neq "" (set choice=%~1) else (set /p choice="Chon: ")
```
```bash
# .sh — ưu tiên arg, fallback sang hỏi user
if [ -n "$1" ]; then choice="$1"; else read -p "Chon: " choice; fi
```

## Debugging
- Screenshot khi gặp visual issues — share cho AI
- Chạy terminal commands dài hạn ở background cho log visibility
- Dùng Esc Esc hoặc `/rewind` khi AI đi lệch — đừng cố sửa trong cùng context
