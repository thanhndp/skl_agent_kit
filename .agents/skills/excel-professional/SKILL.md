---
name: excel-professional
description: Xử lý file Excel chuyên nghiệp với openpyxl - tạo bảng kế hoạch, báo cáo với định dạng chuẩn doanh nghiệp
---

# Excel Professional Skill

Skill này cung cấp khả năng tạo và xử lý file Excel (.xlsx) chuyên nghiệp với định dạng chuẩn doanh nghiệp.

## Khi nào sử dụng

- Tạo bảng kế hoạch, timeline, Gantt chart dạng bảng
- Tạo báo cáo tổng hợp nhiều sheet
- Xuất dữ liệu có định dạng đẹp từ markdown/JSON
- Tạo file Excel với header, group rows, styling chuyên nghiệp

## Công nghệ

- **Library**: `openpyxl` (Python)
- **Output**: `.xlsx` (Excel 2007+)

## Cấu trúc Style chuẩn

### 1. Màu sắc Corporate

```python
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side

# Header chính (xanh dương đậm)
HEADER_FILL = PatternFill(start_color="4472C4", end_color="4472C4", fill_type="solid")
HEADER_FONT = Font(bold=True, size=11, color="FFFFFF")

# Group row (xanh nhạt)
GROUP_FILL = PatternFill(start_color="D9E2F3", end_color="D9E2F3", fill_type="solid")
GROUP_FONT = Font(bold=True, size=11)

# Accent colors
ACCENT_GREEN = PatternFill(start_color="70AD47", end_color="70AD47", fill_type="solid")
ACCENT_ORANGE = PatternFill(start_color="ED7D31", end_color="ED7D31", fill_type="solid")
ACCENT_RED = PatternFill(start_color="C00000", end_color="C00000", fill_type="solid")

# Border chuẩn
THIN_BORDER = Border(
    left=Side(style='thin'),
    right=Side(style='thin'),
    top=Side(style='thin'),
    bottom=Side(style='thin')
)

# Alignment
CENTER_ALIGN = Alignment(horizontal="center", vertical="center", wrap_text=True)
LEFT_ALIGN = Alignment(horizontal="left", vertical="center", wrap_text=True)
```

### 2. Template Functions

```python
from openpyxl import Workbook
from openpyxl.utils import get_column_letter

def create_workbook_with_title(title: str) -> tuple:
    """Tạo workbook với sheet đầu tiên có tiêu đề"""
    wb = Workbook()
    ws = wb.active
    ws.title = title[:31]  # Excel giới hạn 31 ký tự
    return wb, ws

def setup_header_row(ws, row: int, headers: list, start_col: int = 1):
    """Tạo dòng header với style chuẩn"""
    for col, header in enumerate(headers, start_col):
        cell = ws.cell(row=row, column=col, value=header)
        cell.font = HEADER_FONT
        cell.fill = HEADER_FILL
        cell.alignment = CENTER_ALIGN
        cell.border = THIN_BORDER

def add_group_row(ws, row: int, group_code: str, group_name: str, end_col: int):
    """Thêm dòng nhóm với merge cells"""
    ws.cell(row=row, column=1, value=group_code)
    ws.cell(row=row, column=1).font = GROUP_FONT
    ws.cell(row=row, column=1).fill = GROUP_FILL
    ws.cell(row=row, column=1).alignment = CENTER_ALIGN
    ws.cell(row=row, column=1).border = THIN_BORDER
    
    ws.merge_cells(start_row=row, start_column=2, end_row=row, end_column=end_col)
    ws.cell(row=row, column=2, value=group_name)
    ws.cell(row=row, column=2).font = GROUP_FONT
    ws.cell(row=row, column=2).fill = GROUP_FILL
    ws.cell(row=row, column=2).alignment = LEFT_ALIGN
    
    for col in range(2, end_col + 1):
        ws.cell(row=row, column=col).border = THIN_BORDER

def add_data_row(ws, row: int, data: list, start_col: int = 1):
    """Thêm dòng dữ liệu với border"""
    for col, value in enumerate(data, start_col):
        cell = ws.cell(row=row, column=col, value=value)
        cell.border = THIN_BORDER
        cell.alignment = LEFT_ALIGN if col <= 2 else CENTER_ALIGN

def set_column_widths(ws, widths: dict):
    """Đặt độ rộng cột: {1: 10, 2: 50, ...}"""
    for col, width in widths.items():
        ws.column_dimensions[get_column_letter(col)].width = width

def add_title_row(ws, title: str, end_col: int, row: int = 1):
    """Thêm tiêu đề merge cells"""
    ws.merge_cells(start_row=row, start_column=1, end_row=row, end_column=end_col)
    ws[f'A{row}'] = title
    ws[f'A{row}'].font = Font(bold=True, size=14)
    ws[f'A{row}'].alignment = CENTER_ALIGN
```

## Patterns thường dùng

### Pattern 1: Bảng Timeline/Kế hoạch

```python
# Cấu trúc: STT | Công việc | T1 | T2 | ... | T12
headers = ['STT', 'Công việc'] + [f'T{i}' for i in range(1, 13)]

# Data với đánh dấu tháng thực hiện
tasks = [
    ("1.1", "Nhiệm vụ A", [1, 2, 3]),      # Thực hiện T1-T3
    ("1.2", "Nhiệm vụ B", [4, 5, 6, 7]),   # Thực hiện T4-T7
]

# Ký hiệu đánh dấu
MARKER = "●"  # hoặc "✓", "X", "★"
```

### Pattern 2: Báo cáo Multi-Sheet

```python
# Tạo nhiều sheet với cùng format
sheets_config = [
    ("Sheet1", "Tiêu đề Sheet 1", data1),
    ("Sheet2", "Tiêu đề Sheet 2", data2),
    ("Tổng hợp", "Bảng tổng hợp", summary_data),
]

wb = Workbook()
for i, (name, title, data) in enumerate(sheets_config):
    if i == 0:
        ws = wb.active
        ws.title = name
    else:
        ws = wb.create_sheet(name)
    # ... populate sheet
```

### Pattern 3: Bảng tổng hợp số liệu

```python
summary_data = [
    ("Hạng mục A", 100),
    ("Hạng mục B", 200),
    ("Tổng cộng", 300),  # Dòng cuối bold
]

for i, (name, value) in enumerate(summary_data, start_row):
    ws.cell(row=i, column=1, value=name)
    ws.cell(row=i, column=2, value=value)
    if name == "Tổng cộng":
        ws.cell(row=i, column=1).font = Font(bold=True)
        ws.cell(row=i, column=2).font = Font(bold=True)
```

### Pattern 4: Timeline với đánh dấu x và fill màu nền

Pattern này dùng cho các bảng kế hoạch theo tháng, đánh dấu bằng "x" với nền màu nhạt.

```python
# Fill màu nhạt cho ô đánh dấu
MARK_FILL = PatternFill(start_color="E2EFDA", end_color="E2EFDA", fill_type="solid")  # Xanh lá nhạt

def create_timeline_sheet(ws, data):
    """
    Tạo sheet timeline với format chuẩn
    
    data format:
    [
        {"is_group": True, "name": "A. Nhóm công việc"},
        {"stt": "1.1", "name": "Công việc 1", "months": [0,1,1,1,0,0,0,0,0,0,0,0]},
        # months: 12 phần tử, 1 = có đánh dấu, 0 = không
    ]
    """
    # Header row
    headers = ["STT", "Công việc"] + [f"T{i}" for i in range(1, 13)]
    for col, header in enumerate(headers, 1):
        cell = ws.cell(row=1, column=col, value=header)
        cell.font = HEADER_FONT
        cell.fill = HEADER_FILL
        cell.alignment = CENTER_ALIGN
        cell.border = THIN_BORDER
    
    # Data rows
    row = 2
    for item in data:
        if item.get("is_group"):
            # Group header - merge cells
            cell = ws.cell(row=row, column=1, value=item["name"])
            cell.font = GROUP_FONT
            cell.fill = GROUP_FILL
            ws.merge_cells(start_row=row, start_column=1, end_row=row, end_column=14)
            for col in range(1, 15):
                ws.cell(row=row, column=col).border = THIN_BORDER
                ws.cell(row=row, column=col).fill = GROUP_FILL
        else:
            # Data row
            ws.cell(row=row, column=1, value=item["stt"]).alignment = CENTER_ALIGN
            ws.cell(row=row, column=2, value=item["name"]).alignment = LEFT_ALIGN
            
            # Month marks với fill màu
            for i, month in enumerate(item.get("months", []), 3):
                cell = ws.cell(row=row, column=i)
                if month:
                    cell.value = "x"
                    cell.fill = MARK_FILL
                cell.alignment = CENTER_ALIGN
            
            # Apply borders
            for col in range(1, 15):
                ws.cell(row=row, column=col).border = THIN_BORDER
        
        row += 1
    
    # Column widths chuẩn
    ws.column_dimensions['A'].width = 6
    ws.column_dimensions['B'].width = 55
    for col in range(3, 15):
        ws.column_dimensions[get_column_letter(col)].width = 5
```

## Lưu ý quan trọng

1. **Tên sheet**: Giới hạn 31 ký tự, không chứa `\ / * ? : [ ]`
2. **Merge cells**: Chỉ cell đầu tiên giữ giá trị sau khi merge
3. **Wrap text**: Bật `wrap_text=True` trong Alignment cho nội dung dài
4. **Freeze panes**: `ws.freeze_panes = 'A3'` để cố định header
5. **Auto-filter**: `ws.auto_filter.ref = ws.dimensions`

## Ví dụ hoàn chỉnh

Xem file mẫu tại: [excel_template.py](file:///C:/Users/CMB-TungAI/.gemini/antigravity/skills/excel-professional/templates/excel_template.py)

## Dependencies

```bash
pip install openpyxl
```

Kiểm tra:
```python
python -c "import openpyxl; print(f'openpyxl {openpyxl.__version__}')"
```
