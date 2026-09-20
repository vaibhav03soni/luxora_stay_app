import 'package:flutter/foundation.dart';

class PaymentResult {
  final bool success;
  final String? transactionId;
  final String? errorMessage;

  PaymentResult({required this.success, this.transactionId, this.errorMessage});
}

abstract class PaymentService {
  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
    required String orderId,
  });
}

class MockPaymentService implements PaymentService {
  @override
  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
    required String orderId,
  }) async {
    // Simulate a real payment gateway process
    debugPrint('Starting payment for amount: $amount $currency');
    await Future.delayed(const Duration(seconds: 2));

    final String txId = 'TXN_${DateTime.now().millisecondsSinceEpoch}';
    debugPrint('Payment Successful: $txId');
    return PaymentResult(success: true, transactionId: txId);
  }
}
