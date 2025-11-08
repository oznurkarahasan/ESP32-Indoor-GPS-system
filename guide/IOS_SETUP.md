# iOS Kurulum ve Yapılandırma Rehberi

## 📱 Genel Bakış

Bu rehber, NavIn uygulamasının iOS platformunda çalışması için gerekli tüm ayarları içerir.

## 🎯 Minimum Gereksinimler

- **iOS Sürümü**: 11.0 veya üzeri
- **Xcode**: 14.0 veya üzeri
- **CocoaPods**: 1.11.0 veya üzeri
- **Swift**: 5.0 veya üzeri

## 🔐 İzinler (Permissions)

### Info.plist İzinleri

Aşağıdaki izinler `ios/Runner/Info.plist` dosyasına eklenmiştir:

#### 1. Kamera İzni (NSCameraUsageDescription)
```xml
<key>NSCameraUsageDescription</key>
<string>NavIn, AR navigasyon özelliği için kamera erişimine ihtiyaç duyar. Gerçek dünya görüntüsü üzerine yön okları yerleştirerek size yol gösterir.</string>
```

**Ne zaman istenir**: AR kamera sayfası açıldığında
**Zorunlu mu**: Hayır (AR desteklenmeyen cihazlarda video rehber kullanılır)

---

#### 2. Mikrofon İzni (NSMicrophoneUsageDescription)
```xml
<key>NSMicrophoneUsageDescription</key>
<string>NavIn, sesli komutlarla hedef aramanız için mikrofon erişimine ihtiyaç duyar. "Kütüphane" diyerek hedefinizi bulabilirsiniz.</string>
```

**Ne zaman istenir**: Sesli komut butonu kullanıldığında
**Zorunlu mu**: Hayır (Manuel arama da mevcut)

---

#### 3. Konum İzni (NSLocationWhenInUseUsageDescription)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>NavIn, Bluetooth sinyalleri ile bulunduğunuz katı tespit etmek için konum erişimine ihtiyaç duyar. Konumunuz kaydedilmez.</string>
```

**Ne zaman istenir**: Bluetooth tarama başlatıldığında
**Zorunlu mu**: Evet (Bluetooth tarama için iOS gereksinimi)

---

#### 4. Bluetooth İzni (NSBluetoothAlwaysUsageDescription)
```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>NavIn, ESP32 cihazlarından gelen Bluetooth sinyalleri ile bulunduğunuz katı tespit eder ve size yol gösterir.</string>
```

**Ne zaman istenir**: Bluetooth tarama başlatıldığında
**Zorunlu mu**: Evet (Ana özellik)

---

#### 5. Hareket Sensörleri (NSMotionUsageDescription)
```xml
<key>NSMotionUsageDescription</key>
<string>NavIn, AR navigasyon için cihazınızın hareket sensörlerini kullanır. Bu sayede yön okları cihazınızın hareketine göre güncellenir.</string>
```

**Ne zaman istenir**: AR kamera sayfası açıldığında
**Zorunlu mu**: Hayır (AR için opsiyonel)

---

#### 6. Konuşma Tanıma (NSSpeechRecognitionUsageDescription)
```xml
<key>NSSpeechRecognitionUsageDescription</key>
<string>NavIn, sesli komutlarınızı anlamak için konuşma tanıma özelliğini kullanır.</string>
```

**Ne zaman istenir**: Sesli komut kullanıldığında
**Zorunlu mu**: Hayır (Manuel arama da mevcut)

---

## 🔧 Background Modes

Arka planda Bluetooth tarama için gerekli modlar:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>bluetooth-central</string>
    <string>location</string>
</array>
```

**Amaç**: Uygulama arka plandayken de kat değişikliklerini algılayabilmek

---

## 📦 CocoaPods Kurulumu

### 1. CocoaPods Yükleme

```bash
# CocoaPods yüklü değilse
sudo gem install cocoapods

# Sürümü kontrol et
pod --version
```

### 2. Pod Kurulumu

```bash
# iOS dizinine git
cd ios

# Pod'ları yükle
pod install

# Eğer hata alırsanız
pod repo update
pod install --repo-update
```

### 3. Workspace Açma

```bash
# .xcworkspace dosyasını aç (NOT: .xcodeproj değil!)
open Runner.xcworkspace
```

---

## 🏗️ Xcode Ayarları

### 1. Signing & Capabilities

1. Xcode'da `Runner.xcworkspace` dosyasını açın
2. Sol panelden `Runner` projesini seçin
3. `Signing & Capabilities` sekmesine gidin
4. `Team` seçin (Apple Developer hesabınız)
5. `Bundle Identifier` benzersiz yapın (örn: `com.yourcompany.navin`)

### 2. Deployment Target

1. `General` sekmesine gidin
2. `Deployment Info` bölümünde:
   - **iOS Deployment Target**: 11.0
   - **Devices**: iPhone

### 3. Capabilities Ekleme

`Signing & Capabilities` sekmesinde `+ Capability` butonuna tıklayın:

- ✅ **Background Modes**
  - Location updates
  - Uses Bluetooth LE accessories

---

## 🔨 Build Ayarları

### Build Settings

1. `Runner` target'ını seçin
2. `Build Settings` sekmesine gidin
3. Aşağıdaki ayarları yapın:

```
IPHONEOS_DEPLOYMENT_TARGET = 11.0
ENABLE_BITCODE = NO
SWIFT_VERSION = 5.0
```

### Info.plist Ayarları

Aşağıdaki ayarlar otomatik olarak yapılmıştır:

```xml
<!-- Uygulama Adı -->
<key>CFBundleDisplayName</key>
<string>NavIn</string>

<!-- Status Bar -->
<key>UIStatusBarHidden</key>
<false/>

<!-- Desteklenen Yönler -->
<key>UISupportedInterfaceOrientations</key>
<array>
    <string>UIInterfaceOrientationPortrait</string>
    <string>UIInterfaceOrientationLandscapeLeft</string>
    <string>UIInterfaceOrientationLandscapeRight</string>
</array>
```

---

## 🚀 Build ve Run

### Simulator'da Çalıştırma

```bash
# Flutter komutu ile
flutter run -d "iPhone 14 Pro"

# Veya Xcode'dan
# Product > Run (⌘R)
```

**Not**: Simulator'da Bluetooth ve kamera çalışmaz. Gerçek cihaz gereklidir.

### Gerçek Cihazda Çalıştırma

1. iPhone'unuzu Mac'e bağlayın
2. Xcode'da cihazınızı seçin
3. `Product > Run` (⌘R)

```bash
# Flutter komutu ile
flutter run -d "Your iPhone Name"
```

---

## 🐛 Yaygın Sorunlar ve Çözümler

### Problem 1: "No such module" hatası

**Çözüm**:
```bash
cd ios
pod deintegrate
pod install
```

### Problem 2: Signing hatası

**Çözüm**:
1. Xcode'da `Signing & Capabilities` sekmesine gidin
2. `Automatically manage signing` seçeneğini işaretleyin
3. Team seçin

### Problem 3: Bluetooth izni çalışmıyor

**Çözüm**:
1. Info.plist'te tüm Bluetooth izinlerinin olduğundan emin olun
2. Konum izni de verilmiş olmalı (iOS gereksinimi)
3. Uygulamayı silip yeniden yükleyin

### Problem 4: Kamera açılmıyor

**Çözüm**:
1. Info.plist'te NSCameraUsageDescription olduğundan emin olun
2. iOS Ayarlar > NavIn > Kamera iznini kontrol edin
3. Gerçek cihazda test edin (Simulator'da kamera yok)

### Problem 5: Pod install hatası

**Çözüm**:
```bash
# CocoaPods cache'i temizle
pod cache clean --all

# Repo güncelle
pod repo update

# Tekrar dene
pod install
```

---

## 📋 Test Checklist

iOS build öncesi kontrol listesi:

- [ ] Info.plist'te tüm izinler var mı?
- [ ] Podfile doğru yapılandırılmış mı?
- [ ] `pod install` çalıştırıldı mı?
- [ ] Xcode'da signing yapılandırıldı mı?
- [ ] Bundle identifier benzersiz mi?
- [ ] Deployment target 11.0 mı?
- [ ] Background modes eklendi mi?
- [ ] Gerçek cihazda test edildi mi?

---

## 🎯 İzin İsteme Akışı

### Uygulama İlk Açılışta

```
1. Ana Sayfa Açılır
   ↓
2. "Taramayı Başlat" Butonu
   ↓
3. Konum İzni İstenir (Bluetooth için gerekli)
   ↓
4. Bluetooth İzni İstenir
   ↓
5. Tarama Başlar
```

### AR Kamera Kullanımında

```
1. Hedef Seçilir
   ↓
2. AR Desteği Kontrol Edilir
   ↓
3. Kamera İzni İstenir
   ↓
4. Hareket Sensörü İzni İstenir (Otomatik)
   ↓
5. AR Kamera Açılır
```

### Sesli Komut Kullanımında

```
1. Mikrofon Butonu Tıklanır
   ↓
2. Mikrofon İzni İstenir
   ↓
3. Konuşma Tanıma İzni İstenir
   ↓
4. Sesli Komut Dinlenir
```

---

## 📱 iOS Sürüm Desteği

| iOS Sürümü | Bluetooth | Kamera | AR | Durum |
|------------|-----------|--------|-----|-------|
| iOS 11.0-11.4 | ✅ | ✅ | ⚠️ | Desteklenir |
| iOS 12.0-12.5 | ✅ | ✅ | ✅ | Tam Destek |
| iOS 13.0+ | ✅ | ✅ | ✅ | Tam Destek |
| iOS 14.0+ | ✅ | ✅ | ✅ | Önerilen |
| iOS 15.0+ | ✅ | ✅ | ✅ | Önerilen |
| iOS 16.0+ | ✅ | ✅ | ✅ | Önerilen |
| iOS 17.0+ | ✅ | ✅ | ✅ | En İyi |

---

## 🔐 Gizlilik ve Güvenlik

### Veri Toplama

NavIn uygulaması:
- ❌ Konum verilerini kaydetmez
- ❌ Kamera görüntülerini saklamaz
- ❌ Ses kayıtlarını saklamaz
- ✅ Sadece Bluetooth sinyallerini işler
- ✅ Tüm veriler cihazda kalır

### App Store Privacy Labels

App Store'da belirtilmesi gerekenler:

**Konum**
- Kullanım: Bluetooth tarama için
- Bağlantı: Hayır
- İzleme: Hayır

**Kamera**
- Kullanım: AR navigasyon için
- Bağlantı: Hayır
- İzleme: Hayır

**Mikrofon**
- Kullanım: Sesli komutlar için
- Bağlantı: Hayır
- İzleme: Hayır

---

## 📞 Destek

iOS build sorunları için:
1. Bu dokümantasyonu kontrol edin
2. Xcode console loglarını inceleyin
3. `flutter doctor -v` çalıştırın
4. GitHub'da issue açın

---

## 🔗 Faydalı Linkler

- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)
- [CocoaPods](https://cocoapods.org/)
- [Xcode Documentation](https://developer.apple.com/xcode/)
- [iOS Permissions](https://developer.apple.com/documentation/uikit/protecting_the_user_s_privacy)

---

**Not**: iOS build için Mac bilgisayar ve Apple Developer hesabı gereklidir.
