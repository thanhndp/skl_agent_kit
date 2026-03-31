@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

echo ==================================================
echo   SKL AGENT KIT: CAP NHAT HE SINH THAI AI (WINDOWS)
echo ==================================================
echo Dang tai phien ban moi nhat tu Github...

set TEMP_DIR=.skl_agent_kit_update_temp

:: Tao thu muc clone tam thoi
rmdir /s /q %TEMP_DIR% 2>nul
git clone --depth 1 https://github.com/thanhndp/skl_agent_kit.git %TEMP_DIR%

if errorlevel 1 (
    echo [LOI] Khong the tai du lieu tu Github. Vui long kiem tra ket noi mang hoac kho luu tru.
    exit /b 1
)

echo.
echo Dang sao chep cap nhat cau hinh vao thu muc .agents/...

:: Copy an toan de len .agents. Khong lam anh huong src/ hay 1_input/
xcopy /Y /S /E "%TEMP_DIR%\.agents\*" ".agents\" >nul
copy /Y "%TEMP_DIR%\setup.bat" "setup.bat" >nul
copy /Y "%TEMP_DIR%\setup.sh" "setup.sh" >nul
copy /Y "%TEMP_DIR%\update.bat" "update.bat" >nul
copy /Y "%TEMP_DIR%\update.sh" "update.sh" >nul

:: Don dep
rmdir /s /q %TEMP_DIR%

echo.
echo ==================================================
echo Cap nhat thanh cong! Tri tue cua Agent da duoc nang cap.
echo ==================================================
pause
