import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../widgets/device_title.dart';
import '../widgets/stop_scan_button.dart';

typedef StartScanCallback = Future<void> Function();

class BleScannerView extends StatelessWidget {
  final BluetoothAdapterState adapterState;
  final bool isScanning;
  final List<ScanResult> devices;
  final StartScanCallback onStartScan;

  const BleScannerView({
    super.key,
    required this.adapterState,
    required this.isScanning,
    required this.devices,
    required this.onStartScan,
  });

  // Turuncu tema rengi
  static const Color primaryOrange = Color(0xFFFF9800);
  static const Color accentOrange = Color(0xFFFFCC80);
  static const Color darkOrange = Color(0xFFE65100); // Yeni koyu ton

  // Responsive düzenleme için dikey boşluk ayarı
  double _getPadding(BuildContext context) {
    return MediaQuery.of(context).size.height > 800 ? 40.0 : 24.0;
  }

  /// Bluetooth Kapalı Durumu için özel widget (Geliştirildi)
  Widget _buildBluetoothOff(BuildContext context) {
    return Container(
      color: Colors.lightBlue.shade50, // Hafif mavi arka plan
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(_getPadding(context)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.bluetooth_disabled,
                size: 100, // Daha büyük simge
                color: Colors.blueGrey,
              ),
              const SizedBox(height: 30),
              Text(
                'Bluetooth Kapalı',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Lütfen cihazınızın Bluetooth özelliğini açın. Navigasyon için bu gereklidir.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 40),
              // Bluetooth'u açma isteği butonu
              ElevatedButton.icon(
                onPressed: onStartScan, // BleScannerPage'de turnOn çağrısı var
                icon: const Icon(Icons.bluetooth_searching, size: 24),
                label: const Text('Bluetooth\'u Aç'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(
                    double.infinity,
                    60,
                  ), // Responsive butona geçiş
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Tarama Başlatma Durumu için özel widget (Geliştirildi)
  Widget _buildStartScan(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(_getPadding(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, size: 100, color: primaryOrange),
            const SizedBox(height: 30),
            Text(
              'İç Mekan Navigasyonu',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: darkOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Sinyalleri tarayarak katınızı ve konumunuzu hızlıca belirleyin.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: onStartScan,
              icon: const Icon(Icons.radar, size: 30), // Daha uygun bir simge
              label: const Text('Taramayı Başlat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryOrange,
                foregroundColor: Colors.white,
                minimumSize: const Size(
                  double.infinity,
                  65,
                ), // Responsive genişlik
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tarama Açık ve Cihaz Bekleme Durumu için özel widget (Geliştirildi)
  Widget _buildWaitingForDevices(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(_getPadding(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: primaryOrange,
                strokeWidth: 5,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Sinyaller Algılanıyor...',
              style: TextStyle(
                fontSize: 20,
                color: primaryOrange,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Çevrenizdeki sinyaller analiz ediliyor. Lütfen bekleyin.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 50),
            const StopScanButton(
              fullWidth: true,
              padding: EdgeInsets.symmetric(horizontal: 20),
            ),
          ],
        ),
      ),
    );
  }

  /// Tarama Açık ve Cihazlar Bulundu Durumu için özel widget (Geliştirildi)
  Widget _buildDeviceList() {
    return Column(
      children: [
        // Başlık ve Durdurma Butonunu içeren üst alan
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: accentOrange.withOpacity(0.1),
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Aktif Sinyaller (${devices.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkOrange,
                ),
              ),
              const StopScanButton(padding: EdgeInsets.zero, fullWidth: false),
            ],
          ),
        ),
        // Cihaz Listesi
        Expanded(
          child: ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // Daha yuvarlak köşeler
                  border: Border.all(
                    color: primaryOrange.withOpacity(0.2),
                    width: 1,
                  ), // Hafif bir çerçeve
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: DeviceTile(result: devices[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: _buildBody(context),
    ); // Hafif gri arka plan
  }

  // Bluetooth durumuna göre ana içeriği döndüren metot
  Widget _buildBody(BuildContext context) {
    // 1. Bluetooth Kapalı Durumu
    if (adapterState != BluetoothAdapterState.on) {
      return _buildBluetoothOff(context);
    }

    // 2. Tarama Başlatma Durumu
    if (!isScanning) {
      return _buildStartScan(context);
    }

    // 3. Tarama Açık Durumu (Cihaz Listesi veya Bekleme)
    if (devices.isEmpty) {
      return _buildWaitingForDevices(context);
    }

    // 4. Tarama Açık ve Cihazlar Bulundu Durumu
    return _buildDeviceList();
  }
}
