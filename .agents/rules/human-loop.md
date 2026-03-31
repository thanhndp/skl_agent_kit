---
description: "Human-in-the-loop — Agent hỏi User trước khi thực hiện hành động nhạy cảm. Đặc biệt quan trọng cho Education context."
---

# SKL_AGENT Human-in-the-Loop

Agent KHÔNG được tự ý hành động khi: **confidence thấp, action nhạy cảm, hoặc ảnh hưởng tới học sinh/phụ huynh**.

## Hook Points

Gắn vào **giữa step 5 (plan) → step 9 (execute)**:

```
step 5: Build Plan
  → Human Loop Check
    ├── plan an toàn → continue to step 6
    └── plan cần confirm → PAUSE + hỏi User
        ├── User approve → continue
        ├── User modify → rebuild plan
        └── User reject → abort gracefully
```

## Trigger Conditions

### 🔴 ALWAYS ASK (Bắt buộc hỏi)

```yaml
always_confirm:
  - action: delete_file
    reason: "Xóa file không thể undo"

  - action: send_to_parent
    reason: "Gửi thông tin cho phụ huynh — phải chính xác 100%"

  - action: modify_grades
    reason: "Thay đổi điểm số — ảnh hưởng học sinh trực tiếp"

  - action: bulk_operation
    reason: "Thao tác hàng loạt — ảnh hưởng nhiều records"

  - action: external_communication
    reason: "Gửi email/webhook ra ngoài — không thu hồi được"

  - action: modify_system_rules
    reason: "Thay đổi rules của chính Agent — meta-level change"
```

### 🟡 ASK IF LOW CONFIDENCE

```yaml
ask_if_uncertain:
  threshold: 0.7

  conditions:
    - intent_confidence < 0.7
    - ambiguous_request    # User request có thể hiểu nhiều cách
    - missing_context      # Thiếu info để quyết định chính xác

  action: |
    🤔 Tôi hiểu yêu cầu này theo {interpretation_count} cách:
    1. {interpretation_1}
    2. {interpretation_2}
    Bạn muốn cách nào?
```

### 🟢 AUTO-PROCEED (Không cần hỏi)

```yaml
auto_proceed:
  - read_file           # Đọc file — an toàn
  - analyze_data        # Phân tích — không side effect
  - query_brain         # Hỏi Brain — read-only
  - generate_report     # Tạo report (draft) — User review sau
  - format_output       # Format text — cosmetic change
```

## Confirmation Flow

### Simple Confirm
Cho action đơn lẻ:

```
Agent: Tôi sẽ tạo file Excel điểm lớp 3A tại `3_output/diem_3A.xlsx`.
       Tiếp tục? (✅/❌)
User: ✅
Agent: [execute]
```

### Plan Review  
Cho multi-step plan:

```
Agent: Kế hoạch thực hiện:
       1. 📊 Đọc dữ liệu điểm từ `1_input/scores.csv`
       2. 📈 Phân tích: trung bình, min, max, phân loại
       3. 📄 Tạo báo cáo PDF tại `3_output/report.pdf`
       4. 📧 Gửi email cho phụ huynh qua webhook

       Bước 1-3 tôi tự động thực hiện.
       Bước 4 (gửi email) tôi sẽ hỏi lại trước khi gửi.
       
       Bắt đầu? (✅/❌/✏️ sửa)
```

### Escalation
Khi Agent không đủ confidence để tự quyết:

```
Agent: ⚠️ Tôi không chắc cách xử lý yêu cầu này:
       
       Yêu cầu: "{user_request}"
       Vấn đề: {why_uncertain}
       
       Gợi ý:
       A. {option_a}
       B. {option_b}
       C. Bạn hướng dẫn cụ thể hơn
```

## Education-Specific Rules

Trong context giáo dục, thêm các quy tắc đặc biệt:

```yaml
education_guards:
  student_data:
    # Dữ liệu học sinh = sensitive
    rule: "Mọi thao tác liên quan dữ liệu học sinh cần confirm"
    applies_to: [grades, attendance, reports, personal_info]

  parent_communication:
    # Giao tiếp phụ huynh = high stakes
    rule: "PHẢI review nội dung trước khi gửi"
    applies_to: [email, sms, report_card, feedback]

  assessment:
    # Đánh giá = phải chính xác
    rule: "Kết quả đánh giá phải được verify trước khi output"
    applies_to: [test_scores, evaluations, rankings]

  policy_interpretation:
    # Diễn giải chính sách = cần Brain verify
    rule: "Khi trả lời về policy/quy định → PHẢI query Brain, không dùng built-in knowledge"
    applies_to: [regulations, policies, standards, curriculum]
```

## Timeout Handling

```yaml
timeout:
  wait_for_user: 300    # Chờ User confirm max 5 phút
  
  on_timeout:
    - save_state          # Lưu progress vào task-progress.md
    - notify: "⏰ Đang chờ xác nhận của bạn cho bước tiếp theo."
    - remain_in_waiting_user_state   # Không tự proceed
```

## Anti-Patterns

```
❌ Tự ý gửi email/webhook không hỏi
❌ Sửa điểm số mà không confirm
❌ Xóa file không cảnh báo
❌ Đoán ý User khi confidence < 0.7
❌ Hỏi quá nhiều cho task đơn giản (read, analyze)
❌ Proceed khi User chưa respond (timeout = wait, không skip)
```
