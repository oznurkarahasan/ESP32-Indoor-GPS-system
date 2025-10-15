import 'package:flutter/material.dart';

// İleride buraya ses tanıma (Speech-to-Text) paketini ekleyeceksiniz.

class VoiceSearchButton extends StatelessWidget {
  final VoidCallback onStartListening;
  final Color buttonColor;
  final bool isWide;

  const VoiceSearchButton({
    super.key,
    required this.onStartListening,
    this.buttonColor = const Color(0xFFFF9800), // Varsayılan Turuncu
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: buttonColor.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: MaterialButton(
        padding: EdgeInsets.symmetric(vertical: isWide ? 20 : 16),
        onPressed: onStartListening,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mic_none, color: Colors.white, size: isWide ? 28 : 24),
            const SizedBox(width: 10),
            Text(
              'Sesli Komutla Ara',
              style: TextStyle(
                color: Colors.white,
                fontSize: isWide ? 18 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
