#!/bin/bash

# Thiết lập chữ UTF-8
export LANG=C.UTF-8

echo "=================================================="
echo "        SKL_AGENT INIT SYSTEM"
echo "=================================================="
echo ""
echo "Chào mừng bạn đến với SKL_AGENT Framework!"
echo "Hãy chọn mô hình dự án bạn muốn thiết lập:"
echo ""
echo "[1] Data Pipeline (Xử lý dữ liệu)"
echo "    - Mục đích: Crawl, Xử lý dữ liệu lớn, ETL, Phân tích."
echo "    - Cấu trúc: 1_input (chỉ đọc), 2_process, 3_output."
echo ""
echo "[2] App Development (Lập trình ứng dụng)"
echo "    - Mục đích: Xây dựng web/app với React, Node, Python..."
echo "    - Cấu trúc: src/, docs/, tests/."
echo ""

read -p "Nhập lựa chọn của bạn (1 hoặc 2): " choice

if [ "$choice" == "1" ]; then
    echo ""
    echo "Đang khởi tạo mô hình Data Pipeline..."
    mkdir -p 1_input 2_process 3_output
    
    echo "# Thư mục 1_input" > 1_input/README.md
    echo "Thư mục này được thiết lập **[Chỉ Đọc]**." >> 1_input/README.md
    echo "Dữ liệu gốc ở đây không được phép sửa đổi bởi bất kỳ tiến trình nào. Mọi kết quả phải xuất ra 2_process hoặc 3_output." >> 1_input/README.md

    echo "Hoàn tất khởi tạo Data Pipeline!"
    
elif [ "$choice" == "2" ]; then
    echo ""
    echo "Đang khởi tạo mô hình App Development..."
    mkdir -p src docs tests
    
    echo "# Cấu trúc nguồn dự án" > src/README.md
    echo "Chứa mã nguồn cho ứng dụng." >> src/README.md

    echo "Hoàn tất khởi tạo App Development!"
    
else
    echo ""
    echo "Lựa chọn không hợp lệ. Vui lòng chạy lại script."
    exit 1
fi

echo ""
echo "SKL_AGENT đã sẵn sàng hoạt động tại thư mục hiện tại."
echo "Gõ 'antigravity' để triệu hồi Hệ điều hành AI của bạn."
echo "=================================================="
