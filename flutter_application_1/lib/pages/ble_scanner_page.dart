import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleScannerPage extends StatefulWidget {
  const BleScannerPage({super.key});

  @override
  State<BleScannerPage> createState() => _BleScannerPageState();
}

class _BleScannerPageState extends State<BleScannerPage> {
  List<ScanResult> _devices = [];
  StreamSubscription<List<ScanResult>>? _scanSub;
  StreamSubscription<BluetoothAdapterState>? _adapterSub;
  bool _scanning = false;
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  @override
  void initState() {
    super.initState();
    _adapterSub = FlutterBluePlus.adapterState.listen((state) {
      setState(() => _adapterState = state);
    });
    _startScan();
    // 🔁 Her 5 saniyede bir yeniden tarama yap
    Timer.periodic(const Duration(seconds: 5), (_) async {
      if (!_scanning) await _startScan();
    });
  }

  Future<void> _startScan() async {
    if (_scanning) return;
    setState(() {
      _devices = [];
      _scanning = true;
    });

    await FlutterBluePlus.startScan(
      continuousUpdates: true, // sürekli güncelleme aktif
      continuousDivisor: 1, // mümkün olan en sık güncelleme (RSSI)
    );

    _scanSub = FlutterBluePlus.scanResults.listen((results) {
      final allowedDevices = ["Zemin", "Kat 1", "Kat 2"];
      final filtered = results.where((r) {
        final name = r.device.platformName;
        return name.isNotEmpty && allowedDevices.contains(name);
      }).toList();

      // 🔽 RSSI'ye göre büyükten küçüğe sırala (yakın olan en üstte)
      filtered.sort((a, b) => b.rssi.compareTo(a.rssi));

      setState(() => _devices = filtered);
    }, onError: (e) => _showSnack('Tarama hatasi: $e'));
  }

  Future<void> _stopScan() async {
    if (!_scanning) return;
    await FlutterBluePlus.stopScan();
    await _scanSub?.cancel();
    setState(() => _scanning = false);
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final isBtOn = _adapterState == BluetoothAdapterState.on;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE Tarayici'),
        actions: [
          IconButton(
            icon: Icon(_scanning ? Icons.stop : Icons.refresh),
            tooltip: _scanning ? 'Taramayi durdur' : 'Taramayi baslat',
            onPressed: _scanning ? _stopScan : _startScan,
          ),
        ],
      ),
      body: !isBtOn
          ? const Center(child: Text('Bluetooth kapali. Lutfen acin.'))
          : _devices.isEmpty
          ? const Center(child: Text('Taraniyor veya cihaz bulunamadi...'))
          : ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                final result = _devices[index];
                final name = result.device.platformName.isNotEmpty
                    ? result.device.platformName
                    : 'Bilinmeyen cihaz';
                return ListTile(
                  leading: CircleAvatar(child: Text('${result.rssi}')),
                  title: Text(name),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _scanSub?.cancel();
    _adapterSub?.cancel();
    FlutterBluePlus.stopScan();
    super.dispose();
  }
}
