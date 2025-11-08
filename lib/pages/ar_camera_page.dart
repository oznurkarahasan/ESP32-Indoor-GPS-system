import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math' as math;
import 'navigation_page.dart';
import '../services/ble_router.dart';

class ArCameraPage extends StatefulWidget {
  final String destination;
  final Map<String, dynamic>? locationData;

  const ArCameraPage({
    super.key,
    required this.destination,
    this.locationData,
  });

  @override
  State<ArCameraPage> createState() => _ArCameraPageState();
}

class _ArCameraPageState extends State<ArCameraPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  String _errorMessage = '';

  late AnimationController _arrowController;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;

  double _distance = 25.0;
  String _instruction = "İleri doğru ilerleyin";
  int _arrowCount = 3;
  double _deviceTilt = 0.0;
  double _deviceRotation = 0.0;
  double _compass = 0.0;
  bool _sensorsActive = true;
  bool _showInfo = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
    _initializeAnimations();
    _initializeSensors();
    
    // Bluetooth taramasını durdur
    BleRouter().stop();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        setState(() {
          _errorMessage = 'Kamera bulunamadı';
        });
        return;
      }

      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Kamera başlatılamadı: $e';
      });
    }
  }

  void _initializeAnimations() {
    _arrowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  void _initializeSensors() {
    // Accelerometer - cihaz eğimi
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      if (mounted && _sensorsActive) {
        setState(() {
          _deviceTilt = event.y / 10;
        });
      }
    });

    // Gyroscope - cihaz dönüşü
    _gyroscopeSubscription = gyroscopeEvents.listen((event) {
      if (mounted && _sensorsActive) {
        setState(() {
          _deviceRotation = event.z;
        });
      }
    });

    // Magnetometer - pusula
    _magnetometerSubscription = magnetometerEvents.listen((event) {
      if (mounted && _sensorsActive) {
        setState(() {
          double heading = math.atan2(event.y, event.x);
          _compass = heading * (180 / math.pi);
        });
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    // Bluetooth taramasını tekrar başlat
    BleRouter().start();
    
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _arrowController.dispose();
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _magnetometerSubscription?.cancel();
    super.dispose();
  }

  void _simulateMovement() {
    setState(() {
      if (_distance > 0) {
        _distance -= 2.5;
        if (_distance <= 0) {
          _distance = 0;
          _instruction = "🎉 Hedefe ulaştınız!";
        } else if (_distance < 5) {
          _instruction = "⚡ Hedefe çok yakınsınız!";
        } else if (_distance < 10) {
          _instruction = "➡️ Az kaldı, devam edin";
        } else {
          _instruction = "🧭 İleri doğru ilerleyin";
        }
      }
    });
  }

  void _resetNavigation() {
    setState(() {
      _distance = 25.0;
      _instruction = "İleri doğru ilerleyin";
      _arrowCount = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_errorMessage.isNotEmpty) {
      return _buildErrorView();
    }

    if (!_isCameraInitialized) {
      return _buildLoadingView();
    }

    return Stack(
      children: [
        // Kamera görüntüsü
        _buildCameraPreview(),

        // AR Overlay
        _buildAROverlay(),

        // Üst bilgi kartı (Sadeleştirilmiş)
        _buildSimpleInfoCard(),

        // Alt butonlar (Video Rehber ve Hedef Önizleme)
        _buildBottomButtons(),

        // Üst sağ kapat butonu
        _buildCloseButton(),
      ],
    );
  }

  Widget _buildCameraPreview() {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _cameraController!.value.previewSize!.height,
          height: _cameraController!.value.previewSize!.width,
          child: CameraPreview(_cameraController!),
        ),
      ),
    );
  }

  Widget _buildAROverlay() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < _arrowCount && i < 5; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: AnimatedBuilder(
                animation: _arrowController,
                builder: (context, child) {
                  double animationValue = _arrowController.value * 2 * math.pi;
                  double yOffset = math.sin(animationValue + i) * 15;
                  double scale = 1.0 - (i * 0.15);
                  double opacity = 1.0 - (i * 0.15);

                  return Transform.translate(
                    offset: Offset(
                      _sensorsActive ? _deviceRotation * 20 : 0,
                      yOffset,
                    ),
                    child: Transform.scale(
                      scale: scale,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.3),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.orange,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_upward,
                          size: 50 - (i * 8),
                          color: Colors.white.withOpacity(opacity),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSimpleInfoCard() {
    // Hedef POI bilgisini al
    final targetPOI = widget.locationData?['endPOI'];
    final floor = targetPOI?.floor ?? 'Bilinmiyor';
    
    return Positioned(
      top: 60,
      left: 16,
      right: 16,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.black.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Yön talimatı
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.navigation,
                      color: Colors.orange,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _instruction,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: Colors.white24),
              const SizedBox(height: 16),
              // Hedef bilgisi
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Hedef: ',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.destination,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Kat bilgisi
              Row(
                children: [
                  const Icon(
                    Icons.layers,
                    color: Colors.blue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Kat: ',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      floor,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Positioned(
      bottom: 30,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _openVideoGuide,
                icon: const Icon(Icons.play_circle_outline, size: 24),
                label: const Text(
                  'Video Rehber',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _openDestinationPreview,
                icon: const Icon(Icons.preview, size: 24),
                label: const Text(
                  'Hedef Önizleme',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.purple.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openVideoGuide() {
    if (widget.locationData == null) return;
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NavigationPage(
          startPOI: widget.locationData!['startPOI'] ?? 'Zemin ZON',
          endPOI: widget.locationData!['endPOI'],
          showVideoOnly: true,
        ),
      ),
    );
  }

  void _openDestinationPreview() {
    if (widget.locationData == null) return;
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NavigationPage(
          startPOI: widget.locationData!['startPOI'] ?? 'Zemin ZON',
          endPOI: widget.locationData!['endPOI'],
          showPreviewOnly: true,
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return Positioned(
      top: 60,
      right: 16,
      child: FloatingActionButton(
        mini: true,
        heroTag: 'close',
        onPressed: () => Navigator.pop(context),
        backgroundColor: Colors.red.withOpacity(0.9),
        child: const Icon(Icons.close, color: Colors.white),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: FloatingActionButton(
            mini: true,
            heroTag: label,
            onPressed: onPressed,
            backgroundColor: color,
            child: Icon(icon),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorIndicator(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingView() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.orange),
            SizedBox(height: 20),
            Text(
              'Kamera başlatılıyor...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 80,
              ),
              const SizedBox(height: 20),
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Geri Dön'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
