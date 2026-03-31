# 🧪 SKL AGENT KIT Test Simulation

> Validate execution engine bằng 5 test scenarios.
> Mở project trong AI IDE → chạy từng scenario → verify output.

---

## Cách Chạy

1. Clone repo & setup: `setup.bat` hoặc `./setup.sh`
2. Mở trong AI IDE (Antigravity / Cursor)
3. Chạy từng test scenario bên dưới
4. So sánh output với expected result
5. Ghi kết quả vào bảng cuối file

---

## Test 1: Knowledge Query (Brain Route)

**Input:** `"Chuẩn đánh giá môn Toán lớp 5 là gì?"`

| Step | Expected |
|------|----------|
| Intent | `knowledge_query` |
| Route | Brain (NotebookLM) |
| Tools | `notebook_query` |
| Model | Tier 2 |
| Confirm | Không |

**Pass:** Intent đúng · Route Brain · Không hallucinate

---

## Test 2: Action Request (Tool Route)

**Input:** `"Tạo file Excel điểm học sinh lớp 3A"`

| Step | Expected |
|------|----------|
| Intent | `action_request` |
| Route | Tools (write_to_file) |
| Model | Tier 2+ |
| Confirm | ✅ CÓ (tạo file) |

**Pass:** Confirm trước tạo · File .xlsx tạo đúng · Format chuyên nghiệp

---

## Test 3: Multi-step (Plan Route)

**Input:** `"Phân tích điểm rồi gửi báo cáo cho phụ huynh"`

| Step | Expected |
|------|----------|
| Intent | `[analysis, action_request]` |
| Plan | 3+ steps |
| Model | Tier 3 |
| Confirm | ✅ (gửi PH = external) |

**Pass:** Multi-intent detected · Plan 3+ steps · Confirm ở step "gửi"

---

## Test 4: Failure & Fallback

**Setup:** Tắt Brain (`brain.yaml` → `enabled: false`)

**Input:** `"Quy trình xử lý kỷ luật học sinh?"`

| Step | Expected |
|------|----------|
| Route | Brain → FAIL → Fallback |
| Fallback | Local docs → ask user |
| Error | ⚠️ Warning hiển thị |

**Pass:** Warning message · Fallback hoạt động · Không bịa

---

## Test 5: Cost Control

**Simple:** `"SKL là viết tắt của gì?"` → Tier 1, < 2000 tokens

**Complex:** `"Thiết kế lại hệ thống chấm điểm 12 khối"` → Tier 3+, > 15000 tokens

**Pass:** Simple → cheap model · Complex → strong model

---

## 📊 Kết Quả

| Test | Scenario | Status | Notes |
|------|----------|--------|-------|
| 1 | Knowledge Query | ⬜ | |
| 2 | Action Request | ⬜ | |
| 3 | Multi-step | ⬜ | |
| 4 | Fallback | ⬜ | |
| 5 | Cost Control | ⬜ | |

**Legend:** ✅ Pass · ❌ Fail · ⬜ Not tested
