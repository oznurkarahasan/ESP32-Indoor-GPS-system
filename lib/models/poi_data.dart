// lib/models/poi_data.dart

class NavVideo {
  final String startPOI; // Başlangıç POI adı (örneğin: 'Zemin ZON')
  final String endPOI; // Bitiş POI adı (örneğin: 'Danışma Masası')
  final String url; // Navigasyon videosu URL'si
  final String name; // Veri setindeki kod adı (örneğin: 'zeminkatZon_danisma')

  NavVideo({
    required this.startPOI,
    required this.endPOI,
    required this.url,
    required this.name,
  });

  // Geriye dönük rotayı (ters yönde) oluşturur
  // Not: Bu kısım, videonun çift yönlü olduğunu varsayarak ters rota oluşturmak için kullanılır.
  // Çift yönlü olmayan videolarda (örn. katlar arası iniş/çıkış), bu ters rotayı kullanmamak gerekir.
  NavVideo get reversed => NavVideo(
        startPOI: endPOI,
        endPOI: startPOI,
        url: url, // Video genellikle çift yönlüdür
        name: "${name}_reverse",
      );
}

class POI {
  final String
      name; // Kullanıcıya gösterilecek yer adı (örneğin: 'Danışma Masası')
  final String key; // Veri setindeki anahtar (örneğin: 'zeminDanisma')
  final String floor; // Bulunduğu kat (örneğin: 'Zemin', 'Kat 1', 'Kat 2')
  final String imageUrl; // Yerleşim yerinin fotoğrafı

  POI({
    required this.name,
    required this.key,
    required this.floor,
    required this.imageUrl,
  });
}

// BİNADAKİ TÜM NOKTALARIN VE ROTLARIN STATİK VERİLERİ BURAYA EKLENİR
class BuildingData {
  // Veritabanından gelen tüm POI'ler (Resim URL'leri)
  static final List<POI> allPOIs = [
    // --- 0. ZEMİN KAT POI'LERİ ---
    POI(
      name: 'Danışma Masası',
      key: 'zeminDanisma',
      floor: 'Zemin',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1UWLSkR6vGczjFZmjv-87opyyjEw7JWol',
    ),
    POI(
      name: 'Bekleme Salonu',
      key: 'zeminBekleme',
      floor: 'Zemin',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1tWcUMRQ1n3ue2hxnEgRzbTebGSAeVQ5e',
    ),
    POI(
      name: 'Sesli Kütüphane',
      key: 'zeminSesliKutup',
      floor: 'Zemin',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1_AlXmitxUt2NznTQCKYd3D5DsdBVoaFN',
    ),
    POI(
      name: 'Mutfak',
      key: 'zeminMutfak',
      floor: 'Zemin',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1fkfMeMAj0EZFxeiQZrtsUBThqb65VD2w',
    ),
    POI(
      name: 'WC (Zemin)',
      key: 'zeminWC',
      floor: 'Zemin',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1D13lCgNnlJeum9od65_xHrdqK_zakL4b',
    ),
    POI(
      name: 'Giriş/Çıkış',
      key: 'zemingiris',
      floor: 'Zemin',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1sJRV83SP92gTfA15Mb2suEdq3aBfLBEV',
    ),
    POI(
      name: 'Asansör (Zemin)',
      key: 'zeminAsansor',
      floor: 'Zemin',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1EfWTRUXoBPfsJnfwiS4M0v2qF2zhK5Ps',
    ),
    POI(
      name: 'Merdiven (Zemin)',
      key: 'zeminmerdivenfoto',
      floor: 'Zemin',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=11xHFpi4ZnRve0gQfJn3dtO_Aeac9JSl_',
    ),
    POI(
      name: 'Engelsiz Zemin Kat Harita', // Harita/Plan olarak eklenmiştir
      key: 'engelsizzeminkat',
      floor: 'Zemin',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1S5120GMyAPRw3hqgyw_JZQuKNUgM5ofA',
    ),

    // --- 1. KAT POI'LERİ ---
    POI(
      name: 'Kat 1 Harita', // Harita/Plan olarak eklenmiştir
      key: 'kat1map',
      floor: 'Kat 1',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=10pavenp_p-fDXVAmJl3usOIKMHIC1wKZ',
    ),
    POI(
      name: 'WC (Kat 1)',
      key: 'kat1WC',
      floor: 'Kat 1',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1q4RDmj55CzL85ubO9llSAzcZTOXryrPZ',
    ),
    POI(
      name: 'Revir',
      key: 'kat1Revir',
      floor: 'Kat 1',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1cR7YwAMUZfbMn_Xe9w4M2EuW8kzA3IFg',
    ),
    POI(
      name: 'Resim Atölyesi',
      key: 'kat1Resim',
      floor: 'Kat 1',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1TyqTFak6TmifxyXKm_ILLT9SBQemgtbk',
    ),
    POI(
      name: 'Müzik Odası',
      key: 'kat1Muzik',
      floor: 'Kat 1',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1aRm9Y7S1Qvcf7JnhY34utfl70cr3Nf4u',
    ),
    POI(
      name: 'İdari Ofis (Kat 1)',
      key: 'kat1idari',
      floor: 'Kat 1',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1QG09lK4FPgdwkckmTJM3_a2V0nxhJzgf',
    ),
    POI(
      name: 'Bilgisayar Lab. (Kat 1)',
      key: 'kat1bilgisayar',
      floor: 'Kat 1',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1C5OJjhWD2mmshPSjGQlz2fq0Y52wc6C2',
    ),
    POI(
      name: 'Asansör (Kat 1)',
      key: 'kat1asansor',
      floor: 'Kat 1',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1-YID4S1GGiqfpeJC5azgkbwCsaO3Cx3p',
    ),
    POI(
      name: 'Aktivite Odası',
      key: 'kat1aktivite',
      floor: 'Kat 1',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1gP9JAuHvm4IkA8yV7t_vEuYKydkCZDHq',
    ),
    POI(
      name: 'Merdiven (Kat 1)',
      key: 'kat1merdiven',
      floor: 'Kat 1',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=11xHFpi4ZnRve0gQfJn3dtO_Aeac9JSl_',
    ),
    POI(
      name: 'Öğretmen Odası',
      key: 'kat1ogretmen',
      floor: 'Kat 1',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1QG09lK4FPgdwkckmTJM3_a2V0nxhJzgf',
    ),

    // --- 2. KAT POI'LERİ (LYEC Labs) ---
    POI(
      name: 'LYEC Laboratuvarı (Kat 2)',
      key: 'lyeclabs',
      floor: 'Kat 2',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=19aQuVu_uz7_NT_w_UYpplAjR4AkwRF1J',
    ),
    POI(
      name: 'LYEC Giriş (Kat 2)',
      key: 'lyeclabsgiris',
      floor: 'Kat 2',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1W_IqVBK4UrZ3gtVjgeT8qXFZA7whCrBk',
    ),
    POI(
      name: 'Profesör Ofisi',
      key: 'tolunaydemirci',
      floor: 'Kat 2',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1xNMlMffYa-baXxbalvaGzsMCRsUg9Jgh',
    ),
    POI(
      name: 'Asansör (Kat 2)',
      key: 'kat2asansor',
      floor: 'Kat 2',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1EfWTRUXoBPfsJnfwiS4M0v2qF2zhK5Ps',
    ),
    POI(
      name: 'WC (Kat 2)',
      key: 'kat2WC',
      floor: 'Kat 2',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1q4RDmj55CzL85ubO9llSAzcZTOXryrPZ',
    ),
    POI(
      name: 'Araştırma Odası',
      key: 'kat2arastirma',
      floor: 'Kat 2',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1gP9JAuHvm4IkA8yV7t_vEuYKydkCZDHq',
    ),
    POI(
      name: 'Toplantı Salonu',
      key: 'kat2toplanti',
      floor: 'Kat 2',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1tWcUMRQ1n3ue2hxnEgRzbTebGSAeVQ5e',
    ),
  ];

  // Navigasyon rotaları (Tüm video URL'leri ve ilgili POI adları)
  // Rota Adlandırma Kuralı: [başlangıç_adı]_[bitiş_adı]
  static final List<NavVideo> allRoutes = [
    // --- ZEMİN KAT ROTLARI (Başlangıç Noktası: Zemin ZON) ---
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Danışma Masası',
      url:
          'https://drive.google.com/uc?export=view&id=1T6XAtLJr2q73m6E6bcFcUPp0U9YMv1Dj',
      name: 'zeminkatZon_danisma',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Bekleme Salonu',
      url:
          'https://drive.google.com/uc?export=view&id=1c17gxctkubpPFuFp1_PfNKiOv5Zp56bu',
      name: 'zeminkatZon_bekleme',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Sesli Kütüphane',
      url:
          'https://drive.google.com/uc?export=view&id=131wVY1PT9D0pckKWKx1L98UUB3BY2ID7',
      name: 'zeminkatZon_sesli',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Mutfak',
      url:
          'https://drive.google.com/uc?export=view&id=1Th4cA4-pVm01ECvBxq478TNXHdg6tS89',
      name: 'zeminkatZon_mutfak',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'WC (Zemin)',
      url:
          'https://drive.google.com/uc?export=view&id=1L4V0i2rC09Dy9Z8MfNwJzD2atBtQ48cG',
      name: 'zeminkatZon_wc',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Asansör (Zemin)',
      url:
          'https://drive.google.com/uc?export=view&id=1cikJBnsvMClsjA5wA4qZPjs-NdiiYHt-',
      name: 'zeminkatZon_asansor',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Resim Atölyesi',
      url:
          'https://drive.google.com/uc?export=view&id=1PQe_RdeQjtvVsYfKhs8tj36usNJ1SOCG',
      name: 'zemin_resimvideo',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'İdari Ofis (Kat 1)', // Adı 'zemin_idarivideo' olsa da POI'nin adını kullan
      url:
          'https://drive.google.com/uc?export=view&id=1ma6IfO5zC2JZSiNT60b2Y1O_eN31oNa8',
      name: 'zemin_idarivideo',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Müzik Odası',
      url:
          'https://drive.google.com/uc?export=view&id=1caZHD7onVWNaAYgNOSgnxUJBKc7qPVYM',
      name: 'zemin_muzikvideo',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Revir', // Adı 'zemin_revirvideo' olsa da POI'nin adını kullan
      url:
          'https://drive.google.com/uc?export=view&id=1ArA4M9Rcb8M5jmcIKCK8D9bXV-N9ZLfB',
      name: 'zemin_revirvideo',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Aktivite Odası', // 'zemin_sporvideo' Aktivite Odasına götürüyor varsayıldı
      url:
          'https://drive.google.com/uc?export=view&id=1gC37l_RXQTl0vgfCwmt5bfPPL92viB4X',
      name: 'zemin_sporvideo',
    ),
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Bilgisayar Lab. (Kat 1)',
      url:
          'https://drive.google.com/uc?export=view&id=18bqb06sX7Aiu1NwVwnAWqUetVsZmblBp',
      name: 'zemin_bilgisayarvideo',
    ),

    // --- KAT 1 ROTLARI (Başlangıç Noktası: Kat 1'deki ZON) ---
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'Bilgisayar Lab. (Kat 1)',
      url:
          'https://drive.google.com/uc?export=view&id=1R_7EHdHG6jNrWNPtya0ChlXad_7u0seD',
      name: 'kat1_bilgisayar',
    ),
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'Revir',
      url:
          'https://drive.google.com/uc?export=view&id=1CbECeE9WpbtN7o7PuOA9DHZzUdNbUAxX',
      name: 'kat1_revir',
    ),
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'Aktivite Odası', // 'kat1_spor' Aktivite Odasına götürüyor varsayıldı
      url:
          'https://drive.google.com/uc?export=view&id=19XiDJ4sno72xlytQ3rLI2WTndUhic6WN',
      name: 'kat1_spor',
    ),
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'WC (Kat 1)',
      url:
          'https://drive.google.com/uc?export=view&id=1bREyhlUEhWwTwP1BcwkuPDvYCL3yhB-u',
      name: 'kat1_wc',
    ),
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'Resim Atölyesi',
      url:
          'https://drive.google.com/uc?export=view&id=18usNZaI_h2_8U58GGPZwSs4FMWCUYp44',
      name: 'kat1_resim',
    ),
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'Müzik Odası',
      url:
          'https://drive.google.com/uc?export=view&id=1pQMdmzNQEIRQRCtPCgtmalkcWpOBiP9F',
      name: 'kat1_muzik',
    ),
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'Asansör (Kat 1)',
      url:
          'https://drive.google.com/uc?export=view&id=1miYEMkhClrZxAi_RzmAFIKkaUMg6i1z_',
      name: 'kat1_asansor',
    ),
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'İdari Ofis (Kat 1)',
      url:
          'https://drive.google.com/uc?export=view&id=1n7jetGKVyMygZ_tuvS0C9PXijKo96gI7',
      name: 'kat1_idari',
    ),
    // Kat 1'den Zemin Kat POI'lerine giden videolar:
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'Bekleme Salonu', // 'kat1_beklemevideo'
      url:
          'https://drive.google.com/uc?export=view&id=1gABQ5BmWvdFfU4ymtDbSdNSyC4Xxl-bM',
      name: 'kat1_beklemevideo',
    ),
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'Danışma Masası', // 'kat1_danismavideo'
      url:
          'https://drive.google.com/uc?export=view&id=1KcqzSDKWsxN1NKOaa6MO34-mtJS2NKce',
      name: 'kat1_danismavideo',
    ),
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'Mutfak', // 'kat1_mutfakvideo'
      url:
          'https://drive.google.com/uc?export=view&id=1A_jUc1ToJXfgyrYvaU8BVtFFKKqFgYYy',
      name: 'kat1_mutfakvideo',
    ),
    NavVideo(
      startPOI: 'Kat 1 ZON',
      endPOI: 'Sesli Kütüphane', // 'kat1_seslivideo'
      url:
          'https://drive.google.com/uc?export=view&id=13C9KhI9wEfUTFtj6VWbUa_kQwKywNMIH',
      name: 'kat1_seslivideo',
    ),

    // --- LYEC LABS (KAT 2) ROTLARI (Başlangıç Noktası: LYEC Giriş) ---
    // Not: Buradaki POI'lerin Kat 2'de olduğu varsayılmıştır.
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'İdari Ofis (Kat 1)', // 'lyec_idarivideo'
      url:
          'https://drive.google.com/uc?export=view&id=1kxwcEhaLSuDcvRfyznlyTuyYVQ1Bdnnu',
      name: 'lyec_idarivideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Danışma Masası', // 'lyec_danismavideo'
      url:
          'https://drive.google.com/uc?export=view&id=1oCR50vGK8GZLcZ8axJvF1EpDsy9-IAwt',
      name: 'lyec_danismavideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Bekleme Salonu', // 'lyec_beklemevideo'
      url:
          'https://drive.google.com/uc?export=view&id=1IO469ZyIY4_DGxUKBrDld4TMA2rKJJEW',
      name: 'lyec_beklemevideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Bilgisayar Lab. (Kat 1)', // 'lyec_bilgisayarvideo'
      url:
          'https://drive.google.com/uc?export=view&id=18Nc8A-5G72jVTtP_Sb9Vjw69Y5N-x35V',
      name: 'lyec_bilgisayarvideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Asansör (Kat 1)', // 'lyec_asansorvideo'
      url:
          'https://drive.google.com/uc?export=view&id=1eS7qT0WAK9zOBKdzWDXJWS7FpThPEYx6',
      name: 'lyec_asansorvideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Aktivite Odası', // 'lyec_sporvideo'
      url:
          'https://drive.google.com/uc?export=view&id=1ecyMgadlG8VkRIjm9sMsEcLFeakjm0cF',
      name: 'lyec_sporvideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Sesli Kütüphane', // 'lyec_seslivideo'
      url:
          'https://drive.google.com/uc?export=view&id=1u0W4ew0sNXhVTo09mIuhB8SW0Bar9Kub',
      name: 'lyec_seslivideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Revir', // 'lyec_revirvideo'
      url:
          'https://drive.google.com/uc?export=view&id=18Nc8A-5G72jVTtP_Sb9Vjw69Y5N-x35V',
      name: 'lyec_revirvideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Mutfak', // 'lyec_mutfakvideo'
      url:
          'https://drive.google.com/uc?export=view&id=1d0sPU9OaXrnJiNDgZq8YP5aTXzapxpSf',
      name: 'lyec_mutfakvideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Resim Atölyesi', // 'lyec_resimvideo'
      url:
          'https://drive.google.com/uc?export=view&id=1uUkUEFUt-wNpf0nl6bqlqdtDXQz0QlxG',
      name: 'lyec_resimvideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'Müzik Odası', // 'lyec_muzikvideo'
      url:
          'https://drive.google.com/uc?export=view&id=1k1CzxWvaYpLTDE2n2Gcfc9BpEO8ftBm1',
      name: 'lyec_muzikvideo',
    ),
    NavVideo(
      startPOI: 'LYEC Giriş (Kat 2)',
      endPOI: 'WC (Kat 1)', // 'lyec_kat1WCvideo'
      url:
          'https://drive.google.com/uc?export=view&id=19HBgKH7oPtVY-VLu5ravLP1183RkwNy9',
      name: 'lyec_kat1WCvideo',
    ),

    // --- KATLAR ARASI ROTLAR ---
    // Zemin ZON <-> Kat 1
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
      endPOI: 'Profesör Ofisi', // 'zemin_hocavideo'
      url:
          'https://drive.google.com/uc?export=view&id=16TBZvFriiDdAnPgFyeEbu1Sj38U-p-wV',
      name: 'zemin_hocavideo',
    ),
    // LYEC -> Hoca Ofisi
    NavVideo(
      startPOI: 'LYEC Laboratuvarı (Kat 2)',
      endPOI: 'Profesör Ofisi', // 'lyec_hocavideo'
      url:
          'https://drive.google.com/uc?export=view&id=1w2OsypO9b8nczgoS5-cYhrZDLeX72OvT',
      name: 'lyec_hocavideo',
    ),
  ];

  // Yardımcı fonksiyonlar (Arama ve filtreleme için)
  static List<POI> getPOIsByFloor(String floor) {
    return allPOIs.where((poi) => poi.floor == floor).toList();
  }
}