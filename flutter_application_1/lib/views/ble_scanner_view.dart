import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../widgets/device_title.dart';
import '../widgets/stop_scan_button.dart';

// Gerekli fonksiyonel bağımlılıkları tanımlayın
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

  // Responsive düzenleme için dikey boşluk ayarı
  double _getPadding(BuildContext context) {
    return MediaQuery.of(context).size.height > 800 ? 40.0 : 20.0;
  }

  /// Bluetooth Kapalı Durumu için özel widget
  Widget _buildBluetoothOff(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(_getPadding(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bluetooth_disabled,
              size: 80,
              color: Colors.blueGrey,
            ),
            const SizedBox(height: 20),
            Text(
              'Bluetooth Kapalı',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Konum tespiti için lütfen cihazınızın Bluetooth özelliğini açın.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  /// Tarama Başlatma Durumu için özel widget
  Widget _buildStartScan(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(_getPadding(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, size: 80, color: primaryOrange),
            const SizedBox(height: 20),
            Text(
              'Navigasyonu Başlat',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: primaryOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Bina içindeki katınızı ve konumunuzu belirlemek için taramayı başlatın.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: onStartScan,
              icon: const Icon(Icons.send_rounded, size: 28),
              label: const Text('Başla'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryOrange,
                foregroundColor: Colors.white,
                minimumSize: const Size(220, 60), // Responsive butona geçiş
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tarama Açık ve Cihaz Bekleme Durumu için özel widget
  Widget _buildWaitingForDevices(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(_getPadding(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: primaryOrange),
            const SizedBox(height: 20),
            const Text(
              'Sinyaller bekleniyor...',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 5),
            const Text(
              'Beacon sinyalleri algılandığında navigasyon başlayacaktır.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  /// Tarama Açık ve Cihazlar Bulundu Durumu için özel widget
  Widget _buildDeviceList() {
    return Column(
      children: [
        // Başlık ve Durdurma Butonunu içeren üst alan
        Container(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          color: accentOrange.withOpacity(0.1),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Aktif Sinyaller (${devices.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryOrange,
                    ),
                  ),
                  const StopScanButton(
                    padding: EdgeInsets
                        .zero, // Padding'i sadece bu container'a alıyoruz
                    fullWidth: false, // Daha kompakt bir buton
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        // Cihaz Listesi
        Expanded(
          child: ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              // Cihaz kutucuklarına hafif bir görsel vurgu ekleyelim
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
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
    return Scaffold(backgroundColor: Colors.white, body: _buildBody(context));
  }

  // Bluetooth durumuna göre ana içeriği döndüren metot (Orjinal metot)
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
