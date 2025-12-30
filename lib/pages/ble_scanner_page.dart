import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../views/ble_scanner_view.dart';
import '../widgets/custom_appbar.dart';
import '../services/ble_router.dart';
import '../services/video_cache_service.dart'; 

class BleScannerPage extends StatefulWidget {
  const BleScannerPage({super.key});

  @override
  State<BleScannerPage> createState() => _BleScannerPageState();
}

class _BleScannerPageState extends State<BleScannerPage> {
  List<ScanResult> _devices = [];
  StreamSubscription<List<ScanResult>>? _devicesSub;
  StreamSubscription<bool>? _scanStateSub;
  StreamSubscription<TopSignal?>? _topSub;
  StreamSubscription<BluetoothAdapterState>? _adapterSub;
  bool _scanning = false;
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  Timer? _cleanupTimer;
  String? _lastRoute;
  DateTime _lastNav = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndInitialize();
    
    _adapterSub = FlutterBluePlus.adapterState.listen((state) {
      if (mounted) setState(() => _adapterState = state);
      if (state == BluetoothAdapterState.on && BleRouter().isScanning) {
        _attachStreams();
      }
    });

    _cleanupTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!mounted) return;
      setState(() {});
    });

    if (BleRouter().isScanning) {
      BleRouter().stop();
    }
  }

  Future<void> _checkPermissionsAndInitialize() async {
    if (await FlutterBluePlus.isSupported == false) return;
    if (mounted) {
      if (Theme.of(context).platform == TargetPlatform.android ||
          Theme.of(context).platform == TargetPlatform.iOS) {
        await FlutterBluePlus.turnOn();
      }
    }
  }

  Future<void> _startScan() async {
    if (_adapterState != BluetoothAdapterState.on) {
      await FlutterBluePlus.turnOn();
      await Future.delayed(const Duration(milliseconds: 500));
      if (_adapterState != BluetoothAdapterState.on) return;
    }

    setState(() {
      _lastRoute = null;
    });
    
    if (!BleRouter().isScanning) {
      await BleRouter().start();
    }
    _attachStreams();
  }

  void _attachStreams() {
    _scanning = BleRouter().isScanning;
    _scanStateSub?.cancel();
    _scanStateSub = BleRouter().scanningStream.listen((v) {
      if (!mounted) return;
      setState(() => _scanning = v);
    });
    
    _devicesSub?.cancel();
    _devicesSub = BleRouter().devicesStream.listen((list) {
      if (!mounted) return;
      setState(() => _devices = list);
    });
    
    _topSub?.cancel();
    _topSub = BleRouter().topStream.listen((top) {
      if (!mounted || top == null) return;
      
      final route = _routeForName(top.name);
      
      if (route == null) return;
      
      final now = DateTime.now();
      if (now.difference(_lastNav) < const Duration(milliseconds: 500)) return;
      _lastNav = now;
      _navigateRoute(route);
    });
  }

  // >>>>> İŞTE İSTEDİĞİN KURAL BURADA <<<<<
  String? _routeForName(String name) {
    // iTAG kelimesini görürsen direkt '/zemin' sayfasına gönder
    if (name.contains('iTAG') || name.contains('itag') || name == 'Zemin') {
        return '/zemin';
    }
    
    if (name == 'Kat 1') return '/kat1';
    if (name == 'Kat 2') return '/kat2';
    return null;
  }

  void _navigateRoute(String route) {
    if (_lastRoute == route) return;
    _lastRoute = route;
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'NavIn'),
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
    VideoCacheService().disposeAll();
    super.dispose();
  }
}