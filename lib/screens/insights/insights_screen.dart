import 'package:flutter/material.dart';
import '../../services/transaction_service.dart';
import 'insights_calculator.dart';
import 'widgets/alert_card.dart';
import 'widgets/financial_index_card.dart';
import 'widgets/health_section.dart';
import 'widgets/major_impacts_section.dart';
import 'widgets/thermometer_bar.dart';

class InsightsScreen extends StatefulWidget {
  final VoidCallback onNavigateToHistory;

  const InsightsScreen({super.key, required this.onNavigateToHistory});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final TransactionService _transactionService = TransactionService();
  final FinancialCalculator _financialCalculator = FinancialCalculator();
  bool _isLoading = true;
  FinancialInsightsData? _data;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final transactions = await _transactionService.getTransactions();
    setState(() {
      _data = _financialCalculator.process(transactions);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Termômetro de Gastos',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: _isLoading || _data == null
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ThermometerBar(),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HealthSection(financialIndex: _data!.financialIndex),
                          SizedBox(height: 24),
                          FinancialIndexCard(
                            financialIndex: _data!.financialIndex,
                            isLastExpense: _data!.isLastExpense,
                          ),
                          SizedBox(height: 32),
                          MajorImpactsSection(topImpacts: _data!.topImpacts),
                          SizedBox(height: 32),
                          AlertCard(
                            mostFrequentCategoryCount:
                                _data!.mostFrequentCategoryCount,
                            mostFrequentCategoryName:
                                _data!.mostFrequentCategoryName,
                            onNavigateToHistory: widget.onNavigateToHistory,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
