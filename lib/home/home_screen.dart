import 'package:flutter/material.dart';

import '../app/core/dimens.dart';
import 'current_weather.dart';
import 'saved_cities.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: AppDimens.padding),
            FractionallySizedBox(
              widthFactor: AppDimens.widthFactor,
              child: CurrentWeather(),
            ),
            SizedBox(height: AppDimens.padding),
            Expanded(
              child: SavedCities(),
            ),
            SizedBox(height: AppDimens.padding),
          ],
        ),
      ),
    );
  }
}
