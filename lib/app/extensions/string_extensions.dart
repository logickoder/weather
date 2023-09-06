extension StringExtension on String {
  /// Capitalizes the first letter of the string.
  String get capitalizeFirst {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalizes the first letter of each word in the string.
  String get capitalizeCase {
    return splitMapJoin(
      RegExp(r'\s+'),
      onMatch: (m) => m.group(0)!,
      onNonMatch: (n) => n.capitalizeFirst,
    );
  }
}
