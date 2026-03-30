#!/bin/bash

export LANG=C.UTF-8

echo "=================================================="
echo "   SKL_AGENT: CẬP NHẬT HỆ SINH THÁI AI (UNIX)"
echo "=================================================="
echo "Đang tải phiên bản mới nhất từ Github..."

TEMP_DIR=".skl_agent_update_temp"

# Tạo thư mục clone tạm thời
rm -rf "$TEMP_DIR" 2>/dev/null
git clone --depth 1 https://github.com/thanhndp/skl_agent.git "$TEMP_DIR"

if [ $? -ne 0 ]; then
    echo "[LỖI] Không thể tải dữ liệu từ Github. Vui lòng kiểm tra kết nối mạng hoặc kho lưu trữ."
    exit 1
fi

echo ""
echo "Đang sao chép cập nhật cấu hình vào thư mục .agents/..."

# Copy an toàn đè lên .agents. Không làm ảnh hưởng src/ hay 1_input/
cp -r "$TEMP_DIR"/.agents/* .agents/ 2>/dev/null
cp -f "$TEMP_DIR"/setup.bat . 2>/dev/null
cp -f "$TEMP_DIR"/setup.sh . 2>/dev/null
cp -f "$TEMP_DIR"/update.bat . 2>/dev/null
cp -f "$TEMP_DIR"/update.sh . 2>/dev/null

# Dọn dẹp
rm -rf "$TEMP_DIR"

echo ""
echo "=================================================="
echo "Cập nhật thành công! Trí tuệ của Agent đã được nâng cấp."
echo "=================================================="
