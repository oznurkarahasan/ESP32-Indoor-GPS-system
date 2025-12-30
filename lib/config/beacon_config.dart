import 'package:flutter/material.dart';
import '../logic/beacon_logic.dart';

class BeaconConfig {
  // Harita görseli
  static const String mapImagePath = "assets/zeminkat.png"; 

  // Odanın Gerçek Boyutları (Metre cinsinden)
  static const double roomWidth = 20.0;  
  static const double roomHeight = 12.0; 

  static List<BeaconNode> getBeacons() {
    return [
      // 1. SOL iTAG (Sarı Nokta)
      BeaconNode(
        id: "FF:FF:12:89:A3:1D", 
        name: "iTAG Sol", 
        position: const Offset(1.5, 6.0), // Sol duvar ortası
        color: Colors.yellow,
      ), 

      // 2. SAĞ iTAG (Mavi Nokta)
      BeaconNode(
        id: "FF:FF:12:89:6A:D6", 
        name: "iTAG Sağ", 
        position: const Offset(18.5, 6.0), // Sağ duvar ortası
        color: Colors.blue,
      ), 
      
      // 3. YENİ EKLENEN ORTA iTAG (Yeşil Nokta)
      BeaconNode(
        id: "FF:FF:12:88:FF:53", // <--- YENİ EKLEDİĞİN
        name: "iTAG Orta", 
        position: const Offset(7.0, 10.5), // Haritada üst kısımda, biraz solda (Tahmini yer)
        color: Colors.green, 
      ),
    ];
  }
}