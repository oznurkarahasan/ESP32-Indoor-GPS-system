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
  // Anahtar: Kullanıcıya Gösterilecek Ad (Arama Kutusu için)
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
      name: 'WC',
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

    // --- 1. KAT POI'LERİ (VERİ SETİNİZDEN ALINDI) ---
    POI(
      name: 'WC',
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
      name: 'İdari Ofis',
      key: 'kat1idari',
      floor: 'Kat 1',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1QG09lK4FPgdwkckmTJM3_a2V0nxhJzgf',
    ),
    POI(
      name: 'Bilgisayar Lab.',
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

    // --- 2. KAT POI'LERİ (VERİ SETİNDE LYEC LABS OLARAK GEÇEN KISIMLARDAN BAZILARI) ---
    // Not: Buradaki POI'ler Kat 2 olarak varsayılmıştır.
    POI(
      name: 'LYEC Laboratuvarı',
      key: 'lyeclabs',
      floor: 'Kat 2',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=19aQuVu_uz7_NT_w_UYpplAjR4AkwRF1J',
    ),
    POI(
      name: 'LYEC Giriş',
      key: 'lyeclabsgiris',
      floor: 'Kat 2',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1W_IqVBK4UrZ3gtVjgeT8qT8qFZA7whCrBk',
    ),
    POI(
      name: 'Profesör Ofisi',
      key: 'tolunaydemirci',
      floor: 'Kat 2',
      imageUrl:
          'https://drive.google.com/uc?export=view&id=1xNMlMffYa-baXxbalvaGzsMCRsUg9Jgh',
    ),
  ];

  // Navigasyon rotaları (Sadece Zemin Kat rotaları dahil edilmiştir. Diğerlerini eklemelisiniz.)
  static final List<NavVideo> allRoutes = [
    // ZEMİN KAT ROTLARI (Başlangıç Noktası: Zemin ZON)
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
      endPOI: 'WC',
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

    // KATLAR ARASI (Örn: Zemin ZON -> Kat 1)
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'Kat 1',
      url:
          'https://drive.google.com/uc?export=view&id=19pxv5ZDOVhUfSiB9YpiXk-LLPkG1lJBG',
      name: 'zeminkatZon_kat1',
    ),

    // LYEC Laboratuvarı (Kat 2) rotası (Örnek)
    NavVideo(
      startPOI: 'Zemin ZON',
      endPOI: 'LYEC Laboratuvarı',
      url:
          'https://drive.google.com/uc?export=view&id=1RWs_rancEq_y23XkKXsCN-pUsnymf5Zr',
      name: 'zeminkatZonlyecvideo',
    ),
    // LYEC Laboratuvarı'ndan Zemin ZON'a (Ters Rota)
    NavVideo(
      startPOI: 'LYEC Laboratuvarı',
      endPOI: 'Zemin ZON',
      url:
          'https://drive.google.com/uc?export=view&id=1RWs_rancEq_y23XkKXsCN-pUsnymf5Zr',
      name: 'lyeczeminZonvideo',
    ),
  ];

  // Yardımcı fonksiyonlar (Arama ve filtreleme için)
  static List<POI> getPOIsByFloor(String floor) {
    return allPOIs.where((poi) => poi.floor == floor).toList();
  }
}
