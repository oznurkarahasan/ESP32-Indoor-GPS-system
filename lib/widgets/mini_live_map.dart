import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_compass/flutter_compass.dart'; // Pusula paketi
import '../logic/beacon_logic.dart';
import '../config/beacon_config.dart';
import '../services/ble_router.dart';

class MiniLiveMap extends StatefulWidget {
  const MiniLiveMap({super.key});

  @override
  State<MiniLiveMap> createState() => _MiniLiveMapState();
}

class _MiniLiveMapState extends State<MiniLiveMap> with SingleTickerProviderStateMixin {
  List<BeaconNode> beacons = BeaconConfig.getBeacons();
  
  Offset? _targetPosition; 
  Offset? _currentPosition; 
  double _heading = 0.0; // Pusula açısı

  StreamSubscription? _deviceSub;
  StreamSubscription? _compassSub;
  late AnimationController _radarController;
  DateTime _lastUpdateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    
    // 1. BLE Sinyallerini Dinle
    _deviceSub = BleRouter().devicesStream.listen((results) {
      _processScanResults(results);
    });

    // 2. Pusulayı Dinle (Telefonu çevirince harita tepki versin)
    _compassSub = FlutterCompass.events?.listen((event) {
      if (mounted) {
        setState(() {
          // Açıyı radyana çevir
          _heading = (event.heading ?? 0) * (pi / 180);
        });
      }
    });

    // 3. Animasyon Döngüsü
    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted) { timer.cancel(); return; }
      _animatePosition();
    });
  }

  void _processScanResults(List<ScanResult> results) {
    bool needsCalculation = false;
    for (var r in results) {
      try {
        var node = beacons.firstWhere((b) => b.id == r.device.remoteId.str);
        node.updateRssi(r.rssi);
        // 6 saniye hafıza (Sinyal kopsa bile 6sn hatırla)
        if (DateTime.now().difference(node.lastSeen).inSeconds < 6) {
          needsCalculation = true;
        }
      } catch (e) { }
    }
    if (needsCalculation) {
      _calculateHybridPosition();
    }
  }

  // --- HİBRİT HESAPLAMA (Anti-Snap + Trilaterasyon) ---
  void _calculateHybridPosition() {
    double totalWeight = 0, weightedSumX = 0, weightedSumY = 0;
    
    List<BeaconNode> activeNodes = beacons.where((b) => 
      DateTime.now().difference(b.lastSeen).inSeconds < 6 && b.estimatedDistance > 0
    ).toList();

    if (activeNodes.isEmpty) return;

    // Eğer tek cihaz varsa bile direkt üstüne gitme, sinyal mesafesini koru.
    if (activeNodes.length == 1) {
       // Tek cihazda tam konum bilinemez, sadece o cihaza olan uzaklık bilinir.
       // Bu yüzden şimdilik olduğu yerde bırakıyoruz ama "yakınlık halkası" çiziyoruz.
       return; 
    }

    for (var node in activeNodes) {
      // Mesafeyi al
      double d = max(node.estimatedDistance, 0.5);
      
      // --- SİHİRLİ FORMÜL ---
      // Eski Hata: 1 / d^2 yapıyorduk. d=0.5 olunca sonuç devasa çıkıyor ve içine çekiyordu.
      // Yeni Çözüm: 1 / (d + 2.0)^3
      // "+ 2.0" ekleyerek "Sanal Mesafe" oluşturuyoruz.
      // Bu sayede cihazın dibinde bile olsan, matematik seni diğer cihazlardan koparmaz.
      
      double weight = 1.0 / pow(d + 2.0, 3.0); 
      
      weightedSumX += node.position.dx * weight;
      weightedSumY += node.position.dy * weight;
      totalWeight += weight;
    }

    if (totalWeight > 0) {
      Offset rawTarget = Offset(weightedSumX / totalWeight, weightedSumY / totalWeight);
      
      // Filtreleri kaldırdım! Artık anlık hareket edecek.
      _setTarget(rawTarget);
    }
  }

  void _setTarget(Offset rawTarget) {
    _targetPosition = Offset(
      rawTarget.dx.clamp(0.5, BeaconConfig.roomWidth - 0.5),
      rawTarget.dy.clamp(0.5, BeaconConfig.roomHeight - 0.5)
    );
  }

  void _animatePosition() {
    if (_targetPosition == null) return;
    if (_currentPosition == null) {
      setState(() { _currentPosition = _targetPosition; _lastUpdateTime = DateTime.now(); });
      return;
    }

    // Hareket Yumuşatma (Lerp)
    // 0.05 yavaş takip eder, 0.1 orta, 0.2 hızlı.
    // 0.08 ideal bir değerdir.
    double smoothFactor = 0.08; 
    
    double dx = _targetPosition!.dx - _currentPosition!.dx;
    double dy = _targetPosition!.dy - _currentPosition!.dy;

    setState(() {
      _currentPosition = Offset(
        _currentPosition!.dx + dx * smoothFactor,
        _currentPosition!.dy + dy * smoothFactor
      );
    });
  }

  @override
  void dispose() {
    _deviceSub?.cancel();
    _compassSub?.cancel();
    _radarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF6B35), width: 2),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                BeaconConfig.mapImagePath,
                fit: BoxFit.fill,
                errorBuilder: (c, e, s) => Container(color: Colors.grey.shade100),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _HybridMapPainter(
                  beacons: beacons,
                  userPos: _currentPosition,
                  heading: _heading, // Pusula açısını gönder
                  radarValue: _radarController.value,
                ),
              ),
            ),
            // Koordinat Bilgisi
             Positioned(
              bottom: 2, right: 2,
              child: _currentPosition == null ? const SizedBox() : 
              Container(
                padding: const EdgeInsets.all(2),
                color: Colors.black54,
                child: Text(
                  "X:${_currentPosition!.dx.toStringAsFixed(1)} Y:${_currentPosition!.dy.toStringAsFixed(1)}",
                  style: const TextStyle(fontSize: 8, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _HybridMapPainter extends CustomPainter {
  final List<BeaconNode> beacons;
  final Offset? userPos;
  final double heading;
  final double radarValue;

  _HybridMapPainter({
    required this.beacons, 
    required this.userPos, 
    required this.heading,
    required this.radarValue
  });

  @override
  void paint(Canvas canvas, Size size) {
    double scaleX = size.width / BeaconConfig.roomWidth;
    double scaleY = size.height / BeaconConfig.roomHeight;

    for (var b in beacons) {
      Offset bPos = Offset(b.position.dx * scaleX, b.position.dy * scaleY);
      bool isActive = DateTime.now().difference(b.lastSeen).inSeconds < 6; 

      canvas.drawCircle(bPos, 4, Paint()..color = isActive ? b.color : Colors.grey.withOpacity(0.3));
      
      if (isActive) {
         double rippleRadius = 10.0 + (sin(radarValue * pi) * 3);
         canvas.drawCircle(bPos, rippleRadius, Paint()..style=PaintingStyle.stroke..color=b.color.withOpacity(0.4)..strokeWidth=1);
      }
    }

    if (userPos != null) {
      Offset uPos = Offset(userPos!.dx * scaleX, userPos!.dy * scaleY);
      
      // 1. Gölge (Konum Belirsizliği)
      canvas.drawCircle(uPos, 12, Paint()..color = Colors.blue.withOpacity(0.1));
      
      // 2. Kullanıcı Noktası
      canvas.drawCircle(uPos, 6, Paint()..color = Colors.white);
      canvas.drawCircle(uPos, 4, Paint()..color = const Color(0xFFFF6B35));

      // 3. PUSULA OKU (Yön Göstergesi)
      // Bu ok telefonun baktığı yöne doğru döner
      _drawArrow(canvas, uPos, heading, const Color(0xFFFF6B35));
    }
  }

  void _drawArrow(Canvas canvas, Offset center, double angle, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Okun uzunluğu ve genişliği
    const double arrowLen = 20.0;
    const double arrowWidth = 8.0;

    final path = Path();
    
    // Okun ucunu hesapla (Pusula açısına göre dönmüş hali)
    // Not: Haritada "Kuzey" genelde yukarısıdır (-pi/2).
    // Telefon pusulası 0 dereceyi Kuzey verir.
    double rotation = angle - (pi / 2); 

    Offset tip = Offset(
      center.dx + cos(rotation) * arrowLen,
      center.dy + sin(rotation) * arrowLen,
    );
    
    Offset leftBase = Offset(
      center.dx + cos(rotation + 2.6) * arrowWidth,
      center.dy + sin(rotation + 2.6) * arrowWidth,
    );

    Offset rightBase = Offset(
      center.dx + cos(rotation - 2.6) * arrowWidth,
      center.dy + sin(rotation - 2.6) * arrowWidth,
    );

    path.moveTo(tip.dx, tip.dy);
    path.lineTo(leftBase.dx, leftBase.dy);
    path.lineTo(rightBase.dx, rightBase.dy);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}