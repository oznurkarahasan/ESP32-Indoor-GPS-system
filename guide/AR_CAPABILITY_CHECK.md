# AR Yetenek Kontrolü

## 🎯 Genel Bakış

Uygulama, kullanıcının cihazının AR (Augmented Reality) özelliklerini destekleyip desteklemediğini otomatik olarak kontrol eder ve buna göre uygun navigasyon deneyimi sunar.

## 🔍 Kontrol Edilen Özellikler

### 1. Kamera Desteği
- Cihazda kullanılabilir kamera var mı?
- Kamera erişimi mümkün mü?

### 2. Accelerometer (İvmeölçer)
- Cihaz eğimi algılanabiliyor mu?
- Sensör verileri alınabiliyor mu?

### 3. Gyroscope (Jiroskop)
- Cihaz dönüşü algılanabiliyor mu?
- Sensör verileri alınabiliyor mu?

## ⚙️ Nasıl Çalışır?

### Uygulama Başlangıcı

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // AR desteğini kontrol et
  await ArCapabilityService().checkArSupport();
  
  runApp(const MyApp());
}
```

### Kontrol Algoritması

```
1. Kamera Kontrolü
   ├─ Kamera yok → AR Desteklenmiyor ❌
   └─ Kamera var → Devam et ✅

2. Accelerometer Kontrolü
   ├─ 2 saniye içinde veri geldi mi?
   └─ Sonuç kaydet

3. Gyroscope Kontrolü
   ├─ 2 saniye içinde veri geldi mi?
   └─ Sonuç kaydet

4. Final Karar
   ├─ Kamera VAR + (Accelerometer VEYA Gyroscope) VAR
   │  └─ AR Destekleniyor ✅
   └─ Aksi durumda
      └─ AR Desteklenmiyor ❌
```

## 🚀 Kullanım

### Hedef Seçildiğinde

```dart
void _startNavigation(String destinationPOI) async {
  final targetPOI = BuildingData.allPOIs.firstWhere(
    (poi) => poi.name == destinationPOI,
  );

  // AR desteğini kontrol et
  final arSupported = ArCapabilityService().isArSupported ?? false;

  if (arSupported) {
    // ✅ AR destekleniyor - AR kamera sayfasına git
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArCameraPage(
          destination: targetPOI.name,
          locationData: {...},
        ),
      ),
    );
  } else {
    // ❌ AR desteklenmiyor - Direkt navigasyon sayfasına git
    // Normal mod: Hem video rehber hem hedef önizleme gösterilir
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NavigationPage(
          startPOI: 'Başlangıç',
          endPOI: targetPOI,
          showVideoOnly: false,
          showPreviewOnly: false,
        ),
      ),
    );
  }
}
```

## 📊 Kullanıcı Deneyimi Akışı

### AR Desteklenen Cihazlar

```
Kat Sayfası
    ↓ [Hedef Seç]
AR Kamera Sayfası
    ↓
    ├─→ Video Rehber
    └─→ Hedef Önizleme
```

### AR Desteklenmeyen Cihazlar

```
Kat Sayfası
    ↓ [Hedef Seç]
Navigasyon Sayfası (Normal Mod)
    ↓
    ├─→ Video Rehber (Üstte)
    └─→ Hedef Önizleme (Altta)
```

## 🔧 ArCapabilityService API

### Metodlar

#### `checkArSupport()`
```dart
Future<bool> checkArSupport()
```
- AR desteğini kontrol eder
- Sonucu cache'ler
- İlk çağrıda 2-4 saniye sürebilir

#### `isArSupported`
```dart
bool? get isArSupported
```
- Cache'lenmiş AR destek durumunu döndürür
- `null`: Henüz kontrol edilmedi
- `true`: AR destekleniyor
- `false`: AR desteklenmiyor

#### `clearCache()`
```dart
void clearCache()
```
- Cache'i temizler
- Test için kullanılır

### Örnek Kullanım

```dart
// Servis instance'ı al
final arService = ArCapabilityService();

// AR desteğini kontrol et
final isSupported = await arService.checkArSupport();

if (isSupported) {
  print('AR destekleniyor! 🎉');
} else {
  print('AR desteklenmiyor 😢');
}

// Cache'den oku (hızlı)
final cachedResult = arService.isArSupported;
```

## 🎨 Kullanıcı Bildirimi (Opsiyonel)

İsterseniz kullanıcıya AR desteği hakkında bilgi verebilirsiniz:

```dart
void _showArSupportInfo() {
  final arSupported = ArCapabilityService().isArSupported ?? false;
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(arSupported ? 'AR Destekleniyor' : 'AR Desteklenmiyor'),
      content: Text(
        arSupported
            ? 'Cihazınız AR navigasyonu destekliyor. Kamera ile yol bulabilirsiniz!'
            : 'Cihazınız AR navigasyonu desteklemiyor. Video rehber ile yol bulabilirsiniz.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tamam'),
        ),
      ],
    ),
  );
}
```

## 📱 Platform Desteği

| Platform | Kamera | Accelerometer | Gyroscope | AR Desteği |
|----------|--------|---------------|-----------|------------|
| Android 5.0+ | ✅ | ✅ | ✅ | ✅ Tam |
| iOS 11.0+ | ✅ | ✅ | ✅ | ✅ Tam |
| Web | ⚠️ | ⚠️ | ⚠️ | ❌ Sınırlı |
| Windows | ⚠️ | ❌ | ❌ | ❌ Yok |
| Linux | ⚠️ | ❌ | ❌ | ❌ Yok |
| macOS | ⚠️ | ⚠️ | ⚠️ | ⚠️ Sınırlı |

## 🐛 Sorun Giderme

### Problem: AR desteği her zaman false dönüyor

**Olası Nedenler:**
1. Kamera izni verilmemiş
2. Sensör izinleri verilmemiş
3. Cihazda kamera yok
4. Sensörler çalışmıyor

**Çözüm:**
```dart
// İzinleri kontrol et
await Permission.camera.request();
await Permission.sensors.request();

// Cache'i temizle ve tekrar dene
ArCapabilityService().clearCache();
await ArCapabilityService().checkArSupport();
```

### Problem: Kontrol çok uzun sürüyor

**Neden:** Sensör kontrolü 2 saniye timeout kullanıyor

**Çözüm:** Normal davranış, uygulama başlangıcında bir kez yapılır

### Problem: Bazı cihazlarda yanlış sonuç veriyor

**Neden:** Sensör verileri gelmeyebilir

**Çözüm:** Timeout süresini artırın veya alternatif kontrol yöntemi kullanın

## 🔐 İzinler

### Android (AndroidManifest.xml)

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-feature android:name="android.hardware.camera" android:required="false"/>
<uses-feature android:name="android.hardware.sensor.accelerometer" android:required="false"/>
<uses-feature android:name="android.hardware.sensor.gyroscope" android:required="false"/>
```

### iOS (Info.plist)

```xml
<key>NSCameraUsageDescription</key>
<string>AR navigasyon için kamera erişimi gereklidir</string>
```

## 📈 Performans

### İlk Kontrol
- Süre: 2-4 saniye
- Bellek: ~5MB
- CPU: Düşük

### Cache'den Okuma
- Süre: <1ms
- Bellek: Minimal
- CPU: Minimal

## 🎓 Best Practices

1. **Uygulama başlangıcında kontrol edin**
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await ArCapabilityService().checkArSupport();
     runApp(const MyApp());
   }
   ```

2. **Cache'den okuyun**
   ```dart
   final arSupported = ArCapabilityService().isArSupported ?? false;
   ```

3. **Fallback sağlayın**
   ```dart
   if (arSupported) {
     // AR kamera
   } else {
     // Video rehber
   }
   ```

4. **Kullanıcıyı bilgilendirin (opsiyonel)**
   ```dart
   if (!arSupported) {
     showSnackBar('AR desteklenmiyor, video rehber kullanılacak');
   }
   ```

## 🆘 Destek

AR yetenek kontrolü ile ilgili sorunlar için:
1. Bu dokümantasyonu kontrol edin
2. İzinleri kontrol edin
3. Cihaz özelliklerini kontrol edin
4. GitHub'da issue açın

---

**Not**: AR yetenek kontrolü, kullanıcı deneyimini optimize etmek için kritik öneme sahiptir. Her cihazda doğru çalıştığından emin olun.
