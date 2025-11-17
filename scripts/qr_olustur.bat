@echo off
chcp 65001 >nul
echo ============================================================
echo QR KOD OLUŞTURUCU - KURULUM VE ÇALIŞTIRMA
echo ============================================================
echo.

REM Python kurulu mu kontrol et
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python bulunamadı! Lütfen Python yükleyin.
    echo https://www.python.org/downloads/
    pause
    exit /b 1
)

echo ✓ Python bulundu
echo.

REM Gerekli paketleri yükle
echo Gerekli paketler yükleniyor...
pip install -q qrcode[pil] pillow

if errorlevel 1 (
    echo ❌ Paket yükleme başarısız!
    pause
    exit /b 1
)

echo ✓ Paketler yüklendi
echo.

REM QR kod oluştur
echo QR kod oluşturuluyor...
echo.
python generate_qr.py

echo.
echo ============================================================
pause
