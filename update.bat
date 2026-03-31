@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

echo ==================================================
echo   SKL AGENT KIT: CẬP NHẬT HỆ SINH THÁI AI (WINDOWS)
echo ==================================================
echo Đang tải phiên bản mới nhất từ Github...

set TEMP_DIR=.skl_agent_kit_update_temp

:: Tạo thư mục clone tạm thời
rmdir /s /q %TEMP_DIR% 2>nul
git clone --depth 1 https://github.com/thanhndp/skl_agent_kit.git %TEMP_DIR%

if errorlevel 1 (
    echo [LÔI] Không thể tải dữ liệu từ Github. Vui lòng kiểm tra kết nối mạng hoặc kho lưu trữ.
    exit /b 1
)

echo.
echo Đang sao chép cập nhật cấu hình vào thư mục .agents/...

:: Copy an toàn đè lên .agents. Không làm ảnh hưởng src/ hay 1_input/
xcopy /Y /S /E "%TEMP_DIR%\.agents\*" ".agents\" >nul
copy /Y "%TEMP_DIR%\setup.bat" "setup.bat" >nul
copy /Y "%TEMP_DIR%\setup.sh" "setup.sh" >nul
copy /Y "%TEMP_DIR%\update.bat" "update.bat" >nul
copy /Y "%TEMP_DIR%\update.sh" "update.sh" >nul

:: Dọn dẹp
rmdir /s /q %TEMP_DIR%

echo.
echo ==================================================
echo Cập nhật thành công! Trí tuệ của Agent đã được nâng cấp.
echo ==================================================
pause
