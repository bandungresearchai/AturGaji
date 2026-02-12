/// Model for pre-set saving challenges
///
/// Represents a pre-defined challenge that users can select to start
/// their saving journey.
class Challenge {
  final String id;
  final String name;
  final String description;
  final String? dailyAmount; // "10000" or null if not daily
  final double? targetAmount; // Total target amount
  final int? durationDays; // Challenge duration in days
  final String? icon; // Icon asset path
  final String difficulty; // easy, medium, hard

  Challenge({
    required this.id,
    required this.name,
    required this.description,
    this.dailyAmount,
    this.targetAmount,
    this.durationDays,
    this.icon,
    this.difficulty = 'medium',
  });

  /// Calculate total target amount from daily amount
  double? get calculatedTargetAmount {
    if (dailyAmount != null && durationDays != null) {
      return double.tryParse(dailyAmount!) != null
          ? (double.parse(dailyAmount!) * durationDays!)
          : targetAmount;
    }
    return targetAmount;
  }

  @override
  String toString() =>
      'Challenge(id: $id, name: $name, difficulty: $difficulty)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Challenge &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.dailyAmount == dailyAmount &&
        other.targetAmount == targetAmount &&
        other.durationDays == durationDays &&
        other.icon == icon &&
        other.difficulty == difficulty;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        dailyAmount.hashCode ^
        targetAmount.hashCode ^
        durationDays.hashCode ^
        icon.hashCode ^
        difficulty.hashCode;
  }
}
