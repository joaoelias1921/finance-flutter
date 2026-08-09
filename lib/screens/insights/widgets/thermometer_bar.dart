import 'package:flutter/material.dart';

class ThermometerBar extends StatelessWidget {
  const ThermometerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 520,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEF4444), Color(0xFFFBBF24), Color(0xFF10B981)],
        ),
      ),
    );
  }
}
