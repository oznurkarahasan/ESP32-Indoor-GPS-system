import 'package:flutter/material.dart';
import 'pages/ble_scanner_page.dart';
import 'pages/zemin_page.dart';
import 'pages/kat1_page.dart';
import 'pages/kat2_page.dart';
import 'services/ar_capability_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // AR desteğini kontrol et
  await ArCapabilityService().checkArSupport();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NavIn - İç Mekan Navigasyonu',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B35),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const BleScannerPage(),
        '/zemin': (context) => const ZeminPage(),
        '/kat1': (context) => const Kat1Page(),
        '/kat2': (context) => const Kat2Page(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
