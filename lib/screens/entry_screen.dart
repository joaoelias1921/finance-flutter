import 'package:finance_flutter/extensions/string_extension.dart';
import 'package:finance_flutter/models/transaction_model.dart';
import 'package:finance_flutter/services/transaction_service.dart';
import 'package:flutter/material.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final TransactionService _transactionService = TransactionService();
  int _rawValueInCents = 0;
  bool _isExpense = true;
  bool _isLoadingBalance = true;
  double _currentBalance = 0;

  String get _formattedValue {
    double value = _rawValueInCents / 100.0;
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  double get _doubleValue => _rawValueInCents / 100.0;

  Color get _activeColor => _isExpense ? Color(0xFFEF4444) : Color(0xFF10B981);

  @override
  void initState() {
    super.initState();
    _loadBalance();
  }

  Future<void> _loadBalance() async {
    final balance = await _transactionService.getBalance();
    setState(() {
      _currentBalance = balance;
      _isLoadingBalance = false;
    });
  }

  String get _formattedBalance {
    return 'R\$ ${_currentBalance.toStringAsFixed(2).replaceAll('.', ',')}';
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
          _buildTransactionTypeToggle(),
          Container(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              'NOVO VALOR',
              style: TextStyle(fontSize: 12, letterSpacing: 4),
              textAlign: TextAlign.center,
            ),
          ),

          Center(
            child: Draggable<double>(
              data: _doubleValue,
              dragAnchorStrategy: pointerDragAnchorStrategy,
              feedback: Material(
                color: Colors.transparent,
                child: Transform.translate(
                  offset: Offset(-60, -30),
                  child: Text(
                    _formattedValue,
                    style: TextStyle(
                      fontSize: 50,
                      color: _activeColor.withValues(alpha: 0.8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              childWhenDragging: Opacity(opacity: 0.3, child: _buildValueRow()),
              child: _buildValueRow(),
            ),
          ),

          Container(
            padding: EdgeInsets.only(top: 4, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Arraste para categorizar',
                  style: TextStyle(fontSize: 14, color: Color(0xFF3B82F6)),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_downward, size: 16, color: Color(0xFF3B82F6)),
              ],
            ),
          ),

          LargeKeyboard(onKeyPressed: _onKeyPress, onDeletePressed: _onDelete),
          SizedBox(height: 32),
          CategorySelector(
            isExpense: _isExpense,
            onCategoryDropped: (category, amount) {
              _saveTransaction(category, amount);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTypeToggle() {
    return Center(
      child: Container(
        width: 220,
        height: 40,
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isExpense = false),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: !_isExpense ? Color(0xFF10B981) : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Entrada',
                    style: TextStyle(
                      color: !_isExpense ? Colors.white : Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isExpense = true),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: _isExpense ? Color(0xFFEF4444) : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Saída',
                    style: TextStyle(
                      color: _isExpense ? Colors.white : Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      spacing: 4,
      children: [
        Text(
          'R\$',
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFF95B8FF),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          _formattedValue,
          style: TextStyle(
            fontSize: 60,
            color: Color(0xFF3B82F6),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class LargeKeyboard extends StatelessWidget {
  const LargeKeyboard({
    super.key,
    required this.onKeyPressed,
    required this.onDeletePressed,
  });

  final Function(String key)? onKeyPressed;
  final VoidCallback? onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        _buildKeyboardRow(['1', '2', '3']),
        _buildKeyboardRow(['4', '5', '6']),
        _buildKeyboardRow(['7', '8', '9']),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            _buildKeyboardButton('0', width: 184),
            _buildKeyboardButton('delete'),
          ],
        ),
      ],
    );
  }

  Widget _buildKeyboardRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: keys.map((key) => _buildKeyboardButton(key)).toList(),
    );
  }

  Widget _buildKeyboardButton(String key, {double width = 88}) {
    final isDelete = key == 'delete';

    return Material(
      color: !isDelete ? Colors.grey[300] : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (isDelete) {
            onDeletePressed?.call();
            return;
          }
          onKeyPressed?.call(key);
        },
        child: Container(
          width: width,
          height: 60,
          alignment: Alignment.center,
          child: isDelete
              ? Icon(
                  Icons.backspace_outlined,
                  color: Colors.redAccent,
                  size: 24,
                )
              : Text(
                  key,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
        ),
      ),
    );
  }
}

class CategoryItem {
  final String id;
  final String label;
  final IconData icon;
  final Color color;

  const CategoryItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
  });
}

class CategorySelector extends StatefulWidget {
  final bool isExpense;
  final Function(CategoryItem category, double amount)? onCategoryDropped;

  const CategorySelector({
    super.key,
    required this.isExpense,
    this.onCategoryDropped,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  List<CategoryItem> get _currentCategories {
    if (widget.isExpense) {
      return [
        CategoryItem(
          id: 'essential',
          label: 'ESSENCIAL',
          icon: Icons.interests,
          color: Color(0xFF3B82F6),
        ),
        CategoryItem(
          id: 'fun',
          label: 'ENTRETENIMENTO',
          icon: Icons.sports_esports,
          color: Color(0xFFD97706),
        ),
        CategoryItem(
          id: 'finance',
          label: 'FINANÇAS',
          icon: Icons.analytics,
          color: Color(0xFF10B981),
        ),
        CategoryItem(
          id: 'diverse',
          label: 'DIVERSOS',
          icon: Icons.redeem,
          color: Color(0xFFEF4444),
        ),
      ];
    }
    return [
      CategoryItem(
        id: 'salary',
        label: 'SALÁRIO',
        icon: Icons.payments,
        color: Color(0xFF10B981),
      ),
      CategoryItem(
        id: 'freelance',
        label: 'FREELANCE',
        icon: Icons.work,
        color: Color(0xFF3B82F6),
      ),
      CategoryItem(
        id: 'investments',
        label: 'RENDIMENTO',
        icon: Icons.trending_up,
        color: Color(0xFF8B5CF6),
      ),
      CategoryItem(
        id: 'other_income',
        label: 'OUTROS',
        icon: Icons.add_card,
        color: Color(0xFF6B7280),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _currentCategories.map((item) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: DragTarget<double>(
                  onAcceptWithDetails: (details) {
                    widget.onCategoryDropped?.call(item, details.data);
                  },
                  builder: (context, candidateData, rejectedData) {
                    final bool isHovered = candidateData.isNotEmpty;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: isHovered ? 84 : 72,
                          height: isHovered ? 84 : 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: item.color.withValues(
                              alpha: isHovered ? 0.30 : 0.08,
                            ),
                            border: Border.all(
                              color: isHovered
                                  ? item.color
                                  : item.color.withValues(alpha: 0.3),
                              width: isHovered ? 3.5 : 1.5,
                            ),
                            boxShadow: isHovered
                                ? [
                                    BoxShadow(
                                      color: item.color.withValues(alpha: 0.4),
                                      blurRadius: 12,
                                      offset: Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Icon(
                            item.icon,
                            color: item.color,
                            size: isHovered ? 38 : 32,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: isHovered ? item.color : Color(0xFF8E8E93),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
