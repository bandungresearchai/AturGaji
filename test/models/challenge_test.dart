import 'package:flutter_test/flutter_test.dart';
import 'package:nabung_challenge/models/challenge.dart';

void main() {
  group('Challenge Model Tests', () {
    test('Should create Challenge with required fields', () {
      final challenge = Challenge(
        id: 'daily_10k',
        name: 'Nabung 10K Sehari',
        description: 'Save 10,000 IDR every day',
        dailyAmount: '10000',
        durationDays: 30,
        difficulty: 'easy',
      );

      expect(challenge.id, equals('daily_10k'));
      expect(challenge.name, equals('Nabung 10K Sehari'));
      expect(challenge.description, equals('Save 10,000 IDR every day'));
      expect(challenge.dailyAmount, equals('10000'));
      expect(challenge.durationDays, equals(30));
      expect(challenge.difficulty, equals('easy'));
    });

    test('Should create Challenge with default difficulty', () {
      final challenge = Challenge(
        id: 'test',
        name: 'Test Challenge',
        description: 'Test',
      );

      expect(challenge.difficulty, equals('medium'));
    });

    test('calculatedTargetAmount should calculate from dailyAmount and durationDays', () {
      final challenge = Challenge(
        id: 'daily_10k',
        name: 'Nabung 10K Sehari',
        description: 'Save 10,000 IDR every day',
        dailyAmount: '10000',
        durationDays: 30,
      );

      expect(challenge.calculatedTargetAmount, equals(300000.0));
    });

    test('calculatedTargetAmount should return targetAmount when dailyAmount is invalid', () {
      final challenge = Challenge(
        id: 'test',
        name: 'Test',
        description: 'Test',
        dailyAmount: 'invalid',
        durationDays: 30,
        targetAmount: 500000,
      );

      expect(challenge.calculatedTargetAmount, equals(500000));
    });

    test('calculatedTargetAmount should return null when both are null', () {
      final challenge = Challenge(
        id: 'test',
        name: 'Test',
        description: 'Test',
      );

      expect(challenge.calculatedTargetAmount, isNull);
    });

    test('calculatedTargetAmount should return targetAmount when dailyAmount is null', () {
      final challenge = Challenge(
        id: 'fixed',
        name: 'Fixed Target',
        description: 'Test',
        targetAmount: 1000000,
        durationDays: 60,
      );

      expect(challenge.calculatedTargetAmount, equals(1000000));
    });

    test('calculatedTargetAmount should return targetAmount when durationDays is null', () {
      final challenge = Challenge(
        id: 'test',
        name: 'Test',
        description: 'Test',
        dailyAmount: '10000',
        targetAmount: 500000,
      );

      expect(challenge.calculatedTargetAmount, equals(500000));
    });

    test('Should handle decimal dailyAmount', () {
      final challenge = Challenge(
        id: 'decimal',
        name: 'Decimal Challenge',
        description: 'Test',
        dailyAmount: '10000.50',
        durationDays: 20,
      );

      expect(challenge.calculatedTargetAmount, equals(200001.0));
    });

    test('Should handle large values', () {
      final challenge = Challenge(
        id: 'large',
        name: 'Large Challenge',
        description: 'Test',
        dailyAmount: '1000000',
        durationDays: 365,
      );

      expect(challenge.calculatedTargetAmount, equals(365000000.0));
    });

    test('toString should return readable string', () {
      final challenge = Challenge(
        id: 'daily_10k',
        name: 'Nabung 10K Sehari',
        description: 'Test',
        difficulty: 'easy',
      );

      final str = challenge.toString();
      expect(str, contains('Challenge'));
      expect(str, contains('daily_10k'));
      expect(str, contains('Nabung 10K Sehari'));
      expect(str, contains('easy'));
    });

    test('Equality should work correctly', () {
      final challenge1 = Challenge(
        id: 'test',
        name: 'Test Challenge',
        description: 'Description',
        dailyAmount: '10000',
        targetAmount: 300000,
        durationDays: 30,
        difficulty: 'medium',
      );

      final challenge2 = Challenge(
        id: 'test',
        name: 'Test Challenge',
        description: 'Description',
        dailyAmount: '10000',
        targetAmount: 300000,
        durationDays: 30,
        difficulty: 'medium',
      );

      final challenge3 = Challenge(
        id: 'different',
        name: 'Different Challenge',
        description: 'Description',
        difficulty: 'hard',
      );

      expect(challenge1, equals(challenge2));
      expect(challenge1, isNot(equals(challenge3)));
    });

    test('hashCode should be consistent', () {
      final challenge1 = Challenge(
        id: 'test',
        name: 'Test Challenge',
        description: 'Description',
        difficulty: 'medium',
      );

      final challenge2 = Challenge(
        id: 'test',
        name: 'Test Challenge',
        description: 'Description',
        difficulty: 'medium',
      );

      expect(challenge1.hashCode, equals(challenge2.hashCode));
    });

    test('Should support different difficulty levels', () {
      final easyChallenge = Challenge(
        id: 'easy',
        name: 'Easy',
        description: 'Test',
        difficulty: 'easy',
      );

      final mediumChallenge = Challenge(
        id: 'medium',
        name: 'Medium',
        description: 'Test',
        difficulty: 'medium',
      );

      final hardChallenge = Challenge(
        id: 'hard',
        name: 'Hard',
        description: 'Test',
        difficulty: 'hard',
      );

      expect(easyChallenge.difficulty, equals('easy'));
      expect(mediumChallenge.difficulty, equals('medium'));
      expect(hardChallenge.difficulty, equals('hard'));
    });

    test('Should handle optional icon field', () {
      final challengeWithIcon = Challenge(
        id: 'with_icon',
        name: 'With Icon',
        description: 'Test',
        icon: 'assets/icons/challenge.png',
      );

      final challengeWithoutIcon = Challenge(
        id: 'without_icon',
        name: 'Without Icon',
        description: 'Test',
      );

      expect(challengeWithIcon.icon, equals('assets/icons/challenge.png'));
      expect(challengeWithoutIcon.icon, isNull);
    });

    test('Should handle zero daily amount', () {
      final challenge = Challenge(
        id: 'zero',
        name: 'Zero',
        description: 'Test',
        dailyAmount: '0',
        durationDays: 30,
      );

      expect(challenge.calculatedTargetAmount, equals(0.0));
    });
  });
}
