// lib/services/video_cache_service.dart

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/poi_data.dart';

// Video Controller'larını önbellekte tutmak için Singleton sınıfı
class VideoCacheService {
  VideoCacheService._internal();
  static final VideoCacheService _instance = VideoCacheService._internal();
  factory VideoCacheService() => _instance;

  final Map<String, VideoPlayerController> _cache = {}; 

  // Controller'ı önbelleğe eklemek için PUBLIC arayüz
  void setController(String routeName, VideoPlayerController controller) {
    _cache[routeName] = controller;
  }

  /// Tüm rotaları döndürür.
  List<NavVideo> get _popularRoutes {
    // Sadece Danışma Masası değil, tüm rotaları önbelleğe almayı deneyelim (isteğinize göre ayarlanabilir)
    return BuildingData.allRoutes;
  }

  /// Belirtilen anahtara (rota adına) sahip controller'ı döndürür.
  VideoPlayerController? getController(String routeName) {
    return _cache[routeName];
  }
  
  /// Önbellekteki tüm controller'ları temizler (uygulama kapandığında çağrılabilir).
  void disposeAll() {
    for (var controller in _cache.values) {
      controller.dispose();
    }
    _cache.clear();
  }


  /// Belirtilen rotayı (veya tüm popüler rotaları) önbelleğe yükler.
  Future<void> preLoadVideo(NavVideo route) async {
    if (_cache.containsKey(route.name)) {
      debugPrint('Video Cache: ${route.name} zaten yüklü.');
      return;
    }

    try {
      final bool isAsset = route.url.startsWith('assets/');
      late VideoPlayerController controller;

      if (isAsset) {
        // YEREL DOSYA İÇİN ASSET CONTROLLER KULLANILIR
        controller = VideoPlayerController.asset(route.url);
        debugPrint('Video Cache: ${route.name} Asset olarak yükleniyor...');
      } else {
        // Ağ dosyaları için networkUrl kullanılır
        controller = VideoPlayerController.networkUrl(Uri.parse(route.url));
        debugPrint('Video Cache: ${route.name} Network olarak yükleniyor...');
      }

      await controller.initialize();
      controller.setLooping(false);
      controller.setVolume(0.0);
      
      // initialize() çağrısından sonra controller'ı cache'e kaydet
      setController(route.name, controller); 

      // Hafıza tüketimini azaltmak için videoyu duraklat ve ilk kareye geri sar
      controller.pause();
      controller.seekTo(Duration.zero);

    } catch (e) {
      debugPrint('Video Cache Hatası: ${route.name} yüklenemedi. Hata: $e');
    }
  }

  /// Tüm popüler rotaları önceden yüklemeyi başlatır.
  Future<void> preLoadPopularRoutes() async {
    debugPrint('Video Cache: Popüler rotalar ön yükleniyor...');
    
    final routes = _popularRoutes;
    
    // Asenkron olarak tüm popüler rotaları yükle
    await Future.wait(routes.map((route) => preLoadVideo(route)));

    debugPrint('Video Cache: Ön yükleme tamamlandı (${routes.length} rota).');
  }
}