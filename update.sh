#!/bin/bash

export LANG=C.UTF-8

echo "=================================================="
echo "   SKL AGENT KIT: CẬP NHẬT HỆ SINH THÁI AI (UNIX)"
echo "=================================================="
echo "Đang tải phiên bản mới nhất từ Github..."

TEMP_DIR=".skl_agent_kit_update_temp"

# Tạo thư mục clone tạm thời
rm -rf "$TEMP_DIR" 2>/dev/null
git clone --depth 1 https://github.com/thanhndp/skl_agent_kit.git "$TEMP_DIR"

if [ $? -ne 0 ]; then
    echo "[LỖI] Không thể tải dữ liệu từ Github. Vui lòng kiểm tra kết nối mạng hoặc kho lưu trữ."
    exit 1
fi

echo ""
echo "Đang sao chép cập nhật cấu hình vào thư mục .agents/..."

# Bảo vệ User Config: Xóa thư mục config/memory khỏi bản tải về trước khi copy để không nghi đè thiết lập của bạn
rm -rf "$TEMP_DIR/.agents/config" 2>/dev/null
rm -rf "$TEMP_DIR/.agents/memory" 2>/dev/null

# Copy an toàn các Rules và Workflows mới nhất
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
