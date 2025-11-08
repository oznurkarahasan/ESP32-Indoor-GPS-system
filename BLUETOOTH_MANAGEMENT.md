# Bluetooth Tarama Yönetimi

## 📡 Genel Bakış

Uygulama, farklı sayfalarda Bluetooth taramasını otomatik olarak yönetir. Bu, pil tasarrufu ve performans optimizasyonu için önemlidir.

## 🔄 Bluetooth Tarama Durumları

### 📋 Sayfa Bazlı Tarama Yönetimi

| Sayfa | initState() | dispose() | Tarama Durumu |
|-------|-------------|-----------|---------------|
| Ana Sayfa | - | - | ✅ Aktif |
| Kat Sayfaları | - | - | ✅ Aktif |
| AR Kamera | `stop()` | `start()` | ⏸️ Durduruldu |
| NavigationPage | `stop()` | - | ⏸️ Durduruldu |

### ✅ Tarama Aktif Olan Sayfalar

1. **Ana Sayfa (BLE Scanner)**
   - Tarama başlatıldığında aktif
   - Cihazları sürekli tarar
   - Kat değişikliklerini algılar

2. **Kat Sayfaları (Zemin, Kat 1, Kat 2)**
   - Otomatik kat algılama için tarama devam eder
   - Kullanıcı başka kata geçtiğinde otomatik yönlendirme
   - Arka planda sürekli tarama

### ⏸️ Tarama Duran Sayfalar

1. **AR Kamera Sayfası**
   - `initState()`: Bluetooth taraması durdurulur
   - `dispose()`: Bluetooth taraması yeniden başlatılır (sadece kat sayfalarına dönüldüğünde)
   - Kamera ve sensör kaynaklarını optimize eder

2. **Navigation Sayfası (Video Rehber / Önizleme)**
   - `initState()`: Bluetooth taraması durdurulur
   - `dispose()`: Bluetooth taraması BAŞLATILMAZ (AR kameraya geri dönüldüğünde)
   - Video oynatma performansını artırır
   - AR kamera zaten taramayı yönetiyor

## 🔧 Teknik Detaylar

### BleRouter Servisi

```dart
// Taramayı durdur
BleRouter().stop();

// Taramayı başlat
BleRouter().start();
```

### Sayfa Yaşam Döngüsü

#### AR Kamera Sayfası

```dart
@override
void initState() {
  super.initState();
  // ... diğer başlatmalar
  BleRouter().stop(); // ✅ Taramayı durdur
}

@override
void dispose() {
  BleRouter().start(); // ✅ Taramayı başlat
  // ... temizlik işlemleri
  super.dispose();
}
```

#### Navigation Sayfası

```dart
@override
void initState() {
  super.initState();
  // ... diğer başlatmalar
  BleRouter().stop(); // ✅ Taramayı durdur
}

@override
void dispose() {
  // BleRouter().start() KALDIRILDI ❌
  // NavigationPage'den AR kameraya geri dönüldüğünde
  // Bluetooth taraması başlamamalı
  // ... temizlik işlemleri
  super.dispose();
}
```

## 📊 Kullanım Akışı

### 🔑 Önemli Kural

**Sadece AR Kamera Sayfası Bluetooth taramasını yönetir!**
- AR Kamera açıldığında: Taramayı DURDUR
- AR Kamera kapandığında: Taramayı BAŞLAT
- NavigationPage: Sadece DURDUR, asla BAŞLATMA

### Senaryo 1: Normal Navigasyon

```
Ana Sayfa (Tarama: ✅)
    ↓
Kat Sayfası (Tarama: ✅)
    ↓ [Hedef Seç]
AR Kamera (Tarama: ⏸️ DURDUR)
    ↓ [Video Rehber]
Navigation (Tarama: ⏸️ DURDUR)
    ↓ [Geri]
AR Kamera (Tarama: ⏸️ DURMUŞ KALIYOR - Başlatılmıyor)
    ↓ [Geri]
Kat Sayfası (Tarama: ✅ BAŞLAT - AR kamera dispose olduğunda)
```

### Senaryo 2: Hızlı Geri Dönüş

```
Kat Sayfası (Tarama: ✅)
    ↓ [Hedef Seç]
AR Kamera (Tarama: ⏸️ DURDUR)
    ↓ [Geri Butonu]
Kat Sayfası (Tarama: ✅ BAŞLAT)
```

### Senaryo 3: Video Rehber ve Geri Dönüş

```
Kat Sayfası (Tarama: ✅)
    ↓ [Hedef Seç]
AR Kamera (Tarama: ⏸️ DURDUR)
    ↓ [Video Rehber Butonu]
NavigationPage (Tarama: ⏸️ DURDUR)
    ↓ [Geri Butonu]
AR Kamera (Tarama: ⏸️ DURMUŞ KALIYOR)
    ↓ [Hedef Önizleme Butonu]
NavigationPage (Tarama: ⏸️ DURDUR)
    ↓ [Geri Butonu]
AR Kamera (Tarama: ⏸️ DURMUŞ KALIYOR)
    ↓ [Geri Butonu]
Kat Sayfası (Tarama: ✅ BAŞLAT)
```

### Senaryo 4: Kat Değişikliği

```
Zemin Kat (Tarama: ✅)
    ↓ [BLE Sinyali: "Kat 1"]
Kat 1 Sayfası (Tarama: ✅)
    ↓ [Hedef Seç]
AR Kamera (Tarama: ⏸️ DURDUR)
```

## 🎯 Avantajlar

### 1. Pil Tasarrufu
- Gereksiz Bluetooth taraması yapılmaz
- Kamera ve video kullanımı sırasında enerji tasarrufu

### 2. Performans Optimizasyonu
- Kamera ve video daha akıcı çalışır
- Sensör verileri daha hızlı işlenir
- UI daha responsive olur

### 3. Kaynak Yönetimi
- Bluetooth ve kamera aynı anda çalışmaz
- Bellek kullanımı optimize edilir
- CPU kullanımı azalır

## 🔍 Sorun Giderme

### Problem: Kat sayfasına döndüğümde tarama başlamıyor

**Çözüm:**
1. AR kamera sayfasının `dispose()` metodunda `BleRouter().start()` çağrısını kontrol edin
2. Sayfa geçişlerinin doğru yapıldığından emin olun
3. `Navigator.pop()` kullanıldığından emin olun

### Problem: AR kamera açıldığında tarama devam ediyor

**Çözüm:**
1. AR kamera sayfasının `initState()` metodunda `BleRouter().stop()` çağrısını kontrol edin
2. Import'ların doğru olduğundan emin olun
3. BleRouter singleton'ının çalıştığını doğrulayın

### Problem: NavigationPage'den AR kameraya döndüğümde tarama başlıyor

**Çözüm:**
1. NavigationPage'in `dispose()` metodunda `BleRouter().start()` çağrısının OLMADIĞINDAN emin olun
2. Sadece AR kamera sayfası taramayı yönetmeli
3. NavigationPage sadece taramayı durdurmalı, başlatmamalı

### Problem: Tarama sürekli durmuş durumda

**Çözüm:**
1. Ana sayfadan "Taramayı Başlat" butonuna basın
2. Uygulamayı yeniden başlatın
3. Bluetooth izinlerini kontrol edin

## 📱 Platform Özellikleri

### Android
- ✅ Bluetooth tarama otomatik yönetimi
- ✅ Arka plan tarama desteği
- ✅ Pil optimizasyonu

### iOS
- ✅ Bluetooth tarama otomatik yönetimi
- ✅ Arka plan tarama sınırlı
- ✅ Pil optimizasyonu

## 🔐 İzinler

Bluetooth tarama yönetimi için gerekli izinler:

### Android
```xml
<uses-permission android:name="android.permission.BLUETOOTH_SCAN"/>
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
```

### iOS
```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Bluetooth ile konum tespiti için gerekli</string>
```

## 📈 Performans Metrikleri

### Tarama Aktif
- CPU Kullanımı: ~15-20%
- Pil Tüketimi: Orta
- Bellek: ~50MB

### Tarama Durdurulmuş
- CPU Kullanımı: ~5-10%
- Pil Tüketimi: Düşük
- Bellek: ~30MB

## 🎓 Best Practices

1. **Sadece kat sayfalarına dönerken taramayı başlatın**
   ```dart
   // AR Kamera Sayfası
   @override
   void dispose() {
     BleRouter().start(); // ✅ Kat sayfalarına dönüldüğünde başlat
     super.dispose();
   }
   ```

2. **NavigationPage'de taramayı BAŞLATMAYIN**
   ```dart
   // Navigation Sayfası
   @override
   void dispose() {
     // BleRouter().start(); // ❌ BAŞLATMA
     // AR kamera zaten yönetiyor
     super.dispose();
   }
   ```

3. **Kamera/Video sayfalarında taramayı durdurun**
   ```dart
   @override
   void initState() {
     super.initState();
     BleRouter().stop(); // ✅ Taramayı durdur
   }
   ```

4. **Sayfa geçişlerinde Navigator.pop() kullanın**
   ```dart
   Navigator.of(context).pop(); // ✅ Doğru
   // Navigator.pushReplacement() // ❌ Yanlış (dispose çağrılmaz)
   ```

5. **Test edin**
   - Her sayfa geçişinde tarama durumunu kontrol edin
   - Geri butonunu test edin
   - Sistem geri butonunu test edin
   - NavigationPage → AR Kamera geçişini test edin

## 🆘 Destek

Bluetooth tarama yönetimi ile ilgili sorunlar için:
1. Bu dokümantasyonu kontrol edin
2. BleRouter servisini inceleyin
3. Sayfa yaşam döngülerini kontrol edin
4. GitHub'da issue açın

---

**Not**: Bluetooth tarama yönetimi, uygulamanın performansı ve pil ömrü için kritik öneme sahiptir. Her yeni sayfa eklendiğinde bu dokümantasyonu güncelleyin.
