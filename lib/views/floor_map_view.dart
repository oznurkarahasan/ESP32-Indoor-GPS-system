// lib/views/floor_map_view.dart (TAM KOD)

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // CachedNetworkImage için

// Gerekli callback'i tanımlıyoruz
typedef SearchCallback = void Function();
typedef MicCallback = void Function(); 

class FloorMapView extends StatelessWidget {
  final bool isWide;
  final SearchCallback onSearchTap;
  final MicCallback onMicTap; 
  final bool isMicListening; 
  final String floorName;
  final String mapImageUrl;

  // <<< EKSİK PARAMETRELER EKLENDİ >>>
  final Animation<double> micPulseAnimation; 
  final Animation<Color?> micColorAnimation; 
  final String lastWords; 
  // <<< EKSİK PARAMETRELER EKLENDİ SONU >>>

  const FloorMapView({
    super.key,
    required this.isWide,
    required this.onSearchTap,
    required this.onMicTap, 
    required this.isMicListening, 
    required this.floorName,
    required this.mapImageUrl,
    // Yeni eklenen parametreler gerekli (required) olarak eklendi
    required this.micPulseAnimation, 
    required this.micColorAnimation, 
    required this.lastWords, 
  });

  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color micActiveColor = Color(0xFFE91E63);

  // Mikrofon Düğmesi için animasyonlu widget
  Widget _buildMicrophoneButton() {
    return AnimatedBuilder(
      animation: Listenable.merge([micPulseAnimation, micColorAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: isMicListening ? micPulseAnimation.value : 1.0,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isMicListening
                    ? [micActiveColor, micActiveColor.withAlpha(204)]
                    : [primaryOrange, primaryOrange.withAlpha(204)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (isMicListening ? micActiveColor : primaryOrange)
                      .withAlpha(102),
                  blurRadius: isMicListening ? 16 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: onMicTap,
                child: Icon(
                  isMicListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Modern arama kutusu ve mikrofon bölümü
  Widget _buildSearchAndMic() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(51),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Arama Kutusu
          Expanded(
            child: GestureDetector(
              onTap: onSearchTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isMicListening ? micActiveColor : Colors.grey.shade300,
                    width: isMicListening ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: primaryOrange, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isMicListening
                            ? (lastWords.isEmpty
                                ? 'Dinleniyor...'
                                : lastWords)
                            : 'Nereye gitmek istiyorsunuz?',
                        style: TextStyle(
                          fontSize: 16,
                          color: isMicListening
                              ? micActiveColor
                              : Colors.grey.shade600,
                          fontWeight: isMicListening
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Mikrofon Düğmesini kullan
          _buildMicrophoneButton(),
        ],
      ),
    );
  }

  // Harita bölümü (Yerel varlık desteği için Image.asset'i manuel olarak kullanmamız gerekir)
  Widget _buildMapSection() {
    // Harita URL'sinin yerel varlık olup olmadığını kontrol et
    final bool isAsset = mapImageUrl.startsWith('assets/');

    // Harita Görüntüleyici Widget'ı
    final Widget mapImageWidget = isAsset
        ? Image.asset(
            mapImageUrl,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return _buildErrorPlaceholder(context);
            },
          )
        : CachedNetworkImage(
            imageUrl: mapImageUrl,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, url) => Container(
              color: Colors.grey.shade50,
              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    color: primaryOrange,
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => _buildErrorPlaceholder(context),
          );
        
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(38),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            mapImageWidget,

            // Kat bilgisi overlay
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: primaryOrange.withAlpha(230),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: primaryOrange.withAlpha(77),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  floorName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Hata Yer Tutucu metodu
  Widget _buildErrorPlaceholder(BuildContext context) {
      return Container(
        color: Colors.grey.shade50,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.map_outlined,
                  color: Colors.red.shade400,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '$floorName Haritası',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Harita yüklenemedi',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Arama Kutusu ve Mikrofon Bölümü
        _buildSearchAndMic(),

        // Modern harita görünümü
        Expanded(
          child: _buildMapSection(),
        ),
      ],
    );
  }
}