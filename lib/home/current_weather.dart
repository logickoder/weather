import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../app/core/colors.dart';
import '../app/core/dimens.dart';
import '../app/data/models/weather.dart';
import '../app/widgets/custom_dropdown.dart';
import 'home_controller.dart';

class CurrentWeather extends StatelessWidget {
  final Weather weather;
  final int currentPage;
  final int pageCount;

  const CurrentWeather({
    super.key,
    required this.weather,
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.backgroundGradient,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(vertical: AppDimens.padding),
      child: FractionallySizedBox(
        widthFactor: AppDimens.widthFactor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _WeatherActions(
              currentPage: currentPage,
              pageCount: pageCount,
              cityName: weather.city.name,
            ),
            FractionallySizedBox(
              widthFactor: 0.6,
              child: _WeatherIcon(
                iconUrl: weather.icon,
              ),
            ),
            _WeatherTemp(
              temperature: weather.temperature,
              description: weather.description,
            ),
            const SizedBox(height: AppDimens.padding),
            Divider(
              color: Theme.of(context).colorScheme.onPrimary,
              thickness: 1,
            ),
            const SizedBox(height: AppDimens.padding),
            _WeatherExtraInfo(weather),
          ],
        ),
      ),
    );
  }
}

class _WeatherActions extends ConsumerWidget {
  final int currentPage;
  final int pageCount;
  final String cityName;

  const _WeatherActions({
    required this.currentPage,
    required this.pageCount,
    required this.cityName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cities = ref.watch(
      homeController.select(
        (state) => state.cities,
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomDropdown(
          dropdown: (dropdownKey) => DropdownButtonHideUnderline(
            child: DropdownButton(
              key: dropdownKey(),
              items: [
                for (final city in cities)
                  DropdownMenuItem(
                    value: city,
                    child: Text(
                      city.name,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
              ],
              onChanged: (city) {
                if (city != null) {
                  ref.read(homeController.notifier).addCity(city);
                }
              },
            ),
          ),
          child: (openDropdown) => IconButton(
            onPressed: openDropdown,
            icon: Icon(
              Icons.add,
              size: AppDimens.padding * 2,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              cityName,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: AppDimens.padding / 4),
            _PagerIndicator(
              currentPage: currentPage,
              pageCount: pageCount,
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            ref
                .read(homeController.notifier)
                .removeCity(cityName)
                .then((success) {
              final message =
                  success ? '$cityName removed' : 'Failed to remove $cityName';

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    message,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  backgroundColor: success
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error,
                ),
              );
            });
          },
          icon: Icon(Icons.remove, color: theme.colorScheme.onPrimary),
        ),
      ],
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  final String iconUrl;

  const _WeatherIcon({required this.iconUrl});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: LayoutBuilder(builder: (_, constraints) {
        return CachedNetworkImage(
          imageUrl: iconUrl,
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          fit: BoxFit.contain,
        );
      }),
    );
  }
}

class _WeatherTemp extends StatelessWidget {
  final double temperature;
  final String description;

  const _WeatherTemp({
    required this.temperature,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = DateTime.now();
    final day = DateFormat('EEEE').format(date);
    final month = DateFormat('MMMM').format(date);

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                day,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: AppDimens.padding / 2),
              VerticalDivider(
                color: theme.colorScheme.onPrimary,
                thickness: 1,
              ),
              const SizedBox(width: AppDimens.padding / 2),
              Text(
                '$month ${date.day}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '${temperature.toStringAsFixed(2)}°',
            style: theme.textTheme.displayLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          description,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}

class _WeatherExtraInfo extends StatelessWidget {
  final Weather weather;

  const _WeatherExtraInfo(this.weather);

  @override
  Widget build(BuildContext context) {
    final items = [
      _WeatherExtraInfoData(
        label: 'Wind',
        value: '${weather.windSpeed} km/hr',
        icon: Icons.speed,
      ),
      _WeatherExtraInfoData(
        label: 'Humidity',
        value: '${weather.humidity}%',
        icon: Icons.water,
      ),
      _WeatherExtraInfoData(
        label: 'Pressure',
        value: '${weather.pressure} hPa',
        icon: Icons.waves,
      ),
      _WeatherExtraInfoData(
        label: 'Cloudiness',
        value: '${weather.cloudiness}%',
        icon: Icons.cloud,
      ),
    ].slices(2);

    return Column(
      children: items
          .mapIndexed(
            (index, row) => [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final item in row) _WeatherExtraInfoItem(item),
                ],
              ),
              if (index != items.length - 1)
                const SizedBox(height: AppDimens.padding),
            ],
          )
          .expand((element) => element)
          .toList(),
    );
  }
}

class _PagerIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const _PagerIndicator({
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: index == currentPage
                ? theme.colorScheme.onPrimary
                : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.onPrimary,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _WeatherExtraInfoItem extends StatelessWidget {
  final _WeatherExtraInfoData data;

  const _WeatherExtraInfoItem(this.data);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          data.icon,
          color: theme.colorScheme.onPrimary,
          size: AppDimens.padding * 2,
        ),
        const SizedBox(width: AppDimens.padding / 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.value,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: AppDimens.padding / 4),
            Text(
              data.label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WeatherExtraInfoData {
  final String label;
  final String value;
  final IconData icon;

  const _WeatherExtraInfoData({
    required this.label,
    required this.value,
    required this.icon,
  });
}
