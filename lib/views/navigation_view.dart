import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/poi_data.dart';

// Gerekli callback'leri tanımlıyoruz
typedef VideoControlCallback = void Function();
typedef NavigationFinishedCallback = void Function(); // YENİ

class NavigationView extends StatelessWidget {
  final POI endPOI;
  final NavVideo routeVideo;
  final VideoPlayerController controller;
  final bool isControllerReady;
  final bool isPlaying;
  final VideoControlCallback onPlayPause;
  final VideoControlCallback onStop;
  final NavigationFinishedCallback
  onFinished; // YENİ: Navigasyon bitince çağrılır

  const NavigationView({
    super.key,
    required this.endPOI,
    required this.routeVideo,
    required this.controller,
    required this.isControllerReady,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onStop,
    required this.onFinished, // YENİ
  });

  static const Color primaryOrange = Color(0xFFFF9800);
  static const Color primaryBlue = Color(0xFF42A5F5); // Colors.blue.shade600

  // Rota Bilgisi Kartı
  Widget _buildRouteInfoCard(String startPOI) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.alt_route, color: primaryOrange, size: 30),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mevcut Konum: $startPOI",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Hedef: ${endPOI.name}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  Text(
                    "Kat: ${endPOI.floor} | Rota Adı: ${routeVideo.name}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hedef Görseli Kartı (Hedefin ulaşıldığında görünümü)
  Widget _buildDestinationImage(BuildContext context, double width) {
    final imageUrl = endPOI.imageUrl.isNotEmpty
        ? endPOI.imageUrl
        : 'https://placehold.co/400x300/000000/FFFFFF?text=Hedef+Görseli+Yok';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hedef Önizlemesi (Ulaştığınızda Göreceğiniz)",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageUrl,
                width: width,
                height: 200, // Sabit yükseklik
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: width,
                    height: 200,
                    color: Colors.grey.shade200,
                    child: const Center(child: Text("Görsel Yüklenemedi")),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  endPOI.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // YENİ METOT: Tam Ekran Video Oynatıcı (Sadece View'de kalmalı)
  void _openFullscreen(BuildContext context) {
    if (!controller.value.isInitialized) return;

    // Geçici olarak tam ekran moduna geçiş
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // Arka planı şeffaf yap
        pageBuilder: (context, animation, secondaryAnimation) {
          return Scaffold(
            backgroundColor: Colors.black, // Tam ekran arka planı
            body: Center(
              child: AspectRatio(
                aspectRatio: 9 / 16, // Dikey video oranı
                child: GestureDetector(
                  onTap: () => Navigator.pop(context), // Ekrana tıklayınca çık
                  child: VideoPlayer(controller),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Video Oynatıcı ve Kontroller
  Widget _buildVideoPlayer(BuildContext context, bool isWide) {
    if (!isControllerReady) {
      // Yüklenirken veya hata durumunda
      return Container(
        height: isWide ? 400 : 300, // Dikey videoya uygun yükseklik
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: controller.value.hasError
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning, color: Colors.red, size: 40),
                    const SizedBox(height: 8),
                    const Text(
                      "Video Yüklenemedi. URL/İzinleri Kontrol Edin.",
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(
                      "URL: ${routeVideo.url}",
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                )
              : CircularProgressIndicator(color: primaryOrange),
        ),
      );
    }

    // Gerçek Video oynatıcı
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Adım Adım Rota Rehberi", // Başlık güncellendi
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Dikey Video Görüntüleyici ve Ortalamak için Center
        Center(
          child: Container(
            width: isWide
                ? 250 // Geniş ekranda sabit genişlik artırıldı
                : double.infinity, // mobil/dar ekranda tamamı
            height: isWide ? 480 : 350, // Dikey videoya uygun yükseklik
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black,
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(51), blurRadius: 10),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: GestureDetector(
                onTap: () => _openFullscreen(context), // 👈 TAM EKRAN İÇİN
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Video Alanı (Dikey ise AspectRatio 9:16 veya 3:4 olmalıdır)
                    controller.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: 9 / 16,
                            child: VideoPlayer(controller),
                          )
                        : Container(),

                    // Play/Pause Overlay
                    AnimatedOpacity(
                      opacity: isPlaying ? 0.0 : 0.8,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        // Renk opacity'si için withOpacity kullanıldı
                        color: Colors.black.withAlpha(138),
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled,
                              color: Colors.white,
                              size: 80,
                            ),
                            onPressed: onPlayPause,
                          ),
                        ),
                      ),
                    ),
                    // Mute/Unmute
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(
                          controller.value.volume == 0
                              ? Icons.volume_off
                              : Icons.volume_up,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Bu bir StatelessWidget olduğu için volume değişikliği sadece controller'ı etkiler.
                          controller.setVolume(
                            controller.value.volume == 0 ? 1.0 : 0.0,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Kontrol Butonları ve Hedefe Varıldı
        Wrap(
          spacing: 15,
          runSpacing: 15,
          alignment: WrapAlignment.center,
          children: [
            // Pause/Play butonu
            ElevatedButton.icon(
              onPressed: onPlayPause,
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              label: Text(isPlaying ? 'Duraklat' : 'Oynat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            // Stop butonu
            ElevatedButton.icon(
              onPressed: onStop,
              icon: const Icon(Icons.stop),
              label: const Text('Başa Dön'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey, // Rengi değiştirildi
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            // YENİ BUTON: Hedefe Varıldı
            ElevatedButton.icon(
              onPressed: onFinished,
              icon: const Icon(Icons.location_on_sharp, size: 20),
              label: const Text('Hedefe Varıldı!'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryOrange,
                foregroundColor: Colors.white,
                minimumSize: const Size(180, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Geniş ekran kontrolünü 800 piksel olarak ayarlayalım.
    final isWide = size.width > 800;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: isWide
          ? _buildWideLayout(context, size.width)
          : _buildNarrowLayout(context),
    );
  }

  // Dar Ekran (Mobil) Düzeni: Video ve Hedef alt alta
  Widget _buildNarrowLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRouteInfoCard(routeVideo.startPOI),
          const SizedBox(height: 16),
          _buildVideoPlayer(context, false),
          const SizedBox(height: 24),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 24),
          _buildDestinationImage(context, double.infinity),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Geniş Ekran (Tablet/Desktop) Düzeni: Dikey video ve diğer bilgiler yan yana
  Widget _buildWideLayout(BuildContext context, double screenWidth) {
    // Sol: Video ve Kontroller (Dikey formatta olduğu için sabit genişlik veriyoruz)
    // Sağ: Bilgiler ve Hedef Önizlemesi (Kalan alanı kaplar)
    const double videoAreaWidth = 350; // Dikey video + kontrol alanı

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sol Bölüm: Dikey Video Oynatıcı
        SizedBox(
          width: videoAreaWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRouteInfoCard(routeVideo.startPOI),
              // Video ve kontrol butonlarını Expanded ile sarmalıyoruz
              Expanded(
                child: SingleChildScrollView(
                  child: _buildVideoPlayer(context, true),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 24),

        // Sağ Bölüm: Hedef Önizlemesi (Kalan Genişlik)
        Expanded(
          child: SingleChildScrollView(
            child: _buildDestinationImage(
              context,
              screenWidth - videoAreaWidth - 24 - 32, // Hesaplanan genişlik
            ),
          ),
        ),
      ],
    );
  }
}
