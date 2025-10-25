import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceTile extends StatelessWidget {
  final ScanResult result;
  const DeviceTile({super.key, required this.result});

  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color accentOrange = Color(0xFFFFB199);

  Color _getSignalColor(int rssi) {
    if (rssi >= -50) return Colors.green;
    if (rssi >= -70) return Colors.orange;
    return Colors.red;
  }

  String _getSignalStrength(int rssi) {
    if (rssi >= -50) return 'Güçlü';
    if (rssi >= -70) return 'Orta';
    return 'Zayıf';
  }

  IconData _getSignalIcon(int rssi) {
    if (rssi >= -50) return Icons.wifi;
    if (rssi >= -70) return Icons.wifi_2_bar;
    return Icons.wifi_1_bar;
  }

  @override
  Widget build(BuildContext context) {
    final name = result.device.platformName.isNotEmpty
        ? result.device.platformName
        : 'Bilinmeyen Cihaz';

    final signalColor = _getSignalColor(result.rssi);
    final signalStrength = _getSignalStrength(result.rssi);
    final signalIcon = _getSignalIcon(result.rssi);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryOrange.withOpacity(0.8), primaryOrange],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: primaryOrange.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_rounded,
                color: Colors.white,
                size: 20,
              ),
              Text(
                name.substring(0, name.length > 3 ? 3 : name.length),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  signalIcon,
                  color: signalColor,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '$signalStrength (${result.rssi} dBm)',
                  style: TextStyle(
                    color: signalColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              result.device.remoteId.str,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 11,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: signalColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: signalColor.withOpacity(0.3)),
          ),
          child: Text(
            '${result.rssi}',
            style: TextStyle(
              color: signalColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
