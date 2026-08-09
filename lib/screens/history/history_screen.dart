import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import '../../services/transaction_service.dart';
import 'widgets/transaction_card.dart';
import 'widgets/section_header.dart';

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

    if (itemDate == today) return 'HOJE';
    if (itemDate == yesterday) return 'ONTEM';

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
            onPressed: _clearTransactions,
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black, size: 24),
            onPressed: _loadTransactions,
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
              children: _groupedTransactions.entries.expand((entry) {
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
