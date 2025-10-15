import 'package:flutter/material.dart';

// Gerekli callback'i tanımlıyoruz
typedef SearchCallback = void Function();

class FloorMapView extends StatelessWidget {
  final bool isWide;
  final SearchCallback onSearchTap;
  final String floorName;
  final String mapImageUrl; // ZORUNLU PARAMETRE

  const FloorMapView({
    super.key,
    required this.isWide,
    required this.onSearchTap,
    required this.floorName,
    required this.mapImageUrl, // Yapıcıda zorunlu olarak tanımlanmış
  });

  static const Color primaryOrange = Color(0xFFFF9800);

  // Arama Kutusu Widget'ı (Kodu okunabilirlik için burada kesildi, ancak orijinali kullanılacak)
  Widget _buildSearchOnly() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 32 : 16, vertical: 16),
      child: GestureDetector(
        onTap: onSearchTap, // Ana sayfadan gelen metodu çağırır
        child: Container(
          width: double.infinity, // Tüm genişliği kapla
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: primaryOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: primaryOrange, width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sadece Arama Kutusu Bölümü
        _buildSearchOnly(),

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
                  mapImageUrl, // <-- HARİTA GÖRSELİ URL'Sİ KULLANILDI
                  fit: BoxFit.contain, // Görselin ekrana sığmasını sağlar
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    // Yüklenirken gösterilecek bileşen
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
                    // Görsel yüklenemezse hata mesajı
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
