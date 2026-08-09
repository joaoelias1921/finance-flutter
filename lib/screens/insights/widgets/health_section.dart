import 'package:flutter/material.dart';

class HealthSection extends StatelessWidget {
  final double financialIndex;

  const HealthSection({super.key, required this.financialIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saúde Financeira',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        SizedBox(height: 6),
        Text(
          financialIndex >= 7.0
              ? 'Suas finanças estão fluindo bem, mas cuidado com os picos de impulso'
              : 'Atenção aos gastos! Suas despesas estão pesando no orçamento',
          style: TextStyle(fontSize: 13, color: Color(0xFF6B7280), height: 1.3),
        ),
      ],
    );
  }
}
