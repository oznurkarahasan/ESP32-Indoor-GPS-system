import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../services/ble_router.dart';
import '../models/poi_data.dart';
import '../widgets/custom_appbar.dart';
// YENİ EKLENDİ
import '../views/navigation_view.dart';

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
  late VideoPlayerController _controller;
  bool _isControllerReady = false;
  bool _isPlaying = false;

  // YENİ: Rota bilgisini burada tutarız
  late NavVideo _routeVideo;

  @override
  void initState() {
    super.initState();
    _routeVideo = _findRouteVideo(); // Rota bilgisini bul
    _initializeVideoPlayer();

    // Navigasyon başladığında BLE taramasını durdur
    BleRouter().stop();
  }

  @override
  void dispose() {
    // Navigasyon sayfasından çıkıldığında BLE taramasını tekrar başlat
    BleRouter().start();

    _controller.dispose();
    super.dispose();
  }

  // Video kontrolcüsünü başlatır
  Future<void> _initializeVideoPlayer() async {
    // Hata durumunda (rota bulunamazsa) bir placeholder URL kullanırız
    final url = _routeVideo.url;

    _controller = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize()
          .then((_) {
            if (mounted) {
              setState(() {
                _isControllerReady = true;
                _controller.setLooping(true); // Sonsuz döngü
                _controller.play(); // Başlar başlamaz oynat
                _isPlaying = true;
                // Başlangıçta sesi kapatabiliriz
                _controller.setVolume(0.0);
              });
            }
          })
          .catchError((e) {
            debugPrint("Video Oynatma Hatası: $e");
            if (mounted) {
              setState(() {
                _isControllerReady = false;
              });
            }
          });
  }

  // Rota videosunu bulma mantığı
  NavVideo _findRouteVideo() {
    try {
      return BuildingData.allRoutes.firstWhere(
        (r) => r.startPOI == widget.startPOI && r.endPOI == widget.endPOI.name,
      );
    } catch (_) {
      // Rota bulunamazsa hata URL'si döndür
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

  // Video Durdurma (Başa Sarma) metodu
  void _stopVideo() {
    if (!_isControllerReady) return;

    // Video'yu durdur (pause) ve başa sar (seekTo zero)
    _controller.pause();
    _controller.seekTo(Duration.zero);

    if (mounted) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  // YENİ METOT: Hedefe Varıldı butonuna basıldığında
  void _onNavigationFinished() {
    // Sayfadan geri dön (pop)
    // dispose() metodu çağrılacak ve BLE taraması otomatik olarak başlayacaktır.
    Navigator.of(context).pop();
  }

  // Eski görsel build metotları kaldırıldı.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "${widget.endPOI.floor} Katı Navigasyon"),
      body: SafeArea(
        child: NavigationView(
          endPOI: widget.endPOI,
          routeVideo: _routeVideo,
          controller: _controller,
          isControllerReady: _isControllerReady,
          isPlaying: _isPlaying,
          onPlayPause: _playPauseVideo,
          onStop: _stopVideo, // Durdurma/Başa Sarma fonksiyonu
          onFinished: _onNavigationFinished, // Hedefe Varıldı fonksiyonu
        ),
      ),
    );
  }
}
