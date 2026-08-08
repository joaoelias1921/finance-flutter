import 'package:flutter/material.dart';

class Tag {
  final String type;
  const Tag({required this.type});
  String get label => switch (type.toLowerCase()) {
    'essential' => 'Essencial',
    'food' => 'Alimentação',
    'fun' => 'Entretenimento',
    'finance' => 'Finanças',
    _ => 'Diversos',
  };
}

class Transaction {
  final String title;
  final String category;
  final String time;
  final double amount;
  final Tag tag;
  final String dateSection;

  const Transaction({
    required this.title,
    required this.category,
    required this.time,
    required this.amount,
    required this.tag,
    required this.dateSection,
  });
}

const List<Transaction> mockTransactions = [
  Transaction(
    title: 'Supermercado Extra',
    category: 'Alimentação',
    time: '14:20',
    amount: -245.80,
    tag: Tag(type: 'essential'),
    dateSection: 'HOJE',
  ),
  Transaction(
    title: 'Salário Mensal',
    category: 'Renda',
    time: '09:00',
    amount: 5200.00,
    tag: Tag(type: 'finance'),
    dateSection: 'HOJE',
  ),
  Transaction(
    title: 'Starbucks Coffee',
    category: 'Lazer',
    time: '16:45',
    amount: -18.50,
    tag: Tag(type: 'food'),
    dateSection: 'ONTEM',
  ),
  Transaction(
    title: 'Assinatura Netflix',
    category: 'Entretenimento',
    time: '02:00',
    amount: -55.90,
    tag: Tag(type: 'fun'),
    dateSection: 'ONTEM',
  ),
  Transaction(
    title: 'Venda de Notebook',
    category: 'Extra',
    time: '11:30',
    amount: 1200.00,
    tag: Tag(type: 'finance'),
    dateSection: '12 DE OUTUBRO',
  ),
];

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Transaction>> groupedTransactions = {};
    for (var transaction in mockTransactions) {
      groupedTransactions
          .putIfAbsent(transaction.dateSection, () => [])
          .add(transaction);
    }

    return Scaffold(
      backgroundColor: Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(color: Color(0xFFE5E5E5), height: 1.0),
        ),
        leading: Padding(
          padding: EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.flash_on, color: Colors.white, size: 20),
          ),
        ),
        title: Text(
          'Histórico',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black, size: 26),
            onPressed: () {},
          ),
          SizedBox(width: 8),
        ],
      ),
      body: ListView(
        children: groupedTransactions.entries.expand((entry) {
          return [
            SectionHeader(title: entry.key),
            ...entry.value.map(
              (transaction) => TransactionCard(
                title: transaction.title,
                category: transaction.category,
                time: transaction.time,
                amount: transaction.amount,
                tag: transaction.tag,
              ),
            ),
          ];
        }).toList(),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

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
        return Icons.trending_up;
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
        border: Border(right: BorderSide(color: indicatorColor, width: 4)),
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
                    title,
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
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFFE0E0E0), width: 1),
                  ),
                  child: Text(
                    tag.label,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
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
