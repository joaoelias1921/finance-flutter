import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';

class CategoryImpact {
  final String label;
  final double totalAmount;
  final double percentage;
  final Color color;
  final IconData icon;

  const CategoryImpact({
    required this.label,
    required this.totalAmount,
    required this.percentage,
    required this.color,
    required this.icon,
  });
}

class FinancialInsightsData {
  final double financialIndex;
  final List<CategoryImpact> topImpacts;
  final String mostFrequentCategoryName;
  final int mostFrequentCategoryCount;
  final bool isLastExpense;

  const FinancialInsightsData({
    required this.financialIndex,
    required this.topImpacts,
    required this.mostFrequentCategoryName,
    required this.mostFrequentCategoryCount,
    required this.isLastExpense,
  });
}

class _TransactionTotals {
  double incomeSum = 0;
  double expenseSum = 0;
  final Map<String, double> categorySums = {};
  final Map<String, int> categoryCounts = {};
  final Map<String, CategoryItemData> categoryInfo = {};
}

class MostFrequentCategory {
  final String label;
  final int count;

  const MostFrequentCategory({required this.label, required this.count});
}

class FinancialCalculator {
  FinancialInsightsData process(List<TransactionModel> transactions) {
    final totals = _accumulateTotals(transactions);
    final mostFrequentCategory = _identifyMostFrequentCategory(
      totals.categoryCounts,
    );

    return FinancialInsightsData(
      financialIndex: _calculateFinancialIndex(
        totals.incomeSum,
        totals.expenseSum,
      ),
      topImpacts: _calculateTopImpacts(
        totals.expenseSum,
        totals.categorySums,
        totals.categoryInfo,
      ),
      mostFrequentCategoryName: mostFrequentCategory.label,
      mostFrequentCategoryCount: mostFrequentCategory.count,
      isLastExpense: transactions.isNotEmpty
          ? transactions.first.isExpense
          : false,
    );
  }

  _TransactionTotals _accumulateTotals(List<TransactionModel> transactions) {
    final totals = _TransactionTotals();
    for (var t in transactions) {
      if (!t.isExpense) {
        totals.incomeSum += t.amount;
        continue;
      }
      totals.expenseSum += t.amount;
      totals.categorySums[t.categoryLabel] =
          (totals.categorySums[t.categoryLabel] ?? 0) + t.amount;
      totals.categoryCounts[t.categoryLabel] =
          (totals.categoryCounts[t.categoryLabel] ?? 0) + 1;
      totals.categoryInfo[t.categoryLabel] = _getCategoryData(t.categoryId);
    }
    return totals;
  }

  CategoryItemData _getCategoryData(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'essential':
        return CategoryItemData(
          color: Color(0xFF10B981),
          icon: Icons.interests_outlined,
        );
      case 'fun':
        return CategoryItemData(
          color: Color(0xFFF59E0B),
          icon: Icons.sports_esports_outlined,
        );
      case 'finance':
        return CategoryItemData(
          color: Color(0xFF3B82F6),
          icon: Icons.analytics,
        );
      default:
        return CategoryItemData(
          color: Color(0xFFEF4444),
          icon: Icons.redeem_outlined,
        );
    }
  }

  MostFrequentCategory _identifyMostFrequentCategory(
    Map<String, int> categoryCounts,
  ) {
    String topCategoryLabel = '';
    int topCategoryCount = 0;
    categoryCounts.forEach((label, count) {
      if (count > topCategoryCount) {
        topCategoryCount = count;
        topCategoryLabel = label;
      }
    });

    return MostFrequentCategory(
      label: topCategoryLabel,
      count: topCategoryCount,
    );
  }

  double _calculateFinancialIndex(double incomeSum, double expenseSum) {
    if (incomeSum > 0) {
      final ratio = expenseSum / incomeSum;
      return (10 - (ratio * 5)).clamp(1.0, 10.0);
    }
    if (expenseSum > 0) return 3.0;
    return 10.0;
  }

  List<CategoryImpact> _calculateTopImpacts(
    double expenseSum,
    Map<String, double> categorySums,
    Map<String, CategoryItemData> categoryInfo,
  ) {
    if (expenseSum == 0) return [];
    final List<CategoryImpact> impacts = [];

    categorySums.forEach((label, amount) {
      final percentage = (amount / expenseSum) * 100;
      final info =
          categoryInfo[label] ??
          CategoryItemData(color: Color(0xFF6B7280), icon: Icons.category);

      impacts.add(
        CategoryImpact(
          label: label,
          totalAmount: amount,
          percentage: percentage,
          color: info.color,
          icon: info.icon,
        ),
      );
    });
    impacts.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
    return impacts;
  }
}

class CategoryItemData {
  final Color color;
  final IconData icon;
  CategoryItemData({required this.color, required this.icon});
}
