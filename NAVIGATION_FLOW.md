# Navigasyon Akışı ve Bluetooth Yönetimi

## 🎯 Genel Bakış

Bu dokümantasyon, uygulamanın sayfa geçişleri ve Bluetooth tarama yönetimini açıklar.

## 📱 Sayfa Hiyerarşisi

### AR Desteklenen Cihazlar

```
Ana Sayfa (BLE Scanner)
    ↓
Kat Sayfaları (Zemin / Kat 1 / Kat 2)
    ↓
AR Kamera Sayfası
    ↓
    ├─→ NavigationPage (Video Rehber - Sadece Video)
    └─→ NavigationPage (Hedef Önizleme - Sadece Önizleme)
```

### AR Desteklenmeyen Cihazlar

```
Ana Sayfa (BLE Scanner)
    ↓
Kat Sayfaları (Zemin / Kat 1 / Kat 2)
    ↓
NavigationPage (Normal Mod - Video + Önizleme)
```

## 🔄 Bluetooth Tarama Yönetimi

### Temel Kural

**Sadece AR Kamera Sayfası Bluetooth taramasını kontrol eder!**

### Sayfa Bazlı Davranışlar

| Sayfa | Açılışta | Kapanışta | Neden |
|-------|----------|-----------|-------|
| **Kat Sayfaları** | - | - | Kat algılama için tarama gerekli |
| **AR Kamera** | `BleRouter().stop()` | `BleRouter().start()` | Kamera performansı + Sadece kat sayfalarına dönüşte başlat |
| **NavigationPage** | `BleRouter().stop()` | - | Video performansı + AR kamera zaten yönetiyor |

## 🎬 Detaylı Akış Senaryoları

### Senaryo 1: Basit Navigasyon

```
1. Kullanıcı Zemin Kat sayfasında
   └─ Bluetooth: ✅ AKTIF (Kat algılama için)

2. Kullanıcı "Kütüphane" hedefini seçer
   └─ AR Kamera açılır
      └─ Bluetooth: ⏸️ DURDURULDU (initState)

3. Kullanıcı AR kamerada yön oklarını görür
   └─ Bluetooth: ⏸️ DURMUŞ (Kamera performansı için)

4. Kullanıcı geri butonuna basar
   └─ Zemin Kat sayfasına döner
      └─ Bluetooth: ✅ BAŞLATILDI (AR kamera dispose)
```

### Senaryo 2: Video Rehber Kullanımı

```
1. Kullanıcı Kat 1 sayfasında
   └─ Bluetooth: ✅ AKTIF

2. Kullanıcı "Kafeterya" hedefini seçer
   └─ AR Kamera açılır
      └─ Bluetooth: ⏸️ DURDURULDU

3. Kullanıcı "Video Rehber" butonuna basar
   └─ NavigationPage açılır (Video modu)
      └─ Bluetooth: ⏸️ DURMUŞ KALIYOR (zaten durdurulmuştu)

4. Kullanıcı videoyu izler ve geri döner
   └─ AR Kamera sayfasına döner
      └─ Bluetooth: ⏸️ DURMUŞ KALIYOR (NavigationPage başlatmadı)

5. Kullanıcı AR kameradan geri döner
   └─ Kat 1 sayfasına döner
      └─ Bluetooth: ✅ BAŞLATILDI (AR kamera dispose)
```

### Senaryo 3: Hedef Önizleme Kullanımı

```
1. Kullanıcı Kat 2 sayfasında
   └─ Bluetooth: ✅ AKTIF

2. Kullanıcı "Laboratuvar" hedefini seçer
   └─ AR Kamera açılır
      └─ Bluetooth: ⏸️ DURDURULDU

3. Kullanıcı "Hedef Önizleme" butonuna basar
   └─ NavigationPage açılır (Önizleme modu)
      └─ Bluetooth: ⏸️ DURMUŞ KALIYOR

4. Kullanıcı hedef fotoğrafını görür ve geri döner
   └─ AR Kamera sayfasına döner
      └─ Bluetooth: ⏸️ DURMUŞ KALIYOR

5. Kullanıcı AR kameradan geri döner
   └─ Kat 2 sayfasına döner
      └─ Bluetooth: ✅ BAŞLATILDI
```

### Senaryo 4: Çoklu Geçiş

```
1. Kat Sayfası (Bluetooth: ✅)
   ↓
2. AR Kamera (Bluetooth: ⏸️ DURDUR)
   ↓
3. Video Rehber (Bluetooth: ⏸️ DURMUŞ)
   ↓
4. AR Kamera (Bluetooth: ⏸️ DURMUŞ - Başlatılmadı)
   ↓
5. Hedef Önizleme (Bluetooth: ⏸️ DURMUŞ)
   ↓
6. AR Kamera (Bluetooth: ⏸️ DURMUŞ - Başlatılmadı)
   ↓
7. Kat Sayfası (Bluetooth: ✅ BAŞLAT - AR kamera dispose)
```

## 🔧 Teknik Implementasyon

### AR Kamera Sayfası

```dart
class _ArCameraPageState extends State<ArCameraPage> {
  @override
  void initState() {
    super.initState();
    // ... diğer başlatmalar
    
    // Bluetooth taramasını durdur
    BleRouter().stop();
  }

  @override
  void dispose() {
    // Bluetooth taramasını tekrar başlat
    // (Sadece kat sayfalarına dönüldüğünde)
    BleRouter().start();
    
    // ... temizlik işlemleri
    super.dispose();
  }
}
```

### Navigation Sayfası

```dart
class _NavigationPageState extends State<NavigationPage> {
  @override
  void initState() {
    super.initState();
    // ... diğer başlatmalar
    
    // Bluetooth taramasını durdur
    BleRouter().stop();
  }

  @override
  void dispose() {
    // BleRouter().start() ÇAĞRILMAZ!
    // Çünkü AR kamera zaten yönetiyor
    
    // ... temizlik işlemleri
    super.dispose();
  }
}
```

## ⚠️ Önemli Notlar

### ✅ Doğru Yaklaşım

1. **AR Kamera**: Taramayı hem durdurur hem başlatır
2. **NavigationPage**: Sadece durdurur, başlatmaz
3. **Kat Sayfaları**: Hiçbir şey yapmaz, tarama zaten aktif

### ❌ Yanlış Yaklaşımlar

1. **NavigationPage'de `BleRouter().start()` çağırmak**
   - Sonuç: AR kameraya döndüğünde tarama başlar
   - Sorun: Gereksiz tarama, performans kaybı

2. **AR Kamera'da `BleRouter().start()` çağırmamak**
   - Sonuç: Kat sayfalarına döndüğünde tarama başlamaz
   - Sorun: Kat algılama çalışmaz

3. **Her sayfada taramayı yönetmeye çalışmak**
   - Sonuç: Karmaşık ve hatalı davranış
   - Sorun: Tutarsız durum yönetimi

## 🐛 Sorun Giderme

### Problem: NavigationPage'den AR kameraya döndüğümde tarama başlıyor

**Neden**: NavigationPage'in dispose metodunda `BleRouter().start()` çağrılıyor

**Çözüm**: NavigationPage'in dispose metodundan `BleRouter().start()` çağrısını kaldırın

```dart
// ❌ YANLIŞ
@override
void dispose() {
  BleRouter().start(); // Kaldır!
  super.dispose();
}

// ✅ DOĞRU
@override
void dispose() {
  // BleRouter().start() çağrılmaz
  super.dispose();
}
```

### Problem: AR kameradan kat sayfasına döndüğümde tarama başlamıyor

**Neden**: AR Kamera'nın dispose metodunda `BleRouter().start()` çağrılmıyor

**Çözüm**: AR Kamera'nın dispose metoduna `BleRouter().start()` ekleyin

```dart
// ❌ YANLIŞ
@override
void dispose() {
  // BleRouter().start() eksik!
  super.dispose();
}

// ✅ DOĞRU
@override
void dispose() {
  BleRouter().start(); // Ekle!
  super.dispose();
}
```

## 📊 Performans Etkileri

### Bluetooth Tarama Aktif
- CPU: ~15-20%
- Pil: Orta tüketim
- Bellek: ~50MB

### Bluetooth Tarama Durdurulmuş
- CPU: ~5-10%
- Pil: Düşük tüketim
- Bellek: ~30MB

### Kamera + AR Aktif (Tarama Durdurulmuş)
- CPU: ~25-30%
- Pil: Yüksek tüketim
- Bellek: ~80MB

### Kamera + AR + Bluetooth (Yanlış Kullanım)
- CPU: ~40-50% ⚠️
- Pil: Çok yüksek tüketim ⚠️
- Bellek: ~130MB ⚠️

## 🎯 Sonuç

**Tek Sorumluluk Prensibi**: Sadece AR Kamera sayfası Bluetooth taramasını yönetir. Bu yaklaşım:

1. ✅ Basit ve anlaşılır
2. ✅ Performans optimizasyonu
3. ✅ Pil tasarrufu
4. ✅ Tutarlı davranış
5. ✅ Kolay bakım

---

**Önemli**: Bu akışı değiştirirken dikkatli olun. Bluetooth tarama yönetimi, uygulamanın temel işlevselliği için kritik öneme sahiptir.
