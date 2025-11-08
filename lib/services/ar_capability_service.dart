import 'package:camera/camera.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

/// AR özelliklerinin desteklenip desteklenmediğini kontrol eden servis
class ArCapabilityService {
  static final ArCapabilityService _instance = ArCapabilityService._internal();
  factory ArCapabilityService() => _instance;
  ArCapabilityService._internal();

  bool? _isArSupported;
  bool _isChecking = false;

  /// AR desteğinin olup olmadığını kontrol eder
  /// Cache'lenmiş sonucu döndürür veya yeni kontrol yapar
  Future<bool> checkArSupport() async {
    // Eğer daha önce kontrol edildiyse cache'den dön
    if (_isArSupported != null) {
      return _isArSupported!;
    }

    // Eğer kontrol devam ediyorsa bekle
    if (_isChecking) {
      await Future.delayed(const Duration(milliseconds: 100));
      return checkArSupport();
    }

    _isChecking = true;

    try {
      // 1. Kamera kontrolü
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _isArSupported = false;
        _isChecking = false;
        return false;
      }

      // 2. Sensör kontrolü (Accelerometer)
      bool hasAccelerometer = false;
      try {
        final completer = Completer<bool>();
        final subscription = accelerometerEvents.listen(
          (event) {
            if (!completer.isCompleted) {
              completer.complete(true);
            }
          },
          onError: (error) {
            if (!completer.isCompleted) {
              completer.complete(false);
            }
          },
        );

        // 2 saniye bekle
        hasAccelerometer = await completer.future.timeout(
          const Duration(seconds: 2),
          onTimeout: () => false,
        );

        await subscription.cancel();
      } catch (e) {
        hasAccelerometer = false;
      }

      // 3. Gyroscope kontrolü
      bool hasGyroscope = false;
      try {
        final completer = Completer<bool>();
        final subscription = gyroscopeEvents.listen(
          (event) {
            if (!completer.isCompleted) {
              completer.complete(true);
            }
          },
          onError: (error) {
            if (!completer.isCompleted) {
              completer.complete(false);
            }
          },
        );

        // 2 saniye bekle
        hasGyroscope = await completer.future.timeout(
          const Duration(seconds: 2),
          onTimeout: () => false,
        );

        await subscription.cancel();
      } catch (e) {
        hasGyroscope = false;
      }

      // AR desteği için kamera ve en az bir sensör gerekli
      _isArSupported = cameras.isNotEmpty && (hasAccelerometer || hasGyroscope);
      _isChecking = false;
      return _isArSupported!;
    } catch (e) {
      _isArSupported = false;
      _isChecking = false;
      return false;
    }
  }

  /// Cache'i temizler (test için)
  void clearCache() {
    _isArSupported = null;
  }

  /// AR desteği var mı? (Cache'den)
  bool? get isArSupported => _isArSupported;
}
