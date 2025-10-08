import 'package:flutter/material.dart';

class Kat1Page extends StatelessWidget {
  const Kat1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("1. Kat")),
      body: const Center(
        child: Text("Bu sayfa 1. kata ait.", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
