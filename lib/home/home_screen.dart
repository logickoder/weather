import 'package:flutter/material.dart';

import 'saved_cities.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
      ),
      body: const Column(
        children: [
          Expanded(
            child: SavedCities(),
          ),
        ],
      ),
    );
  }
}
