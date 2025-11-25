![System](docs/nav.png)

# ESP32 Indoor GPS System with AR Navigation

Flutter tabanlı iç mekan navigasyon sistemi. Bluetooth Low Energy (BLE) sinyalleri kullanarak konum tespiti yapar ve AR (Augmented Reality) teknolojisi ile kullanıcıya yol gösterir.

## 🚀 Özellikler

### 🔵 Bluetooth Navigasyon

- ESP32 cihazlarından BLE sinyalleri ile konum tespiti
- Otomatik kat algılama (Zemin, Kat 1, Kat 2)
- Gerçek zamanlı sinyal gücü takibi
- Akıllı navigasyon algoritması
- Otomatik tarama yönetimi (pil tasarrufu için)

### 🎯 AR (Augmented Reality) Navigasyon

- **Otomatik AR Yetenek Kontrolü**: Cihaz desteğine göre otomatik yönlendirme
- **Kamera Tabanlı AR**: Gerçek dünya görüntüsü üzerine yön okları
- Gerçek zamanlı 3D AR yön göstergeleri
- Animasyonlu ok işaretleri ile yol tarifi
- Cihaz sensörleri entegrasyonu (Accelerometer, Gyroscope, Magnetometer)
- Pusula desteği ile yön bulma
- Mesafe ve hız göstergeleri
- İnteraktif kontroller (ok ekle/çıkar, ilerle, sıfırla)
- **Fallback Desteği**: AR desteklenmeyen cihazlarda video rehber

### 🎨 Modern UI/UX

- Material Design 3
- Gradient ve animasyonlar
- Shimmer efektleri
- Lottie animasyonları
- Responsive tasarım

## 📱 Ekran Görüntüleri

- Ana Sayfa: BLE tarayıcı
- AR Navigasyon: Artırılmış gerçeklik yol tarifi
- Kat Sayfaları: Zemin, Kat 1, Kat 2

## 🛠️ Teknolojiler

### Flutter Paketleri

- `flutter_blue_plus`: BLE iletişimi
- `permission_handler`: İzin yönetimi
- `sensors_plus`: Cihaz sensörleri (AR için)
- `vector_math`: 3D matematik işlemleri
- `flutter_animate`: Animasyonlar
- `shimmer`: Yükleme efektleri
- `lottie`: Vektör animasyonları
- `video_player`: Video oynatma
- `speech_to_text`: Ses tanıma

### Donanım

- ESP32 geliştirme kartları
- BLE beacon'lar
- Bluetooth 4.0+ destekli mobil cihazlar

## 📋 Gereksinimler

- Flutter SDK: 3.7.12
- Dart SDK: 3.0.6
- Java JDK: 17 (Android için)
- Android SDK: API 21+ (Android 5.0+)
- iOS: 11.0+ (iOS geliştirme için)

## 🔧 Kurulum

### 1. Projeyi Klonlayın

```bash
git clone https://github.com/yourusername/ESP32-Indoor-GPS-system.git
cd ESP32-Indoor-GPS-system
```

### 2. Bağımlılıkları Yükleyin

```bash
flutter pub get
```

### 3. Flutter Doctor Kontrolü

```bash
flutter doctor
```

### 4. Uygulamayı Çalıştırın

```bash
# Android
flutter run

# iOS (macOS gerekli)
flutter run -d ios

# Web
flutter run -d chrome
```

## 🏗️ Build

### Android APK

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

## 🎮 Kullanım

### BLE Navigasyon

1. Uygulamayı açın
2. "Taramayı Başlat" butonuna tıklayın
3. Bluetooth izinlerini verin
4. Sistem otomatik olarak bulunduğunuz katı algılayacak
5. Kat sayfasında konumunuzu göreceksiniz

### AR Kamera Navigasyon (AR Desteklenen Cihazlar)

1. Kat sayfalarında (Zemin, Kat 1, Kat 2) gitmek istediğiniz yeri seçin
2. Otomatik olarak AR Kamera sayfası açılır
3. Kamera ve sensör izinlerini verin
4. Gerçek dünya görüntüsü üzerine AR okları görün
5. Üst tarafta bilgi kartında gösterilir:
   - **Yön Talimatı**: Hangi yöne doğru ilerleyeceğiniz
   - **Hedef**: Gitmek istediğiniz yer
   - **Kat**: Hedefin hangi katta olduğu
6. Alt tarafta 2 büyük buton görünür:
   - **Video Rehber**: Hedefe giden yolu video ile gösterir
   - **Hedef Önizleme**: Gideceğiniz yerin fotoğrafını gösterir
7. Cihazınızı hareket ettirerek AR efektlerini görün
8. Sağ üst köşeden kapat butonu ile çıkabilirsiniz

### Video Rehber Navigasyon (AR Desteklenmeyen Cihazlar)

1. Kat sayfalarında (Zemin, Kat 1, Kat 2) gitmek istediğiniz yeri seçin
2. Otomatik olarak Navigasyon sayfası açılır
3. Sayfada hem video rehber hem hedef önizleme gösterilir:
   - **Video Rehber**: Hedefe giden yolu video ile gösterir
   - **Hedef Önizleme**: Gideceğiniz yerin fotoğrafını gösterir
4. Video kontrolleri ile videoyu oynatabilirsiniz
5. Hedefe ulaştığınızda başarı mesajı görürsünüz

## 📚 Dokümantasyon

- **README.md** - Bu dosya (Genel proje bilgisi)
- **IOS_SETUP.md** - 🍎 iOS kurulum ve yapılandırma rehberi
- **AR_CAPABILITY_CHECK.md** - 🎯 AR yetenek kontrolü ve otomatik yönlendirme
- **AR_VS_NORMAL_FLOW.md** - 🔄 AR ve Normal mod karşılaştırması
- **BLUETOOTH_QUICK_GUIDE.md** - ⚡ Bluetooth yönetimi hızlı rehber (Yeni sayfa eklerken)
- **BLUETOOTH_CHEATSHEET.md** - 📋 Bluetooth kopya kağıdı (Hızlı referans)
- **BLUETOOTH_MANAGEMENT.md** - Detaylı Bluetooth tarama yönetimi
- **NAVIGATION_FLOW.md** - Sayfa geçişleri ve akış senaryoları
- **AR_FEATURES.md** - AR özellikleri ve kullanımı
- **PROJECT_STRUCTURE.md** - Proje yapısı ve dosya açıklamaları
- **requirements.txt** - Sistem gereksinimleri

## 📁 Proje Yapısı

```
lib/
├── main.dart                 # Ana uygulama
├── pages/                    # Sayfa widget'ları
│   ├── ble_scanner_page.dart
│   ├── ar_camera_page.dart
│   ├── navigation_page.dart
│   ├── zemin_page.dart
│   ├── kat1_page.dart
│   └── kat2_page.dart
├── services/                 # Servis katmanı
│   └── ble_router.dart
├── views/                    # Görünüm bileşenleri
│   └── ble_scanner_view.dart
├── widgets/                  # Yeniden kullanılabilir widget'lar
│   ├── custom_appbar.dart
│   ├── device_title.dart
│   └── stop_scan_button.dart
└── models/                   # Veri modelleri
```

## 🔐 İzinler

### Android (AndroidManifest.xml)

```xml
<uses-permission android:name="android.permission.BLUETOOTH"/>
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
<uses-permission android:name="android.permission.BLUETOOTH_SCAN"/>
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
```

### iOS (Info.plist)

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Bluetooth ile konum tespiti için gerekli</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>İç mekan navigasyonu için gerekli</string>
<key>NSCameraUsageDescription</key>
<string>AR navigasyon için gerekli</string>
<key>NSMicrophoneUsageDescription</key>
<string>Ses komutları için gerekli</string>
```

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request açın

## 📝 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## 👥 Geliştirici

- GitHub: [@yourusername](https://github.com/yourusername)

## 🐛 Bilinen Sorunlar

- AR özelliği bazı eski cihazlarda performans sorunları yaşayabilir
- iOS'ta ARKit desteği için iOS 11+ gereklidir
- Bluetooth izinleri Android 12+ için özel yapılandırma gerektirir

## 🔮 Gelecek Planlar

- [ ] Gerçek ARCore/ARKit entegrasyonu
- [ ] 3D bina modelleri
- [ ] Çoklu dil desteği
- [ ] Offline harita desteği
- [ ] Ses komutları ile navigasyon
- [ ] Sosyal özellikler (konum paylaşımı)

## 📞 İletişim

Sorularınız için issue açabilir veya email gönderebilirsiniz.

---

⭐ Bu projeyi beğendiyseniz yıldız vermeyi unutmayın!!!
