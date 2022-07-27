import 'package:flutter/material.dart';

class LocationPickerModeButton extends StatelessWidget {
  final void Function() onPressed;
  final IconData iconData;
  final String label;

  const LocationPickerModeButton(
      {Key? key,
      required this.onPressed,
      required this.iconData,
      required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      child: Column(
        children: [
          Icon(
            iconData,
            size: 48,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5,
          )
        ],
      ),
    );
  }
}
