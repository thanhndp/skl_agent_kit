@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

echo ==================================================
echo         SKL AGENT KIT INIT SYSTEM
echo ==================================================
echo.
echo Chao mung ban den voi SKL AGENT KIT Framework!
echo Hay chon mo hinh du an ban muon thiet lap:
echo.
echo [1] Data Pipeline (Xu ly du lieu)
echo     - Muc dich: Crawl, Xu ly du lieu lon, ETL, Phan tich.
echo     - Cau truc: 1_input (chi doc), 2_process, 3_output.
echo.
echo [2] App Development (Lap trinh ung dung)
echo     - Muc dich: Xay dung web/app voi React, Node, Python...
echo     - Cau truc: src/, docs/, tests/.
echo.

if "%~1" neq "" (
    set choice=%~1
) else (
    set /p choice="Nhap lua chon cua ban (1 hoac 2): "
)

if "%choice%"=="1" (
    echo.
    echo Dang khoi tao mo hinh Data Pipeline...
    mkdir 1_input\archived_docs 2>nul
    mkdir 1_input\structured 2>nul
    mkdir 2_process 2>nul
    mkdir 3_output 2>nul
    
    echo # Thung Chua Du Lieu ^(Smart Funnel^) > 1_input\README.md
    echo Thu muc nay la cho de Nhan vien vut file vao. >> 1_input\README.md
    echo Ban hay quang tat ca file bao cao vao day. Du la Excel, PDF, Anh hay Word, cu nem het vao! >> 1_input\README.md
    echo Sau do go lenh ^`/data-ingest^` de AI tu dong sap xep va phan luong. >> 1_input\README.md

    echo Hoan tat khoi tao Data Pipeline!
) else if "%choice%"=="2" (
    echo.
    echo Dang khoi tao mo hinh App Development...
    mkdir src 2>nul
    mkdir docs 2>nul
    mkdir tests 2>nul
    
    echo # Cau truc nguon du an > src\README.md
    echo Chua ma nguon cho ung dung. >> src\README.md

    echo Hoan tat khoi tao App Development!
) else (
    echo.
    echo Lua chon khong hop le. Vui long chay lai script.
    exit /b 1
)

echo.
git remote remove origin 2>nul
echo Dong bo an toan: Da ngat ket noi voi Master Template Github de tranh push nham.
echo SKL AGENT KIT da san sang hoat dong tai thu muc hien tai.
echo Go "antigravity" de trieu hoi He dieu hanh AI cua ban.
echo ==================================================
