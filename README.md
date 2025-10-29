# NavBle - Bluetooth Tabanlı İç Mekan Navigasyon Uygulaması

## 📱 Proje Hakkında

NavBle, Bluetooth Low Energy (BLE) teknolojisini kullanarak bina içi navigasyon sağlayan bir Flutter uygulamasıdır. Uygulama, kullanıcıların bina içindeki farklı katlarda bulunan noktalara (POI - Point of Interest) kolayca ulaşmasını sağlar. Sesli komut desteği ve video tabanlı navigasyon özellikleri ile kullanıcı deneyimini geliştirir.

## ✨ Özellikler

- **Bluetooth Tabanlı Konum Tespiti**: BLE sinyallerini kullanarak kullanıcının bulunduğu katı otomatik tespit eder
- **Çok Katlı Bina Desteği**: Zemin, 1. Kat ve 2. Kat için ayrı harita görünümleri
- **Sesli Komut Desteği**: Mikrofon kullanarak hedef noktaya sesli komutla navigasyon
- **Video Tabanlı Navigasyon**: Her rota için özel hazırlanmış navigasyon videoları
- **Gerçek Zamanlı Arama**: Bina içindeki tüm noktaları arama ve filtreleme
- **Otomatik Kat Değiştirme**: BLE sinyallerine göre otomatik kat geçişi
- **Modern UI/UX**: Material Design prensiplerine uygun kullanıcı arayüzü

## 🏗️ Mimari Yapı

```
lib/
├── main.dart                 # Ana uygulama giriş noktası
├── models/
│   └── poi_data.dart        # POI ve navigasyon veri modelleri
├── pages/
│   ├── ble_scanner_page.dart # BLE tarama ana sayfası
│   ├── zemin_page.dart      # Zemin kat harita sayfası
│   ├── kat1_page.dart       # 1. kat harita sayfası
│   ├── kat2_page.dart       # 2. kat harita sayfası
│   └── navigation_page.dart # Navigasyon sayfası
├── services/
│   └── ble_router.dart      # BLE yönetim servisi
├── views/
│   ├── ble_scanner_view.dart # BLE tarama görünümü
│   ├── floor_map_view.dart   # Kat harita görünümü
│   └── navigation_view.dart  # Navigasyon görünümü
└── widgets/
    ├── custom_appbar.dart    # Özel uygulama çubuğu
    ├── device_title.dart     # Cihaz başlık widget'ı
    ├── stop_scan_button.dart # Tarama durdurma butonu
    └── voice_search_button.dart # Sesli arama butonu
```

## 🚀 Kurulum

### Gereksinimler

- **Flutter SDK**: 3.9.2 veya üzeri
- **Dart SDK**: 3.9.2 veya üzeri
- **Android Studio** veya **VS Code** (Flutter eklentisi ile)
- **Git**

### Adım 1: Flutter Kurulumu

1. [Flutter resmi sitesinden](https://flutter.dev/docs/get-started/install) Flutter SDK'yı indirin
2. Flutter'ı PATH'e ekleyin
3. Kurulumu doğrulayın:
   ```bash
   flutter doctor
   ```

### Adım 2: Projeyi Klonlama

```bash
git clone <repository-url>
cd deneme1/flutter_application_1
```

### Adım 3: Bağımlılıkları Yükleme

```bash
flutter pub get
```

### Adım 4: Platform Özel Kurulumlar

#### Android Kurulumu

1. **Android Studio**'yu açın
2. **SDK Manager**'dan gerekli Android SDK'ları yükleyin
3. **Android Virtual Device (AVD)** oluşturun veya fiziksel cihaz bağlayın
4. USB Debugging'i etkinleştirin

#### iOS Kurulumu (macOS gerekli)

1. **Xcode**'u App Store'dan indirin
2. **CocoaPods**'u yükleyin:
   ```bash
   sudo gem install cocoapods
   ```
3. iOS bağımlılıklarını yükleyin:
   ```bash
   cd ios && pod install && cd ..
   ```

### Adım 5: Uygulamayı Çalıştırma

#### Android'de Çalıştırma

```bash
flutter run
```

#### iOS'ta Çalıştırma (macOS gerekli)

```bash
flutter run -d ios
```

#### Web'de Çalıştırma

```bash
flutter run -d web
```

## 📱 Kullanım

### 1. BLE Tarama

- Uygulama açıldığında otomatik olarak BLE tarama başlar
- "Taramayı Başlat" butonuna basarak manuel tarama başlatabilirsiniz
- Uygulama, "Zemin", "Kat 1", "Kat 2" isimli BLE cihazlarını arar

### 2. Kat Değiştirme

- BLE sinyallerine göre otomatik olarak kat değişir
- Manuel olarak farklı katlara geçiş yapabilirsiniz

### 3. Hedef Arama

- Arama çubuğuna tıklayarak tüm bina noktalarını görüntüleyin
- İstediğiniz hedefe tıklayarak navigasyonu başlatın

### 4. Sesli Komut

- Mikrofon butonuna basarak sesli komut modunu aktifleştirin
- Hedef noktanın adını söyleyerek navigasyonu başlatın
- Örnek: "Danışma Masası", "Bekleme Salonu", "WC"

### 5. Navigasyon

- Seçilen hedef için video tabanlı navigasyon başlar
- Video, hedefe giden yolu adım adım gösterir

## 🔧 Geliştirme

### Proje Yapısı

- **MVC Pattern**: Model-View-Controller mimarisi kullanılır
- **Service Layer**: BLE yönetimi için ayrı servis katmanı
- **Widget Composition**: Yeniden kullanılabilir widget'lar
- **State Management**: Flutter'ın built-in state yönetimi

### Yeni POI Ekleme

`lib/models/poi_data.dart` dosyasında `BuildingData.allPOIs` listesine yeni POI ekleyin:

```dart
POI(
  name: 'Yeni Nokta',
  key: 'yeniNokta',
  floor: 'Zemin',
  imageUrl: 'https://example.com/image.jpg',
),
```

### Yeni Rota Ekleme

`lib/models/poi_data.dart` dosyasında `BuildingData.allRoutes` listesine yeni rota ekleyin:

```dart
NavVideo(
  startPOI: 'Başlangıç Noktası',
  endPOI: 'Bitiş Noktası',
  url: 'https://example.com/video.mp4',
  name: 'rota_adi',
),
```

### Yeni Kat Ekleme

1. Yeni kat sayfası oluşturun (`kat3_page.dart`)
2. `main.dart`'ta route ekleyin
3. `ble_router.dart`'ta kat adını `_allowedNames`'e ekleyin
4. `ble_scanner_page.dart`'ta `_routeForName` metodunu güncelleyin

## 📦 Bağımlılıklar

### Ana Bağımlılıklar

- **flutter_blue_plus**: ^2.0.0 - Bluetooth Low Energy desteği
- **permission_handler**: ^12.0.1 - İzin yönetimi
- **video_player**: ^2.10.0 - Video oynatma
- **speech_to_text**: ^7.3.0 - Ses tanıma

### Geliştirme Bağımlılıkları

- **flutter_test**: Test framework'ü
- **flutter_lints**: ^5.0.0 - Kod kalitesi kontrolü

## 🔐 İzinler

### Android (android/app/src/main/AndroidManifest.xml)

```xml
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS (ios/Runner/Info.plist)

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Bu uygulama Bluetooth kullanarak konum tespiti yapar</string>
<key>NSMicrophoneUsageDescription</key>
<string>Bu uygulama sesli komutlar için mikrofon kullanır</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Bu uygulama konum tespiti için konum bilgisi kullanır</string>
```

## 🐛 Sorun Giderme

### Yaygın Sorunlar

1. **BLE Cihazları Görünmüyor**

   - Bluetooth'un açık olduğundan emin olun
   - Konum izinlerini kontrol edin
   - Cihazı yeniden başlatın

2. **Sesli Komut Çalışmıyor**

   - Mikrofon iznini kontrol edin
   - İnternet bağlantısını kontrol edin
   - Cihazın mikrofonunun çalıştığından emin olun

3. **Video Oynatılamıyor**
   - İnternet bağlantısını kontrol edin
   - Video URL'lerinin erişilebilir olduğundan emin olun

### Debug Modu

```bash
flutter run --debug
```

### Log Görüntüleme

```bash
flutter logs
```

## 📊 Performans

### Optimizasyon Önerileri

- BLE tarama sıklığını ihtiyaca göre ayarlayın
- Video dosyalarını optimize edin
- Gereksiz widget rebuild'lerini önleyin
- Memory leak'leri kontrol edin

### Test Etme

```bash
# Unit testler
flutter test

# Integration testler
flutter drive --target=test_driver/app.dart
```

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit yapın (`git commit -m 'Add amazing feature'`)
4. Push yapın (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına bakın.

## 📞 İletişim

- **Proje Sahibi**: [Öznur Karahasan]
- **E-posta**: [oznurkarahasann@gmail.com]
- **GitHub**: [github.com/oznurkarahasan]

**Not**: Bu uygulama geliştirme aşamasındadır. Üretim ortamında kullanmadan önce kapsamlı testler yapın.
