#!/usr/bin/env python3
"""
QR Kod Oluşturucu - APK İndirme Linki için
Tek seferlik çalıştırılır ve QR kodu bilgisayara indirir.
"""

import qrcode
from datetime import datetime
import os

def generate_apk_qr():
    """APK indirme linki için QR kod oluşturur"""
    
    # APK indirme linkinizi buraya yazın
    # Örnek: GitHub Releases, Google Drive, Firebase App Distribution, vb.
    apk_download_url = "https://github.com/KULLANICI_ADI/REPO_ADI/releases/latest/download/app-release.apk"
    
    print("=" * 60)
    print("QR KOD OLUŞTURUCU - APK İNDİRME")
    print("=" * 60)
    print(f"\nQR Kod içeriği: {apk_download_url}")
    print("\nNot: Yukarıdaki URL'yi kendi APK indirme linkinizle değiştirin!")
    print("-" * 60)
    
    # QR kod oluştur
    qr = qrcode.QRCode(
        version=1,  # 1-40 arası, None ise otomatik
        error_correction=qrcode.constants.ERROR_CORRECT_H,  # Yüksek hata düzeltme
        box_size=10,  # Her kutunun piksel boyutu
        border=4,  # Kenar boşluğu (minimum 4)
    )
    
    qr.add_data(apk_download_url)
    qr.make(fit=True)
    
    # QR kodu resim olarak oluştur
    img = qr.make_image(fill_color="black", back_color="white")
    
    # Dosya adı (tarih-saat damgalı)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"apk_qr_code_{timestamp}.png"
    
    # Kaydetme yolu
    script_dir = os.path.dirname(os.path.abspath(__file__))
    output_path = os.path.join(script_dir, filename)
    
    # QR kodu kaydet
    img.save(output_path)
    
    print(f"\n✓ QR kod başarıyla oluşturuldu!")
    print(f"✓ Dosya konumu: {output_path}")
    print(f"✓ Dosya adı: {filename}")
    print("\n" + "=" * 60)
    print("KULLANIM:")
    print("1. QR kodu yazdırın veya ekranda gösterin")
    print("2. Kullanıcılar QR kodu telefonlarıyla okusun")
    print("3. APK otomatik olarak indirilecektir")
    print("=" * 60)
    
    return output_path

if __name__ == "__main__":
    try:
        generate_apk_qr()
    except Exception as e:
        print(f"\n❌ HATA: {e}")
        print("\nLütfen 'qrcode' ve 'pillow' paketlerinin yüklü olduğundan emin olun:")
        print("pip install qrcode[pil]")
