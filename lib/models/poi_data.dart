// lib/models/poi_data.dart

class NavVideo {
  final String startPOI;
  final String endPOI;
  final String url;
  final String name;

  const NavVideo({
    required this.startPOI,
    required this.endPOI,
    required this.url,
    required this.name,
  });

  NavVideo get reversed => NavVideo(
        startPOI: endPOI,
        endPOI: startPOI,
        url: url,
        name: "${name}_reverse",
      );
}

class POI {
  final String name;
  final String key;
  final String floor;
  final String imageUrl;
  final List<String> aliases;

  const POI({
    required this.name,
    required this.key,
    required this.floor,
    required this.imageUrl,
    this.aliases = const [],
  });
}

class BuildingData {
  
  // Haritalar (Gerçek dosya adlarına göre güncellendi)
  static const String zeminKatHaritaUrl = 'assets/zeminkat.png';
  static const String kat1HaritaUrl = 'assets/kat1.jpg'; 
  static const String kat2HaritaUrl = 'assets/kat2.png'; 

  static final List<POI> allPOIs = [
    // --- 0. ZEMİN KAT POI'LERİ ---
    const POI(
      name: 'Danışma Masası',
      key: 'zeminDanisma',
      floor: 'Zemin',
      imageUrl: 'assets/DanismaMasasi/DanismaMasasi.jpg', 
      aliases: ['danışma', 'giriş danışma', 'bilgi masası', 'resepsiyon'],
    ),
    const POI(
      name: 'Bekleme Salonu',
      key: 'zeminBekleme',
      floor: 'Zemin',
      imageUrl: 'assets/BeklemeSalonu/BeklemeSalonu.jpg', 
      aliases: ['bekleme odası', 'salon', 'oturma alanı', 'lobi'],
    ),
    const POI(
      name: 'Sesli Kütüphane',
      key: 'zeminSesliKutup',
      floor: 'Zemin',
      // DÜZELTME: Kütüphane -> Kutuphane
      imageUrl: 'assets/SesliKutuphane/SesliKutuphane.jpg', 
      aliases: ['kütüphane', 'sesli kitaplar', 'okuma alanı', 'kitap odası'],
    ),
    const POI(
      name: 'Mutfak',
      key: 'zeminMutfak',
      floor: 'Zemin',
      imageUrl: 'assets/Mutfak/Mutfak.jpg', 
      aliases: ['yemekhane', 'kafeterya', 'yemek alanı', 'çay ocağı'],
    ),
    const POI(
      name: 'WC (Zemin)',
      key: 'zeminWC',
      floor: 'Zemin',
      // DÜZELTME: WC(Zemin).jpg -> WCZemin.jpg
      imageUrl: 'assets/WCZemin/WCZemin.jpg', 
      aliases: ['tuvalet', 'lavabo', 'zemin tuvalet', 'zemin wc'],
    ),
    const POI(
      name: 'Giriş/Çıkış',
      key: 'zemingiris',
      floor: 'Zemin',
      // DÜZELTME: Giris-Çıigis.jpg -> GirisCikis.jpg
      imageUrl: 'assets/GirisCikis/GirisCikis.jpg', 
      aliases: ['ana giriş', 'kapı', 'çıkış', 'giriş kapısı', 'dış kapı'],
    ),
    const POI(
      name: 'Asansör (Zemin)',
      key: 'zeminAsansor',
      floor: 'Zemin',
      // DÜZELTME: Asansor(Zemin).png -> AsansorZemin.png
      imageUrl: 'assets/AsansorZemin/AsansorZemin.png', 
      aliases: ['asansör', 'zemin asansör', 'lift'],
    ),
    const POI(
      name: 'Merdiven (Zemin)',
      key: 'zeminmerdivenfoto',
      floor: 'Zemin',
      // DÜZELTME: Merdiven(Zemin).jpg -> MerdivenZemin.jpg
      imageUrl: 'assets/MerdivenZemin/MerdivenZemin.jpg', 
      aliases: ['merdivenler', 'zemin merdiven', 'basamaklar'],
    ),

    // --- 1. KAT ---
    const POI(
      name: 'WC (Kat 1)',
      key: 'kat1WC',
      floor: 'Kat 1',
      // DÜZELTME: WC(Kat 1).jpg -> WCKat1.jpg
      imageUrl: 'assets/WCKat1/WCKat1.jpg', 
      aliases: ['tuvalet', 'lavabo', 'birinci kat tuvalet', 'kat 1 wc'],
    ),
    const POI(
      name: 'Revir',
      key: 'kat1Revir',
      floor: 'Kat 1',
      imageUrl: 'assets/Revir/Revir.jpg', 
      aliases: ['sağlık odası', 'doktor', 'ilk yardım', 'hemşire odası'],
    ),
    const POI(
      name: 'Resim Atölyesi',
      key: 'kat1Resim',
      floor: 'Kat 1',
      // DÜZELTME: ResimAtölyesi.jpg -> ResimAtolyesi.jpg
      imageUrl: 'assets/ResimAtolyesi/ResimAtolyesi.jpg', 
      aliases: ['resim odası', 'atölye', 'boya odası', 'sanat atölyesi'],
    ),
    const POI(
      name: 'Müzik Odası',
      key: 'kat1Muzik',
      floor: 'Kat 1',
      imageUrl: 'assets/MuzikOdasi/MuzikOdasi.jpg', 
      aliases: ['müzik sınıfı', 'enstrüman odası', 'piyano odası'],
    ),
    const POI(
      name: 'İdari Ofis (Kat 1)',
      key: 'kat1idari',
      floor: 'Kat 1',
      imageUrl: 'assets/IdariOfisKat1/IdariOfisKat1.jpg', 
      aliases: ['ofis', 'idari ofis', 'yönetim odası', 'sekreterlik'],
    ),
    const POI(
      name: 'Bilgisayar Lab. (Kat 1)',
      key: 'kat1bilgisayar',
      floor: 'Kat 1',
      // DÜZELTME: BilgisayarLabKat(1).jpg -> BilgisayarLabKat1.jpg
      imageUrl: 'assets/BilgisayarLabKat1/BilgisayarLabKat1.jpg', 
      aliases: ['bilgisayar laboratuvarı', 'bilgisayar odası', 'lab'],
    ),
    const POI(
      name: 'Asansör (Kat 1)',
      key: 'kat1asansor',
      floor: 'Kat 1',
      // DÜZELTME: Asansor(Kat 1).jpg -> AsansorKat1.jpg
      imageUrl: 'assets/AsansorKat1/AsansorKat1.jpg', 
      aliases: ['asansör', 'birinci kat asansör', 'kat 1 asansör', 'lift'],
    ),
    const POI(
      name: 'Aktivite Odası',
      key: 'kat1aktivite',
      floor: 'Kat 1',
      imageUrl: 'assets/AktiviteOdasi/AktiviteOdasi.jpg', 
      aliases: ['spor odası', 'spor salonu', 'etkinlik odası', 'aktivite salonu'],
    ),
    const POI(
      name: 'Merdiven (Kat 1)',
      key: 'kat1merdiven',
      floor: 'Kat 1',
      // DÜZELTME: Merdiven(Kat 1).jpg -> MerdivenKat1.jpg
      imageUrl: 'assets/MerdivenKat1/MerdivenKat1.jpg', 
      aliases: ['merdiven', 'kat 1 merdiven', 'basamaklar'],
    ),
    /* // GEÇİCİ OLARAK KAPATILDI - 'assets/OgretmenOdasi' klasörü boş
    const POI(
      name: 'Öğretmen Odası',
      key: 'kat1ogretmen',
      floor: 'Kat 1',
      imageUrl: 'assets/OgretmenOdasi/OgretmenOdasi.jpg', 
      aliases: ['öğretmenler odası', 'hoca odası', 'eğitmen odası', 'personel odası'],
    ),
    */

    // --- 2. KAT ---
    const POI(
      name: 'LYEC Giriş (Kat 2)',
      key: 'lyeclabsgiris',
      floor: 'Kat 2',
      // DÜZELTME: LYECGiris(Kat 2).jpg -> LYECGirisKat2.jpg
      imageUrl: 'assets/LYECGirisKat2/LYECGirisKat2.jpg', 
      aliases: ['lyec', 'laboratuvar', 'kat 2 giriş', 'gaca', 'thegaca', 'ogaca'],
    ),
    const POI(
      name: 'Profesör Ofisi',
      key: 'tolunaydemirci',
      floor: 'Kat 2',
      imageUrl: 'assets/toluhoca/toluhoca.png', // Dosya listenizde var
      aliases: ['tolunay hoca', 'profesör odası', 'tolunay demirci'],
    ),
    const POI(
      name: 'Asansör (Kat 2)',
      key: 'kat2asansor',
      floor: 'Kat 2',
      // DÜZELTME: Asansor(Kat 2).jpg -> AsansorKat2.jpg
      imageUrl: 'assets/AsansorKat2/AsansorKat2.jpg', 
      aliases: ['asansör', 'ikinci kat asansör', 'kat 2 asansör', 'lift'],
    ),
    const POI(
      name: 'Mutfak (kat2)',
      key: 'kat2Mutfak',
      floor: 'Kat 2',
      // DÜZELTME: Mutfak(kat2).jpeg -> MutfakKat2.jpeg
      imageUrl: 'assets/MutfakKat2/MutfakKat2.jpeg', 
      aliases: ['Mutfak', 'ikinci kat Mutfak', 'kat 2 Mutfak', 'yemek'],
    ),
    const POI(
      name: 'Teras 2',
      key: 'kat2Teras',
      floor: 'Kat 2',
      // DÜZELTME: Teras2.jpeg -> Teras2.jpg
      imageUrl: 'assets/Teras2/Teras2.jpg', 
      aliases: ['Teras 2', 'ikinci kat Teras 2', 'kat 2 Teras 2'],
    ),
    const POI(
      name: 'Teras 1',
      key: 'kat1Teras',
      floor: 'Kat 2',
      // DÜZELTME: Teras1.jpeg -> Teras1.jpg
      imageUrl: 'assets/Teras1/Teras1.jpg', 
      aliases: ['Teras 1', 'ikinci kat Teras 1', 'kat 2 Teras 1'],
    ),
  ];

  static final List<NavVideo> allRoutes = [
    // --- ZEMİN KAT ROTLARI (Tümü Yerel Varlık) ---
    const NavVideo( startPOI: 'Zemin ZON', endPOI: 'Danışma Masası', url: 'assets/DanismaMasasi/DanismaMasasi.mp4', name: 'zeminkatZonDanisma', ),
    const NavVideo( startPOI: 'Zemin ZON', endPOI: 'Bekleme Salonu', url: 'assets/BeklemeSalonu/BeklemeSalonu.mp4', name: 'zeminkatZonBekleme', ),
    const NavVideo( startPOI: 'Zemin ZON', endPOI: 'Sesli Kütüphane', url: 'assets/SesliKutuphane/SesliKutuphane.mp4', name: 'zeminkatZonSesli', ),
    const NavVideo( startPOI: 'Zemin ZON', endPOI: 'Mutfak', url: 'assets/Mutfak/Mutfak.mp4', name: 'zeminkatZonMutfak', ),
    const NavVideo( startPOI: 'Zemin ZON', endPOI: 'WC (Zemin)', url: 'assets/WCZemin/WCZemin.mp4', name: 'zeminkatZonWC', ), 
    const NavVideo( startPOI: 'Zemin ZON', endPOI: 'Asansör (Zemin)', url: 'assets/AsansorZemin/AsansorZemin.mp4', name: 'zeminkatZonAsansor', ), 
    const NavVideo( startPOI: 'Zemin ZON', endPOI: 'Giriş/Çıkış', url: 'assets/GirisCikis/GirisCikis.mp4', name: 'zeminGiriscikis', ), 
    const NavVideo( startPOI: 'Zemin ZON', endPOI: 'Merdiven (Zemin)', url: 'assets/MerdivenZemin/MerdivenZemin.mp4', name: 'zeminMerdiven', ), 
    const NavVideo( startPOI: 'Zemin ZON', endPOI: 'Resim Atölyesi', url: 'assets/ResimAtolyesi/ResimAtolyesi.mp4', name: 'zeminResimvideo', ), 
    const NavVideo( startPOI: 'Zemin ZON', endPOI: 'İdari Ofis (Kat 1)', url: 'assets/IdariOfisKat1/IdariOfisKat1.mp4', name: 'zeminIdariVideo', ),
    const NavVideo( startPOI: 'Zemin ZON', endPOI: 'Müzik Odası', url: 'assets/MuzikOdasi/MuzikOdasi.mp4', name: 'zeminMuzikVideo', ), 
    const NavVideo( startPOI: 'Zemin ZON', endPOI: 'Revir', url: 'assets/Revir/Revir.mp4', name: 'zeminRevirVideo', ),
    const NavVideo( startPOI: 'Zemin ZON', endPOI: 'Aktivite Odası', url: 'assets/AktiviteOdasi/AktiviteOdasi.mp4', name: 'zeminSporVideo', ),
    const NavVideo( startPOI: 'Zemin ZON', endPOI: 'Bilgisayar Lab. (Kat 1)', url: 'assets/BilgisayarLabKat1/BilgisayarLabKat1.mp4', name: 'zeminBilgisayarVideo', ), 
    const NavVideo( startPOI: 'Zemin ZON', endPOI: 'Profesör Ofisi', url: 'assets/toluhoca/toluhoca.mp4', name: 'zeminHocaVideo', ), 

    // --- KAT 1 ROTLARI ---
    const NavVideo( startPOI: 'Kat 1 ZON', endPOI: 'Bilgisayar Lab. (Kat 1)', url: 'assets/BilgisayarLabKat1/BilgisayarLabKat1.mp4', name: 'kat1Bilgisayar', ), 
    const NavVideo( startPOI: 'Kat 1 ZON', endPOI: 'Revir', url: 'assets/Revir/Revir.mp4', name: 'kat1Revir', ),
    const NavVideo( startPOI: 'Kat 1 ZON', endPOI: 'Aktivite Odası', url: 'assets/AktiviteOdasi/AktiviteOdasi.mp4', name: 'kat1Spor', ),
    const NavVideo( startPOI: 'Kat 1 ZON', endPOI: 'WC (Kat 1)', url: 'assets/WCKat1/WCKat1.mp4', name: 'kat1WC', ), 
    const NavVideo( startPOI: 'Kat 1 ZON', endPOI: 'Resim Atölyesi', url: 'assets/ResimAtolyesi/ResimAtolyesi.mp4', name: 'kat1Resim', ), 
    const NavVideo( startPOI: 'Kat 1 ZON', endPOI: 'Müzik Odası', url: 'assets/MuzikOdasi/MuzikOdasi.mp4', name: 'kat1Muzik', ), // Düzeltildi
    const NavVideo( startPOI: 'Kat 1 ZON', endPOI: 'Asansör (Kat 1)', url: 'assets/AsansorKat1/AsansorKat1.mp4', name: 'kat1Asansor', ), // Düzeltildi
    const NavVideo( startPOI: 'Kat 1 ZON', endPOI: 'İdari Ofis (Kat 1)', url: 'assets/IdariOfisKat1/IdariOfisKat1.mp4', name: 'kat1Idari', ),
    const NavVideo( startPOI: 'Kat 1 ZON', endPOI: 'Profesör Ofisi', url: 'assets/toluhoca/toluhoca.mp4', name: 'kat1TolunayVideo', ),
    
    // --- YENİ EKLENEN EKSİK KAT 1 ROTALARI (Diğer Katlara) ---
    const NavVideo( startPOI: 'Kat 1 ZON', endPOI: 'Bekleme Salonu', url: 'assets/BeklemeSalonu/BeklemeSalonu.mp4', name: 'kat1BeklemeVideo', ),
    const NavVideo( startPOI: 'Kat 1 ZON', endPOI: 'Danışma Masası', url: 'assets/DanismaMasasi/DanismaMasasi.mp4', name: 'kat1DanismaVideo', ),
    const NavVideo( startPOI: 'Kat 1 ZON', endPOI: 'Mutfak', url: 'assets/Mutfak/Mutfak.mp4', name: 'kat1MutfakVideo', ),
    const NavVideo( startPOI: 'Kat 1 ZON', endPOI: 'Sesli Kütüphane', url: 'assets/SesliKutuphane/SesliKutuphane.mp4', name: 'kat1SesliVideo', ), 
    const NavVideo( startPOI: 'Kat 1 ZON', endPOI: 'WC (Zemin)', url: 'assets/WCZemin/WCZemin.mp4', name: 'kat1ZeminWCVideo', ), 
    const NavVideo( startPOI: 'Kat 1 ZON', endPOI: 'Giriş/Çıkış', url: 'assets/GirisCikis/GirisCikis.mp4', name: 'kat1GirisCikisVideo', ), 
    const NavVideo( startPOI: 'Kat 1 ZON', endPOI: 'Asansör (Zemin)', url: 'assets/AsansorZemin/AsansorZemin.mp4', name: 'kat1AsansorZeminVideo', ), 
    const NavVideo( startPOI: 'Kat 1 ZON', endPOI: 'Merdiven (Zemin)', url: 'assets/MerdivenZemin/MerdivenZemin.mp4', name: 'kat1MerdivenZeminVideo', ), 
    const NavVideo( startPOI: 'Kat 1 ZON', endPOI: 'Mutfak (kat2)', url: 'assets/MutfakKat2/MutfakKat2.mp4', name: 'kat1MutfakKat2Video', ), 
    const NavVideo( startPOI: 'Kat 1 ZON', endPOI: 'Teras 2', url: 'assets/Teras2/Teras2.mp4', name: 'kat1Teras2Video', ), 
    const NavVideo( startPOI: 'Kat 1 ZON', endPOI: 'Teras 1', url: 'assets/Teras1/Teras1.mp4', name: 'kat1Teras1Video', ), 

    // --- KAT 2 ROTLARI ---
    const NavVideo( startPOI: 'LYEC Giriş (Kat 2)', endPOI: 'Profesör Ofisi', url: 'assets/toluhoca/toluhoca.mp4', name: 'lyecHocaVideo', ),
    const NavVideo( startPOI: 'LYEC Giriş (Kat 2)', endPOI: 'Mutfak (kat2)', url: 'assets/MutfakKat2/MutfakKat2.mp4', name: 'lyecMutfakVideo', ), // Düzeltildi
    const NavVideo( startPOI: 'LYEC Giriş (Kat 2)', endPOI: 'Teras 2', url: 'assets/Teras2/Teras2.mp4', name: 'lyecTeras2Video', ),
    const NavVideo( startPOI: 'LYEC Giriş (Kat 2)', endPOI: 'Teras 1', url: 'assets/Teras1/Teras1.mp4', name: 'lyecTeras1Video', ),
    const NavVideo( startPOI: 'LYEC Giriş (Kat 2)', endPOI: 'İdari Ofis (Kat 1)', url: 'assets/IdariOfisKat1/IdariOfisKat1.mp4', name: 'lyecIdariVideo', ),
    const NavVideo( startPOI: 'LYEC Giriş (Kat 2)', endPOI: 'Danışma Masası', url: 'assets/DanismaMasasi/DanismaMasasi.mp4', name: 'lyecDanismaVideo', ),
    const NavVideo( startPOI: 'LYEC Giriş (Kat 2)', endPOI: 'Bekleme Salonu', url: 'assets/BeklemeSalonu/BeklemeSalonu.mp4', name: 'lyecBeklemeVideo', ),
    const NavVideo( startPOI: 'LYEC Giriş (Kat 2)', endPOI: 'Bilgisayar Lab. (Kat 1)', url: 'assets/BilgisayarLabKat1/BilgisayarLabKat1.mp4', name: 'lyecBilgisayarVideo', ), 
    const NavVideo( startPOI: 'LYEC Giriş (Kat 2)', endPOI: 'Asansör (Kat 2)', url: 'assets/AsansorKat2/AsansorKat2.mp4', name: 'lyecAsansorVideo', ), 
    const NavVideo( startPOI: 'LYEC Giriş (Kat 2)', endPOI: 'Aktivite Odası', url: 'assets/AktiviteOdasi/AktiviteOdasi.mp4', name: 'lyecSporVideo', ),
    const NavVideo( startPOI: 'LYEC Giriş (Kat 2)', endPOI: 'Sesli Kütüphane', url: 'assets/SesliKutuphane/SesliKutuphane.mp4', name: 'lyecSesliVideo', ), 
    const NavVideo( startPOI: 'LYEC Giriş (Kat 2)', endPOI: 'Revir', url: 'assets/Revir/Revir.mp4', name: 'lyecRevirVideo', ),
    const NavVideo( startPOI: 'LYEC Giriş (Kat 2)', endPOI: 'Mutfak', url: 'assets/Mutfak/Mutfak.mp4', name: 'lyecMutfakVideoZemin', ), // İsim çakışmasını önlemek için 'Zemin' eklendi
    const NavVideo( startPOI: 'LYEC Giriş (Kat 2)', endPOI: 'Resim Atölyesi', url: 'assets/ResimAtolyesi/ResimAtolyesi.mp4', name: 'lyecResimVideo', ), 
    const NavVideo( startPOI: 'LYEC Giriş (Kat 2)', endPOI: 'Müzik Odası', url: 'assets/MuzikOdasi/MuzikOdasi.mp4', name: 'lyecMuzikVideo', ),
    const NavVideo( startPOI: 'LYEC Giriş (Kat 2)', endPOI: 'WC (Kat 1)', url: 'assets/WCKat1/WCKat1.mp4', name: 'lyecKat1WCVideo', ),

    // --- KATLAR ARASI ROTLAR ---
    const NavVideo( startPOI: 'Zemin ZON', endPOI: 'Kat 1', url: 'assets/MerdivenKat1/MerdivenKat1.mp4', name: 'zeminkatZonKat1', ), 
    const NavVideo( startPOI: 'Kat 1 ZON', endPOI: 'Zemin', url: 'assets/MerdivenZemin/MerdivenZemin.mp4', name: 'kat1ZeminVideo', ), // Hedef adı ZON'dan temizlendi
    const NavVideo( startPOI: 'Zemin ZON', endPOI: 'LYEC Giriş (Kat 2)', url: 'assets/LYECGirisKat2/LYECGirisKat2.mp4', name: 'zeminZonlyecvideo', ), 
    const NavVideo( startPOI: 'LYEC Giriş (Kat 2)', endPOI: 'Zemin', url: 'assets/AsansorZemin/AsansorZemin.mp4', name: 'lyeczeminZonvideo', ), // Hedef adı ZON'dan temizlendi
    const NavVideo( startPOI: 'Kat 1 ZON', endPOI: 'LYEC Giriş (Kat 2)', url: 'assets/LYECGirisKat2/LYECGirisKat2.mp4', name: 'lyecKat1Video', ), 
    const NavVideo( startPOI: 'LYEC Giriş (Kat 2)', endPOI: 'Kat 1', url: 'assets/AsansorKat1/AsansorKat1.mp4', name: 'kat1LyecVideo', ), // Mantık hatası düzeltildi
  ];

  // Yardımcı fonksiyonlar (Arama ve filtreleme için)
  static List<POI> getPOIsByFloor(String floor) {
    return allPOIs.where((poi) => poi.floor == floor).toList();
  }
}
/*
ResimAtolyesi      video 
MuzikOdasi     video
IdariOfisKat1     video
merdivenKat1     video
WCZemin     video
GirisCikis     video
AsansorZemin     video
MerdivenZemin     video
LYECGirisKat2     video
profesörOfisi     fotoraf
asansorKat2     video
MutfakKat2     video
Teras2     video
Teras1     video
*/

/*
assets/AktiviteOdasi
assets/AktiviteOdasi/AktiviteOdasi.jpg
assets/AktiviteOdasi/AktiviteOdasi.mp4
assets/AsansorKat1
assets/AsansorKat1/AsansorKat1.jpg
assets/AsansorKat1/AsansorKat1.mp4
assets/AsansorKat2
assets/AsansorKat2/AsansorKat2.jpg
assets/AsansorKat2/AsansorKat2.mp4
assets/AsansorZemin
assets/AsansorZemin/AsansorZemin.png  
assets/AsansorZemin/AsansorZemin.mp4
assets/BeklemeSalonu
assets/BeklemeSalonu/BeklemeSalonu.jpg
assets/BeklemeSalonu/BeklemeSalonu.mp4
assets/BilgisayarLabKat1
assets/BilgisayarLabKat1/BilgisayarLabKat1.jpg
assets/BilgisayarLabKat1/BilgisayarLabKat1.mp4
assets/DanismaMasasi
assets/DanismaMasasi/DanismaMasasi.jpg
assets/DanismaMasasi/DanismaMasasi.mp4
assets/GirisCikis
assets/GirisCikis/GirisCikis.jpg
assets/GirisCikis/GirisCikis.mp4
assets/IdariOfisKat1
assets/IdariOfisKat1/IdariOfisKat1.jpg
assets/IdariOfisKat1/IdariOfisKat1.mp4
assets/LYECGirisKat2
assets/LYECGirisKat2/LYECGirisKat2.jpg
assets/LYECGirisKat2/LYECGirisKat2.mp4
assets/MerdivenKat1
assets/MerdivenKat1/MerdivenKat1.jpg
assets/MerdivenKat1/MerdivenKat1.mp4
assets/MerdivenZemin
assets/MerdivenZemin/MerdivenZemin.jpg
assets/MerdivenZemin/MerdivenZemin.mp4
assets/Mutfak
assets/Mutfak/Mutfak.jpg
assets/Mutfak/Mutfak.mp4
assets/MutfakKat2
assets/MutfakKat2/MutfakKat2.jpeg
assets/MutfakKat2/MutfakKat2.mp4
assets/MuzikOdasi
assets/MuzikOdasi/MuzikOdasi.jpg
assets/MuzikOdasi/MuzikOdasi.mp4
assets/OgretmenOdasi
boş
assets/ResimAtolyesi
assets/ResimAtolyesi/ResimAtolyesi.jpg
assets/ResimAtolyesi/ResimAtolyesi.mp4
assets/Revir
assets/Revir/Revir.jpg
assets/Revir/Revir.mp4
assets/SesliKutuphane
assets/SesliKutuphane/SesliKutuphane.jpg
assets/SesliKutuphane/SesliKutuphane.mp4
assets/Teras1
assets/Teras1/Teras1.jpg
assets/Teras1/Teras1.mp4
assets/Teras2
assets/Teras2/Teras2.jpg
assets/Teras2/Teras2.mp4
assets/toluhoca
assets/toluhoca/toluhoca.jpg
assets/toluhoca/toluhoca.mp4
assets/WCKat1
assets/WCKat1/WCKat1.jpg
assets/WCKat1/WCKat1.mp4
assets/WCZemin
assets/WCZemin/WCZemin.jpg
assets/WCZemin/WCZemin.mp4
assets/kat1.jpg
assets/kat2.png
assets/zeminkat.png
*/