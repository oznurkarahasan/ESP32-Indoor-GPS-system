// Eski import'ları temizliyoruz
import 'package:flutter/material.dart';
import 'dart:async';
import '../services/ble_router.dart';
import '../widgets/stop_scan_button.dart';
import '../widgets/custom_appbar.dart';
import '../views/floor_map_view.dart'; // YENİ VIEW

const String ZEMIN_KAT_HARITA_URL =
    "https://drive.google.com/uc?export=view&id=1S5120GMyAPRw3hqgyw_JZQuKNUgM5ofA";

class ZeminPage extends StatefulWidget {
  const ZeminPage({super.key});

  @override
  State<ZeminPage> createState() => _ZeminPageState();
}

class _ZeminPageState extends State<ZeminPage> {
  // ... (Tüm mantık ve değişkenler aynı kalır)
  static const Color primaryOrange = Color(0xFFFF9800);
  StreamSubscription<TopSignal?>? _sub;
  DateTime _lastNav = DateTime.fromMillisecondsSinceEpoch(0);
  final TextEditingController _searchController = TextEditingController();

  // [initState, _navigateFor, _openLocationSearch ve dispose metotları ZeminPage'den aynen korunur]

  // Örn: _openLocationSearch metodu
  void _openLocationSearch() {
    showModalBottomSheet(
      // ... (Modal içeriği aynı kalır)
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 1.0,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Gidilecek Yerler',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryOrange,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: const [
                      ListTile(title: Text('Danışma Masası (Zemin)')),
                      ListTile(title: Text('Kafeterya (Zemin)')),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // [Diğer metotlar buraya yapıştırılmalıdır]
  @override
  void initState() {
    super.initState();
    _sub = BleRouter().topStream.listen((top) {
      if (!mounted) return;
      if (top == null) return;
      if (top.name == 'Zemin') return;

      final now = DateTime.now();
      if (now.difference(_lastNav) < const Duration(milliseconds: 1200)) return;
      _lastNav = now;
      _navigateFor(top.name);
    });
  }

  void _navigateFor(String name) {
    String? route;
    if (name == 'Kat 1') route = '/kat1';
    if (name == 'Kat 2') route = '/kat2';

    if (route != null) {
      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 480;

    return Scaffold(
      appBar: const CustomAppBar(title: "Zemin Kat Haritası"),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FloorMapView(
                // YENİ WIDGET'I KULLANIYORUZ
                isWide: isWide,
                onSearchTap: _openLocationSearch,
                floorName: 'Zemin Kat', // Kat adını iletiyoruz
                mapImageUrl: ZEMIN_KAT_HARITA_URL, // Buradan erişiliyor
              ),
            ),
            const StopScanButton(),
          ],
        ),
      ),
    );
  }
}
