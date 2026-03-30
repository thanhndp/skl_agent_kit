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

## Debugging
- Screenshot khi gặp visual issues — share cho AI
- Chạy terminal commands dài hạn ở background cho log visibility
- Dùng Esc Esc hoặc `/rewind` khi AI đi lệch — đừng cố sửa trong cùng context
