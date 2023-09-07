import 'package:flutter/material.dart';

class PagerIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const PagerIndicator({
    super.key,
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
