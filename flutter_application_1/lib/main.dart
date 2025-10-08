import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLE Tarayici',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BleScannerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

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
      setState(() {
        _adapterState = state;
      });
    });

    _startScan();
  }

  Future<void> _startScan() async {
    if (_scanning) return;
    setState(() {
      _devices = [];
      _scanning = true;
    });

    await FlutterBluePlus.startScan();

    await _scanSub?.cancel();
    _scanSub = FlutterBluePlus.scanResults.listen(
      (results) {
        final sorted = [...results]..sort((a, b) => b.rssi.compareTo(a.rssi));
        setState(() {
          _devices = sorted;
        });
      },
      onError: (e) {
        _showSnack('Tarama hatasi: $e');
      },
    );
  }

  Future<void> _stopScan() async {
    if (!_scanning) return;
    await FlutterBluePlus.stopScan();
    await _scanSub?.cancel();
    setState(() {
      _scanning = false;
    });
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
            tooltip: _scanning ? 'Taramayi durdur' : 'Taramayi baslat',
            icon: Icon(_scanning ? Icons.stop : Icons.refresh),
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
                  subtitle: Text(
                    '${result.device.remoteId.str} - RSSI: ${result.rssi} dBm',
                  ),
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
