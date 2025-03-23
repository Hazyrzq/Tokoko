// File: lib/services/transaction_service.dart

import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class Transaction {
  final String id;
  final List<CartItem> items;
  final String date;
  final double totalAmount;
  final String status;
  final String image; // Image of the first item
  final String description;

  Transaction({
    required this.id,
    required this.items,
    required this.date,
    required this.totalAmount,
    required this.status,
    required this.image,
    required this.description,
  });
}

class TransactionService extends ChangeNotifier {
  // Singleton pattern
  static final TransactionService _instance = TransactionService._internal();
  
  factory TransactionService() {
    return _instance;
  }
  
  TransactionService._internal();
  
  // Daftar transaksi - mulai dengan list kosong
  final List<Transaction> _transactions = [];
  
  // Getter untuk mendapatkan semua transaksi
  List<Transaction> get transactions => _transactions;
  
  // Menambahkan transaksi baru
  void addTransaction(List<CartItem> items, double totalAmount) {
    // Generate random order ID
    final orderId = '#${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    
    // Get current date in "Month DD" format
    final date = _formatDate(DateTime.now());
    
    // Get image and description from the first item
    final firstItem = items.first;
    final image = firstItem.imageUrl;
    
    // Create a short description
    final itemNames = items.map((item) => item.name).join(', ');
    final description = items.length > 1 
        ? '${firstItem.name} dan ${items.length - 1} item lainnya'
        : firstItem.name;
    
    // Create new transaction
    final newTransaction = Transaction(
      id: orderId,
      items: List.from(items),
      date: date,
      totalAmount: totalAmount,
      status: 'Completed',
      image: image,
      description: description,
    );
    
    // Add to the list
    _transactions.insert(0, newTransaction);
    
    // Notify listeners
    notifyListeners();
  }
  
  // Format date to "Month DD" format
  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    final month = months[date.month - 1];
    final day = date.day.toString().padLeft(2, '0');
    
    return '$month $day';
  }
}