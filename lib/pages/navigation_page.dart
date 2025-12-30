import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../services/ble_router.dart';
import '../models/poi_data.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/modern_card.dart';
import '../widgets/modern_loading.dart';
import '../services/video_cache_service.dart';
import '../widgets/mini_live_map.dart'; // Harita burada

class NavigationPage extends StatefulWidget {
  final String startPOI;
  final POI endPOI;
  final bool isVoiceGuideEnabled;

  const NavigationPage({
    super.key,
    required this.startPOI,
    required this.endPOI,
    required this.isVoiceGuideEnabled,
  });

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> with TickerProviderStateMixin {
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color successGreen = Color(0xFF4CAF50);

  late VideoPlayerController _controller;
  bool _isControllerReady = false;
  bool _isPlaying = false;
  late NavVideo _routeVideo;
  bool _isNavigationStarted = false;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _routeVideo = _findRouteVideo();
    _progressController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _initializeVideoWithCache();
  }

  @override
  void dispose() {
    if (_isControllerReady) {
        _controller.pause();
        _controller.seekTo(Duration.zero);
    }
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _initializeVideoWithCache() async {
    final routeName = _routeVideo.name;
    final cachedController = VideoCacheService().getController(routeName);

    if (cachedController != null) {
      _controller = cachedController;
      _controller.setVolume(widget.isVoiceGuideEnabled ? 1.0 : 0.0);
      if (mounted) {
        setState(() {
          _isControllerReady = true;
        });
      }
    } else {
      _initializeVideoPlayer(isForCache: false); 
    }
  }

  Future<void> _initializeVideoPlayer({required bool isForCache}) async {
    final url = _routeVideo.url;
    try {
      final bool isAsset = url.startsWith('assets/');
      if (isAsset) {
        _controller = VideoPlayerController.asset(url);
      } else {
        _controller = VideoPlayerController.networkUrl(Uri.parse(url));
      }
      await _controller.initialize();
      if (mounted) {
        setState(() {
          _isControllerReady = true;
          _controller.setLooping(false);
          _controller.setVolume(widget.isVoiceGuideEnabled ? 1.0 : 0.0);
        });
        if (isForCache) {
             VideoCacheService().setController(_routeVideo.name, _controller); 
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isControllerReady = false);
    }
  }

  NavVideo _findRouteVideo() {
    try {
      return BuildingData.allRoutes.firstWhere(
        (r) => r.startPOI == widget.startPOI && r.endPOI == widget.endPOI.name,
      );
    } catch (_) {
      return NavVideo(
        startPOI: 'Hata',
        endPOI: 'Hata',
        url: 'https://placehold.co/400x200/FF0000/FFFFFF?text=Rota+Bulunamadı',
        name: 'hata',
      );
    }
  }

  void _startNavigation() {
    if (!_isControllerReady) return;
    setState(() {
      _isNavigationStarted = true;
      _isPlaying = true;
    });
    _controller.play();
    HapticFeedback.lightImpact();
  }

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
    HapticFeedback.selectionClick();
  }

  // --- YENİ EKLENEN: İLERİ/GERİ SARMA FONKSİYONU ---
  void _seekRelative(int seconds) {
    if (!_isControllerReady) return;
    final currentPosition = _controller.value.position;
    final targetPosition = currentPosition + Duration(seconds: seconds);
    _controller.seekTo(targetPosition);
    HapticFeedback.selectionClick();
  }
  // ------------------------------------------------

  void _stopVideo() {
    if (!_isControllerReady) return;
    _controller.pause();
    _controller.seekTo(Duration.zero);
    setState(() {
      _isPlaying = false;
      _isNavigationStarted = false;
    });
    HapticFeedback.mediumImpact();
  }

  void _onNavigationFinished() {
    _controller.pause();
    _progressController.forward();
    HapticFeedback.heavyImpact();
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: successGreen.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: successGreen, size: 64),
            ),
            const SizedBox(height: 24),
            const Text('Tebrikler!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: successGreen)),
            const SizedBox(height: 12),
            Text('${widget.endPOI.name} hedefinize başarıyla ulaştınız.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); 
                  Navigator.of(context).pop(); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: successGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Ana Sayfaya Dön', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(title: "Navigasyon: ${widget.endPOI.name}"),
      body: SafeArea(
        child: Stack(
          children: [
            // 1. ANA İÇERİK (Video ve Butonlar)
            _buildBody(),

            // 2. MİNİ CANLI HARİTA (SAĞ ÜST KÖŞE)
            // Harita burada Positioned widget ile yerleştirildi.
            const Positioned(
              top: 16,
              right: 16,
              child: MiniLiveMap(), 
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRouteInfoCard(),
          const SizedBox(height: 20),
          _buildVideoSection(),
          const SizedBox(height: 20),
          
          // Kontrol Butonları (İleri/Geri burada)
          _buildControlButtons(),
          
          const SizedBox(height: 20),
          _buildDestinationPreview(),
          const SizedBox(height: 100), // Alttan boşluk (Harita için değil, scroll rahatlığı için)
        ],
      ),
    );
  }

  Widget _buildRouteInfoCard() {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: primaryOrange.withAlpha(26), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.navigation_rounded, color: primaryOrange, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rota Bilgileri', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
                    const SizedBox(height: 4),
                    Text('${widget.startPOI} → ${widget.endPOI.name}', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSection() {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Video Rehber', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
          const SizedBox(height: 16),
          _buildVideoPlayer(),
          if (_isNavigationStarted) ...[const SizedBox(height: 16), _buildProgressIndicator()],
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (!_isControllerReady) {
      return Container(
        height: 300,
        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
        child: const Center(child: ModernLoading(message: 'Video yükleniyor...')),
      );
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black,
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(230), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller)),
            if (!_isPlaying)
              GestureDetector(
                onTap: () { if (!_isNavigationStarted) _startNavigation(); else _playPauseVideo(); },
                child: Container(
                  color: Colors.black.withAlpha(77),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white.withAlpha(230), shape: BoxShape.circle),
                      child: const Icon(Icons.play_arrow_rounded, size: 48, color: primaryOrange),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, VideoPlayerValue value, child) {
        double progress = 0.0;
        if (value.isInitialized && value.duration.inMilliseconds > 0) {
          progress = value.position.inMilliseconds / value.duration.inMilliseconds;
        }
        progress = progress.clamp(0.0, 1.0);
        return LinearProgressIndicator(value: progress, backgroundColor: Colors.grey.shade200, valueColor: const AlwaysStoppedAnimation<Color>(primaryOrange), minHeight: 6);
      },
    );
  }

  Widget _buildControlButtons() {
    return Column(
      children: [
        if (!_isNavigationStarted) 
          _buildStartNavigationButton() 
        else 
          _buildNavigationControls(),
      ],
    );
  }

  Widget _buildStartNavigationButton() {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primaryOrange, primaryOrange.withAlpha(204)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: primaryOrange.withAlpha(102), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: ElevatedButton.icon(
        onPressed: _startNavigation,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
        icon: const Icon(Icons.navigation_rounded, size: 28, color: Colors.white),
        label: const Text('Navigasyonu Başlat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  // --- GÜNCELLENEN KONTROL PANELİ ---
  Widget _buildNavigationControls() {
    return Column(
      children: [
        // 1. Satır: Geri Sar | Oynat/Duraklat | İleri Sar
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // -1 Saniye Butonu
            _buildCircleButton(
              icon: Icons.replay_10_rounded, // -1 için ikon (veya custom)
              onPressed: () => _seekRelative(-1),
              color: Colors.orangeAccent,
              tooltip: "1 Sn Geri",
            ),
            
            const SizedBox(width: 20),

            // Oynat / Duraklat Butonu
            _buildCircleButton(
              icon: _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              onPressed: _playPauseVideo,
              color: primaryOrange,
              size: 64, // Büyük buton
              iconSize: 32,
            ),

            const SizedBox(width: 20),

            // +1 Saniye Butonu
            _buildCircleButton(
              icon: Icons.forward_10_rounded, // +1 için ikon
              onPressed: () => _seekRelative(1),
              color: Colors.orangeAccent,
              tooltip: "1 Sn İleri",
            ),
          ],
        ),
        
        const SizedBox(height: 16),

        // 2. Satır: Başa Dön Butonu (Küçük)
        TextButton.icon(
          onPressed: _stopVideo,
          icon: const Icon(Icons.replay_rounded, color: Colors.grey),
          label: const Text("Başa Dön", style: TextStyle(color: Colors.grey)),
        ),

        const SizedBox(height: 10),

        // 3. Satır: HEDEFE VARDIM BUTONU
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [successGreen, Colors.green.shade600]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: successGreen.withAlpha(77), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: ElevatedButton.icon(
            onPressed: _onNavigationFinished,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
            icon: const Icon(Icons.location_on_rounded, size: 24, color: Colors.white),
            label: const Text('Hedefe Vardım!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  // Yuvarlak Buton Yardımcısı
  Widget _buildCircleButton({
    required IconData icon, 
    required VoidCallback onPressed, 
    required Color color, 
    double size = 48,
    double iconSize = 24,
    String? tooltip,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        shape: BoxShape.circle,
        border: Border.all(color: color.withAlpha(100), width: 1.5),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: iconSize),
        tooltip: tooltip,
      ),
    );
  }

  Widget _buildDestinationPreview() {
    final imageUrl = widget.endPOI.imageUrl;
    final bool isAsset = imageUrl.startsWith('assets/');
    final Widget imageWidget = isAsset 
        ? Image.asset(imageUrl, width: double.infinity, height: 200, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(color: Colors.grey.shade200))
        : Image.network(imageUrl, width: double.infinity, height: 200, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(color: Colors.grey.shade200));

    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hedef Önizleme', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.grey.withAlpha(26), blurRadius: 8, offset: const Offset(0, 2))]),
            child: ClipRRect(borderRadius: BorderRadius.circular(12), child: imageWidget),
          ),
        ],
      ),
    );
  }
}