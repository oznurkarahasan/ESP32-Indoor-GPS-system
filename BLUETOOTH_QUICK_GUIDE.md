# Bluetooth Tarama - Hızlı Başlangıç Rehberi

## 🎯 Temel Kodlar

### Bluetooth Taramasını Başlatmak

```dart
import '../services/ble_router.dart';

BleRouter().start();
```

### Bluetooth Taramasını Durdurmak

```dart
import '../services/ble_router.dart';

BleRouter().stop();
```

## 📋 Sayfa Türlerine Göre Kullanım

### 1️⃣ Kat Sayfaları (Bluetooth AKTIF olmalı)

**Örnek: zemin_page.dart, kat1_page.dart, kat2_page.dart**

```dart
import 'package:flutter/material.dart';
// Diğer import'lar...

class ZeminPage extends StatefulWidget {
  const ZeminPage({super.key});

  @override
  State<ZeminPage> createState() => _ZeminPageState();
}

class _ZeminPageState extends State<ZeminPage> {
  @override
  void initState() {
    super.initState();
    // ❌ BleRouter().start() ÇAĞIRMA
    // ❌ BleRouter().stop() ÇAĞIRMA
    // Kat sayfaları taramayı yönetmez, sadece kullanır
  }

  @override
  void dispose() {
    // ❌ BleRouter().start() ÇAĞIRMA
    // ❌ BleRouter().stop() ÇAĞIRMA
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... sayfa içeriği
    );
  }
}
```

**Özet:**
- ✅ Hiçbir şey yapma
- ✅ Tarama zaten aktif
- ✅ Kat algılama çalışıyor

---

### 2️⃣ AR Kamera Sayfası (Bluetooth DURDUR → BAŞLAT)

**Örnek: ar_camera_page.dart**

```dart
import 'package:flutter/material.dart';
import '../services/ble_router.dart'; // ✅ Import ekle

class ArCameraPage extends StatefulWidget {
  const ArCameraPage({super.key});

  @override
  State<ArCameraPage> createState() => _ArCameraPageState();
}

class _ArCameraPageState extends State<ArCameraPage> {
  @override
  void initState() {
    super.initState();
    // ... diğer başlatmalar
    
    // ✅ Bluetooth taramasını DURDUR
    BleRouter().stop();
  }

  @override
  void dispose() {
    // ✅ Bluetooth taramasını BAŞLAT
    // (Sadece kat sayfalarına dönüldüğünde)
    BleRouter().start();
    
    // ... temizlik işlemleri
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... sayfa içeriği
    );
  }
}
```

**Özet:**
- ✅ `initState()`: Taramayı DURDUR
- ✅ `dispose()`: Taramayı BAŞLAT
- ✅ Kamera performansı için gerekli

---

### 3️⃣ Video/Önizleme Sayfaları (Bluetooth SADECE DURDUR)

**Örnek: navigation_page.dart**

```dart
import 'package:flutter/material.dart';
import '../services/ble_router.dart'; // ✅ Import ekle

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  @override
  void initState() {
    super.initState();
    // ... diğer başlatmalar
    
    // ✅ Bluetooth taramasını DURDUR
    BleRouter().stop();
  }

  @override
  void dispose() {
    // ❌ BleRouter().start() ÇAĞIRMA!
    // AR kamera zaten yönetiyor
    
    // ... temizlik işlemleri
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... sayfa içeriği
    );
  }
}
```

**Özet:**
- ✅ `initState()`: Taramayı DURDUR
- ❌ `dispose()`: Taramayı BAŞLATMA
- ✅ AR kamera zaten yönetiyor

---

## 🆕 Yeni Sayfa Ekleme Rehberi

### Senaryo 1: Kat Sayfası Benzeri (Bluetooth Aktif Kalmalı)

```dart
import 'package:flutter/material.dart';

class YeniKatPage extends StatefulWidget {
  const YeniKatPage({super.key});

  @override
  State<YeniKatPage> createState() => _YeniKatPageState();
}

class _YeniKatPageState extends State<YeniKatPage> {
  @override
  void initState() {
    super.initState();
    // ❌ Bluetooth kodları ekleme
  }

  @override
  void dispose() {
    // ❌ Bluetooth kodları ekleme
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Kat')),
      body: Center(child: Text('Bluetooth taraması aktif')),
    );
  }
}
```

---

### Senaryo 2: Kamera/Video Sayfası (Bluetooth Durdurulmalı)

```dart
import 'package:flutter/material.dart';
import '../services/ble_router.dart'; // ✅ Import ekle

class YeniKameraSayfasi extends StatefulWidget {
  const YeniKameraSayfasi({super.key});

  @override
  State<YeniKameraSayfasi> createState() => _YeniKameraSayfasiState();
}

class _YeniKameraSayfasiState extends State<YeniKameraSayfasi> {
  @override
  void initState() {
    super.initState();
    
    // ✅ Bluetooth taramasını DURDUR
    BleRouter().stop();
  }

  @override
  void dispose() {
    // ✅ Bluetooth taramasını BAŞLAT
    BleRouter().start();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Kamera')),
      body: Center(child: Text('Kamera aktif, Bluetooth durdu')),
    );
  }
}
```

---

### Senaryo 3: Alt Sayfa (Ana Sayfa Zaten Yönetiyor)

```dart
import 'package:flutter/material.dart';
import '../services/ble_router.dart'; // ✅ Import ekle

class AltSayfa extends StatefulWidget {
  const AltSayfa({super.key});

  @override
  State<AltSayfa> createState() => _AltSayfaState();
}

class _AltSayfaState extends State<AltSayfa> {
  @override
  void initState() {
    super.initState();
    
    // ✅ Bluetooth taramasını DURDUR
    BleRouter().stop();
  }

  @override
  void dispose() {
    // ❌ BleRouter().start() ÇAĞIRMA
    // Ana sayfa zaten yönetiyor
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alt Sayfa')),
      body: Center(child: Text('Alt sayfa')),
    );
  }
}
```

---

## 🔄 Mevcut Sayfadan Bluetooth Kaldırma

### Adım 1: Import'u Kaldır

```dart
// ❌ Kaldır
import '../services/ble_router.dart';
```

### Adım 2: initState()'den Kaldır

```dart
@override
void initState() {
  super.initState();
  
  // ❌ Kaldır
  // BleRouter().stop();
}
```

### Adım 3: dispose()'dan Kaldır

```dart
@override
void dispose() {
  // ❌ Kaldır
  // BleRouter().start();
  
  super.dispose();
}
```

---

## 📊 Karar Ağacı

```
Yeni sayfa ekleyeceksiniz?
    │
    ├─→ Kat sayfası mı? (Harita gösterimi)
    │   └─→ ✅ Bluetooth kodları EKLEME
    │
    ├─→ Kamera/Video sayfası mı?
    │   └─→ ✅ initState(): stop()
    │       └─→ ✅ dispose(): start()
    │
    └─→ Alt sayfa mı? (Başka sayfadan açılıyor)
        └─→ ✅ initState(): stop()
            └─→ ❌ dispose(): start() EKLEME
```

---

## ⚠️ Yaygın Hatalar

### ❌ Hata 1: Her sayfada start() çağırmak

```dart
// ❌ YANLIŞ
@override
void dispose() {
  BleRouter().start(); // Her sayfada çağırma!
  super.dispose();
}
```

**Sonuç**: Gereksiz tarama, performans kaybı

---

### ❌ Hata 2: Hiçbir yerde start() çağırmamak

```dart
// ❌ YANLIŞ
@override
void dispose() {
  // BleRouter().start() eksik!
  super.dispose();
}
```

**Sonuç**: Kat sayfalarına döndüğünde tarama başlamaz

---

### ❌ Hata 3: Import'u unutmak

```dart
// ❌ YANLIŞ - Import eksik
class MyPage extends StatefulWidget {
  @override
  void initState() {
    BleRouter().stop(); // Hata: BleRouter tanımlı değil
  }
}
```

**Çözüm**: `import '../services/ble_router.dart';` ekle

---

## ✅ Doğru Örnekler

### Örnek 1: Kat Sayfası

```dart
// ✅ DOĞRU
class Kat3Page extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    // Bluetooth kodları yok
  }
  
  @override
  void dispose() {
    // Bluetooth kodları yok
    super.dispose();
  }
}
```

---

### Örnek 2: AR Sayfası

```dart
// ✅ DOĞRU
import '../services/ble_router.dart';

class ArPage extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    BleRouter().stop(); // ✅ Durdur
  }
  
  @override
  void dispose() {
    BleRouter().start(); // ✅ Başlat
    super.dispose();
  }
}
```

---

### Örnek 3: Video Sayfası

```dart
// ✅ DOĞRU
import '../services/ble_router.dart';

class VideoPage extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    BleRouter().stop(); // ✅ Durdur
  }
  
  @override
  void dispose() {
    // ✅ Başlatma (AR zaten yönetiyor)
    super.dispose();
  }
}
```

---

## 🎓 Özet Tablo

| Sayfa Türü | initState() | dispose() | Neden |
|------------|-------------|-----------|-------|
| **Kat Sayfaları** | - | - | Tarama zaten aktif |
| **AR Kamera** | `stop()` | `start()` | Kamera performansı + Kat sayfalarına dönüş |
| **Video/Önizleme** | `stop()` | - | Video performansı + AR yönetiyor |
| **Ana Sayfa** | - | - | Taramayı başlatan sayfa |

---

## 🔍 Test Checklist

Yeni sayfa ekledikten sonra test edin:

- [ ] Sayfaya girildiğinde Bluetooth durumu doğru mu?
- [ ] Sayfadan çıkıldığında Bluetooth durumu doğru mu?
- [ ] Geri butonu çalışıyor mu?
- [ ] Sistem geri butonu çalışıyor mu?
- [ ] Performans sorunları var mı?
- [ ] Pil tüketimi normal mi?

---

## 📞 Yardım

Bluetooth yönetimi ile ilgili sorunlar için:

1. Bu rehberi kontrol edin
2. `BLUETOOTH_MANAGEMENT.md` dosyasını okuyun
3. `NAVIGATION_FLOW.md` dosyasını inceleyin
4. GitHub'da issue açın

---

**Önemli**: Bluetooth tarama yönetimi, uygulamanın performansı ve pil ömrü için kritik öneme sahiptir. Her yeni sayfa eklerken bu rehberi takip edin.
