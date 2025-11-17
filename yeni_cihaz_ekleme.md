# 🔧 Yeni Bluetooth Cihazı Ekleme Rehberi

Bu rehber, ESP32 Indoor GPS sistemine yeni bir Bluetooth beacon (örneğin Kat 3, Kat 4, vb.) eklemeniz için gereken tüm adımları içerir.

---

## 📋 Genel Bakış

Mevcut sistemde 3 Bluetooth beacon var:
- **Zemin** (Zemin kat)
- **Kat 1** (1. kat)
- **Kat 2** (2. kat)

Yeni bir kat eklemek için **5 ana adım** gereklidir.

---

## ADIM 1: BLE Router'a Yeni Cihaz Adını Ekleyin

### Dosya: `lib/services/ble_router.dart`

**Satır 14'te** `_allowedNames` setine yeni cihaz adını ekleyin:

```dart
// ÖNCESİ:
static const Set<String> _allowedNames = {'Zemin', 'Kat 1', 'Kat 2'};

// SONRASI (Kat 3 eklendi):
static const Set<String> _allowedNames = {'Zemin', 'Kat 1', 'Kat 2', 'Kat 3'};
```

**⚠️ Önemli:** ESP32 cihazınızın Bluetooth adı tam olarak bu isimle eşleşmeli!

---

## ADIM 2: Yeni Kat Sayfası Oluşturun

### Dosya: `lib/pages/kat3_page.dart` (yeni dosya)

Mevcut `kat2_page.dart` dosyasını kopyalayıp aşağıdaki değişiklikleri yapın:

### 2.1 Harita URL'sini Güncelleyin

```dart
// Satır 16-17
const String kat3HaritaUrl =
    "https://drive.google.com/uc?export=view&id=SIZIN_KAT3_HARITA_ID";
```

**Not:** Google Drive'dan harita görselinin paylaşım linkini alın ve ID'yi buraya yazın.

### 2.2 Class İsimlerini Değiştirin

```dart
// Satır 19-25
class Kat3Page extends StatefulWidget {
  const Kat3Page({super.key});

  @override
  State<Kat3Page> createState() => _Kat3PageState();
}

class _Kat3PageState extends State<Kat3Page> with TickerProviderStateMixin {
```

### 2.3 Beacon Dinleme Kontrolünü Güncelleyin

```dart
// Satır 60-65 civarı (initState içinde)
_sub = BleRouter().topStream.listen((top) {
  if (!mounted) return;
  if (top == null) return;
  if (top.name == 'Kat 3') return;  // ← BURASI DEĞİŞTİ

  final now = DateTime.now();
  if (now.difference(_lastNav) < const Duration(milliseconds: 1200)) return;
  _lastNav = now;
  _navigateFor(top.name);
});
```

### 2.4 Navigasyon Metodunu Güncelleyin

```dart
// Satır 650 civarı
void _navigateFor(String name) {
  String? route;
  if (name == 'Zemin') route = '/zemin';
  if (name == 'Kat 1') route = '/kat1';
  if (name == 'Kat 2') route = '/kat2';
  // YENİ: Diğer katlardan Kat 3'e geçiş için route ekleyin
  // (Eğer daha fazla kat eklerseniz, onları da buraya ekleyin)

  if (route != null) {
    Navigator.of(context).pushReplacementNamed(route);
  }
}
```

### 2.5 AppBar Başlığını Değiştirin

```dart
// Satır 700 civarı (build metodu içinde)
appBar: const CustomAppBar(title: "3. Kat"),  // ← BURASI DEĞİŞTİ
```

### 2.6 Başlangıç POI'sini Ayarlayın

```dart
// Satır 250 civarı (_startNavigation metodu içinde)
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) =>
        NavigationPage(startPOI: 'Kat 3 Giriş', endPOI: targetPOI),  // ← BURASI DEĞİŞTİ
  ),
);
```

**Not:** 'Kat 3 Giriş' POI'sinin `poi_data.dart` dosyasında tanımlı olması gerekir (Adım 5'e bakın).

### 2.7 Kat Bilgisi Overlay'ini Güncelleyin

```dart
// Satır 800 civarı (_buildMapSection metodu içinde)
child: const Text(
  '3. Kat',  // ← BURASI DEĞİŞTİ
  style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  ),
),
```

---

## ADIM 3: Ana Routing'e Yeni Sayfayı Ekleyin

### Dosya: `lib/main.dart`

### 3.1 Import Ekleyin

```dart
import 'pages/zemin_page.dart';
import 'pages/kat1_page.dart';
import 'pages/kat2_page.dart';
import 'pages/kat3_page.dart';  // YENİ
```

### 3.2 Route Tanımı Ekleyin

```dart
routes: {
  '/zemin': (context) => const ZeminPage(),
  '/kat1': (context) => const Kat1Page(),
  '/kat2': (context) => const Kat2Page(),
  '/kat3': (context) => const Kat3Page(),  // YENİ
},
```

---

## ADIM 4: Diğer Kat Sayfalarına Geçiş Ekleyin

Her kat sayfasının `_navigateFor` metoduna yeni katı ekleyin.

### Dosyalar: 
- `lib/pages/zemin_page.dart`
- `lib/pages/kat1_page.dart`
- `lib/pages/kat2_page.dart`

Her birinde aşağıdaki değişikliği yapın:

```dart
void _navigateFor(String name) {
  String? route;
  if (name == 'Zemin') route = '/zemin';
  if (name == 'Kat 1') route = '/kat1';
  if (name == 'Kat 2') route = '/kat2';
  if (name == 'Kat 3') route = '/kat3';  // YENİ

  if (route != null) {
    Navigator.of(context).pushReplacementNamed(route);
  }
}
```

---

## ADIM 5: POI Verilerini Ekleyin (Opsiyonel)

Eğer Kat 3'te navigasyon yapılacak yerler varsa, POI verilerini ekleyin.

### Dosya: `lib/models/poi_data.dart`

`allPOIs` listesine yeni POI'leri ekleyin:

```dart
static final List<POI> allPOIs = [
  // ... mevcut POI'ler ...
  
  // Kat 3 POI'leri
  POI(
    name: 'Kat 3 Giriş',
    key: 'kat3_giris',
    floor: 'Kat 3',
    imageUrl: 'https://example.com/kat3_giris.jpg',
    aliases: ['üçüncü kat giriş', 'kat üç giriş'],
  ),
  POI(
    name: 'Kat 3 Ofis',
    key: 'kat3_ofis',
    floor: 'Kat 3',
    imageUrl: 'https://example.com/kat3_ofis.jpg',
    aliases: ['ofis', 'çalışma alanı', 'üçüncü kat ofis'],
  ),
  POI(
    name: 'Kat 3 Toplantı Salonu',
    key: 'kat3_toplanti',
    floor: 'Kat 3',
    imageUrl: 'https://example.com/kat3_toplanti.jpg',
    aliases: ['toplantı', 'konferans', 'meeting'],
  ),
  // Daha fazla POI ekleyebilirsiniz...
];
```

**POI Parametreleri:**
- `name`: POI'nin görünen adı
- `key`: Benzersiz tanımlayıcı (küçük harf, alt çizgi kullanın)
- `floor`: Hangi katta olduğu ('Kat 3', 'Kat 4', vb.)
- `imageUrl`: POI'nin görsel URL'si
- `aliases`: Sesli komut için alternatif isimler (liste)

---

## 📝 ÖZET KONTROL LİSTESİ

Yeni bir kat eklerken şunları yapın:

### Kod Değişiklikleri
- [ ] **BLE Router** (`lib/services/ble_router.dart`): `_allowedNames` setine cihaz adı ekle
- [ ] **Yeni Sayfa** (`lib/pages/katX_page.dart`): Kat2'den kopyala ve özelleştir
  - [ ] Harita URL'sini değiştir
  - [ ] Class isimlerini değiştir
  - [ ] Beacon kontrolünü güncelle
  - [ ] AppBar başlığını değiştir
  - [ ] Başlangıç POI'sini ayarla
  - [ ] Kat bilgisi overlay'ini güncelle
- [ ] **Main.dart** (`lib/main.dart`): Import ve route ekle
- [ ] **Diğer Sayfalar**: Tüm kat sayfalarının `_navigateFor` metoduna yeni katı ekle
  - [ ] `zemin_page.dart`
  - [ ] `kat1_page.dart`
  - [ ] `kat2_page.dart`
- [ ] **POI Data** (`lib/models/poi_data.dart`): Yeni kat için POI'leri ekle (opsiyonel)

### Donanım Ayarları
- [ ] **ESP32**: Bluetooth cihaz adını doğru ayarla
- [ ] **Test**: Cihazın tarama listesinde göründüğünü doğrula

### İçerik Hazırlığı
- [ ] **Harita Görseli**: Kat haritasını Google Drive'a yükle
- [ ] **POI Görselleri**: Her POI için görsel hazırla (opsiyonel)

---

## 🔌 ESP32 Cihaz Ayarları

ESP32'nizde Bluetooth adını ayarlarken:

### Arduino/ESP32 Kodu

```cpp
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>

void setup() {
  // Bluetooth cihaz adını ayarla
  BLEDevice::init("Kat 3");  // ← Tam olarak bu isim olmalı!
  
  // BLE Server oluştur
  BLEServer *pServer = BLEDevice::createServer();
  
  // Advertising başlat
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->start();
  
  Serial.println("Bluetooth beacon başlatıldı: Kat 3");
}

void loop() {
  delay(2000);
}
```

**⚠️ Kritik Önemli:** 
- Bluetooth adı `_allowedNames` setindeki isimle **tam olarak** eşleşmeli
- Büyük/küçük harf duyarlıdır: "Kat 3" ≠ "kat 3" ≠ "KAT 3"
- Boşluklar önemlidir: "Kat 3" ≠ "Kat3"

---

## 🧪 Test Adımları

Yeni katı ekledikten sonra:

1. **Derleme Testi**
   ```bash
   flutter clean
   flutter pub get
   flutter build apk --release
   ```

2. **Bluetooth Testi**
   - ESP32'yi açın
   - Uygulamayı başlatın
   - "Taramayı Başlat" butonuna tıklayın
   - Yeni cihazın listede göründüğünü doğrulayın

3. **Navigasyon Testi**
   - Yeni kata yaklaşın
   - Otomatik olarak yeni kat sayfasına geçiş yapmalı
   - Harita doğru yüklenmeli
   - Diğer katlara geçiş çalışmalı

4. **Sesli Komut Testi**
   - Mikrofon butonuna tıklayın
   - Yeni kattaki bir POI adını söyleyin
   - Navigasyon başlamalı

---

## 🐛 Sık Karşılaşılan Sorunlar

### Sorun 1: Cihaz Listede Görünmüyor
**Çözüm:**
- ESP32'nin Bluetooth adını kontrol edin
- `_allowedNames` setinde doğru yazıldığından emin olun
- ESP32'nin açık ve çalışır durumda olduğunu doğrulayın

### Sorun 2: Sayfa Geçişi Çalışmıyor
**Çözüm:**
- `main.dart` dosyasında route tanımını kontrol edin
- Tüm kat sayfalarının `_navigateFor` metodunu güncelleyin
- Route adının doğru olduğundan emin olun ('/kat3')

### Sorun 3: Harita Yüklenmiyor
**Çözüm:**
- Google Drive linkinin doğru formatda olduğunu kontrol edin
- Link formatı: `https://drive.google.com/uc?export=view&id=DOSYA_ID`
- Dosyanın "Herkese açık" olarak paylaşıldığından emin olun

### Sorun 4: POI Bulunamıyor
**Çözüm:**
- `poi_data.dart` dosyasında POI'nin tanımlı olduğunu kontrol edin
- POI'nin `floor` değerinin doğru olduğundan emin olun
- Başlangıç POI adının `_startNavigation` metodunda doğru yazıldığını kontrol edin

---

## 📚 Ek Kaynaklar

- **Flutter Bluetooth Plus Dokümantasyonu**: https://pub.dev/packages/flutter_blue_plus
- **ESP32 BLE Örnekleri**: https://github.com/espressif/arduino-esp32/tree/master/libraries/BLE
- **Google Drive Paylaşım Rehberi**: Dosya → Paylaş → Bağlantıyı kopyala

---

## 💡 İpuçları

1. **Sistematik İsimlendirme**: Kat isimlerini tutarlı tutun (Kat 1, Kat 2, Kat 3...)
2. **Yedekleme**: Değişiklik yapmadan önce dosyaları yedekleyin
3. **Test Ortamı**: Önce test cihazında deneyin, sonra production'a geçin
4. **Dokümantasyon**: Her yeni kat için hangi POI'lerin eklendiğini not alın
5. **Versiyon Kontrolü**: Git commit'lerinde açıklayıcı mesajlar kullanın

---

## 📞 Destek

Sorun yaşarsanız:
1. Bu rehberi baştan sona kontrol edin
2. Hata mesajlarını not alın
3. Hangi adımda takıldığınızı belirleyin
4. Gerekirse kod örneklerini karşılaştırın

---

**Son Güncelleme:** 18 Kasım 2025
**Versiyon:** 1.0
