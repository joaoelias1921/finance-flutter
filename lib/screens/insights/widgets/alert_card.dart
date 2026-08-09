import 'package:flutter/material.dart';
import '../../../extensions/string_extension.dart';

class AlertCard extends StatelessWidget {
  final String mostFrequentCategoryName;
  final int mostFrequentCategoryCount;
  final VoidCallback onNavigateToHistory;

  const AlertCard({
    super.key,
    required this.mostFrequentCategoryCount,
    required this.mostFrequentCategoryName,
    required this.onNavigateToHistory,
  });

  @override
  Widget build(BuildContext context) {
    final String purchasesText = mostFrequentCategoryCount == 1
        ? '1 saída'
        : '$mostFrequentCategoryCount saídas';

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFF59E0B),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Alerta de frequência',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          Text(
            mostFrequentCategoryCount > 0
                ? 'Você teve $purchasesText na categoria ${mostFrequentCategoryName.capitalize()}. Isso pode impactar sua saúde financeira'
                : 'Você não teve nenhuma saída recentemente. Suas finanças estão equilibradas!',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
          SizedBox(height: 12),

          GestureDetector(
            onTap: () {
              onNavigateToHistory.call();
            },
            child: Row(
              children: [
                Text(
                  'Ver detalhes no histórico',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B82F6),
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.north_east, size: 14, color: Color(0xFF3B82F6)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
