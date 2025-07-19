class Donation {
  final String donorName;
  final double amount;
  final DateTime date;

  Donation({
    required this.donorName,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'donorName': donorName,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory Donation.fromMap(Map<String, dynamic> map) {
    return Donation(
      donorName: map['donorName'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
    );
  }
}
