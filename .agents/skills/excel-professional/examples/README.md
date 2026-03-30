# Excel Professional Examples

Các ví dụ sử dụng skill `excel-professional`.

## Ví dụ 1: Bảng kế hoạch năm

```python
from excel_template import ExcelBuilder

# Khởi tạo
builder = ExcelBuilder("KẾ HOẠCH CHUYỂN ĐỔI SỐ 2026")

# Header với 12 tháng
headers = ['STT', 'Công việc'] + [f'T{i}' for i in range(1, 13)]
builder.add_header_row(headers)

# Nhóm A
builder.add_group_row("A", "Nhiệm vụ chung", 14)
builder.add_timeline_row("1.1", "Thành lập Ban chỉ đạo", [1])
builder.add_timeline_row("1.2", "Nghiên cứu quy trình", [1, 2, 3])

# Nhóm B
builder.add_group_row("B", "Triển khai hệ thống", 14)
builder.add_timeline_row("2.1", "Cài đặt phần mềm", [4, 5, 6])
builder.add_timeline_row("2.2", "Đào tạo nhân sự", [6, 7, 8, 9])

# Cấu hình
builder.set_column_widths({1: 6, 2: 50})
builder.freeze_panes("C3")
builder.save("ke_hoach_2026.xlsx")
```

## Ví dụ 2: Báo cáo nhiều sheet

```python
from excel_template import ExcelBuilder

builder = ExcelBuilder("BÁO CÁO TỔNG HỢP Q1")

# Sheet 1: Doanh thu
builder.add_header_row(["Tháng", "Doanh thu", "Chi phí", "Lợi nhuận"])
builder.add_data_rows([
    ["Tháng 1", 100, 80, 20],
    ["Tháng 2", 120, 85, 35],
    ["Tháng 3", 150, 90, 60],
])

# Sheet 2: Chi tiết
builder.create_sheet("Chi tiết", "CHI TIẾT DOANH THU")
builder.add_header_row(["Hạng mục", "Giá trị", "Ghi chú"])
builder.add_data_rows([
    ["Sản phẩm A", 200, "Tăng 10%"],
    ["Sản phẩm B", 170, "Giảm 5%"],
])

builder.save("bao_cao_q1.xlsx")
```

## Ví dụ 3: Sử dụng Utility Functions

```python
from excel_template import create_timeline_excel, create_summary_excel

# Tạo timeline nhanh
data = [
    ("A", "Phase 1: Chuẩn bị", None),
    ("1.1", "Khảo sát hiện trạng", [1, 2]),
    ("1.2", "Lập kế hoạch", [2, 3]),
    ("B", "Phase 2: Triển khai", None),
    ("2.1", "Phát triển hệ thống", [4, 5, 6, 7]),
    ("2.2", "Kiểm thử", [7, 8]),
]

create_timeline_excel(
    "TIMELINE DỰ ÁN ABC",
    data,
    output_path="timeline_abc.xlsx"
)

# Tạo bảng tổng hợp nhanh
summary = [
    ("Đã hoàn thành", 15),
    ("Đang thực hiện", 8),
    ("Chưa bắt đầu", 12),
    ("Tổng cộng", 35),
]

create_summary_excel(
    "TIẾN ĐỘ DỰ ÁN",
    summary,
    output_path="tien_do.xlsx"
)
```

## Ví dụ 4: Custom Styling

```python
from excel_template import ExcelBuilder, ExcelStyles
from openpyxl.styles import Font, PatternFill

builder = ExcelBuilder("BÁO CÁO TÌNH TRẠNG")
builder.add_header_row(["Hạng mục", "Trạng thái", "Ghi chú"])

# Custom colors cho status
status_styles = {
    "Hoàn thành": ExcelStyles.GREEN_FILL,
    "Đang làm": ExcelStyles.YELLOW_FILL,
    "Trễ hạn": ExcelStyles.RED_FILL,
}

data = [
    ("Nhiệm vụ 1", "Hoàn thành", "OK"),
    ("Nhiệm vụ 2", "Đang làm", "50%"),
    ("Nhiệm vụ 3", "Trễ hạn", "Cần hỗ trợ"),
]

for task, status, note in data:
    row = builder.current_row
    builder.ws.cell(row=row, column=1, value=task)
    
    status_cell = builder.ws.cell(row=row, column=2, value=status)
    status_cell.fill = status_styles.get(status, None)
    status_cell.font = Font(bold=True, color="FFFFFF")
    
    builder.ws.cell(row=row, column=3, value=note)
    
    for col in range(1, 4):
        builder.ws.cell(row=row, column=col).border = builder.styles.THIN_BORDER
    
    builder.current_row += 1

builder.set_column_widths({1: 30, 2: 15, 3: 30})
builder.save("tinh_trang.xlsx")
```
