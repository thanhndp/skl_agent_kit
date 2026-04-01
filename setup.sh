#!/bin/bash

# Thiết lập chữ UTF-8
export LANG=C.UTF-8

echo "=================================================="
echo "        SKL AGENT KIT INIT SYSTEM"
echo "=================================================="
echo ""
echo "Chào mừng bạn đến với SKL AGENT KIT Framework!"
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

if [ -n "$1" ]; then
    choice="$1"
else
    read -p "Nhập lựa chọn của bạn (1 hoặc 2): " choice
fi

if [ -f "README.md" ]; then
    mv README.md SKL_AGENT_KIT_README.md 2>/dev/null
fi

if [ "$choice" == "1" ]; then
    echo ""
    echo "Đang khởi tạo mô hình Data Pipeline..."
    mkdir -p 1_input/archived_docs 1_input/structured 2_process 3_output
    
    echo "# Thùng Chứa Dữ Liệu (Smart Funnel)" > 1_input/README.md
    echo "Thư mục này là chỗ để Nhân viên vận hành ném file thô vào (Drag & Drop)." >> 1_input/README.md
    echo "Hãy quăng tất cả file báo cáo của bạn vào đây. Dù là Excel, PDF, Ảnh chụp hay Word, cứ ném hết vào!" >> 1_input/README.md
    echo "Sau đó gõ lệnh \`/data-ingest\` cho AI tự động sắp xếp phân luồng." >> 1_input/README.md

    echo "# Data Pipeline Project" > README.md
    echo "Dự án được khởi tạo từ SKL AGENT KIT." >> README.md
    echo "Vui lòng xem hướng dẫn chi tiết của Framework tại \`SKL_AGENT_KIT_README.md\`." >> README.md

    echo "Hoàn tất khởi tạo Data Pipeline!"
    
elif [ "$choice" == "2" ]; then
    echo ""
    echo "Đang khởi tạo mô hình App Development..."
    mkdir -p src docs tests
    
    echo "# Cấu trúc nguồn dự án" > src/README.md
    echo "Chứa mã nguồn cho ứng dụng." >> src/README.md

    echo "# App Development Project" > README.md
    echo "Dự án được khởi tạo từ SKL AGENT KIT." >> README.md
    echo "Vui lòng xem hướng dẫn chi tiết của Framework tại \`SKL_AGENT_KIT_README.md\`." >> README.md

    echo "Hoàn tất khởi tạo App Development!"
    
else
    echo ""
    echo "Lựa chọn không hợp lệ. Vui lòng chạy lại script."
    exit 1
fi

echo ""
git remote remove origin 2>/dev/null
echo "Đồng bộ an toàn: Đã ngắt kết nối với Master Template Github để tránh push nhầm."
echo "SKL AGENT KIT đã sẵn sàng hoạt động tại thư mục hiện tại."
echo "Gõ 'antigravity' để triệu hồi Hệ điều hành AI của bạn."
echo "=================================================="
