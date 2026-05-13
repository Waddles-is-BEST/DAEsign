import 'package:flutter/material.dart';

class DaeSignNavCircle extends StatelessWidget {
  const DaeSignNavCircle({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = selected ? Colors.white : Colors.black87;
    final Color iconColor = selected ? Colors.black87 : Colors.white;
    final Border? border = selected
        ? Border.all(color: Colors.black87, width: 2)
        : null;


    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: border,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}
