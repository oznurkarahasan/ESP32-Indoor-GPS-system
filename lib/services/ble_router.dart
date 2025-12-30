import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class TopSignal {
  final String name;
  final int rssi;
  TopSignal(this.name, this.rssi);
}

class BleRouter {
  BleRouter._internal();
  static final BleRouter _instance = BleRouter._internal();
  factory BleRouter() => _instance;

  // Sadece bu isimleri tarar
  static const Set<String> _allowedNames = {
    'Zemin', 
    'Kat 1', 
    'Kat 2', 
    'iTAG',       // Büyük harf iTAG
    'itag',       // Küçük harf itag
    'iTAG Sol',   
    'iTAG Sağ'
  };
  
  static const Duration _aliveTimeout = Duration(milliseconds: 2000); 
  static const int _rssiThreshold = -95; 
  static const int _maxHistorySize = 5;

  bool _scanning = false;
  StreamSubscription<List<ScanResult>>? _scanSub;
  Timer? _tickTimer;

  final _devicesCtrl = StreamController<List<ScanResult>>.broadcast();
  final _topCtrl = StreamController<TopSignal?>.broadcast();
  final _scanningCtrl = StreamController<bool>.broadcast();

  Stream<List<ScanResult>> get devicesStream => _devicesCtrl.stream;
  Stream<TopSignal?> get topStream => _topCtrl.stream;
  Stream<bool> get scanningStream => _scanningCtrl.stream;
  bool get isScanning => _scanning;

  final Map<String, DateTime> _lastSeenById = {};
  final Map<String, ScanResult> _lastResultById = {};
  final Map<String, List<int>> _rssiHistory = {};
  String? _publishedTopId;

  Future<void> start() async {
    if (_scanning) return;
    _scanning = true;
    _scanningCtrl.add(true);

    await FlutterBluePlus.startScan(
      continuousUpdates: true,
      continuousDivisor: 1,
    );

    _scanSub = FlutterBluePlus.scanResults.listen((results) {
      final now = DateTime.now();

      for (final r in results) {
        final name = r.device.platformName;
        if (name.isEmpty) continue;
        
        // Filtreleme
        bool isAllowed = false;
        for (var allowed in _allowedNames) {
          if (name.contains(allowed)) {
            isAllowed = true;
            break;
          }
        }
        if (!isAllowed) continue;

        if (r.rssi < _rssiThreshold) continue;
        
        final id = r.device.remoteId.str;
        _lastSeenById[id] = now;
        
        _rssiHistory.putIfAbsent(id, () => <int>[]);
        _rssiHistory[id]!.add(r.rssi);
        if (_rssiHistory[id]!.length > _maxHistorySize) {
          _rssiHistory[id]!.removeAt(0);
        }
        final smoothedRssi = _rssiHistory[id]!.reduce((a, b) => a + b) ~/ _rssiHistory[id]!.length;
        
        final smoothedResult = ScanResult(
          device: r.device,
          advertisementData: r.advertisementData,
          rssi: smoothedRssi,
          timeStamp: r.timeStamp,
        );
        
        _lastResultById[id] = smoothedResult;
      }
      _publish(now);
    }, onError: (_) {});

    _tickTimer?.cancel();
    _tickTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      _publish(DateTime.now());
    });
  }

  Future<void> stop() async {
    if (!_scanning) return;
    await FlutterBluePlus.stopScan();
    await _scanSub?.cancel();
    _scanSub = null;
    _tickTimer?.cancel();
    _tickTimer = null;
    _scanning = false;
    _scanningCtrl.add(false);
    _lastSeenById.clear();
    _lastResultById.clear();
    _rssiHistory.clear();
    _publishedTopId = null;
    _devicesCtrl.add(const []);
    _topCtrl.add(null);
  }

  void _publish(DateTime now) {
    _lastSeenById.removeWhere((id, seenAt) => now.difference(seenAt) > _aliveTimeout);
    _lastResultById.removeWhere((id, _) => !_lastSeenById.containsKey(id));

    final alive = _lastResultById.values.toList()
      ..sort((a, b) => b.rssi.compareTo(a.rssi));

    _devicesCtrl.add(alive);

    if (alive.isNotEmpty) {
      final top = alive.first;
      final topId = top.device.remoteId.str;
      // Basit bir debounce ile en güçlü sinyali yayınla
      if (_publishedTopId != topId) {
        _publishedTopId = topId;
        _topCtrl.add(TopSignal(top.device.platformName, top.rssi));
      } else {
        _topCtrl.add(TopSignal(top.device.platformName, top.rssi));
      }
    } else {
      if (_publishedTopId != null) {
        _publishedTopId = null;
        _topCtrl.add(null);
      }
    }
  }
}