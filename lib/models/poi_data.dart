// lib/models/poi_data.dart

class NavVideo {
  final String startPOI;
  final String endPOI;
  final String url;
  final String name;

  NavVideo({
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

  POI({
    required this.name,
    required this.key,
    required this.floor,
    required this.imageUrl,
    this.aliases = const [],
  });
}

class BuildingData {
  
  // <<< YENİ EKLENEN MERKEZİ HARİTA URL'LERİ >>>
  static const String zeminKatHaritaUrl =
      "https://drive.google.com/uc?export=view&id=1-rGQy7qUzATSE4Jzyh5KrXUGEFEZ7YZi";
  static const String kat1HaritaUrl =
      "https://drive.google.com/uc?export=view&id=166-2gIZ4Yt4y9EPQx0ewgOvgfK7F9at7";
  static const String kat2HaritaUrl =
      "https://drive.google.com/uc?export=view&id=1I2a_iSfLcC6sv1fpBG-5pDgNBxS8qxIg";
  // <<< YENİ EKLEME SONU >>>

  static final List<POI> allPOIs = [
    // --- 0. ZEMİN KAT POI'LERİ ---
    POI(
      name: 'Danışma Masası',
      key: 'zeminDanisma',
      floor: 'Zemin',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1KIewbljKD87pEn5MqU4j6Pw7gxN1VcAh',
      aliases: [
        'danışma', 'giriş danışma', 'bilgi masası', 'resepsiyon',
        'karşılama', 'yardım masası', 'danışma noktası', 'girişteki masa',
        'bilgi noktası', 'giriş masası', 'bilgilendirme masası'
      ],
    ),
    POI(
      name: 'Bekleme Salonu',
      key: 'zeminBekleme',
      floor: 'Zemin',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1BvfAHgrfoCpcPu3w2WiF5oPcmZrE8c4X',
      aliases: [
        'bekleme odası', 'salon', 'oturma alanı', 'bekleme alanı',
        'misafir salonu', 'dinlenme alanı', 'lobi', 'giriş salonu'
      ],
    ),
    POI(
      name: 'Sesli Kütüphane',
      key: 'zeminSesliKutup',
      floor: 'Zemin',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1ILlPYBI_YNV7AmQta9LQnr2a4KVm7fKU',
      aliases: [
        'kütüphane', 'sesli kitaplar', 'okuma alanı', 'kitap odası',
        'öğrenme alanı', 'kitaplık', 'okuma salonu', 'sesli kitap bölümü'
      ],
    ),
    POI(
      name: 'Mutfak',
      key: 'zeminMutfak',
      floor: 'Zemin',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1--OmmXChRpT-YA1WVYVcsOgSX9Z4NCba',
      aliases: [
        'yemekhane', 'kafeterya', 'yemek alanı', 'çay ocağı', 'yemek odası',
        'mutfak bölümü', 'gıda hazırlık alanı'
      ],
    ),
    POI(
      name: 'WC (Zemin)',
      key: 'zeminWC',
      floor: 'Zemin',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1TJYM30Lc_FlqN53um9qLV2m0w0MMBE62',
      aliases: [
        'tuvalet', 'lavabo', 'zemin tuvalet', 'zemin wc',
        'banyo', 'wc', 'kadın tuvaleti', 'erkek tuvaleti', 'tuvalletler'
      ],
    ),
    POI(
      name: 'Giriş/Çıkış',
      key: 'zemingiris',
      floor: 'Zemin',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1qTyRYmDQSgFEoLibwj6q7b4o0xro2sOs',
      aliases: [
        'ana giriş', 'kapı', 'çıkış', 'binaya giriş', 'giriş kapısı',
        'dış kapı', 'bina girişi', 'ana kapı', 'ön kapı'
      ],
    ),
    POI(
      name: 'Asansör (Zemin)',
      key: 'zeminAsansor',
      floor: 'Zemin',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1yTKlMbigTRUzfKScjT6eN6UTyj96y5Dx',
      aliases: [
        'asansör', 'zemin asansör', 'asansör girişi', 'asansör kapısı',
        'asansör bölümü', 'kaldırma', 'lift'
      ],
    ),
    POI(
      name: 'Merdiven (Zemin)',
      key: 'zeminmerdivenfoto',
      floor: 'Zemin',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1QZT0oGcKaz1ui9RViWZBF_sxPjJ8G9yW',
      aliases: [
        'merdivenler', 'zemin merdiven', 'basamaklar', 'üst kata çıkan merdiven',
        'kat merdiveni', 'merdiven çıkışı'
      ],
    ),

    // --- 1. KAT ---
    POI(
      name: 'WC (Kat 1)',
      key: 'kat1WC',
      floor: 'Kat 1',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1WNXLzN7st3A_px5yOHH1q_hM1Use4vBP',
      aliases: [
        'tuvalet', 'lavabo', 'birinci kat tuvalet', 'kat 1 wc',
        'wc', 'kadın tuvaleti', 'erkek tuvaleti', 'banyo', 'tuvaletler'
      ],
    ),
    POI(
      name: 'Revir',
      key: 'kat1Revir',
      floor: 'Kat 1',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1RYNb0VF_kzlkNsM0YIZAiQ2MGHDwaTxb',
      aliases: [
        'sağlık odası', 'doktor', 'ilk yardım', 'hemşire odası',
        'muayene odası', 'revir odası', 'sağlık birimi'
      ],
    ),
    POI(
      name: 'Resim Atölyesi',
      key: 'kat1Resim',
      floor: 'Kat 1',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1zPEmZsj0PgBaSoMFWdhK4MnFEijWNWUK',
      aliases: [
        'resim odası', 'atölye', 'boya odası', 'sanat atölyesi',
        'çizim alanı', 'resim sınıfı', 'görsel sanatlar', 'sanat odası'
      ],
    ),
    POI(
      name: 'Müzik Odası',
      key: 'kat1Muzik',
      floor: 'Kat 1',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=186jTmekynX4Ty_kBvp7Um12CsCM0oYfa',
      aliases: [
        'müzik sınıfı', 'enstrüman odası', 'müzik dersi', 'piyano odası',
        'gitar odası', 'müzik çalışma odası'
      ],
    ),
    POI(
      name: 'İdari Ofis (Kat 1)',
      key: 'kat1idari',
      floor: 'Kat 1',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1RDsr5rUt-1DeyamnVEOzvilaT_cv7iq4',
      aliases: [
        'ofis', 'idari ofis', 'yönetim odası', 'sekreterlik',
        'ofis bölümü', 'idari bölüm', 'yönetici ofisi'
      ],
    ),
    POI(
      name: 'Bilgisayar Lab. (Kat 1)',
      key: 'kat1bilgisayar',
      floor: 'Kat 1',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1VNgfpgMZ5AQtX56FPzXhMOIAlwUmyFzF',
      aliases: [
        'bilgisayar laboratuvarı', 'bilgisayar odası', 'bilişim laboratuvarı',
        'lab', 'teknoloji odası', 'bilgisayar sınıfı', 'bilişim odası'
      ],
    ),
    POI(
      name: 'Asansör (Kat 1)',
      key: 'kat1asansor',
      floor: 'Kat 1',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1OE940-u94yJjGXXIAZqnMRLUrckXAcgh',
      aliases: [
        'asansör', 'birinci kat asansör', 'kat 1 asansör', 'lift', 'asansör kapısı'
      ],
    ),
    POI(
      name: 'Aktivite Odası',
      key: 'kat1aktivite',
      floor: 'Kat 1',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1622Ih6jsxjagAD3Dni4jEYsY8gcBrdro',
      aliases: [
        'spor odası', 'spor salonu', 'etkinlik odası', 'aktivite salonu',
        'hareket odası', 'egzersiz alanı', 'oyun alanı'
      ],
    ),
    POI(
      name: 'Merdiven (Kat 1)',
      key: 'kat1merdiven',
      floor: 'Kat 1',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=15-aYZ1ui5e9Wtn1VS_eb-FJgVxWvDNNA',
      aliases: [
        'merdiven', 'kat 1 merdiven', 'üst kata çıkan merdiven', 'basamaklar',
        'kat merdiveni', 'iniş merdiveni'
      ],
    ),
    POI(
      name: 'Öğretmen Odası',
      key: 'kat1ogretmen',
      floor: 'Kat 1',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1QG09lK4FPgdwkckmTJM3_a2V0nxhJzgf',
      aliases: ['öğretmenler odası', 'hoca odası', 'eğitmen odası', 'personel odası'],
    ),

    // --- 2. KAT ---
    POI(
      name: 'LYEC Giriş (Kat 2)',
      key: 'lyeclabsgiris',
      floor: 'Kat 2',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1jSiHld-B4LVrUTSGb4au1rMTYH-Nysk-',
      aliases: [
        'lyec', 'laboratuvar', 'kat 2 giriş', 'gaca', 'thegaca', 'ogaca',
        'atölye', 'laboratuvar girişi', 'teknoloji lab', 'araştırma alanı'
      ],
    ),
    POI(
      name: 'Profesör Ofisi',
      key: 'tolunaydemirci',
      floor: 'Kat 2',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1xNMlMffYa-baXxbalvaGzsMCRsUg9Jgh',
      aliases: [
        'tolunay hoca', 'profesör odası', 'tolunay demirci',
        'akademisyen odası', 'hocanın ofisi', 'danışman odası'
      ],
    ),
    POI(
      name: 'Asansör (Kat 2)',
      key: 'kat2asansor',
      floor: 'Kat 2',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1fuIFJASArbm2Xc1IbzyISr2_AHEK6oDh',
      aliases: [
        'asansör', 'ikinci kat asansör', 'kat 2 asansör', 'lift', 'asansör kapısı'
      ],
    ),
    //yeni
    POI(
      name: 'Mutfak (kat2)',
      key: 'kat2Mutfak',
      floor: 'Kat 2',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1IGj1ZiaYMRgagZfVUnh8Blw4zieQvKVF',
      aliases: ['Mutfak', 'ikinci kat Mutfak', 'kat 2 Mutfak', 'yemek'],
    ),
    POI(
      name: 'Teras 2',
      key: 'kat2Teras',
      floor: 'Kat 2',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1X8zhnlt3HTHMAcjm8qDnbBkHR50JappO',
      aliases: ['Teras 2', 'ikinci kat Teras 2', 'kat 2 Teras 2', 'Teras 2'],
    ),
    POI(
      name: 'Teras 1',
      key: 'kat1Teras',
      floor: 'Kat 2',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1fvn5os7_uexCs_r2Ppl60I0O-8992tE0',
      aliases: ['Teras 1', 'ikinci kat Teras 1', 'kat 2 Teras 1', 'Teras 1'],
    ),
  ];

  static final List<NavVideo> allRoutes = [
    // --- ZEMİN KAT ROTLARI (Başlangıç Noktası: Zemin ZON) ---
    // <<< TÜM 'https_//' URL'LER 'https://' OLARAK DÜZELTİLDİ >>>
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Danışma Masası',
      url:
          'https://drive.google.com/uc?export=view&id=1C9LjjD4b4vsj2IAb3vqB0uULYbEX3NeZ',
      name: 'zeminkatZon_danisma',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Bekleme Salonu',
      url:
          'https://drive.google.com/uc?export=view&id=1z6cbOOV3aYwoNmzn5AT-kUBzWgJ4bKOo',
      name: 'zeminkatZon_bekleme',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Sesli Kütüphane',
      url:
          'https://drive.google.com/uc?export=view&id=1gMtEfMKg5cM1ASYX_BuAZuiGH0N-t_yO',
      name: 'zeminkatZon_sesli',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Mutfak',
      url:
          'https://drive.google.com/uc?export=view&id=1Ga2ksNUbsDA_h51YhllbzzU2jnUcPdoi',
      name: 'zeminkatZon_mutfak',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'WC (Zemin)',
      url:
          'https://drive.google.com/uc?export=view&id=1i2_WCyzSy4Po-IKexAXHWbEUPHoF6oKY',
      name: 'zeminkatZon_wc',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Asansör (Zemin)',
      url:
          'https://drive.google.com/uc?export=view&id=115jTAj5G54tyS2EjWrfPpBH7UENOI6I_',
      name: 'zeminkatZon_asansor',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Resim Atölyesi',
      url:
          'https://drive.google.com/uc?export=view&id=1e0BSDBGjXP7dL2w6WexWZA6TBdkbZkAi',
      name: 'zemin_resimvideo',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'İdari Ofis (Kat 1)',
      url:
          'https://drive.google.com/uc?export=view&id=1wu5kNknkOTz0_TR2UbOvagO9md4y9YnO',
      name: 'zemin_idarivideo',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Müzik Odası',
      url:
          'https://drive.google.com/uc?export=view&id=19yg1b_WgOyl_K4rjRC2oAgZNo6s7jLcz',
      name: 'zemin_muzikvideo',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Revir',
      url:
          'https://drive.google.com/uc?export=view&id=1eEmWwZjFUHDkaJS9YAdLDE7nGUea-7_i',
      name: 'zemin_revirvideo',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Aktivite Odası',
      url:
          'https://drive.google.com/uc?export=view&id=1DZW_kYkgBxBV9zOADxLURalKY0qNpzjW',
      name: 'zemin_sporvideo',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Bilgisayar Lab. (Kat 1)',
      url:
          'https://drive.google.com/uc?export=view&id=1uuNqt5aDV0jmKWVD3OD39U9pxVIBFcN-',
      name: 'zemin_bilgisayarvideo',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Giriş/Çıkış',
      url:
          'https://drive.google.com/uc?export=view&id=1pTOwMIAH2N8fYMd3byFQiTRl3kLzQjmb',
      name: 'zemin_Giriscikisvideo',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Merdiven (Zemin)',
      url:
          'https://drive.google.com/uc?export=view&id=19wKKAAwkWqGnrT0KphQHNG9KcVtGKxNR',
      name: 'zemin_Merdivenvideo',
    ),

    // --- KAT 1 ROTLARI (Başlangıç Noktası: Kat 1'deki ZON) ---
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'Bilgisayar Lab. (Kat 1)',
      url:
          'https://drive.google.com/uc?export=view&id=1uuNqt5aDV0jmKWVD3OD39U9pxVIBFcN-',
      name: 'kat1_bilgisayar',
    ),
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'Revir',
      url:
          'https://drive.google.com/uc?export=view&id=1eEmWwZjFUHDkaJS9YAdLDE7nGUea-7_i',
      name: 'kat1_revir',
    ),
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'Aktivite Odası',
      url:
          'https://drive.google.com/uc?export=view&id=1DZW_kYkgBxBV9zOADxLURalKY0qNpzjW',
      name: 'kat1_spor',
    ),
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'WC (Kat 1)',
      url:
          'https://drive.google.com/uc?export=view&id=1N6AS-xe9sQKCIDpjvPeyMofOJFdb9WvI',
      name: 'kat1_wc',
    ),
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'Resim Atölyesi',
      url:
          'https://drive.google.com/uc?export=view&id=1e0BSDBGjXP7dL2w6WexWZA6TBdkbZkAi',
      name: 'kat1_resim',
    ),
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'Müzik Odası',
      url:
          'https://drive.google.com/uc?export=view&id=19yg1b_WgOyl_K4rjRC2oAgZNo6s7jLcz',
      name: 'kat1_muzik',
    ),
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'Asansör (Kat 1)',
      url:
          'https://drive.google.com/uc?export=view&id=1ZrVwyuxhtYv9FbIse2MGGGqRQuPLPQd4',
      name: 'kat1_asansor',
    ),
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'İdari Ofis (Kat 1)',
      url:
          'https://drive.google.com/uc?export=view&id=1wu5kNknkOTz0_TR2UbOvagO9md4y9YnO',
      name: 'kat1_idari',
    ),
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'Bekleme Salonu',
      url:
          'https://drive.google.com/uc?export=view&id=1gABQ5BmWvdFfU4ymtDbSdNSyC4Xxl-bM',
      name: 'kat1_beklemevideo',
    ),
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'Danışma Masası',
      url:
          'https://drive.google.com/uc?export=view&id=1KcqzSDKWsxN1NKOaa6MO34-mtJS2NKce',
      name: 'kat1_danismavideo',
    ),
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'Mutfak',
      url:
          'https://drive.google.com/uc?export=view&id=1A_jUc1ToJXfgyrYvaU8BVtFFKKqFgYYy',
      name: 'kat1_mutfakvideo',
    ),
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'Sesli Kütüphane',
      url:
          'https://drive.google.com/uc?export=view&id=13C9KhI9wEfUTFtj6VWbUa_kQwKywNMIH',
      name: 'kat1_seslivideo',
    ),

    // --- LYEC LABS (KAT 2) ROTLARI (Başlangıç Noktası: LYEC Giriş) ---
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'İdari Ofis (Kat 1)',
      url:
          'https://drive.google.com/uc?export=view&id=1kxwcEhaLSuDcvRfyznlyTuyYVQ1Bdnnu',
      name: 'lyec_idarivideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Danışma Masası',
      url:
          'https://drive.google.com/uc?export=view&id=1oCR50vGK8GZLcZ8axJvF1EpDsy9-IAwt',
      name: 'lyec_danismavideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Bekleme Salonu',
      url:
          'https://drive.google.com/uc?export=view&id=1IO469ZyIY4_DGxUKBrDld4TMA2rKJJEW',
      name: 'lyec_beklemevideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Bilgisayar Lab. (Kat 1)',
      url:
          'https://drive.google.com/uc?export=view&id=18Nc8A-5G72jVTtP_Sb9Vjw69Y5N-x35V',
      name: 'lyec_bilgisayarvideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Asansör (Kat 1)',
      url:
          'https://drive.google.com/uc?export=view&id=1eS7qT0WAK9zOBKdzWDXJWS7FpThPEYx6',
      name: 'lyec_asansorvideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Aktivite Odası',
      url:
          'https://drive.google.com/uc?export=view&id=1ecyMgadlG8VkRIjm9sMsEcLFeakjm0cF',
      name: 'lyec_sporvideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Sesli Kütüphane',
      url:
          'https://drive.google.com/uc?export=view&id=1u0W4ew0sNXhVTo09mIuhB8SW0Bar9Kub',
      name: 'lyec_seslivideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Revir',
      url:
          'https://drive.google.com/uc?export=view&id=18Nc8A-5G72jVTtP_Sb9Vjw69Y5N-x35V',
      name: 'lyec_revirvideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Mutfak',
      url:
          'https://drive.google.com/uc?export=view&id=1d0sPU9OaXrnJiNDgZq8YP5aTXzapxpSf',
      name: 'lyec_mutfakvideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Resim Atölyesi',
      url:
          'https://drive.google.com/uc?export=view&id=1uUkUEFUt-wNpf0nl6bqlqdtDXQz0QlxG',
      name: 'lyec_resimvideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Müzik Odası',
      url:
          'https://drive.google.com/uc?export=view&id=1k1CzxWvaYpLTDE2n2Gcfc9BpEO8ftBm1',
      name: 'lyec_muzikvideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'WC (Kat 1)',
      url:
          'https://drive.google.com/uc?export=view&id=19HBgKH7oPtVY-VLu5ravLP1183RkwNy9',
      name: 'lyec_kat1WCvideo',
    ),

    // --- KATLAR ARASI ROTLAR ---
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Kat 1',
      url:
          'https://drive.google.com/uc?export=view&id=19pxv5ZDOVhUfSiB9YpiXk-LLPkG1lJBG',
      name: 'zeminkatZon_kat1',
    ),
    NavVideo(
      startPOI: 'Kat 1',
      endPOI: 'Zemin ZON',
      url:
          'https://drive.google.com/uc?export=view&id=1y7HdLcRmMXG9ylYJiUsjDTZpWO_uQAOn',
      name: 'kat1_zeminvideo',
    ),

    // Zemin ZON <-> LYEC Laboratuvarı
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'LYEC Laboratuvarı (Kat 2)',
      url:
          'https://drive.google.com/uc?export=view&id=19Xe0jlQoe9BYemEBJ5oIC4y4RUnJZlU5',
      name: 'zeminZonlyecvideo',
    ),
    NavVideo(
      startPOI: 'LYEC Laboratuvarı (Kat 2)',
      endPOI: 'Zemin ZON',
      url:
          'https://drive.google.com/uc?export=view&id=1RWs_rancEq_y23XkKXsCN-pUsnymf5Zr',
      name: 'lyeczeminZonvideo',
    ),

    // Kat 1 <-> LYEC Laboratuvarı
    NavVideo(
      startPOI: 'Kat 1',
      endPOI: 'LYEC Laboratuvarı (Kat 2)',
      url:
          'https://drive.google.com/uc?export=view&id=1jL6vFUJFJ1c0vNoQspn7ruaUitO94q1I',
      name: 'lyec_kat1video',
    ),
    NavVideo(
      startPOI: 'LYEC Laboratuvarı (Kat 2)',
      endPOI: 'Kat 1',
      url:
          'https://drive.google.com/uc?export=view&id=1ge8n3fXOdjxoMFjfjc2fOPyYeEAo_Z3N',
      name: 'kat1_lyecvideo',
    ),

    // Kat 1 -> Profesör Ofisi (Tolunay Demirci)
    NavVideo(
      startPOI: 'Kat 1',
      endPOI: 'Profesör Ofisi',
      url:
          'https://drive.google.com/uc?export=view&id=1Y5vN9zgDfvo4127iEi_8ld8q6Ikfbpi0',
      name: 'kat1_tolunayvideo',
    ),
    // Zemin -> Hoca Ofisi
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Profesör Ofisi',
      url:
          'https://drive.google.com/uc?export=view&id=16TBZvFriiDdAnPgFyeEbu1Sj38U-p-wV',
      name: 'zemin_hocavideo',
    ),

    // LYEC -> Hoca Ofisi
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Profesör Ofisi',
      url:
          'https://drive.google.com/uc?export=view&id=16Q4o6TSxwzjXrNg919_1st0H8pbwo-qL',
      name: 'lyec_hocavideo',
    ),
    //yeni
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Mutfak (kat2)',
      url:
          'https://drive.google.com/uc?export=view&id=1bzhmIyFKkxiYMqlwKdb3mbD5tdpXjJb4',
      name: 'lyec_mutfakvideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Teras 2',
      url:
          'https://drive.google.com/uc?export=view&id=1JyMFV__kv9FdzqkcaAtSvVumlELpPh1a',
      name: 'lyec_teras2video',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Teras 1',
      url:
          'https://drive.google.com/uc?export=view&id=1JSLXqAVWjglZoVk67J7iwAUZv4fktEui',
      name: 'lyec_teras1video',
    ),
  ];

  // Yardımcı fonksiyonlar (Arama ve filtreleme için)
  static List<POI> getPOIsByFloor(String floor) {
    return allPOIs.where((poi) => poi.floor == floor).toList();
  }
}