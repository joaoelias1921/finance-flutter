import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';

class TransactionService {
  static const String _storageKey = 'user_transactions';

  Future<List<TransactionModel>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_storageKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    final List<dynamic> decodedData = jsonDecode(data);
    return decodedData.map((item) => TransactionModel.fromJson(item)).toList();
  }

  Future<void> saveTransaction(TransactionModel transaction) async {
    final prefs = await SharedPreferences.getInstance();
    final List<TransactionModel> currentList = await getTransactions();
    currentList.insert(0, transaction);

    final String encodedData = jsonEncode(
      currentList.map((transaction) => transaction.toJson()).toList(),
    );
    await prefs.setString(_storageKey, encodedData);
  }

  Future<double> getBalance() async {
    final transactions = await getTransactions();
    double balance = 0;

    for (var t in transactions) {
      if (!t.isExpense) {
        balance += t.amount;
        continue;
      }
      balance -= t.amount;
    }
    return balance;
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
