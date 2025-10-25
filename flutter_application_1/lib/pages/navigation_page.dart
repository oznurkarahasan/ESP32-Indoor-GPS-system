import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../services/ble_router.dart';
import '../models/poi_data.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/modern_card.dart';
import '../widgets/modern_loading.dart';

class NavigationPage extends StatefulWidget {
  final String startPOI;
  final POI endPOI;

  const NavigationPage({
    super.key,
    required this.startPOI,
    required this.endPOI,
  });

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage>
    with TickerProviderStateMixin {
  // Modern tema renkleri
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color accentOrange = Color(0xFFFFB199);
  static const Color darkOrange = Color(0xFFE55100);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningRed = Color(0xFFF44336);

  // Video oynatıcı durum yönetimi
  late VideoPlayerController _controller;
  bool _isControllerReady = false;
  bool _isPlaying = false;
  bool _isMuted = true;
  bool _isFullscreen = false;
  
  // Navigasyon durumu
  late NavVideo _routeVideo;
  bool _isNavigationStarted = false;
  bool _isNavigationCompleted = false;
  
  // Animasyon kontrolcüleri
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _routeVideo = _findRouteVideo();
    _initializeAnimations();
    _initializeVideoPlayer();
    BleRouter().stop();
  }

  @override
  void dispose() {
    BleRouter().start();
    _controller.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _progressController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _initializeVideoPlayer() async {
    final url = _routeVideo.url;

    _controller = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isControllerReady = true;
            _controller.setLooping(true);
            _controller.setVolume(0.0);
          });
        }
      }).catchError((e) {
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

  void _startNavigation() {
    if (!_isControllerReady) return;
    
    setState(() {
      _isNavigationStarted = true;
      _isPlaying = true;
    });
    
    _controller.play();
    _progressController.forward();
    
    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  void _playPauseVideo() {
    if (!_isControllerReady) return;

    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
        _progressController.stop();
      } else {
        _controller.play();
        _isPlaying = true;
        _progressController.forward();
      }
    });
    
    HapticFeedback.selectionClick();
  }

  void _stopVideo() {
    if (!_isControllerReady) return;

    _controller.pause();
    _controller.seekTo(Duration.zero);
    _progressController.reset();

    setState(() {
      _isPlaying = false;
      _isNavigationStarted = false;
    });
    
    HapticFeedback.mediumImpact();
  }

  void _toggleMute() {
    if (!_isControllerReady) return;
    
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0.0 : 1.0);
    });
    
    HapticFeedback.selectionClick();
  }

  void _onNavigationFinished() {
    setState(() {
      _isNavigationCompleted = true;
    });
    
    _controller.pause();
    _progressController.forward();
    
    HapticFeedback.heavyImpact();
    
    // Başarı mesajı göster
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
                color: successGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: successGreen,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Tebrikler!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: successGreen,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${widget.endPOI.name} hedefinize başarıyla ulaştınız.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dialog'u kapat
                  Navigator.of(context).pop(); // Navigation sayfasını kapat
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: successGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Ana Sayfaya Dön',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
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
      appBar: CustomAppBar(
        title: "Navigasyon: ${widget.endPOI.name}",
      ),
      body: SafeArea(
        child: _buildBody(),
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
          _buildControlButtons(),
          const SizedBox(height: 20),
          _buildDestinationPreview(),
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
                decoration: BoxDecoration(
                  color: primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.navigation_rounded,
                  color: primaryOrange,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rota Bilgileri',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.startPOI} → ${widget.endPOI.name}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Video rehberini takip ederek hedefinize güvenle ulaşın',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
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
          Text(
            'Video Rehber',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          _buildVideoPlayer(),
          if (_isNavigationStarted) ...[
            const SizedBox(height: 16),
            _buildProgressIndicator(),
          ],
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (!_isControllerReady) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: ModernLoading(
            message: 'Video yükleniyor...',
          ),
        ),
      );
    }

    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: VideoPlayer(_controller),
            ),
            if (!_isPlaying)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: 48,
                      color: primaryOrange,
                    ),
                  ),
                ),
              ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _isMuted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Navigasyon İlerlemesi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                Text(
                  '${(_progressAnimation.value * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: primaryOrange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _progressAnimation.value,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(primaryOrange),
              minHeight: 6,
            ),
          ],
        );
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
        gradient: LinearGradient(
          colors: [primaryOrange, darkOrange],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryOrange.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _startNavigation,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(
          Icons.navigation_rounded,
          size: 28,
          color: Colors.white,
        ),
        label: const Text(
          'Navigasyonu Başlat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildControlButton(
                icon: _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                label: _isPlaying ? 'Duraklat' : 'Oynat',
                onPressed: _playPauseVideo,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildControlButton(
                icon: Icons.replay_rounded,
                label: 'Başa Dön',
                onPressed: _stopVideo,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 12),
            _buildControlButton(
              icon: _isMuted ? Icons.volume_off : Icons.volume_up,
              label: '',
              onPressed: _toggleMute,
              color: Colors.orange,
              isIconOnly: true,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [successGreen, Colors.green.shade600],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: successGreen.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: _onNavigationFinished,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(
              Icons.location_on_rounded,
              size: 24,
              color: Colors.white,
            ),
            label: const Text(
              'Hedefe Vardım!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
    bool isIconOnly = false,
  }) {
    if (isIconOnly) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: color),
        ),
      );
    }

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(icon, color: color, size: 20),
        label: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationPreview() {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hedef Önizleme',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.endPOI.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Görsel yüklenemedi',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  color: primaryOrange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.endPOI.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.endPOI.floor} Katı',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
