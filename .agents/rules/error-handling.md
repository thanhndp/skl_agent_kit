---
description: "Error handling — retry, fallback, graceful degradation. Wrap step 9."
---

# SKL AGENT KIT Error Handling

Agent KHÔNG được fail im lặng. Mọi error phải có: **retry → fallback → thông báo User**.

## Hook Point

Wrap **step 9 (Execute)** trong execution engine:

```
step 9: Execute
  ├── try: execute tool/action
  │     ├── success → continue
  │     └── error → Error Handler
  │           ├── retry (nếu transient)
  │           ├── fallback (nếu tool unavailable)
  │           └── escalate (nếu cả 2 fail)
  └── continue pipeline
```

## Retry Logic

```yaml
retry:
  max_attempts: 2
  delay: 2s (exponential backoff)

  retryable_errors:
    - timeout              # Tool chạy quá lâu
    - rate_limit           # API quota tạm hết
    - network_error        # Mất kết nối tạm
    - transient_500        # Server error tạm thời

  non_retryable_errors:
    - permission_denied    # Không có quyền → không retry
    - invalid_input        # Input sai → sửa input, không retry
    - not_found           # File/resource không tồn tại → không retry
    - auth_expired        # Token hết hạn → cần re-auth
```

## Fallback Chain

Khi retry hết mà vẫn fail:

```yaml
fallback_chain:

  tool_failure:
    # Tool không hoạt động → thử nguồn thay thế
    chain:
      - retry tool (2 lần)
      - try alternative_tool (nếu có)
      - fallback to Brain query
      - fallback to local files
      - ask User

    message: |
      ⚠️ Tool {tool_name} không phản hồi sau 2 lần thử.
      Tôi đang dùng {fallback_source} thay thế.
      Kết quả có thể không đầy đủ như khi dùng {tool_name}.

  brain_failure:
    # Brain (NotebookLM) không kết nối
    chain:
      - retry Brain query (2 lần)
      - fallback to local docs/specs
      - use Agent's built-in knowledge (với warning)
      - ask User

    message: |
      ⚠️ Không kết nối được Brain (NotebookLM).
      Tôi trả lời dựa trên {fallback_source}.
      Kết quả chưa được verify qua knowledge base.

  model_failure:
    # Model hiện tại hết quota
    chain:
      - cascade fallback theo model-routing.yaml
      - thông báo theo notification template

    message: |
      ⚠️ Model {current_model} hết quota.
      Đã chuyển sang {fallback_model}.
      Output quality có thể khác — thử lại sau nếu cần.

  file_operation_failure:
    # Ghi/đọc file lỗi
    chain:
      - retry (permission issue?)
      - try alternative path
      - ask User for manual action

    message: |
      ❌ Không thể {operation} file {file_path}.
      Lý do: {error_detail}
      Bạn có thể kiểm tra quyền truy cập hoặc thực hiện thủ công?
```

## Error Response Format

Khi error xảy ra, Agent PHẢI báo User theo format:

```
⚠️ **Lỗi:** {mô tả ngắn}
📍 **Bước:** {step nào trong plan}
🔄 **Đã thử:** {retry count} lần
🔀 **Fallback:** {đang dùng gì thay thế}
💡 **Đề xuất:** {User nên làm gì}
```

## Graceful Degradation

Agent phải **tiếp tục hoạt động** dù mất 1 layer:

| Layer mất | Agent vẫn làm được |
|-----------|-------------------|
| Brain offline | Xử lý bằng local knowledge + tools |
| Tools fail | Trả lời bằng Brain + built-in knowledge |
| Memory empty | Hoạt động bình thường, hỏi User preferences |
| Cache fail | Chạy fresh mọi thứ (chậm hơn nhưng đúng) |
| Model fallback | Dùng model thấp hơn, quality giảm nhưng vẫn chạy |

## Anti-Patterns

```
❌ Fail im lặng — User không biết có lỗi
❌ Retry vô hạn — tốn resource, User chờ mãi
❌ Dừng toàn bộ plan vì 1 step fail
❌ Retry non-retryable error (permission, not_found)
❌ Không log error — không learn được từ failure
```
