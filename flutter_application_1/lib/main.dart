import 'package:flutter/material.dart';
import 'pages/ble_scanner_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NavBle',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BleScannerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
