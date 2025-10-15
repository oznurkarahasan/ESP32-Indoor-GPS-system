import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// Yeni eklenen görünüm dosyası
import '../views/ble_scanner_view.dart';
// Kullanılan widget'lar
import '../widgets/custom_appbar.dart';
import '../services/ble_router.dart';

class BleScannerPage extends StatefulWidget {
  const BleScannerPage({super.key});

  @override
  State<BleScannerPage> createState() => _BleScannerPageState();
}

class _BleScannerPageState extends State<BleScannerPage> {
  // ... (Tüm değişkenler aynı kalır) ...
  List<ScanResult> _devices = [];
  StreamSubscription<List<ScanResult>>? _devicesSub;
  StreamSubscription<bool>? _scanStateSub;
  StreamSubscription<TopSignal?>? _topSub;
  StreamSubscription<BluetoothAdapterState>? _adapterSub;
  bool _scanning = false;
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  Timer? _cleanupTimer;
  // ... (Diğer navigasyon değişkenleri aynı kalır) ...
  String? _lastRoute;
  DateTime _lastNav = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    // ... (initState içeriği aynı kalır) ...
    _adapterSub = FlutterBluePlus.adapterState.listen((state) {
      setState(() => _adapterState = state);
    });

    _cleanupTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
      setState(() {});
    });

    if (BleRouter().isScanning) {
      _attachStreams();
      setState(() => _scanning = true);
    }
  }

  // ... (_startScan, _attachStreams, _routeForName, _navigateRoute metotları aynı kalır) ...
  Future<void> _startScan() async {
    setState(() {
      _lastRoute = null;
    });
    if (!BleRouter().isScanning) {
      await BleRouter().start();
    }
    _attachStreams();
  }

  void _attachStreams() {
    // scanning state
    _scanning = BleRouter().isScanning;
    _scanStateSub?.cancel();
    _scanStateSub = BleRouter().scanningStream.listen((v) {
      if (!mounted) return;
      setState(() => _scanning = v);
    });
    // devices list
    _devicesSub?.cancel();
    _devicesSub = BleRouter().devicesStream.listen((list) {
      if (!mounted) return;
      setState(() => _devices = list);
    });
    // top signal for navigation
    _topSub?.cancel();
    _topSub = BleRouter().topStream.listen((top) {
      if (!mounted || top == null) return;
      final route = _routeForName(top.name);
      if (route == null) return;
      final now = DateTime.now();
      if (now.difference(_lastNav) < const Duration(milliseconds: 800)) return;
      _lastNav = now;
      _navigateRoute(route);
    });
  }

  String? _routeForName(String name) {
    if (name == 'Zemin') return '/zemin';
    if (name == 'Kat 1') return '/kat1';
    if (name == 'Kat 2') return '/kat2';
    return null;
  }

  void _navigateRoute(String route) {
    if (_lastRoute == route) return;
    _lastRoute = route;
    Navigator.of(context).pushReplacementNamed(route);
  }

  // Tarama durdurma butonu StopScanButton widget'ı içinde yönetildiği için bu metot artık gerekli değil.
  // Ancak tarama durdurma ikonunu AppBar'a eklemek isterseniz bu metodu kullanabilirsiniz.
  /*
  Future<void> _stopScan() async {
    if (!BleRouter().isScanning) return;
    try {
      await BleRouter().stop();
      setState(() {
        _devices = [];
      });
    } catch (_) {
      // Hata yönetimi
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // CustomAppBar'ı kullanıyoruz
      appBar: const CustomAppBar(title: 'NavIn'),

      // Tüm arayüz mantığını BleScannerView'e aktarıyoruz
      body: BleScannerView(
        adapterState: _adapterState,
        isScanning: _scanning,
        devices: _devices,
        onStartScan: _startScan,
      ),
    );
  }

  @override
  void dispose() {
    _devicesSub?.cancel();
    _scanStateSub?.cancel();
    _topSub?.cancel();
    _adapterSub?.cancel();
    _cleanupTimer?.cancel();
    super.dispose();
  }
}
