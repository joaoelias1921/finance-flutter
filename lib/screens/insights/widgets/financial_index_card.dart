import 'package:flutter/material.dart';

class FinancialIndexCard extends StatelessWidget {
  final double financialIndex;
  final bool isLastExpense;

  const FinancialIndexCard({
    super.key,
    required this.financialIndex,
    required this.isLastExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Color(0xFFF0F5FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ÍNDICE FINANCEIRO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: Color(0xFF6B7280),
                ),
              ),
              SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    financialIndex.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  Text(
                    ' /10',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isLastExpense
                  ? Color(0xFFFEE2E2)
                  : Color(0xFF007C34).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: isLastExpense
                ? Icon(Icons.trending_down, color: Color(0xFFEF4444), size: 24)
                : Icon(Icons.trending_up, color: Color(0xFF007C34), size: 24),
          ),
        ],
      ),
    );
  }
}
