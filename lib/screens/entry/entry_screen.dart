import 'package:finance_flutter/extensions/string_extension.dart';
import 'package:finance_flutter/models/transaction_model.dart';
import 'package:finance_flutter/screens/entry/widgets/category_selector.dart';
import 'package:finance_flutter/screens/entry/widgets/large_keyboard.dart';
import 'package:finance_flutter/screens/entry/widgets/transaction_type_toggle.dart';
import 'package:finance_flutter/screens/entry/widgets/value_display.dart';
import 'package:finance_flutter/services/transaction_service.dart';
import 'package:flutter/material.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final TransactionService _transactionService = TransactionService();

  bool _isExpense = true;
  int _rawValueInCents = 0;
  bool _isLoadingBalance = true;
  double _currentBalance = 0;

  String get _formattedValue {
    double value = _rawValueInCents / 100.0;
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  double get _doubleValue => _rawValueInCents / 100.0;
  Color get _activeColor => _isExpense ? Color(0xFFEF4444) : Color(0xFF10B981);
  String get _formattedBalance {
    return 'R\$ ${_currentBalance.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    final balance = await _transactionService.getBalance();
    if (!mounted) return;
    setState(() {
      _currentBalance = balance;
      _isLoadingBalance = false;
    });
  }

  void _onKeyPress(String key) {
    setState(() {
      if (_rawValueInCents < 99999999) {
        _rawValueInCents = (_rawValueInCents * 10) + int.parse(key);
      }
    });
  }

  void _onDelete() {
    setState(() {
      _rawValueInCents = _rawValueInCents ~/ 10;
    });
  }

  void _resetValue() {
    setState(() {
      _rawValueInCents = 0;
    });
  }

  void _saveTransaction(CategoryItem category, double amount) async {
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, insira um valor maior que R\$ 0,00'),
        ),
      );
      return;
    }

    final newTransaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      categoryId: category.id,
      categoryLabel: category.label,
      isExpense: _isExpense,
      date: DateTime.now(),
    );

    await _transactionService.saveTransaction(newTransaction);
    await _loadBalance();
    if (!mounted) return;

    final typeLabel = _isExpense ? 'Saída' : 'Entrada';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$typeLabel de R\$ $_formattedValue salva em ${category.label.capitalize()}!',
        ),
        backgroundColor: category.color,
      ),
    );

    _resetValue();
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
          'Saldo: ${_isLoadingBalance ? 'R\$ ...' : _formattedBalance}',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SizedBox(height: 32),
          TransactionTypeToggle(
            isExpense: _isExpense,
            onChanged: (value) => setState(() => _isExpense = value),
          ),
          ValueDisplay(
            doubleValue: _doubleValue,
            formattedValue: _formattedValue,
            activeColor: _activeColor,
          ),
          LargeKeyboard(onKeyPressed: _onKeyPress, onDeletePressed: _onDelete),
          SizedBox(height: 32),
          CategorySelector(
            isExpense: _isExpense,
            onCategoryDropped: (category, amount) =>
                _saveTransaction(category, amount),
          ),
        ],
      ),
    );
  }
}
