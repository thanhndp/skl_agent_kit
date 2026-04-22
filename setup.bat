@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

echo ==================================================
echo         SKL AGENT KIT INIT SYSTEM v4.0
echo ==================================================
echo.
echo Chao mung ban den voi SKL AGENT KIT Framework!
echo.
echo De toi uu hoa AI, ban thuoc nhom nao?
echo [1] Beginner (Nguoi moi) - Can giai thich ky, uu tien an toan.
echo [2] Expert (Chuyen gia) - Thich multi-agent chay song song, ngan gon.
set /p profile="Nhap lua chon (1 hoac 2): "

if "%profile%"=="2" (
    set profile_desc=AI Engineer. Thich su ngan gon, chay da luong multi-agent. Profile: expert.
) else (
    set profile_desc=Giao vien/Quan ly. Khong ranh code. Can giai thich step-by-step. Profile: beginner.
)

:: Khoi tao Memory cho AI vao Entities.yaml (date dong theo he thong)
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set today_date=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%
echo entities: > .agents\memory\entities.yaml
echo   - type: user >> .agents\memory\entities.yaml
echo     name: "User Profile" >> .agents\memory\entities.yaml
echo     content: "%profile_desc%" >> .agents\memory\entities.yaml
echo     confidence: 1.0 >> .agents\memory\entities.yaml
echo     date: "%today_date%" >> .agents\memory\entities.yaml

echo.
echo Hay chon mo hinh du an ban muon thiet lap:
echo [1] Data Pipeline (Xu ly du lieu lon, bao cao)
echo [2] App Development (Lap trinh ung dung Web/App)
set /p choice="Nhap lua chon cua ban (1 hoac 2): "

if exist README.md (
    set /p confirm_rename="README.md ton tai va se duoc doi ten thanh SKL_AGENT_KIT_README.md. Tiep tuc? (y/N): "
    if /I "!confirm_rename!"=="y" (
        ren README.md SKL_AGENT_KIT_README.md 2>nul
    ) else (
        echo Bo qua: README.md giu nguyen.
    )
)

if "%choice%"=="1" (
    echo.
    echo Dang khoi tao mo hinh Data Pipeline...
    mkdir 1_input\archived_docs 2>nul
    mkdir 1_input\structured 2>nul
    mkdir 2_process 2>nul
    mkdir 3_output 2>nul
    
    echo # Thung Chua Du Lieu ^(Smart Funnel^) > 1_input\README.md
    echo Ban hay quang tat ca file bao cao vao thu muc nay. >> 1_input\README.md

    :: Tao Du Lieu Mau de script chay duoc ngay lap tuc
    echo id,name,score > 1_input\structured\sample_data_1.csv
    echo 1,Alice Nguyen,85 >> 1_input\structured\sample_data_1.csv
    echo 2,Bob Tran,92 >> 1_input\structured\sample_data_1.csv
    echo id,name,score > 1_input\structured\sample_data_2.csv
    echo 3,Charlie Pham,78 >> 1_input\structured\sample_data_2.csv

    echo # Data Pipeline Project > README.md
    echo Du an duoc khoi tao tu SKL AGENT KIT. >> README.md
    echo Go lenh `python 2_process\base_parallel_engine.py` de test thu. >> README.md

    if exist .agents\templates\base_parallel_engine.py (
        copy /Y .agents\templates\base_parallel_engine.py 2_process\base_parallel_engine.py >nul
    )

    echo Hoan tat khoi tao Data Pipeline! (Da tao san file sample CSV)
) else if "%choice%"=="2" (
    echo.
    echo Dang khoi tao mo hinh App Development...
    mkdir src 2>nul
    mkdir docs 2>nul
    mkdir tests 2>nul
    
    :: Tao Project mau be ti de chay duoc ngay
    echo { "name": "skl-app", "version": "1.0.0", "scripts": { "start": "node src/index.js" } } > package.json
    echo console.log("Chao mung den voi ung dung danh cho SKL AGENT KIT! He thong hoat dong tot."); > src\index.js

    echo # App Development Project > README.md
    echo Du an duoc khoi tao tu SKL AGENT KIT. >> README.md
    echo Go lenh `npm start` hoac `node src/index.js` de test thu. >> README.md

    echo Hoan tat khoi tao App Development (Da tao san package.json va index.js mau).
) else (
    echo.
    echo Lua chon khong hop le. Vui long chay lai script.
    exit /b 1
)

echo.
set /p confirm_remote="Xoa git remote origin? Lam vay se ngat ket noi clone goc. (y/N): "
if /I "!confirm_remote!"=="y" (
    git remote remove origin 2>nul
    echo Da xoa remote origin.
) else (
    echo Bo qua: remote origin giu nguyen.
)
echo ==================================================================
echo [THONG BAO THANH CONG] - Project da san sang de RUN!
echo.
echo Cach test ngay (neu ban chua co AI):
if "%choice%"=="1" (
    echo - Chay lenh: python 2_process\base_parallel_engine.py
) else (
    echo - Chay lenh: node src\index.js
)
echo.
echo 2. KHOI DONG ANTIGRAVITY IDE ^(Mac dinh^):
echo    Go lenh: antigravity
echo    Sau do gui tin nhan: "Hay doc README.md va de xuat buoc tiep theo"
echo ==================================================================
pause
