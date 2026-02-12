import 'package:flutter_test/flutter_test.dart';
import 'package:nabung_challenge/models/saving_goal.dart';

void main() {
  group('SavingGoal Model Tests', () {
    final testDate = DateTime(2025, 1, 1);
    final targetDate = DateTime(2025, 12, 31);

    test('Should create SavingGoal with all fields', () {
      final goal = SavingGoal(
        id: 1,
        name: 'Holiday Fund',
        targetAmount: 10000000,
        currentAmount: 5000000,
        category: 'vacation',
        startDate: testDate,
        targetDate: targetDate,
        imageUrl: 'assets/images/goal1.png',
        isCompleted: false,
      );

      expect(goal.id, equals(1));
      expect(goal.name, equals('Holiday Fund'));
      expect(goal.targetAmount, equals(10000000));
      expect(goal.currentAmount, equals(5000000));
      expect(goal.category, equals('vacation'));
      expect(goal.isCompleted, equals(false));
    });

    test('progressPercentage should calculate correctly', () {
      final goal = SavingGoal(
        id: 1,
        name: 'Test Goal',
        targetAmount: 1000,
        currentAmount: 500,
        category: 'test',
        startDate: testDate,
        imageUrl: 'test.png',
      );

      expect(goal.progressPercentage, equals(50.0));
    });

    test('progressPercentage should return 0 when targetAmount is 0', () {
      final goal = SavingGoal(
        id: 1,
        name: 'Test Goal',
        targetAmount: 0,
        currentAmount: 0,
        category: 'test',
        startDate: testDate,
        imageUrl: 'test.png',
      );

      expect(goal.progressPercentage, equals(0.0));
    });

    test('remainingAmount should calculate correctly', () {
      final goal = SavingGoal(
        id: 1,
        name: 'Test Goal',
        targetAmount: 1000,
        currentAmount: 600,
        category: 'test',
        startDate: testDate,
        imageUrl: 'test.png',
      );

      expect(goal.remainingAmount, equals(400.0));
    });

    test('isOverTarget should return true when currentAmount >= targetAmount', () {
      final goal = SavingGoal(
        id: 1,
        name: 'Test Goal',
        targetAmount: 1000,
        currentAmount: 1500,
        category: 'test',
        startDate: testDate,
        imageUrl: 'test.png',
      );

      expect(goal.isOverTarget, equals(true));
    });

    test('isOverTarget should return false when currentAmount < targetAmount', () {
      final goal = SavingGoal(
        id: 1,
        name: 'Test Goal',
        targetAmount: 1000,
        currentAmount: 500,
        category: 'test',
        startDate: testDate,
        imageUrl: 'test.png',
      );

      expect(goal.isOverTarget, equals(false));
    });

    test('daysUntilTarget should return null when targetDate is null', () {
      final goal = SavingGoal(
        id: 1,
        name: 'Test Goal',
        targetAmount: 1000,
        currentAmount: 500,
        category: 'test',
        startDate: testDate,
        targetDate: null,
        imageUrl: 'test.png',
      );

      expect(goal.daysUntilTarget, isNull);
    });

    test('estimatedDailySavingsNeeded should calculate correctly', () {
      final futureDate = DateTime.now().add(const Duration(days: 10));
      final goal = SavingGoal(
        id: 1,
        name: 'Test Goal',
        targetAmount: 1000,
        currentAmount: 500,
        category: 'test',
        startDate: testDate,
        targetDate: futureDate,
        imageUrl: 'test.png',
      );

      final estimatedDaily = goal.estimatedDailySavingsNeeded;
      expect(estimatedDaily, greaterThan(0));
      expect(estimatedDaily, lessThanOrEqualTo(50.0)); // 500 / 10 days or less
    });

    test('toMap should convert SavingGoal to Map correctly', () {
      final goal = SavingGoal(
        id: 1,
        name: 'Test Goal',
        targetAmount: 1000,
        currentAmount: 500,
        category: 'test',
        startDate: testDate,
        imageUrl: 'test.png',
        isCompleted: false,
      );

      final map = goal.toMap();
      expect(map['id'], equals(1));
      expect(map['name'], equals('Test Goal'));
      expect(map['targetAmount'], equals(1000));
      expect(map['currentAmount'], equals(500));
      expect(map['isCompleted'], equals(0));
    });

    test('fromMap should create SavingGoal from Map correctly', () {
      final map = {
        'id': 1,
        'name': 'Test Goal',
        'targetAmount': 1000.0,
        'currentAmount': 500.0,
        'category': 'test',
        'startDate': testDate.toIso8601String(),
        'targetDate': null,
        'imageUrl': 'test.png',
        'isCompleted': 0,
        'completedDate': null,
      };

      final goal = SavingGoal.fromMap(map);
      expect(goal.id, equals(1));
      expect(goal.name, equals('Test Goal'));
      expect(goal.targetAmount, equals(1000.0));
      expect(goal.currentAmount, equals(500.0));
      expect(goal.isCompleted, equals(false));
    });

    test('copyWith should create new instance with updated fields', () {
      final goal = SavingGoal(
        id: 1,
        name: 'Original',
        targetAmount: 1000,
        currentAmount: 500,
        category: 'test',
        startDate: testDate,
        imageUrl: 'test.png',
      );

      final updated = goal.copyWith(
        name: 'Updated',
        currentAmount: 600,
      );

      expect(updated.name, equals('Updated'));
      expect(updated.currentAmount, equals(600));
      expect(updated.id, equals(1)); // Original fields preserved
      expect(updated.targetAmount, equals(1000));
    });

    test('equality should work correctly', () {
      final goal1 = SavingGoal(
        id: 1,
        name: 'Test',
        targetAmount: 1000,
        currentAmount: 500,
        category: 'test',
        startDate: testDate,
        imageUrl: 'test.png',
      );

      final goal2 = SavingGoal(
        id: 1,
        name: 'Test',
        targetAmount: 1000,
        currentAmount: 500,
        category: 'test',
        startDate: testDate,
        imageUrl: 'test.png',
      );

      final goal3 = SavingGoal(
        id: 2,
        name: 'Different',
        targetAmount: 2000,
        currentAmount: 1000,
        category: 'test',
        startDate: testDate,
        imageUrl: 'test.png',
      );

      expect(goal1, equals(goal2));
      expect(goal1, isNot(equals(goal3)));
    });

    test('hashCode should be consistent', () {
      final goal1 = SavingGoal(
        id: 1,
        name: 'Test',
        targetAmount: 1000,
        currentAmount: 500,
        category: 'test',
        startDate: testDate,
        imageUrl: 'test.png',
      );

      final goal2 = SavingGoal(
        id: 1,
        name: 'Test',
        targetAmount: 1000,
        currentAmount: 500,
        category: 'test',
        startDate: testDate,
        imageUrl: 'test.png',
      );

      expect(goal1.hashCode, equals(goal2.hashCode));
    });
  });
}
