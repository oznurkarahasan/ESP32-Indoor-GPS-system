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

  static const Set<String> _allowedNames = {'Zemin', 'Kat 1', 'Kat 2'};
  // Alive Timeout aynı kalsın (1500ms), bu cihazın ne kadar süre sonra kaybolacağını belirler.
  static const Duration _aliveTimeout = Duration(milliseconds: 1500);

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

  // Internal state
  final Map<String, DateTime> _lastSeenById = {}; // id -> last seen
  final Map<String, ScanResult> _lastResultById = {}; // id -> last result
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

      // Update last seen/result per id
      for (final r in results) {
        final name = r.device.platformName;
        if (name.isEmpty || !_allowedNames.contains(name)) continue;
        final id = r.device.remoteId.str;
        _lastSeenById[id] = now;
        final prev = _lastResultById[id];
        if (prev == null || r.rssi > prev.rssi) {
          _lastResultById[id] = r;
        }
      }

      _publish(now);
    }, onError: (_) {});

    // Periodic tick to prune and publish even without new scan events
    _tickTimer?.cancel();
    // Zamanlayıcıyı 500ms'den 200ms'ye düşürerek tepkiselliği artırdık
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
