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

  static const Set<String> _allowedNames = {'Zemin', 'Kat 1', 'Kat 2', 'Orni1'};
  static const Duration _aliveTimeout = Duration(milliseconds: 1200); // Daha hızlı timeout
  static const int _rssiThreshold = -85; // Çok zayıf sinyalleri filtrele
  static const int _maxHistorySize = 5; // RSSI geçmişi için

  bool _scanning = false;
  StreamSubscription<List<ScanResult>>? _scanSub;
  Timer? _tickTimer;

  final _devicesCtrl = StreamController<List<ScanResult>>.broadcast();
  final _topCtrl = StreamController<TopSignal?>.broadcast();
  final _scanningCtrl = StreamController<bool>.broadcast();

  // Public streams/state
  Stream<List<ScanResult>> get devicesStream => _devicesCtrl.stream;
  Stream<TopSignal?> get topStream => _topCtrl.stream;
  Stream<bool> get scanningStream => _scanningCtrl.stream;
  bool get isScanning => _scanning;

  // Enhanced internal state with RSSI smoothing
  final Map<String, DateTime> _lastSeenById = {};
  final Map<String, ScanResult> _lastResultById = {};
  final Map<String, List<int>> _rssiHistory = {}; // RSSI geçmişi için smoothing
  String? _publishedTopId;

  Future<void> start() async {
    if (_scanning) return;
    _scanning = true;
    _scanningCtrl.add(true);

    await FlutterBluePlus.startScan(
      continuousUpdates: true,
      // Tarama hızını artırmak için continuousDivisor varsayılan değerde kalmalı (1)
      continuousDivisor: 1,
    );

    _scanSub = FlutterBluePlus.scanResults.listen((results) {
      final now = DateTime.now();

      // Update last seen/result per id with RSSI smoothing
      for (final r in results) {
        final name = r.device.platformName;
        if (name.isEmpty || !_allowedNames.contains(name)) continue;
        
        // Çok zayıf sinyalleri filtrele
        if (r.rssi < _rssiThreshold) continue;
        
        final id = r.device.remoteId.str;
        _lastSeenById[id] = now;
        
        // RSSI smoothing için geçmiş tut
        _rssiHistory.putIfAbsent(id, () => <int>[]);
        _rssiHistory[id]!.add(r.rssi);
        
        // Geçmişi sınırla
        if (_rssiHistory[id]!.length > _maxHistorySize) {
          _rssiHistory[id]!.removeAt(0);
        }
        
        // Smoothed RSSI hesapla (moving average)
        final smoothedRssi = _rssiHistory[id]!.reduce((a, b) => a + b) ~/ _rssiHistory[id]!.length;
        
        // Smoothed değerle yeni ScanResult oluştur
        final smoothedResult = ScanResult(
          device: r.device,
          advertisementData: r.advertisementData,
          rssi: smoothedRssi,
          timeStamp: r.timeStamp,
        );
        
        final prev = _lastResultById[id];
        if (prev == null || smoothedRssi > prev.rssi) {
          _lastResultById[id] = smoothedResult;
        }
      }

      _publish(now);
    }, onError: (_) {});

    // Periodic tick to prune and publish even without new scan events
    _tickTimer?.cancel();
    // Daha optimize edilmiş zamanlayıcı - 150ms için daha hızlı tepki
    _tickTimer = Timer.periodic(const Duration(milliseconds: 150), (_) {
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
    _rssiHistory.clear(); // RSSI geçmişini de temizle
    _publishedTopId = null;
    _devicesCtrl.add(const []);
    _topCtrl.add(null);
  }

  void _publish(DateTime now) {
    // Prune stale
    _lastSeenById.removeWhere(
      (id, seenAt) => now.difference(seenAt) > _aliveTimeout,
    );
    _lastResultById.removeWhere((id, _) => !_lastSeenById.containsKey(id));

    // Build alive list
    final alive = _lastResultById.values.toList()
      ..sort((a, b) => b.rssi.compareTo(a.rssi));

    _devicesCtrl.add(alive);

    // Publish top
    if (alive.isNotEmpty) {
      final top = alive.first;
      final topId = top.device.remoteId.str;
      if (_publishedTopId != topId) {
        _publishedTopId = topId;
        _topCtrl.add(TopSignal(top.device.platformName, top.rssi));
      } else {
        // update RSSI changes for same top
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
