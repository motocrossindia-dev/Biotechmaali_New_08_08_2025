class WalletDetailsResponse {
  final String message;
  final WalletData data;

  WalletDetailsResponse({required this.message, required this.data});

  factory WalletDetailsResponse.fromJson(Map<String, dynamic> json) {
    return WalletDetailsResponse(
      message: json['message'],
      data: WalletData.fromJson(json['data']),
    );
  }
}

class WalletData {
  final String balance;
  final DateTime createdAt;
  final DateTime updatedAt;

  WalletData({
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      balance: json['balance'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class TransactionsResponse {
  final String message;
  final TransactionData data;

  TransactionsResponse({required this.message, required this.data});

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) {
    return TransactionsResponse(
      message: json['message'],
      data: TransactionData.fromJson(json['data']),
    );
  }
}

class TransactionData {
  final double balance;
  final List<Transaction> transactions;

  TransactionData({required this.balance, required this.transactions});

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      balance: double.parse(json['balance'].toString()),
      transactions: (json['transactions'] as List)
          .map((t) => Transaction.fromJson(t))
          .toList(),
    );
  }
}

class Transaction {
  final String transactionType;
  final String amount;
  final String status;
  final String? referenceId; // Made nullable
  final String description;
  final DateTime createdAt;

  Transaction({
    required this.transactionType,
    required this.amount,
    required this.status,
    this.referenceId, // Made optional
    required this.description,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionType: json['transaction_type'] ?? '',
      amount: json['amount']?.toString() ?? '0.00',
      status: json['status'] ?? '',
      referenceId: json['reference_id'], // Can be null
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  bool get isCredit => transactionType == 'CREDIT';
}
