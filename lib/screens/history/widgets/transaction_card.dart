import 'package:flutter/material.dart';
import '../../../extensions/string_extension.dart';
import '../history_screen.dart';

class TransactionCard extends StatelessWidget {
  final String title;
  final String category;
  final String time;
  final double amount;
  final Tag tag;

  const TransactionCard({
    super.key,
    required this.title,
    required this.category,
    required this.time,
    required this.amount,
    required this.tag,
  });

  IconData _getIconByTag(String tagValue) {
    switch (tagValue.toLowerCase()) {
      case 'essential':
        return Icons.local_mall_outlined;
      case 'food':
        return Icons.coffee_outlined;
      case 'fun':
        return Icons.videogame_asset_outlined;
      case 'finance':
      case 'investments':
        return Icons.trending_up;
      case 'salary':
      case 'freelance':
        return Icons.payments_outlined;
      default:
        return Icons.attach_money;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isIncome = amount > 0;
    final String sign = isIncome ? '+ R\$' : '- R\$';
    final String formattedAmount =
        '$sign ${amount.abs().toStringAsFixed(2).replaceAll('.', ',')}';
    final Color indicatorColor = isIncome
        ? Color(0xFF66FFA6)
        : Color(0xFFFF7777);

    return Container(
      margin: EdgeInsets.only(bottom: 1.5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: indicatorColor, width: 8)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Color(0xFFF4F5F7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconByTag(tag.type),
                color: Color(0xFF555555),
                size: 22,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.capitalize(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$category  •  $time',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formattedAmount,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: indicatorColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tag.label,
                    style: TextStyle(
                      color: isIncome ? Color(0xFF007C34) : Color(0xFF8F0000),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
