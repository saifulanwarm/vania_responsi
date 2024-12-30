import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed; // Ubah ke VoidCallback? untuk mendukung null
  final Icon? icon;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final bool iconAtStart;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    this.iconAtStart = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: backgroundColor,
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment:
                  iconAtStart ? MainAxisAlignment.start : MainAxisAlignment.end,
              children: [
                if (iconAtStart) icon!,
                Text(
                  label,
                  style: TextStyle(color: textColor),
                ),
                if (!iconAtStart) ...[
                  const SizedBox(width: 8),
                  icon!,
                ],
              ],
            )
          : Text(
              label,
              style: TextStyle(color: textColor),
            ),
    );
  }
}

