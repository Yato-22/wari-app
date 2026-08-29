class DonationRecord {
  final String id;
  final double amount;
  final String campName;
  final String donorName;
  final String donorPhone;
  final String paymentMode;
  final DateTime timestamp;
  final bool isAnonymous;
  final bool taxReceiptRequired;
  final String? panNumber;

  const DonationRecord({
    required this.id,
    required this.amount,
    required this.campName,
    required this.donorName,
    required this.donorPhone,
    required this.paymentMode,
    required this.timestamp,
    this.isAnonymous = false,
    this.taxReceiptRequired = false,
    this.panNumber,
  });
}

