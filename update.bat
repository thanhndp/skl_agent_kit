@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

set REPO_URL=https://github.com/thanhndp/skl_agent_kit.git
set TEMP_DIR=.skl_agent_kit_update_temp

echo ==================================================
echo   SKL AGENT KIT: CAP NHAT HE SINH THAI AI (WINDOWS)
echo ==================================================

:: Chon che do cap nhat
echo Chon che do cap nhat:
echo [1] Moi nhat (main branch) - co the chua thay doi chua on dinh
echo [2] Ban phat hanh cu the (tag) - khuyen nghi cho production
set /p update_mode="Nhap lua chon (1 hoac 2, mac dinh 1): "

set TARGET_REF=
if "!update_mode!"=="2" (
    set /p input_tag="Nhap tag version (vi du: v4.0): "
    if "!input_tag!"=="" (
        echo [LOI] Tag khong duoc de trong.
        exit /b 1
    )
    set TARGET_REF=!input_tag!
    echo Dang tai phien ban !TARGET_REF! tu Github...
) else (
    echo Dang tai phien ban moi nhat (main) tu Github...
)

:: Tao thu muc clone tam thoi
rmdir /s /q %TEMP_DIR% 2>nul

if "!TARGET_REF!"=="" (
    git clone --depth 1 %REPO_URL% %TEMP_DIR%
) else (
    git clone --depth 1 --branch !TARGET_REF! %REPO_URL% %TEMP_DIR%
)

if errorlevel 1 (
    echo [LOI] Khong the tai du lieu tu Github. Vui long kiem tra ket noi mang hoac tag version.
    exit /b 1
)

:: Kiem tra tinh toan ven (integrity check)
echo.
echo Dang kiem tra tinh toan ven cua ban tai ve...
set integrity_ok=true
if not exist "%TEMP_DIR%\.agents\runtime\execution-engine.yaml" set integrity_ok=false
if not exist "%TEMP_DIR%\.agents\rules\orchestrator.md" set integrity_ok=false
if not exist "%TEMP_DIR%\.agents\rules\safety-guard.md" set integrity_ok=false
if not exist "%TEMP_DIR%\setup.sh" set integrity_ok=false
if not exist "%TEMP_DIR%\setup.bat" set integrity_ok=false

if "!integrity_ok!"=="false" (
    echo [HUY] Ban tai ve khong hop le - thieu file bat buoc. Khong cap nhat.
    rmdir /s /q %TEMP_DIR%
    exit /b 1
)
echo OK - Tinh toan ven hop le.

:: Sao chep cap nhat
echo.
echo Dang sao chep cap nhat cau hinh vao thu muc .agents/...

:: Bao ve User Config: Khong ghi de config va memory cua nguoi dung
rmdir /s /q "%TEMP_DIR%\.agents\config" 2>nul
rmdir /s /q "%TEMP_DIR%\.agents\memory" 2>nul

:: Copy an toan cac Rules va Workflows moi nhat
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
