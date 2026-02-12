/// Model for a saving goal
///
/// Represents a user's saving goal with target amount, current amount,
/// category, and completion status.
class SavingGoal {
  final int? id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final String category; // wedding, emergency, vehicle, etc.
  final DateTime startDate;
  final DateTime? targetDate;
  final String imageUrl;
  final bool isCompleted;
  final DateTime? completedDate;

  SavingGoal({
    this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.category,
    required this.startDate,
    this.targetDate,
    required this.imageUrl,
    this.isCompleted = false,
    this.completedDate,
  });

  /// Calculate progress percentage (0-100)
  double get progressPercentage {
    if (targetAmount == 0) return 0;
    return (currentAmount / targetAmount) * 100;
  }

  /// Calculate remaining amount to save
  double get remainingAmount {
    return targetAmount - currentAmount;
  }

  /// Check if goal is over target
  bool get isOverTarget {
    return currentAmount >= targetAmount;
  }

  /// Calculate days until target date
  int? get daysUntilTarget {
    if (targetDate == null) return null;
    return targetDate!.difference(DateTime.now()).inDays;
  }

  /// Calculate estimated daily savings needed
  double get estimatedDailySavingsNeeded {
    final daysLeft = daysUntilTarget;
    if (daysLeft == null || daysLeft <= 0) return 0;
    return remainingAmount / daysLeft;
  }

  /// Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'category': category,
      'startDate': startDate.toIso8601String(),
      'targetDate': targetDate?.toIso8601String(),
      'imageUrl': imageUrl,
      'isCompleted': isCompleted ? 1 : 0,
      'completedDate': completedDate?.toIso8601String(),
    };
  }

  /// Create SavingGoal from Map (database row)
  static SavingGoal fromMap(Map<String, dynamic> map) {
    return SavingGoal(
      id: map['id'] as int?,
      name: map['name'] as String,
      targetAmount: (map['targetAmount'] as num).toDouble(),
      currentAmount: (map['currentAmount'] as num).toDouble(),
      category: map['category'] as String,
      startDate: DateTime.parse(map['startDate'] as String),
      targetDate: map['targetDate'] != null
          ? DateTime.parse(map['targetDate'] as String)
          : null,
      imageUrl: map['imageUrl'] as String,
      isCompleted: (map['isCompleted'] as int?) == 1,
      completedDate: map['completedDate'] != null
          ? DateTime.parse(map['completedDate'] as String)
          : null,
    );
  }

  /// Create a copy with modified fields
  SavingGoal copyWith({
    int? id,
    String? name,
    double? targetAmount,
    double? currentAmount,
    String? category,
    DateTime? startDate,
    DateTime? targetDate,
    String? imageUrl,
    bool? isCompleted,
    DateTime? completedDate,
  }) {
    return SavingGoal(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      targetDate: targetDate ?? this.targetDate,
      imageUrl: imageUrl ?? this.imageUrl,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDate: completedDate ?? this.completedDate,
    );
  }

  @override
  String toString() => 'SavingGoal(id: $id, name: $name, targetAmount: $targetAmount, '
      'currentAmount: $currentAmount, category: $category, progress: ${progressPercentage.toStringAsFixed(1)}%)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SavingGoal &&
        other.id == id &&
        other.name == name &&
        other.targetAmount == targetAmount &&
        other.currentAmount == currentAmount &&
        other.category == category &&
        other.startDate == startDate &&
        other.targetDate == targetDate &&
        other.imageUrl == imageUrl &&
        other.isCompleted == isCompleted &&
        other.completedDate == completedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        targetAmount.hashCode ^
        currentAmount.hashCode ^
        category.hashCode ^
        startDate.hashCode ^
        targetDate.hashCode ^
        imageUrl.hashCode ^
        isCompleted.hashCode ^
        completedDate.hashCode;
  }
}
