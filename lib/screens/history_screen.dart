import 'package:finance_flutter/extensions/string_extension.dart';
import 'package:finance_flutter/models/transaction_model.dart';
import 'package:finance_flutter/services/transaction_service.dart';
import 'package:flutter/material.dart';

class Tag {
  final String type;
  const Tag({required this.type});

  String get label => switch (type.toLowerCase()) {
    'essential' => 'Essencial',
    'food' => 'Alimentação',
    'fun' => 'Entretenimento',
    'finance' => 'Finanças',
    'salary' => 'Salário',
    'freelance' => 'Freelance',
    'investments' => 'Rendimento',
    'other_income' => 'Outros',
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

  factory Transaction.fromModel(TransactionModel model) {
    final double realAmount = model.isExpense ? -model.amount : model.amount;
    final hour = model.date.hour.toString().padLeft(2, '0');
    final minute = model.date.minute.toString().padLeft(2, '0');
    final formattedTime = '$hour:$minute';

    return Transaction(
      title: model.categoryLabel,
      category: model.isExpense ? 'Saída' : 'Entrada',
      time: formattedTime,
      amount: realAmount,
      tag: Tag(type: model.categoryId),
      dateSection: _formatDateSection(model.date),
    );
  }

  static String _formatDateSection(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final itemDate = DateTime(date.year, date.month, date.day);

    if (itemDate == today) {
      return 'HOJE';
    } else if (itemDate == yesterday) {
      return 'ONTEM';
    } else {
      final months = [
        'JANEIRO',
        'FEVEREIRO',
        'MARÇO',
        'ABRIL',
        'MAIO',
        'JUNHO',
        'JULHO',
        'AGOSTO',
        'SETEMBRO',
        'OUTUBRO',
        'NOVEMBRO',
        'DEZEMBRO',
      ];
      return '${date.day} DE ${months[date.month - 1]}';
    }
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TransactionService _transactionService = TransactionService();
  bool _isLoading = true;
  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    final savedModels = await _transactionService.getTransactions();
    setState(() {
      _transactions = savedModels
          .map((model) => Transaction.fromModel(model))
          .toList();
      _isLoading = false;
    });
  }

  Future<void> _clearTransactions() async {
    setState(() => _isLoading = true);
    await _transactionService.clearAll();
    _transactions = [];
    setState(() => _isLoading = false);
  }

  Map<String, List<Transaction>> get _groupedTransactions {
    final Map<String, List<Transaction>> grouped = {};
    for (var transaction in _transactions) {
      grouped.putIfAbsent(transaction.dateSection, () => []).add(transaction);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupedTransactions;

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
            icon: Icon(Icons.delete_forever, color: Colors.redAccent, size: 24),
            onPressed: _clearTransactions, // Permite recarregar manualmente
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black, size: 24),
            onPressed: _loadTransactions, // Permite recarregar manualmente
          ),
          SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _transactions.isEmpty
          ? Center(
              child: Text(
                'Nenhuma transação registrada',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView(
              children: grouped.entries.expand((entry) {
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
