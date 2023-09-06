import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/core/dimens.dart';
import 'current_weather.dart';
import 'home_controller.dart';

class SavedCities extends ConsumerWidget {
  const SavedCities({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cities = ref.watch(
      homeController.select(
        (state) => state.weathers,
      ),
    );
    return PageView.builder(
      itemCount: cities.length,
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimens.padding,
        ),
        child: FractionallySizedBox(
          widthFactor: AppDimens.widthFactor,
          child: CurrentWeather(
            weather: cities[index],
            currentPage: index,
            pageCount: cities.length,
          ),
        ),
      ),
    );
  }
}
