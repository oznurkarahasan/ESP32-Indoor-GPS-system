import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DeviceTile extends StatelessWidget {
  final ScanResult result;
  const DeviceTile({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final name = result.device.platformName.isNotEmpty
        ? result.device.platformName
        : 'Bilinmeyen cihaz';

    return ListTile(
      leading: CircleAvatar(child: Text('${result.rssi}')),
      title: Text(name),
      subtitle: Text(result.device.remoteId.str),
    );
  }
}
