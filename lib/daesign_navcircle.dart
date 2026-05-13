import 'package:flutter/material.dart';
import 'daesign_home.dart';
import 'daesign_create.dart';
import 'daesign_search.dart';

enum DaeSignNavTarget {
  home,
  create,
  search,
  alerts,
}

class DaeSignNavCircle extends StatelessWidget {
  const DaeSignNavCircle({
    super.key,
    required this.icon,
    required this.label,
    required this.target,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final DaeSignNavTarget target;
  final bool selected;

  void _handleTap(BuildContext context) {
    if (selected) return;

    switch (target) {
      case DaeSignNavTarget.home:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DaeSignHomePage()),
        );
        break;
      case DaeSignNavTarget.create:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DaeSignCreatePage()),
        );
        break;
      case DaeSignNavTarget.search:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DaeSignSearchPage()),
        );
        break;
      case DaeSignNavTarget.alerts:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Alerts tapped')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = selected ? Colors.white : Colors.black87;
    final Color iconColor = selected ? Colors.black87 : Colors.white;
    final Border? border = selected
        ? Border.all(color: Colors.black87, width: 2)
        : null;

    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: () => _handleTap(context),
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
      ),
    );
  }
}
