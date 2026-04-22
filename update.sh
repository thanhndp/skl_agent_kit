#!/bin/bash

export LANG=C.UTF-8

SKL_KIT_VERSION="4.0"
REPO_URL="https://github.com/thanhndp/skl_agent_kit.git"
TEMP_DIR=".skl_agent_kit_update_temp"

echo "=================================================="
echo "   SKL AGENT KIT v${SKL_KIT_VERSION}: CẬP NHẬT HỆ SINH THÁI AI (UNIX)"
echo "=================================================="

# ── Chọn chế độ cập nhật ────────────────────────────────────────────────────
echo "Chọn chế độ cập nhật:"
echo "[1] Mới nhất (main branch) — có thể chứa thay đổi chưa ổn định"
echo "[2] Bản phát hành cụ thể (tag) — khuyến nghị cho môi trường production"
read -p "Nhập lựa chọn (1 hoặc 2, mặc định 1): " update_mode

TARGET_REF=""
if [ "$update_mode" == "2" ]; then
    read -p "Nhập tag version (ví dụ: v4.0): " input_tag
    if [ -z "$input_tag" ]; then
        echo "[LỖI] Tag không được để trống."
        exit 1
    fi
    TARGET_REF="$input_tag"
    echo "Đang tải phiên bản $TARGET_REF từ Github..."
else
    echo "Đang tải phiên bản mới nhất (main) từ Github..."
fi

# ── Clone ────────────────────────────────────────────────────────────────────
rm -rf "$TEMP_DIR" 2>/dev/null

if [ -n "$TARGET_REF" ]; then
    git clone --depth 1 --branch "$TARGET_REF" "$REPO_URL" "$TEMP_DIR"
else
    git clone --depth 1 "$REPO_URL" "$TEMP_DIR"
fi

if [ $? -ne 0 ]; then
    echo "[LỖI] Không thể tải dữ liệu từ Github. Vui lòng kiểm tra kết nối mạng hoặc tag version."
    exit 1
fi

# ── Kiểm tra tính toàn vẹn (integrity check) ────────────────────────────────
echo ""
echo "Đang kiểm tra tính toàn vẹn của bản tải về..."
REQUIRED_FILES=(
    "$TEMP_DIR/.agents/runtime/execution-engine.yaml"
    "$TEMP_DIR/.agents/rules/orchestrator.md"
    "$TEMP_DIR/.agents/rules/safety-guard.md"
    "$TEMP_DIR/setup.sh"
    "$TEMP_DIR/setup.bat"
)
all_ok=true
for f in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$f" ]; then
        echo "[LỖI] File bắt buộc bị thiếu trong bản tải về: $f"
        all_ok=false
    fi
done
if [ "$all_ok" != "true" ]; then
    echo "[HỦY] Bản tải về không hợp lệ. Không cập nhật."
    rm -rf "$TEMP_DIR"
    exit 1
fi
echo "✅ Tính toàn vẹn OK."

# ── Sao chép cập nhật ────────────────────────────────────────────────────────
echo ""
echo "Đang sao chép cập nhật cấu hình vào thư mục .agents/..."

# Bảo vệ User Config: Không ghi đè config và memory của người dùng
rm -rf "$TEMP_DIR/.agents/config" 2>/dev/null
rm -rf "$TEMP_DIR/.agents/memory" 2>/dev/null

cp -r "$TEMP_DIR"/.agents/* .agents/ 2>/dev/null
cp -f "$TEMP_DIR"/setup.bat . 2>/dev/null
cp -f "$TEMP_DIR"/setup.sh . 2>/dev/null
cp -f "$TEMP_DIR"/update.bat . 2>/dev/null
cp -f "$TEMP_DIR"/update.sh . 2>/dev/null

# ── Dọn dẹp ─────────────────────────────────────────────────────────────────
rm -rf "$TEMP_DIR"

echo ""
echo "=================================================="
echo "✅ Cập nhật thành công! Trí tuệ của Agent đã được nâng cấp."
echo "=================================================="
