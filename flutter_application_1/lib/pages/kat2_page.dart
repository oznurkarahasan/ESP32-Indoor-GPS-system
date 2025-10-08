import 'package:flutter/material.dart';

class Kat2Page extends StatelessWidget {
  const Kat2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("2. Kat")),
      body: const Center(
        child: Text("Bu sayfa 2. kata ait.", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
