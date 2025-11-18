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
  List<ScanResult> _devices = [];
  StreamSubscription<List<ScanResult>>? _devicesSub;
  StreamSubscription<bool>? _scanStateSub;
  StreamSubscription<TopSignal?>? _topSub;
  StreamSubscription<BluetoothAdapterState>? _adapterSub;
  bool _scanning = false;
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  // Temizlik zamanlayıcısını 500ms'ye düşürdük
  Timer? _cleanupTimer;
  String? _lastRoute;
  DateTime _lastNav = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    // 1. İzinleri Kontrol Et ve Başlat
    _checkPermissionsAndInitialize();

    _adapterSub = FlutterBluePlus.adapterState.listen((state) {
      if (mounted) {
        setState(() => _adapterState = state);
      }
      // 2. Eğer Bluetooth yeni açıldıysa, taramaya otomatik başla
      if (state == BluetoothAdapterState.on && BleRouter().isScanning) {
        // Zaten tarıyorsa akışları tekrar bağla
        _attachStreams();
      }
    });

    // 3. Temizlik/Güncelleme zamanlayıcısını 500ms'ye ayarla
    _cleanupTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!mounted) return;
      setState(() {});
    });

    if (BleRouter().isScanning) {
      BleRouter().stop();
    }
  }

  Future<void> _checkPermissionsAndInitialize() async {
    // 4. Bluetooth desteğini kontrol et
    if (await FlutterBluePlus.isSupported == false) {
      // Cihaz Bluetooth'u desteklemiyor.
      if (mounted) {
        // Hata mesajı gösterilebilir.
      }
      return;
    }

    // Yüksek BLE izinleri (tarama ve bağlanma) genellikle turnOn() ile istenir.
    // Kullanıcının platformunu kontrol et ve Bluetooth'u açmasını iste.
    if (mounted) {
      // mounted kontrolü eklendi
      if (Theme.of(context).platform == TargetPlatform.android ||
          Theme.of(context).platform == TargetPlatform.iOS) {
        // Bluetooth'u açma ve gerekli izinleri alma isteği.
        // Konum izni (Android) ve Bluetooth izinleri (iOS/Android) bu çağrıyla dolaylı olarak istenir.
        await FlutterBluePlus.turnOn();
      }
    }
  }

  Future<void> _startScan() async {
    // Bluetooth kapalıysa açılmasını iste
    if (_adapterState != BluetoothAdapterState.on) {
      // Bluetooth'u açmak için platformun izin diyalogunu göster
      await FlutterBluePlus.turnOn();
      // State'in güncellenmesini bekle (BleScannerView'da durumu kontrol et)
      await Future.delayed(const Duration(milliseconds: 500));
      if (_adapterState != BluetoothAdapterState.on) {
        // Kullanıcı açmayı reddettiyse, uyarı gösterilebilir.
        return;
      }
    }

    setState(() {
      _lastRoute = null;
    });
    // Aşağıdaki if bloğunda tek satır statement yerine blok kullanın (curly_braces_in_flow_control_structures hatası için)
    if (!BleRouter().isScanning) {
      await BleRouter().start();
    }
    _attachStreams();
  }

  // ... (Diğer metotlar aynı kalır) ...
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
      // Navigasyon gecikmesi daha kısa tutulur
      final now = DateTime.now();
      if (now.difference(_lastNav) < const Duration(milliseconds: 500)) return;
      _lastNav = now;
      _navigateRoute(route);
    });
  }

  String? _routeForName(String name) {
    if (name == 'Zemin') return '/zemin';
    if (name == 'Kat 1') return '/kat1';
    if (name == 'Kat 2') return '/kat2';
    if (name == 'Orni1') return '/orni1';
    if (name == 'Orni2') return '/orni2';
    if (name == 'Orni3') return '/orni3';
    if (name == 'Orni4') return '/orni4';
    if (name == 'Orni5') return '/orni5';
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
    super.dispose();
  }
}
