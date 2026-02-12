/// Model for a saving transaction
///
/// Represents each transaction (deposit) made towards a saving goal.
class Transaction {
  final int? id;
  final int goalId;
  final double amount;
  final DateTime date;
  final String? note;

  Transaction({
    this.id,
    required this.goalId,
    required this.amount,
    required this.date,
    this.note,
  });

  /// Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'goalId': goalId,
      'amount': amount,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  /// Create Transaction from Map (database row)
  static Transaction fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as int?,
      goalId: map['goalId'] as int,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      note: map['note'] as String?,
    );
  }

  /// Create a copy with modified fields
  Transaction copyWith({
    int? id,
    int? goalId,
    double? amount,
    DateTime? date,
    String? note,
  }) {
    return Transaction(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }

  @override
  String toString() => 'Transaction(id: $id, goalId: $goalId, '
      'amount: $amount, date: ${date.toIso8601String()}, note: $note)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Transaction &&
        other.id == id &&
        other.goalId == goalId &&
        other.amount == amount &&
        other.date == date &&
        other.note == note;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        goalId.hashCode ^
        amount.hashCode ^
        date.hashCode ^
        note.hashCode;
  }
}
