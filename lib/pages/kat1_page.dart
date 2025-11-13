import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../services/ble_router.dart';
import '../widgets/stop_scan_button.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/modern_card.dart';
import '../models/poi_data.dart';
import 'ar_camera_page.dart';
import 'navigation_page.dart';
import '../services/ar_capability_service.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

// Harita URL'si (Yeni linkinle değiştirebilirsin)
const String kat1HaritaUrl =
    "https://drive.google.com/uc?export=view&id=166-2gIZ4Yt4y9EPQx0ewgOvgfK7F9at7";

class Kat1Page extends StatefulWidget {
  const Kat1Page({super.key});

  @override
  State<Kat1Page> createState() => _Kat1PageState();
}

class _Kat1PageState extends State<Kat1Page> with TickerProviderStateMixin {
  // Modern tema renkleri
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color micActiveColor = Color(0xFFE91E63);

  StreamSubscription<TopSignal?>? _sub;
  DateTime _lastNav = DateTime.fromMillisecondsSinceEpoch(0);

  // Ses tanıma değişkenleri
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _lastWords = '';

  bool _isVoiceGuideEnabled = false;

  // Animasyon kontrolcüleri
  late AnimationController _micPulseController;
  late AnimationController _listeningController;
  late Animation<double> _micPulseAnimation;
  late Animation<double> _listeningAnimation;
  late Animation<Color?> _micColorAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeSpeechRecognition();

    _sub = BleRouter().topStream.listen((top) {
      if (!mounted) return;
      if (top == null) return;
      if (top.name == 'Kat 1') return;

      final now = DateTime.now();
      if (now.difference(_lastNav) < const Duration(milliseconds: 1200)) return;
      _lastNav = now;
      _navigateFor(top.name);
    });
  }

  void _initializeAnimations() {
    _micPulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _listeningController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _micPulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _micPulseController, curve: Curves.easeInOut),
    );

    _listeningAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _listeningController, curve: Curves.elasticOut),
    );

    _micColorAnimation =
        ColorTween(begin: primaryOrange, end: micActiveColor).animate(
      CurvedAnimation(
        parent: _listeningController,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _initializeSpeechRecognition() async {
    try {
      var micStatus = await Permission.microphone.request();
      var speechStatus = await Permission.speech.request();

      if (micStatus.isGranted && speechStatus.isGranted) {
        bool available = await _speechToText.initialize(
          onError: (error) {
            debugPrint('STT Error: ${error.errorMsg}');
            _showSnack('Ses tanıma hatası: ${error.errorMsg}');
            _stopListening();
          },
          onStatus: (status) {
            debugPrint('STT Status: $status');
          },
        );

        if (!mounted) return;
        setState(() {
          _speechEnabled = available;
          if (!available) {
            _showSnack(
              'Sesli komut servisi kullanılamıyor. Lütfen cihaz ayarlarınızı kontrol edin.',
            );
          }
        });
      } else if (micStatus.isDenied && speechStatus.isDenied) {
        _showSnack(
          'Sesli komut için mikrofon izni reddedildi. Ayarlardan izin vermeniz gerekiyor.',
        );
      } else if (micStatus.isPermanentlyDenied &&
          speechStatus.isPermanentlyDenied) {
        _showSnack(
          'Mikrofon izni kalıcı olarak reddedildi. Lütfen cihaz ayarlarından manuel olarak izin verin.',
        );
      } else {
        _showSnack('Sesli komut için mikrofon izni gereklidir.');
      }
    } catch (e) {
      debugPrint('Speech recognition initialization error: $e');
      if (mounted) {
        _showSnack('Ses tanıma servisi başlatılırken bir hata oluştu.');
      }
    }
  }

  void _startListening() {
    if (!_speechEnabled) {
      _showSnack('Sesli komut servisi başlatılamadı. İzinleri kontrol edin.');
      return;
    }

    if (_speechToText.isListening) {
      _stopListening();
      return;
    }

    _lastWords = '';
    setState(() => _isListening = true);

    // Animasyonları başlat
    _listeningController.forward();
    _micPulseController.repeat(reverse: true);

    // Haptic feedback
    HapticFeedback.mediumImpact();

    _speechToText.listen(
      onResult: (result) {
        if (mounted) {
          setState(() {
            _lastWords = result.recognizedWords;
          });
          if (result.finalResult) {
            _handleVoiceCommand(_lastWords);
            _stopListening();
          }
        }
      },
      localeId: 'tr_TR',
    );

    _showSnack('Dinleme başladı... Lütfen konuşun.');
  }

  void _stopListening() {
    _speechToText.stop();
    _listeningController.reverse();
    _micPulseController.stop();

    if (mounted) {
      setState(() => _isListening = false);
    }

    HapticFeedback.lightImpact();
  }

  void _handleVoiceCommand(String command) {
    if (command.isEmpty) return;

    final String lowerCommand = command.toLowerCase();

    final target = BuildingData.allPOIs.firstWhere(
      (poi) {
        final String lowerName = poi.name.toLowerCase();

        // Kriter 1: POI'nin ana adı komutu içeriyor mu?
        if (lowerName.contains(lowerCommand)) return true;

        // Kriter 2: Komut, POI'nin ana adını içeriyor mu?
        if (lowerCommand.contains(lowerName)) return true;

        // Kriter 3: Takma adlardan (aliases) BİRİ eşleşiyor mu?
        final bool aliasMatch = poi.aliases.any((alias) {
          final String lowerAlias = alias.toLowerCase();

          if (lowerCommand.contains(lowerAlias)) return true;
          if (lowerAlias.contains(lowerCommand)) return true;

          return false;
        });

        if (aliasMatch) return true;

        return false;
      },
      orElse: () => POI(name: 'NOT_FOUND', key: '', floor: '', imageUrl: ''),
    );

    if (target.name != 'NOT_FOUND') {
      _showSnack('Komut algılandı: ${target.name}. Navigasyon başlatılıyor...');
      _startNavigation(target.name);
    } else {
      _showSnack(
        'Dinlendi: "$command". Bina hedefleriyle eşleşen yer bulunamadı.',
      );
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _startNavigation(String destinationPOI) async {
    try {
      final targetPOI = BuildingData.allPOIs.firstWhere(
        (poi) => poi.name == destinationPOI,
      );

      // AR desteğini kontrol et
      final arSupported = ArCapabilityService().isArSupported ?? false;

      if (arSupported) {
        // AR destekleniyor - AR kamera sayfasına git
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ArCameraPage(
              destination: targetPOI.name,
              locationData: {
                'startPOI': 'Kat 1 ZON',
                'endPOI': targetPOI,
                'targetPOI': targetPOI,
              },
            ),
          ),
        );
      } else {
        // AR desteklenmiyor - Direkt navigasyon sayfasına git
        // Normal mod: Hem video rehber hem hedef önizleme gösterilir
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NavigationPage(
              startPOI: 'Kat 1 ZON',
              endPOI: targetPOI,
              showVideoOnly: false,
              showPreviewOnly: false,
            ),
          ),
        );
      }
    } catch (e) {
      _showSnack('Hata: Hedef ($destinationPOI) veri setinde bulunamadı.');
    }
  }

  void _openLocationSearch() {
    final allBuildingPOIs = BuildingData.allPOIs;
    final kat1POIs =
        allBuildingPOIs.where((poi) => poi.floor == 'Kat 1').toList();
    final otherPOIs =
        allBuildingPOIs.where((poi) => poi.floor != 'Kat 1').toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: primaryOrange.withAlpha(26),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.search_rounded,
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
                              'Nereye Gitmek İstiyorsunuz?',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Hedef seçin veya sesli komut kullanın',
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
                ),

                // Tüm yerler listesi
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      // Bu kattaki yerler
                      if (kat1POIs.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                color: successGreen,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Bu Kattaki Yerler',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: successGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...kat1POIs.map((poi) => _buildPOITile(poi, true)),
                        const SizedBox(height: 16),
                      ],

                      // Diğer katlardaki yerler
                      if (otherPOIs.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.stairs_rounded,
                                color: Colors.blue,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Diğer Katlardaki Yerler',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...otherPOIs.map((poi) => _buildPOITile(poi, false)),
                        const SizedBox(height: 20),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPOITile(POI poi, bool isCurrentFloor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ModernCard(
        onTap: () {
          Navigator.pop(context);
          _startNavigation(poi.name);
        },
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(poi.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withAlpha(77),
                ),
                child: Icon(
                  isCurrentFloor
                      ? Icons.location_on_rounded
                      : Icons.stairs_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    poi.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isCurrentFloor
                              ? successGreen.withAlpha(26)
                              : Colors.blue.withAlpha(26),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          poi.floor,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isCurrentFloor ? successGreen : Colors.blue,
                          ),
                        ),
                      ),
                      if (!isCurrentFloor) ...[
                        const SizedBox(width: 8),
                        Icon(
                          poi.floor == 'Zemin'
                              ? Icons.arrow_downward_rounded
                              : Icons.arrow_upward_rounded,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateFor(String name) {
    String? route;
    if (name == 'Zemin') route = '/zemin';
    if (name == 'Kat 2') route = '/kat2';

    if (route != null) {
      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _speechToText.stop();
    _micPulseController.dispose();
    _listeningController.dispose();
    super.dispose();
  }

  Widget _buildVoiceGuideButton() {
    final bool isActive = _isVoiceGuideEnabled;
    final Color buttonColor = isActive ? Colors.blueGrey : successGreen;
    final String label =
        isActive ? 'Sesli Rehberi Kapat' : 'Sesli Rehberi Aktif Et';
    final IconData icon =
        isActive ? Icons.voice_over_off : Icons.record_voice_over;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0), // Üstte boşluk
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _isVoiceGuideEnabled = !_isVoiceGuideEnabled;
          });
          _showSnack(
            isActive
                ? 'Sesli rehber Kapatıldı.'
                : 'Sesli rehber Aktif Edildi. (İşlev eklenecek)',
          );
        },
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: const CustomAppBar(title: "1. Kat"),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchSection(),
            Expanded(child: _buildMapSection()),
            if (_isListening) _buildListeningIndicator(),
            _buildVoiceGuideButton(),
            const StopScanButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
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
          Expanded(
            child: GestureDetector(
              onTap: _openLocationSearch,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isListening ? micActiveColor : Colors.grey.shade300,
                    width: _isListening ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: primaryOrange, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isListening
                            ? (_lastWords.isEmpty
                                ? 'Dinleniyor...'
                                : _lastWords)
                            : 'Nereye gitmek istiyorsunuz?',
                        style: TextStyle(
                          fontSize: 16,
                          color: _isListening
                              ? micActiveColor
                              : Colors.grey.shade600,
                          fontWeight:
                              _isListening ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _buildMicrophoneButton(),
        ],
      ),
    );
  }

  Widget _buildMicrophoneButton() {
    return AnimatedBuilder(
      animation: Listenable.merge([_micPulseAnimation, _micColorAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _isListening ? _micPulseAnimation.value : 1.0,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isListening
                    ? [micActiveColor, micActiveColor.withAlpha(204)]
                    : [primaryOrange, primaryOrange.withAlpha(204)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (_isListening ? micActiveColor : primaryOrange)
                      .withAlpha(102),
                  blurRadius: _isListening ? 16 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: _startListening,
                child: Icon(
                  _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
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

  // <<< GÜNCELLENEN BÖLÜM >>>
  Widget _buildMapSection() {
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
            Image.network(
              kat1HaritaUrl,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
              // <<< cacheWidth VE cacheHeight SATIRLARI KALDIRILDI >>>
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey.shade50,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            color: primaryOrange,
                            strokeWidth: 3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Harita yükleniyor...',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
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
                        const Text(
                          '1. Kat Haritası',
                          style: TextStyle(
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
              },
            ),

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
                child: const Text(
                  '1. Kat',
                  style: TextStyle(
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
  // <<< GÜNCELLEME SONU >>>

  Widget _buildListeningIndicator() {
    return AnimatedBuilder(
      animation: _listeningAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                micActiveColor.withAlpha(26),
                micActiveColor.withAlpha(13),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: micActiveColor.withAlpha(77), width: 2),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: micActiveColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mic_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sesli Komut Aktif',
                      style: TextStyle(
                        color: micActiveColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      _lastWords.isEmpty
                          ? 'Lütfen hedef yerinizi söyleyin...'
                          : '"$_lastWords"',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _stopListening,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
