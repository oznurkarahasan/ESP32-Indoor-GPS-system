import 'dart:math';
import 'package:flutter/material.dart';

// --- KALMAN FİLTRESİ ---
class KalmanFilter {
  // R=150: Hareket yavaş ama çok stabil olur (Titremez)
  double _R = 150.0; 
  double _Q = 1.0;
  double _A = 1, _B = 0, _C = 1;
  double? _x;
  double _cov = double.nan;

  double filter(double measurement) {
    if (_x == null) {
      _x = measurement;
      _cov = 1;
      return measurement;
    }
    double predX = (_A * _x!) + (_B * 0);
    double predCov = ((_A * _cov) * _A) + _Q;
    double K = predCov * _C / ((_C * predCov * _C) + _R);
    _x = predX + K * (measurement - (_C * predX));
    _cov = predCov - (K * _C * predCov);
    return _x!;
  }
}

// --- BEACON NESNESİ (iTAG UYUMLU) ---
class BeaconNode {
  final String id;   // MAC Adresi
  final String name; 
  final Offset position; 
  final Color color; // Haritadaki rengi
  
  final KalmanFilter _kalman = KalmanFilter();
  
  double filteredRssi = -100;
  double estimatedDistance = 0;
  DateTime lastSeen = DateTime.fromMillisecondsSinceEpoch(0);

  BeaconNode({
    required this.id, 
    required this.name, 
    required this.position,
    this.color = Colors.blue,
  });

  void updateRssi(int newRssi) {
    // iTAG sinyali bazen kopabilir, çok zayıfsa yoksay
    if (newRssi < -98) return;
    
    filteredRssi = _kalman.filter(newRssi.toDouble());
    estimatedDistance = _calculateDistance(filteredRssi);
    lastSeen = DateTime.now();
  }

  double _calculateDistance(double rssi) {
    // iTAG TxPower (Genelde -60 ile -65 arasıdır)
    int txPower = -62; 
    double n = 2.5;    
    return pow(10, ((txPower - rssi) / (10 * n))).toDouble();
  }
}