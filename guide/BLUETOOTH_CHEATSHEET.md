# Bluetooth Tarama - Kopya Kağıdı 📋

## 🚀 Hızlı Başvuru

### Import

```dart
import '../services/ble_router.dart';
```

### Komutlar

```dart
BleRouter().start();  // Taramayı başlat
BleRouter().stop();   // Taramayı durdur
```

---

## 📄 Sayfa Şablonları

### 1. Kat Sayfası (Bluetooth Aktif)

```dart
class YeniKatPage extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    // Bluetooth kodları YOK
  }
  
  @override
  void dispose() {
    // Bluetooth kodları YOK
    super.dispose();
  }
}
```

---

### 2. Kamera Sayfası (Bluetooth Durdur → Başlat)

```dart
import '../services/ble_router.dart';

class YeniKameraPage extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    BleRouter().stop();  // ✅ DURDUR
  }
  
  @override
  void dispose() {
    BleRouter().start(); // ✅ BAŞLAT
    super.dispose();
  }
}
```

---

### 3. Alt Sayfa (Bluetooth Sadece Durdur)

```dart
import '../services/ble_router.dart';

class AltSayfa extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    BleRouter().stop();  // ✅ DURDUR
  }
  
  @override
  void dispose() {
    // ❌ start() ÇAĞIRMA
    super.dispose();
  }
}
```

---

## 🎯 Karar Tablosu

| Sayfa Türü | initState() | dispose() |
|------------|-------------|-----------|
| Kat Sayfası | - | - |
| AR Kamera | `stop()` | `start()` |
| Video/Önizleme | `stop()` | - |

---

## ⚡ Hızlı Kopyala-Yapıştır

### Kamera Sayfası İçin

```dart
// initState() içine ekle:
BleRouter().stop();

// dispose() içine ekle:
BleRouter().start();

// Import ekle:
import '../services/ble_router.dart';
```

### Video Sayfası İçin

```dart
// initState() içine ekle:
BleRouter().stop();

// dispose() içine EKLEME!

// Import ekle:
import '../services/ble_router.dart';
```

---

## ❌ Yapma

```dart
// Her sayfada start() çağırma
@override
void dispose() {
  BleRouter().start(); // ❌
  super.dispose();
}

// Import'u unutma
BleRouter().stop(); // ❌ Hata: Tanımlı değil
```

---

## ✅ Yap

```dart
// Sadece gerekli sayfalarda kullan
import '../services/ble_router.dart';

@override
void initState() {
  super.initState();
  BleRouter().stop(); // ✅
}

@override
void dispose() {
  BleRouter().start(); // ✅ (Sadece kamera sayfalarında)
  super.dispose();
}
```

---

## 🔍 Test

- [ ] Sayfaya gir → Bluetooth durumu doğru mu?
- [ ] Sayfadan çık → Bluetooth durumu doğru mu?
- [ ] Geri butonu → Çalışıyor mu?

---

**Detaylı bilgi için**: `BLUETOOTH_QUICK_GUIDE.md`
