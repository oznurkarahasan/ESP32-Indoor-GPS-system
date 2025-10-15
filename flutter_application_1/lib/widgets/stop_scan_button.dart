import 'package:flutter/material.dart';
import '../services/ble_router.dart';

class StopScanButton extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final bool fullWidth;

  // Turuncu temayla uyumlu, ancak durdurma eylemi için güvenlik rengi (Kırmızı)
  static const Color warningRed = Colors.red;

  const StopScanButton({
    super.key,
    this.padding = const EdgeInsets.all(16),
    this.fullWidth = true,
  });

  Future<void> _stopAndHome(BuildContext context) async {
    // BLE taramasını durdur
    try {
      await BleRouter().stop();
    } catch (_) {}

    if (!context.mounted) return;

    // Tüm yığınları kaldırarak başlangıç sayfasına (ScannerPage) dön
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 480;

    // Butonun responsive ve temalı görünümü
    final btn = ElevatedButton.icon(
      onPressed: () => _stopAndHome(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: warningRed, // Uyarı/Durdurma eylemi için kırmızı
        foregroundColor: Colors.white,

        // Gövde ve yuvarlatılmış köşeler eklendi (Temaya uyum)
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),

        // Boyutlandırma ve Responsive Kontrol
        minimumSize: Size(
          fullWidth
              ? double.infinity
              : 180, // fullWidth true ise tüm genişliği kapla
          isWide ? 56 : 48, // Geniş ekranlarda daha büyük
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? 24 : 16,
          vertical: isWide ? 16 : 12,
        ),
        textStyle: TextStyle(
          fontSize: isWide ? 18 : 16,
          fontWeight: FontWeight.bold, // Kalın font ile vurgu
        ),

        // Hafif gölge ekleyerek daha modern bir görünüm (İsteğe bağlı)
        elevation: 4,
      ),
      icon: const Icon(Icons.stop),
      label: const Text('Taramayı Durdur'),
    );

    return Padding(padding: padding, child: btn);
  }
}
