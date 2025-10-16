// Eski import'ları temizliyoruz
import 'package:flutter/material.dart';
import 'dart:async';
import '../services/ble_router.dart';
import '../widgets/stop_scan_button.dart';
import '../widgets/custom_appbar.dart';
import '../views/floor_map_view.dart';
import '../models/poi_data.dart'; // POI modelini dahil ettik
import 'navigation_page.dart'; // NavigationPage'i dahil ettik
// YENİ PAKETLER
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

const String kat2HaritaUrl =
    "https://drive.google.com/uc?export=view&id=19aQuVu_uz7_NT_w_UYpplAjR4AkwRF1J";

class Kat2Page extends StatefulWidget {
  const Kat2Page({super.key});

  @override
  State<Kat2Page> createState() => _Kat2PageState();
}

class _Kat2PageState extends State<Kat2Page> {
  static const Color primaryOrange = Color(0xFFFF9800);
  StreamSubscription<TopSignal?>? _sub;
  DateTime _lastNav = DateTime.fromMillisecondsSinceEpoch(0);
  final TextEditingController _searchController = TextEditingController();

  // YENİ: Ses Tanıma Değişkenleri
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initializeSpeechRecognition(); // Ses iznini başta iste

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

  // YENİ METOT: Mikrofon İznini İste ve Başlat
  Future<void> _initializeSpeechRecognition() async {
    var status = await Permission.microphone.request();

    if (status.isGranted) {
      bool available = await _speechToText.initialize(
        onError: (e) => print('STT Error: ${e.errorMsg}'),
      );
      if (mounted) {
        setState(() {
          _speechEnabled = available;
          if (!available) {
            _showSnack('Sesli komut servisi kullanılamıyor.');
          }
        });
      }
    } else {
      _showSnack('Sesli komut için mikrofon izni gereklidir.');
    }
  }

  // YENİ METOT: Ses Kaydını Başlat/Durdur
  void _startListening() {
    if (!_speechEnabled) {
      _showSnack('Sesli komut servisi başlatılamadı. İzinleri kontrol edin.');
      return;
    }

    if (_speechToText.isListening) {
      _stopListening();
      return;
    }

    _lastWords = '';
    setState(() => _isListening = true);

    _speechToText.listen(
      onResult: (result) {
        if (mounted) {
          setState(() {
            _lastWords = result.recognizedWords;
          });
          if (result.finalResult) {
            _handleVoiceCommand(_lastWords);
            _isListening = false;
          }
        }
      },
      localeId: 'tr_TR',
    );

    _showSnack(
      _isListening
          ? 'Dinleme başladı... Lütfen konuşun.'
          : 'Dinleme başlatılamadı.',
    );
  }

  // YENİ METOT: Ses Kaydını Durdur
  void _stopListening() {
    _speechToText.stop();
    if (mounted) {
      setState(() => _isListening = false);
    }
  }

  // YENİ METOT: Algılanan metni hedeflerle karşılaştır
  void _handleVoiceCommand(String command) {
    if (command.isEmpty) return;

    final target = BuildingData.allPOIs.firstWhere(
      (poi) => command.toLowerCase().contains(poi.name.toLowerCase()),
      orElse: () => POI(name: 'NOT_FOUND', key: '', floor: '', imageUrl: ''),
    );

    if (target.name != 'NOT_FOUND') {
      _showSnack('Komut algılandı: ${target.name}. Navigasyon başlatılıyor...');
      _startNavigation(target.name);
    } else {
      _showSnack(
        'Dinlendi: "$command". Bina hedefleriyle eşleşen yer bulunamadı.',
      );
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // Navigasyonu başlatan metot
  void _startNavigation(String destinationPOI) {
    try {
      final targetPOI = BuildingData.allPOIs.firstWhere(
        (poi) => poi.name == destinationPOI,
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => NavigationPage(
            // BAŞLANGIÇ NOKTASI: Kat 2 ZON
            startPOI: 'Kat 2 ZON',
            endPOI: targetPOI,
          ),
        ),
      );
    } catch (e) {
      _showSnack('Hata: Hedef ($destinationPOI) veri setinde bulunamadı.');
    }
  }

  // Arama alanına tıklandığında yapılacak işlem (gidilecek yerler listesini açma)
  void _openLocationSearch() {
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
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: allBuildingPOIs.length,
                    itemBuilder: (context, index) {
                      final poi = allBuildingPOIs[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.pin_drop,
                          color: primaryOrange,
                        ),
                        title: Text(poi.name),
                        subtitle: Text('Kat: ${poi.floor}'),
                        onTap: () {
                          Navigator.pop(context);
                          _startNavigation(poi.name);
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
    _speechToText.stop(); // Uygulama kapanınca durdur
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
                isWide: isWide,
                onSearchTap: _openLocationSearch,
                // YENİ: Mikrofon işlevini FloorMapView'e iletiyoruz
                onMicTap: _startListening,
                isMicListening: _isListening, // Dinleme durumunu iletiyoruz
                floorName: '2. Kat',
                mapImageUrl: kat2HaritaUrl,
              ),
            ),
            // Dinleme durumu göstergesi
            if (_isListening)
              Container(
                color: primaryOrange.withOpacity(0.8),
                padding: const EdgeInsets.symmetric(vertical: 8),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.mic_none, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      _lastWords.isEmpty ? 'Dinleniyor...' : _lastWords,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            const StopScanButton(),
          ],
        ),
      ),
    );
  }
}
