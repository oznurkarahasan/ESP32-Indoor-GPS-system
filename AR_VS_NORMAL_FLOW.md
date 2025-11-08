# AR vs Normal Navigasyon Akışı

## 🎯 Genel Bakış

Uygulama, cihazın AR desteğine göre otomatik olarak iki farklı navigasyon deneyimi sunar.

## 🔄 Akış Karşılaştırması

### ✅ AR Desteklenen Cihazlar

```
┌─────────────────────────────────────────────────────────────┐
│                      Kat Sayfası                            │
│  (Zemin / Kat 1 / Kat 2)                                   │
│                                                             │
│  [Hedef Seç: "Kütüphane"]                                  │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ↓ AR Desteği: ✅ VAR
                       │
┌──────────────────────┴──────────────────────────────────────┐
│                  AR Kamera Sayfası                          │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  📷 Gerçek Kamera Görüntüsü                         │   │
│  │                                                      │   │
│  │         ↑  ↑  ↑                                     │   │
│  │         AR Okları                                    │   │
│  │                                                      │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  Sol Tarafta Butonlar:                                     │
│  ┌──────────────────┐                                      │
│  │ 🎥 Video Rehber  │ ← Tıkla                             │
│  └──────────────────┘                                      │
│  ┌──────────────────┐                                      │
│  │ 👁️ Hedef Önizleme│ ← Tıkla                             │
│  └──────────────────┘                                      │
└──────────────────────┬──────────────────────────────────────┘
                       │
        ┌──────────────┴──────────────┐
        │                             │
        ↓                             ↓
┌───────────────────┐         ┌───────────────────┐
│ NavigationPage    │         │ NavigationPage    │
│ (Video Modu)      │         │ (Önizleme Modu)   │
│                   │         │                   │
│ ✅ Video Rehber   │         │ ❌ Video Rehber   │
│ ❌ Hedef Önizleme │         │ ✅ Hedef Önizleme │
└───────────────────┘         └───────────────────┘
```

---

### ❌ AR Desteklenmeyen Cihazlar

```
┌─────────────────────────────────────────────────────────────┐
│                      Kat Sayfası                            │
│  (Zemin / Kat 1 / Kat 2)                                   │
│                                                             │
│  [Hedef Seç: "Kütüphane"]                                  │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ↓ AR Desteği: ❌ YOK
                       │
┌──────────────────────┴──────────────────────────────────────┐
│              NavigationPage (Normal Mod)                    │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  📹 Video Rehber                                    │   │
│  │  ┌─────────────────────────────────────────────┐   │   │
│  │  │  Video Oynatıcı                             │   │   │
│  │  │  [▶️ Play] [⏸️ Pause] [⏹️ Stop]              │   │   │
│  │  └─────────────────────────────────────────────┘   │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  👁️ Hedef Önizleme                                  │   │
│  │  ┌─────────────────────────────────────────────┐   │   │
│  │  │  Hedef Fotoğrafı                            │   │   │
│  │  │  [Kütüphane Görüntüsü]                      │   │   │
│  │  └─────────────────────────────────────────────┘   │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ✅ Her İkisi de Gösteriliyor                              │
└─────────────────────────────────────────────────────────────┘
```

## 📊 Özellik Karşılaştırması

| Özellik | AR Desteklenen | AR Desteklenmeyen |
|---------|----------------|-------------------|
| **Kamera Görüntüsü** | ✅ Var | ❌ Yok |
| **AR Okları** | ✅ Var | ❌ Yok |
| **Sensör Kullanımı** | ✅ Var | ❌ Yok |
| **Video Rehber** | ✅ Var (Ayrı sayfa) | ✅ Var (Aynı sayfa) |
| **Hedef Önizleme** | ✅ Var (Ayrı sayfa) | ✅ Var (Aynı sayfa) |
| **Navigasyon Türü** | İnteraktif AR | Statik Video |
| **Pil Tüketimi** | Yüksek | Orta |
| **Kullanım Kolaylığı** | Orta | Kolay |

## 🎮 Kullanıcı Deneyimi

### AR Desteklenen Cihazlar

**Avantajlar:**
- 🎯 Gerçek dünya üzerine yön göstergeleri
- 🔄 İnteraktif ve dinamik
- 📱 Cihaz hareketine tepki verir
- 🎨 Modern ve etkileyici

**Dezavantajlar:**
- 🔋 Daha fazla pil tüketir
- 📷 Kamera izni gerektirir
- 🎓 Öğrenme eğrisi var

**Kullanım Senaryosu:**
```
1. Kullanıcı hedefe gitmek ister
2. AR kamera açılır
3. Gerçek dünya görüntüsü üzerine oklar yerleşir
4. Kullanıcı cihazı hareket ettirerek yönünü bulur
5. İhtiyaç duyarsa video rehber veya önizlemeye bakar
6. Hedefe ulaşır
```

---

### AR Desteklenmeyen Cihazlar

**Avantajlar:**
- 🔋 Daha az pil tüketir
- 📱 Basit ve anlaşılır
- ✅ Tüm bilgiler tek sayfada
- 🚀 Hızlı başlangıç

**Dezavantajlar:**
- 📹 Sadece video tabanlı
- 🔄 İnteraktif değil
- 📱 Cihaz hareketine tepki vermez

**Kullanım Senaryosu:**
```
1. Kullanıcı hedefe gitmek ister
2. Navigasyon sayfası açılır
3. Video rehber ve hedef önizleme gösterilir
4. Kullanıcı videoyu izler
5. Hedef fotoğrafına bakar
6. Hedefe ulaşır
```

## 🔧 Teknik Detaylar

### AR Desteklenen Cihazlar - Kod

```dart
// Kat sayfasında hedef seçildiğinde
void _startNavigation(String destinationPOI) async {
  final targetPOI = BuildingData.allPOIs.firstWhere(...);
  
  final arSupported = ArCapabilityService().isArSupported ?? false;

  if (arSupported) {
    // AR Kamera Sayfası
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArCameraPage(
          destination: targetPOI.name,
          locationData: {
            'startPOI': 'Zemin ZON',
            'endPOI': targetPOI,
          },
        ),
      ),
    );
  }
}
```

**AR Kamera Sayfasından Video Rehber:**
```dart
void _openVideoGuide() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => NavigationPage(
        startPOI: 'Zemin ZON',
        endPOI: targetPOI,
        showVideoOnly: true,      // ✅ Sadece video
        showPreviewOnly: false,
      ),
    ),
  );
}
```

**AR Kamera Sayfasından Hedef Önizleme:**
```dart
void _openDestinationPreview() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => NavigationPage(
        startPOI: 'Zemin ZON',
        endPOI: targetPOI,
        showVideoOnly: false,
        showPreviewOnly: true,    // ✅ Sadece önizleme
      ),
    ),
  );
}
```

---

### AR Desteklenmeyen Cihazlar - Kod

```dart
// Kat sayfasında hedef seçildiğinde
void _startNavigation(String destinationPOI) async {
  final targetPOI = BuildingData.allPOIs.firstWhere(...);
  
  final arSupported = ArCapabilityService().isArSupported ?? false;

  if (!arSupported) {
    // Navigasyon Sayfası (Normal Mod)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NavigationPage(
          startPOI: 'Zemin ZON',
          endPOI: targetPOI,
          showVideoOnly: false,     // ✅ Her ikisi de
          showPreviewOnly: false,   // ✅ gösterilir
        ),
      ),
    );
  }
}
```

## 📱 Platform Desteği

### AR Desteklenen Platformlar

| Platform | Kamera | Sensörler | AR Desteği |
|----------|--------|-----------|------------|
| Android 5.0+ | ✅ | ✅ | ✅ Tam |
| iOS 11.0+ | ✅ | ✅ | ✅ Tam |
| Android 4.x | ⚠️ | ⚠️ | ❌ Sınırlı |
| iOS 10.x | ⚠️ | ⚠️ | ❌ Sınırlı |

### AR Desteklenmeyen Platformlar

| Platform | Video | Önizleme | Navigasyon |
|----------|-------|----------|------------|
| Web | ✅ | ✅ | ✅ Normal Mod |
| Windows | ✅ | ✅ | ✅ Normal Mod |
| Linux | ✅ | ✅ | ✅ Normal Mod |
| Eski Cihazlar | ✅ | ✅ | ✅ Normal Mod |

## 🎯 Karar Ağacı

```
Kullanıcı hedef seçti
    │
    ├─→ AR Desteği Kontrolü
    │
    ├─→ Kamera VAR?
    │   ├─→ Hayır → Normal Mod
    │   └─→ Evet → Devam
    │
    ├─→ Accelerometer VAR?
    │   ├─→ Evet → AR Modu
    │   └─→ Hayır → Gyroscope Kontrol
    │
    ├─→ Gyroscope VAR?
    │   ├─→ Evet → AR Modu
    │   └─→ Hayır → Normal Mod
    │
    └─→ Sonuç
        ├─→ AR Modu: AR Kamera Sayfası
        └─→ Normal Mod: Navigasyon Sayfası (Video + Önizleme)
```

## 🔄 Geçiş Senaryoları

### Senaryo 1: AR Cihazda Tam Deneyim

```
Kat Sayfası
    ↓ [Hedef: Kütüphane]
AR Kamera (Oklar gösteriliyor)
    ↓ [Video Rehber Butonu]
NavigationPage (Sadece Video)
    ↓ [Geri]
AR Kamera (Oklar hala gösteriliyor)
    ↓ [Hedef Önizleme Butonu]
NavigationPage (Sadece Önizleme)
    ↓ [Geri]
AR Kamera
    ↓ [Geri]
Kat Sayfası
```

### Senaryo 2: Normal Cihazda Basit Deneyim

```
Kat Sayfası
    ↓ [Hedef: Kütüphane]
NavigationPage (Video + Önizleme)
    ↓ [Video izle, Önizlemeye bak]
    ↓ [Geri]
Kat Sayfası
```

## 📈 Performans Karşılaştırması

| Metrik | AR Modu | Normal Mod |
|--------|---------|------------|
| **Başlangıç Süresi** | 2-3 saniye | <1 saniye |
| **Bellek Kullanımı** | ~100MB | ~50MB |
| **CPU Kullanımı** | 30-40% | 10-15% |
| **Pil Tüketimi** | Yüksek | Orta |
| **Ağ Kullanımı** | Orta | Orta |

## 🎓 Best Practices

### AR Modu İçin

1. **Pil durumunu kontrol edin**
2. **Aydınlatmayı optimize edin**
3. **Sensör kalibrasyonu yapın**
4. **Kullanıcıyı bilgilendirin**

### Normal Mod İçin

1. **Video kalitesini optimize edin**
2. **Önbellekleme kullanın**
3. **Hızlı yükleme sağlayın**
4. **Basit arayüz sunun**

## 🆘 Destek

Her iki mod için de:
- Kullanıcı geri bildirimi toplayın
- Performans metrikleri izleyin
- Hata raporlarını analiz edin
- Sürekli iyileştirme yapın

---

**Sonuç**: Her cihaz için en uygun deneyim otomatik olarak sunulur! 🎉
