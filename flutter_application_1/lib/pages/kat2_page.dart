// Eski import'ları temizliyoruz
import 'package:flutter/material.dart';
import 'dart:async';
import '../services/ble_router.dart';
import '../widgets/stop_scan_button.dart';
import '../widgets/custom_appbar.dart';
import '../views/floor_map_view.dart';
import '../models/poi_data.dart'; // YENİ: POI modelini dahil ettik
import 'navigation_page.dart'; // YENİ: NavigationPage'i dahil ettik

const String kat2HaritaUrl =
    "https://drive.google.com/uc?export=view&id=19aQuVu_uz7_NT_w_UYpplAjR4AkwRF1J";

class Kat2Page extends StatefulWidget {
  const Kat2Page({super.key});

  @override
  State<Kat2Page> createState() => _Kat2PageState();
}

class _Kat2PageState extends State<Kat2Page> {
  // ... (Tüm mantık ve değişkenler aynı kalır)
  static const Color primaryOrange = Color(0xFFFF9800);
  StreamSubscription<TopSignal?>? _sub;
  DateTime _lastNav = DateTime.fromMillisecondsSinceEpoch(0);
  final TextEditingController _searchController = TextEditingController();

  // YENİ: Navigasyonu başlatan metot
  void _startNavigation(String destinationPOI) {
    try {
      // 1. Hedef POI'yi bul (TÜM POI'ler arasında arıyoruz)
      final targetPOI = BuildingData.allPOIs.firstWhere(
        (poi) => poi.name == destinationPOI,
      );

      // 2. Navigasyon sayfasına yönlendir
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => NavigationPage(
            // Başlangıç noktasını bu katın ana sinyal bölgesini varsayıyoruz.
            startPOI: 'Kat 2 ZON',
            endPOI: targetPOI,
          ),
        ),
      );
    } catch (e) {
      // POI bulunamazsa kullanıcıya bilgi ver
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Hata: Hedef ($destinationPOI) veri setinde bulunamadı.',
          ),
        ),
      );
    }
  }

  // Arama alanına tıklandığında yapılacak işlem (gidilecek yerler listesini açma)
  void _openLocationSearch() {
    // 👇 TÜM BİNADAKİ POI'leri alıyoruz.
    final allBuildingPOIs = BuildingData.allPOIs;

    showModalBottomSheet(
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
                    'Tüm Bina Hedefleri', // BAŞLIK GÜNCELLENDİ
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryOrange,
                    ),
                  ),
                ),
                // Dinamik olarak POI'leri listele
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: allBuildingPOIs.length, // TÜM LİSTE KULLANILDI
                    itemBuilder: (context, index) {
                      final poi = allBuildingPOIs[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.pin_drop,
                          color: primaryOrange,
                        ),
                        title: Text(poi.name),
                        // Hangi katta olduğunu belirtmek önemlidir
                        subtitle: Text('Kat: ${poi.floor}'),
                        onTap: () {
                          Navigator.pop(context); // Modalı kapat
                          _startNavigation(poi.name); // Navigasyonu başlat
                        },
                      );
                    },
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
      if (top.name == 'Kat 2') return;

      final now = DateTime.now();
      if (now.difference(_lastNav) < const Duration(milliseconds: 1200)) return;
      _lastNav = now;
      _navigateFor(top.name);
    });
  }

  void _navigateFor(String name) {
    String? route;
    if (name == 'Zemin') route = '/zemin';
    if (name == 'Kat 1') route = '/kat1';

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
      appBar: const CustomAppBar(title: "2. Kat Haritası"),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FloorMapView(
                // YENİ WIDGET'I KULLANIYORUZ
                isWide: isWide,
                onSearchTap: _openLocationSearch,
                floorName: '2. Kat', // Kat adını iletiyoruz
                mapImageUrl: kat2HaritaUrl, // Buradan erişiliyor
              ),
            ),
            const StopScanButton(),
          ],
        ),
      ),
    );
  }
}
