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

  // Modern tema renkleri
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color accentOrange = Color(0xFFFFB199);
  static const Color darkOrange = Color(0xFFE55100);
  static const Color lightBackground = Color(0xFFFAFAFA);

  // Responsive düzenleme için dikey boşluk ayarı
  double _getPadding(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (height > 800) return 32.0;
    if (height > 600) return 24.0;
    return 16.0;
  }

  // Responsive font size
  double _getTitleSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 400) return 28.0;
    return 24.0;
  }

  /// Bluetooth Kapalı Durumu için modern widget
  Widget _buildBluetoothOff(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [lightBackground, Colors.blue.shade50],
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(_getPadding(context)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withAlpha(51),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.bluetooth_disabled_rounded,
                  size: 80,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Bluetooth Kapalı',
                style: TextStyle(
                  fontSize: _getTitleSize(context),
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey.shade700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(26),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Text(
                  'İç mekan navigasyonu için Bluetooth özelliğinin açık olması gerekiyor.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade600],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withAlpha(77),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: onStartScan,
                  icon: const Icon(Icons.bluetooth_searching_rounded, size: 24),
                  label: const Text(
                    'Bluetooth\'u Aç',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Modern tarama başlatma widget'ı
  Widget _buildStartScan(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [lightBackground, accentOrange.withAlpha(26)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(_getPadding(context)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryOrange.withAlpha(51),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.navigation_rounded,
                  size: 80,
                  color: primaryOrange,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'NavIn',
                style: TextStyle(
                  fontSize: _getTitleSize(context) + 8,
                  fontWeight: FontWeight.bold,
                  color: darkOrange,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'İç Mekan Navigasyonu',
                style: TextStyle(
                  fontSize: _getTitleSize(context) - 4,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(26),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: const Text(
                  'Bluetooth sinyallerini tarayarak bulunduğunuz katı otomatik olarak tespit eder ve size yol gösterir.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [primaryOrange, darkOrange]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: primaryOrange.withAlpha(102),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: onStartScan,
                  icon: const Icon(Icons.radar_rounded, size: 28),
                  label: const Text(
                    'Taramayı Başlat',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Modern bekleme widget'ı
  Widget _buildWaitingForDevices(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [lightBackground, primaryOrange.withAlpha(13)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(_getPadding(context)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryOrange.withAlpha(51),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    color: primaryOrange,
                    strokeWidth: 4,
                    backgroundColor: primaryOrange.withAlpha(51),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Sinyaller Algılanıyor',
                style: TextStyle(
                  fontSize: _getTitleSize(context),
                  color: primaryOrange,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(26),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Çevrenizdeki Bluetooth sinyalleri taranıyor...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lütfen birkaç saniye bekleyin',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const StopScanButton(
                fullWidth: true,
                padding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ],
          ),
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
            color: accentOrange.withAlpha(26),
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
                    color: primaryOrange.withAlpha(51),
                    width: 1,
                  ), // Hafif bir çerçeve
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(38),
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
      backgroundColor: lightBackground,
      body: _buildBody(context),
    );
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
