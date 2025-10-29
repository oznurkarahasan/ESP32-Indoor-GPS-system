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

    final btn = Container(
      width: fullWidth ? double.infinity : 200,
      height: isWide ? 56 : 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade400, Colors.red.shade600],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withAlpha(77),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => _stopAndHome(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(Icons.stop_circle_rounded, size: 20),
        label: Text(
          'Taramayı Durdur',
          style: TextStyle(
            fontSize: isWide ? 16 : 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    return Padding(padding: padding, child: btn);
  }
}
