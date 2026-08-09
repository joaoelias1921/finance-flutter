import 'package:flutter/material.dart';
import '../../../extensions/string_extension.dart';
import '../insights_calculator.dart';

class MajorImpactsSection extends StatelessWidget {
  final List<CategoryImpact> topImpacts;

  const MajorImpactsSection({super.key, required this.topImpacts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MAIORES IMPACTOS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Valores arredondados para melhor entendimento',
          style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
        ),
        SizedBox(height: 12),
        if (topImpacts.isEmpty)
          Text(
            'Nenhuma despesa registrada no período',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )
        else
          ...topImpacts.take(3).map((impact) => _buildImpactCard(impact)),
      ],
    );
  }

  Widget _buildImpactCard(CategoryImpact impact) {
    final formattedAmount =
        'R\$ ${impact.totalAmount.toStringAsFixed(0).replaceAll('.', ',')}';

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: impact.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(impact.icon, color: Colors.white, size: 22),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  impact.label.capitalize(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: impact.percentage / 100,
                    minHeight: 6,
                    backgroundColor: Color(0xFFF3F4F6),
                    valueColor: AlwaysStoppedAnimation<Color>(impact.color),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formattedAmount,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${impact.percentage.toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
