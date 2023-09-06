import 'package:flutter/material.dart';

typedef CustomDropdownChildBuilder = Widget Function(
  Function() openDropdown,
);

typedef CustomDropdownWidgetBuilder = Widget Function(
  Key Function() dropdownKey,
);

class CustomDropdown extends StatelessWidget {
  /// The builder that will be used to build the widget that will be shown
  /// when the custom dropdown is clicked providing the dropdown options,
  /// preferably a [DropdownButton]
  final CustomDropdownWidgetBuilder dropdown;

  /// The builder that will be used to build the widget that will open the
  /// dropdown when clicked
  final CustomDropdownChildBuilder child;

  const CustomDropdown({
    super.key,
    required this.dropdown,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final dropdownKey = GlobalKey();
    return Stack(
      children: [
        Offstage(
          child: dropdown(() => dropdownKey),
        ),
        child(() => _openDropdown(dropdownKey)),
      ],
    );
  }

  void _openDropdown(GlobalKey key) {
    GestureDetector? detector;

    void searchForGestureDetector(BuildContext? element) {
      element?.visitChildElements((element) {
        if (element.widget is GestureDetector) {
          detector = element.widget as GestureDetector?;
          return;
        } else {
          searchForGestureDetector(element);
        }
        return;
      });
    }

    searchForGestureDetector(key.currentContext);

    detector?.onTap?.call();
  }
}
