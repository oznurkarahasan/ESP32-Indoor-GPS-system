import 'package:flutter/material.dart';

class ZeminPage extends StatelessWidget {
  const ZeminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Zemin Kat")),
      body: const Center(
        child: Text("Bu sayfa zemin kata ait.", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
