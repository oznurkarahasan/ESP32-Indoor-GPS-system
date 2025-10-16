import 'package:flutter/material.dart';

// Gerekli callback'i tanımlıyoruz
typedef SearchCallback = void Function();
typedef MicCallback = void Function(); // Yeni mikrofon callback'i

class FloorMapView extends StatelessWidget {
  final bool isWide;
  final SearchCallback onSearchTap;
  final MicCallback onMicTap; // YENİ: Mikrofon düğmesi işlevi
  final bool isMicListening; // YENİ: Mikrofon dinleme durumu
  final String floorName;
  final String mapImageUrl;

  const FloorMapView({
    super.key,
    required this.isWide,
    required this.onSearchTap,
    required this.onMicTap, // YENİ
    required this.isMicListening, // YENİ
    required this.floorName,
    required this.mapImageUrl,
  });

  static const Color primaryOrange = Color(0xFFFF9800);

  // Arama Kutusu ve Mikrofon Bölümü
  Widget _buildSearchAndMic() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 32 : 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Arama Kutusu (Expanded)
          Expanded(
            child: GestureDetector(
              onTap: onSearchTap, // Ana sayfadan gelen metodu çağırır
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: primaryOrange, width: 1.5),
                  // Dinleniyorsa hafif bir gölge ekle
                  boxShadow: isMicListening
                      ? [
                          BoxShadow(
                            color: primaryOrange.withOpacity(0.4),
                            blurRadius: 10,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: primaryOrange),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        'Nereye gitmek istersiniz?',
                        style: TextStyle(
                          fontSize: isWide ? 18 : 16,
                          color: primaryOrange.withOpacity(0.8),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Mikrofon Düğmesi
          Container(
            width: isWide ? 52 : 44, // Responsive boyut
            height: isWide ? 52 : 44,
            decoration: BoxDecoration(
              color: isMicListening
                  ? Colors.redAccent
                  : primaryOrange, // Dinliyorsa kırmızı, değilse turuncu
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (isMicListening ? Colors.redAccent : primaryOrange)
                      .withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                isMicListening
                    ? Icons.mic_off
                    : Icons.mic, // Dinleme durumuna göre ikon değişimi
                color: Colors.white,
                size: isWide ? 26 : 22,
              ),
              onPressed: onMicTap, // Ana sayfadan gelen dinleme fonksiyonu
              tooltip: isMicListening
                  ? 'Dinleniyor, Durdur'
                  : 'Sesli Arama Başlat',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Arama Kutusu ve Mikrofon Bölümü
        _buildSearchAndMic(),

        // Harita Görünümü Bölümü (GÖRSEL KULLANIMI BURADA BAŞLIYOR)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: primaryOrange.withOpacity(0.5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade100,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  mapImageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                        color: primaryOrange,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 40,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "$floorName Haritası Yüklenemedi.",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Text(
                            "URL veya erişim iznini kontrol edin.",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
