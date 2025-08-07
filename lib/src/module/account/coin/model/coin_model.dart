class CoinTransactionResponse {
  final bool success;
  final List<CoinTransaction> data;

  CoinTransactionResponse({
    required this.success,
    required this.data,
  });

  factory CoinTransactionResponse.fromJson(Map<String, dynamic> json) {
    return CoinTransactionResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? List<CoinTransaction>.from(
              json['data'].map((x) => CoinTransaction.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}

class CoinTransaction {
  final int id;
  final int coins;
  final String transactionType;
  final String reference;
  final DateTime createdAt;

  CoinTransaction({
    required this.id,
    required this.coins,
    required this.transactionType,
    required this.reference,
    required this.createdAt,
  });

  factory CoinTransaction.fromJson(Map<String, dynamic> json) {
    return CoinTransaction(
      id: json['id'] ?? 0,
      coins: json['coins'] ?? 0,
      transactionType: json['transaction_type'] ?? '',
      reference: json['reference'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coins': coins,
      'transaction_type': transactionType,
      'reference': reference,
      'created_at': createdAt.toIso8601String(),
    };
  }
}