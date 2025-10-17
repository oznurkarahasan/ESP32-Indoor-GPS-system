import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'; // YENİ: Video Player Paketi
import '../services/ble_router.dart';
import '../models/poi_data.dart';
import '../widgets/custom_appbar.dart';

// NavigationPage'i StatefulWidget'a dönüştürüyoruz
class NavigationPage extends StatefulWidget {
  final String startPOI; // Başlangıç POI anahtarı (örneğin: 'Zemin ZON')
  final POI endPOI; // Bitiş POI nesnesi

  const NavigationPage({
    super.key,
    required this.startPOI,
    required this.endPOI,
  });

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  // Video oynatıcı durum yönetimi
  late VideoPlayerController _controller; // YENİ: Video kontrolcüsü
  bool _isControllerReady = false;
  bool _isPlaying = false;

  // Simülasyon değişkenlerini kaldırıyoruz
  // bool _isPaused = false;
  // bool _isInitialized = false;

  final Color primaryOrange = const Color(0xFFFF9800);
  final Color primaryBlue = Colors.blue.shade600;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();

    // YENİ MANTIK: Navigasyon başladığında BLE taramasını durdur
    BleRouter().stop();
  }

  @override
  void dispose() {
    // YENİ MANTIK: Navigasyon sayfasından çıkıldığında BLE taramasını tekrar başlat
    // Bu, kullanıcıyı doğru kata yönlendirmeyi sağlayacaktır.
    BleRouter().start();

    _controller.dispose();
    super.dispose();
  }

  // YENİ METOT: Video kontrolcüsünü başlatır
  Future<void> _initializeVideoPlayer() async {
    final routeVideo = _findRouteVideo();

    // Video URL'sini kontrol ediyoruz (Drive linkleri güvenilir olmayabilir)
    if (routeVideo.url.startsWith('https://drive.google.com/')) {
      // Uyarı: Google Drive linkleri genellikle doğrudan oynatılamaz.
      // Bu linkin gerçekten oynatılabilir olduğundan emin olun, aksi takdirde hata alırsınız.
      // Hata durumunda buraya sadece bir placeholder URL koyabiliriz.
      debugPrint(
        "UYARI: Video için Google Drive linki kullanılıyor. Oynatma sorunları olabilir.",
      );
    }

    _controller = VideoPlayerController.networkUrl(Uri.parse(routeVideo.url))
      ..initialize()
          .then((_) {
            // Kontrolcü başlatıldıktan sonra UI'yı güncelle
            if (mounted) {
              setState(() {
                _isControllerReady = true;
                _controller.setLooping(true); // Sonsuz döngü
                _controller.play(); // Başlar başlamaz oynat
                _isPlaying = true;
              });
            }
          })
          .catchError((e) {
            debugPrint("Video Oynatma Hatası: $e");
            if (mounted) {
              setState(() {
                _isControllerReady =
                    false; // Hata durumunda oynatıcı hazır değil
              });
            }
          });
  }

  // Rota videosunu bulma mantığı
  NavVideo _findRouteVideo() {
    try {
      // Varsayılan rotayı bulmaya çalış
      return BuildingData.allRoutes.firstWhere(
        (r) => r.startPOI == widget.startPOI && r.endPOI == widget.endPOI.name,
      );
    } catch (_) {
      // Hata durumunda (rota bulunamazsa) bir hata nesnesi döndür
      return NavVideo(
        startPOI: 'Hata',
        endPOI: 'Hata',
        url: 'https://placehold.co/400x200/FF0000/FFFFFF?text=Rota+Bulunamadı',
        name: 'hata',
      );
    }
  }

  // Video kontrol metotları
  void _playPauseVideo() {
    if (!_isControllerReady) return;

    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  // Rota Bilgisi Kartı
  Widget _buildRouteInfoCard(NavVideo routeVideo) {
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
                    "Mevcut Konum: ${widget.startPOI}",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Hedef: ${widget.endPOI.name}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  Text(
                    "Rota Adı: ${routeVideo.name}",
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

  // Hedef Görseli Kartı (Aynı kalır)
  Widget _buildDestinationImage(double width) {
    final imageUrl = widget.endPOI.imageUrl.isNotEmpty
        ? widget.endPOI.imageUrl
        : 'https://placehold.co/600x400/000000/FFFFFF?text=Hedef+Görseli';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            width: width,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: width,
                height: 200,
                color: Colors.grey.shade200,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, size: 40, color: Colors.grey),
                      Text(
                        "Hedef Fotoğrafı Yok",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              widget.endPOI.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // YENİ: Gerçek Video Oynatıcı Widget'ı
  Widget _buildVideoPlayer(NavVideo routeVideo) {
    if (!_isControllerReady) {
      // Yüklenirken veya hata durumunda
      return Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: _controller.value.hasError
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning, color: Colors.red, size: 40),
                    const SizedBox(height: 8),
                    const Text(
                      "Video Yüklenemedi. URL'yi Kontrol Edin.",
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

    // Video oynatıcı ve kontroller
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Adım Adım Navigasyon Videosu",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // Video Görüntüleyici
        Container(
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black, // Video kutusunun arka planı
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Kontrol Butonları
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pause/Play butonu
            ElevatedButton.icon(
              onPressed: _playPauseVideo,
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              label: Text(_isPlaying ? 'Duraklat' : 'Oynat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(width: 15),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeVideo = _findRouteVideo();
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;

    return Scaffold(
      appBar: CustomAppBar(title: "${widget.endPOI.floor} Katı Navigasyon"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isWide
              ? _buildWideLayout(routeVideo)
              : _buildNarrowLayout(routeVideo),
        ),
      ),
    );
  }

  // Dar Ekran (Mobil) Düzeni
  Widget _buildNarrowLayout(NavVideo routeVideo) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRouteInfoCard(routeVideo),
          const SizedBox(height: 16),
          _buildVideoPlayer(routeVideo), // GERÇEK OYNATICI BURAYA GELDİ
          const SizedBox(height: 24),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 24),
          const Text(
            "Hedefinize Ulaştığınızda Görünüm Önizlemesi",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildDestinationImage(double.infinity),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Geniş Ekran (Tablet/Desktop) Düzeni
  Widget _buildWideLayout(NavVideo routeVideo) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sol Bölüm: Video ve Bilgiler (Daha Fazla Alan)
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRouteInfoCard(routeVideo),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildVideoPlayer(
                    routeVideo,
                  ), // GERÇEK OYNATICI BURAYA GELDİ
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        // Sağ Bölüm: Hedef Görseli (Daha Az Alan)
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hedef Önizlemesi",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildDestinationImage(double.infinity),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
