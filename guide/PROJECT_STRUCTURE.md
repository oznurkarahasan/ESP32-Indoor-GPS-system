# Proje Yapısı

## 📁 Dizin Yapısı

```
ESP32-Indoor-GPS-system/
├── lib/
│   ├── main.dart                      # Ana uygulama giriş noktası
│   │
│   ├── pages/                         # Sayfa widget'ları
│   │   ├── ble_scanner_page.dart     # Ana sayfa - BLE tarayıcı
│   │   ├── zemin_page.dart           # Zemin kat sayfası
│   │   ├── kat1_page.dart            # Kat 1 sayfası
│   │   ├── kat2_page.dart            # Kat 2 sayfası
│   │   ├── ar_camera_page.dart       # AR kamera navigasyon
│   │   └── navigation_page.dart      # Video rehber / Önizleme
│   │
│   ├── services/                      # Servis katmanı
│   │   ├── ble_router.dart           # Bluetooth tarama yönetimi
│   │   └── video_cache_service.dart  # Video önbellekleme
│   │
│   ├── models/                        # Veri modelleri
│   │   └── poi_data.dart             # POI ve rota verileri
│   │
│   ├── widgets/                       # Yeniden kullanılabilir widget'lar
│   │   ├── custom_appbar.dart        # Özel app bar
│   │   ├── device_title.dart         # BLE cihaz kartı
│   │   ├── stop_scan_button.dart     # Taramayı durdur butonu
│   │   ├── modern_card.dart          # Modern kart widget
│   │   └── modern_loading.dart       # Yükleme göstergesi
│   │
│   └── views/                         # Görünüm bileşenleri
│       └── ble_scanner_view.dart     # BLE tarayıcı görünümü
│
├── android/                           # Android platform kodu
├── ios/                               # iOS platform kodu
├── web/                               # Web platform kodu
├── windows/                           # Windows platform kodu
├── linux/                             # Linux platform kodu
├── macos/                             # macOS platform kodu
│
├── README.md                          # Proje dokümantasyonu
├── AR_FEATURES.md                     # AR özellikleri dokümantasyonu
├── BLUETOOTH_MANAGEMENT.md            # Bluetooth yönetimi
├── NAVIGATION_FLOW.md                 # Navigasyon akışı
├── PROJECT_STRUCTURE.md               # Bu dosya
├── requirements.txt                   # Sistem gereksinimleri
│
├── pubspec.yaml                       # Flutter bağımlılıkları
└── analysis_options.yaml              # Dart analiz ayarları
```

## 📄 Dosya Açıklamaları

### Ana Dosyalar

#### `lib/main.dart`
- Uygulamanın giriş noktası
- MaterialApp yapılandırması
- Route tanımlamaları
- Tema ayarları

### Sayfalar (Pages)

#### `lib/pages/ble_scanner_page.dart`
- Ana sayfa
- BLE cihaz tarama
- Kat algılama
- Otomatik yönlendirme

#### `lib/pages/zemin_page.dart`
- Zemin kat haritası
- Hedef arama
- Sesli komut desteği
- POI listesi

#### `lib/pages/kat1_page.dart`
- Kat 1 haritası
- Hedef arama
- Sesli komut desteği
- POI listesi

#### `lib/pages/kat2_page.dart`
- Kat 2 haritası
- Hedef arama
- Sesli komut desteği
- POI listesi

#### `lib/pages/ar_camera_page.dart`
- AR kamera görünümü
- Gerçek zamanlı AR okları
- Sensör entegrasyonu
- Video rehber butonu
- Hedef önizleme butonu
- Bluetooth tarama yönetimi

#### `lib/pages/navigation_page.dart`
- Video rehber oynatma
- Hedef önizleme
- İki mod: Video Only / Preview Only
- Video kontrolleri
- Bluetooth tarama yönetimi

### Servisler (Services)

#### `lib/services/ble_router.dart`
- Bluetooth Low Energy tarama
- Sinyal gücü takibi
- Kat algılama algoritması
- Stream tabanlı veri yönetimi

#### `lib/services/video_cache_service.dart`
- Video önbellekleme
- Ağ optimizasyonu
- Cache yönetimi

### Modeller (Models)

#### `lib/models/poi_data.dart`
- POI (Point of Interest) veri yapısı
- Rota bilgileri
- Video URL'leri
- Bina verileri

### Widget'lar (Widgets)

#### `lib/widgets/custom_appbar.dart`
- Özelleştirilmiş app bar
- Gradient arka plan
- Tutarlı tasarım

#### `lib/widgets/device_title.dart`
- BLE cihaz kartı
- Sinyal gücü göstergesi
- Cihaz bilgileri

#### `lib/widgets/stop_scan_button.dart`
- Taramayı durdur butonu
- Yeniden kullanılabilir
- Tutarlı stil

#### `lib/widgets/modern_card.dart`
- Modern kart tasarımı
- Gölge efektleri
- Yuvarlak köşeler

#### `lib/widgets/modern_loading.dart`
- Yükleme göstergesi
- Animasyonlu
- Özelleştirilebilir mesaj

### Görünümler (Views)

#### `lib/views/ble_scanner_view.dart`
- BLE tarayıcı UI
- Cihaz listesi
- Durum göstergeleri
- Responsive tasarım

## 🗂️ Silinen Dosyalar

Aşağıdaki dosyalar artık kullanılmadığı için projeden kaldırılmıştır:

- ❌ `lib/pages/ar_demo_page.dart` - AR demo sayfası (kullanılmıyor)
- ❌ `lib/pages/ar_navigation_page.dart` - Eski AR navigasyon (ar_camera_page ile değiştirildi)
- ❌ `lib/services/ar_service.dart` - AR servisi (kullanılmıyor)
- ❌ `AR_CAMERA_GUIDE.md` - Eski rehber (NAVIGATION_FLOW.md ile değiştirildi)

## 📊 Sayfa İlişkileri

```
Ana Sayfa (BLE Scanner)
    ↓
Kat Sayfaları (Zemin / Kat 1 / Kat 2)
    ↓
AR Kamera Sayfası
    ↓
    ├─→ NavigationPage (Video Rehber)
    └─→ NavigationPage (Hedef Önizleme)
```

## 🔄 Veri Akışı

```
BleRouter Service
    ↓ (Stream)
BLE Scanner Page
    ↓ (Navigation)
Kat Sayfaları
    ↓ (POI Selection)
AR Kamera Page
    ↓ (Button Press)
Navigation Page
```

## 📱 Platform Desteği

| Platform | Durum | Notlar |
|----------|-------|--------|
| Android | ✅ Tam Destek | API 21+ |
| iOS | ✅ Tam Destek | iOS 11.0+ |
| Web | ⚠️ Sınırlı | Kamera ve BLE sınırlı |
| Windows | ⚠️ Sınırlı | BLE sınırlı |
| Linux | ⚠️ Sınırlı | BLE sınırlı |
| macOS | ⚠️ Sınırlı | BLE sınırlı |

## 🎯 Temel Özellikler

### Bluetooth Navigasyon
- `ble_router.dart` - Tarama yönetimi
- `ble_scanner_page.dart` - Kullanıcı arayüzü
- Kat sayfaları - Otomatik algılama

### AR Navigasyon
- `ar_camera_page.dart` - Kamera ve AR
- `navigation_page.dart` - Video ve önizleme
- Sensör entegrasyonu

### Sesli Komut
- Kat sayfalarında entegre
- `speech_to_text` paketi
- Türkçe dil desteği

## 📦 Bağımlılıklar

### Ana Paketler
- `flutter_blue_plus` - Bluetooth
- `camera` - Kamera erişimi
- `sensors_plus` - Cihaz sensörleri
- `video_player` - Video oynatma
- `speech_to_text` - Ses tanıma
- `permission_handler` - İzin yönetimi

### UI Paketler
- `flutter_animate` - Animasyonlar
- `shimmer` - Yükleme efektleri
- `lottie` - Vektör animasyonları
- `cached_network_image` - Görüntü önbellekleme

## 🔧 Geliştirme

### Yeni Sayfa Ekleme
1. `lib/pages/` altında yeni dosya oluştur
2. `main.dart`'a route ekle
3. Gerekirse Bluetooth yönetimi ekle

### Yeni Servis Ekleme
1. `lib/services/` altında yeni dosya oluştur
2. Singleton pattern kullan
3. Stream tabanlı veri yönetimi

### Yeni Widget Ekleme
1. `lib/widgets/` altında yeni dosya oluştur
2. Yeniden kullanılabilir yap
3. Dokümante et

## 📚 Dokümantasyon

- `README.md` - Genel proje bilgisi
- `AR_FEATURES.md` - AR özellikleri
- `BLUETOOTH_MANAGEMENT.md` - Bluetooth yönetimi
- `NAVIGATION_FLOW.md` - Navigasyon akışı
- `PROJECT_STRUCTURE.md` - Bu dosya
- `requirements.txt` - Sistem gereksinimleri

## 🆘 Destek

Proje yapısı ile ilgili sorular için:
1. Bu dokümantasyonu kontrol edin
2. İlgili dosyanın içindeki yorumları okuyun
3. GitHub'da issue açın

---

**Son Güncelleme**: Kullanılmayan dosyalar temizlendi, proje yapısı optimize edildi.
