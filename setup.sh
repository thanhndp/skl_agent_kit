#!/bin/bash

# Thiết lập chữ UTF-8
export LANG=C.UTF-8

echo "=================================================="
echo "        SKL AGENT KIT INIT SYSTEM v4.0"
echo "=================================================="
echo ""
echo "Chào mừng bạn đến với SKL AGENT KIT Framework!"
echo ""
echo "Để tối ưu hóa trải nghiệm AI, bạn thuộc nhóm nào?"
echo "[1] Beginner (Sử dụng đơn giản, ưu tiên an toàn, hướng dẫn chi tiết)"
echo "[2] Expert (Tốc độ cao, đa luồng multi-agent, bỏ qua giải thích)"
read -p "Nhập lựa chọn của bạn (1 hoặc 2): " profile

if [ "$profile" == "2" ]; then
    PROFILE_DESC="AI Engineer. Thích sự ngắn gọn, chạy đa luồng multi-agent. Profile: expert."
else
    PROFILE_DESC="Giáo viên/Quản lý. Không rành code. Cần AI giải thích step-by-step. Profile: beginner."
fi

# Khởi tạo Memory cho AI
cat <<EOF > .agents/memory/entities.yaml
entities:
  - type: user
    name: "User Profile"
    content: "$PROFILE_DESC"
    confidence: 1.0
    date: "$(date +%Y-%m-%d)"
EOF

echo ""
echo "Hãy chọn mô hình dự án bạn muốn thiết lập:"
echo "[1] Data Pipeline (Xử lý dữ liệu, ETL)"
echo "[2] App Development (Lập trình ứng dụng Web/Node)"
read -p "Nhập lựa chọn của bạn (1 hoặc 2): " choice

if [ -f "README.md" ]; then
    read -p "README.md đã tồn tại và sẽ được đổi tên thành SKL_AGENT_KIT_README.md. Tiếp tục? (y/N): " confirm_rename
    if [ "$confirm_rename" == "y" ] || [ "$confirm_rename" == "Y" ]; then
        mv README.md SKL_AGENT_KIT_README.md 2>/dev/null
    else
        echo "Bỏ qua: README.md giữ nguyên."
    fi
fi

if [ "$choice" == "1" ]; then
    echo ""
    echo "Đang khởi tạo mô hình Data Pipeline..."
    mkdir -p 1_input/archived_docs 1_input/structured 2_process 3_output
    
    echo "# Thùng Chứa Dữ Liệu (Smart Funnel)" > 1_input/README.md
    echo "Ném file thô vào (Drag & Drop) và gọi \`/data-ingest\`." >> 1_input/README.md

    # Tạo Dữ Liệu Mẫu
    echo -e "id,name,score\n1,Alice Nguyen,85\n2,Bob Tran,92" > 1_input/structured/sample_data_1.csv
    echo -e "id,name,score\n3,Charlie Pham,78" > 1_input/structured/sample_data_2.csv

    echo "# Data Pipeline Project" > README.md
    echo "Dự án được khởi tạo từ SKL AGENT KIT." >> README.md
    echo "Gõ lệnh \`python 2_process/base_parallel_engine.py\` để test tự động xử lý." >> README.md

    if [ -f ".agents/templates/base_parallel_engine.py" ]; then
        cp .agents/templates/base_parallel_engine.py 2_process/base_parallel_engine.py 2>/dev/null
    fi

    echo "Hoàn tất khởi tạo Data Pipeline! (Đã tạo sẵn Dummy Data)"
    
elif [ "$choice" == "2" ]; then
    echo ""
    echo "Đang khởi tạo mô hình App Development..."
    mkdir -p src docs tests
    
    # Tạo Project Mẫu
    cat <<EOF > package.json
{
  "name": "skl-app",
  "version": "1.0.0",
  "scripts": { "start": "node src/index.js" }
}
EOF
    echo 'console.log("Chào mừng đến với ứng dụng dành cho SKL AGENT KIT! Hệ thống hoạt động hoàn hảo.");' > src/index.js

    echo "# App Development Project" > README.md
    echo "Dự án được khởi tạo từ SKL AGENT KIT." >> README.md
    echo "Gõ lệnh \`npm start\` hoặc \`node src/index.js\` để test." >> README.md

    echo "Hoàn tất khởi tạo App Development (Đã tạo sẵn package.json và index.js)."
    
else
    echo ""
    echo "Lựa chọn không hợp lệ. Vui lòng chạy lại script."
    exit 1
fi

echo ""
read -p "Xóa git remote origin? Làm vậy sẽ ngắt kết nối clone gốc. (y/N): " confirm_remote
if [ "$confirm_remote" == "y" ] || [ "$confirm_remote" == "Y" ]; then
    git remote remove origin 2>/dev/null
    echo "Đã xóa remote origin."
else
    echo "Bỏ qua: remote origin giữ nguyên."
fi
echo "=================================================================="
echo "✨ [THÀNH CÔNG] DỰ ÁN ĐÃ SẴN SÀNG ĐỂ CHẠY CẢ CODE LẪN AI!"
echo ""
echo "1️⃣  TEST TÍNH NĂNG (Không cần AI):"
if [ "$choice" == "1" ]; then
    echo "    Chạy lệnh: python 2_process/base_parallel_engine.py"
else
    echo "    Chạy lệnh: node src/index.js"
fi
echo ""
echo "2️⃣  KHỞI ĐỘNG ANTIGRAVITY IDE (Mặc định)"
echo "    Gõ lệnh: antigravity"
echo "    Sau đó dán tin nhắn này: \"Hãy đọc README.md và đề xuất công việc tiếp theo.\""
echo "=================================================================="
