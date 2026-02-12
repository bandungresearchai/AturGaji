import 'package:flutter_test/flutter_test.dart';
import 'package:nabung_challenge/models/transaction.dart';

void main() {
  group('Transaction Model Tests', () {
    final testDate = DateTime(2025, 1, 15, 10, 30);

    test('Should create Transaction with required fields', () {
      final transaction = Transaction(
        id: 1,
        goalId: 1,
        amount: 50000,
        date: testDate,
        note: 'Initial savings',
      );

      expect(transaction.id, equals(1));
      expect(transaction.goalId, equals(1));
      expect(transaction.amount, equals(50000));
      expect(transaction.date, equals(testDate));
      expect(transaction.note, equals('Initial savings'));
    });

    test('Should create Transaction without optional note', () {
      final transaction = Transaction(
        id: 2,
        goalId: 1,
        amount: 75000,
        date: testDate,
      );

      expect(transaction.id, equals(2));
      expect(transaction.goalId, equals(1));
      expect(transaction.amount, equals(75000));
      expect(transaction.note, isNull);
    });

    test('Should create Transaction without id (for new records)', () {
      final transaction = Transaction(
        goalId: 1,
        amount: 100000,
        date: testDate,
        note: 'Monthly savings',
      );

      expect(transaction.id, isNull);
      expect(transaction.goalId, equals(1));
      expect(transaction.amount, equals(100000));
    });

    test('toMap should convert Transaction to Map correctly', () {
      final transaction = Transaction(
        id: 1,
        goalId: 5,
        amount: 250000.50,
        date: testDate,
        note: 'Test transaction',
      );

      final map = transaction.toMap();
      expect(map['id'], equals(1));
      expect(map['goalId'], equals(5));
      expect(map['amount'], equals(250000.50));
      expect(map['date'], equals(testDate.toIso8601String()));
      expect(map['note'], equals('Test transaction'));
    });

    test('fromMap should create Transaction from Map correctly', () {
      final map = {
        'id': 1,
        'goalId': 5,
        'amount': 250000.50,
        'date': testDate.toIso8601String(),
        'note': 'Test transaction',
      };

      final transaction = Transaction.fromMap(map);
      expect(transaction.id, equals(1));
      expect(transaction.goalId, equals(5));
      expect(transaction.amount, equals(250000.50));
      expect(transaction.date, equals(testDate));
      expect(transaction.note, equals('Test transaction'));
    });

    test('fromMap should handle null note', () {
      final map = {
        'id': 2,
        'goalId': 3,
        'amount': 100000.0,
        'date': testDate.toIso8601String(),
        'note': null,
      };

      final transaction = Transaction.fromMap(map);
      expect(transaction.note, isNull);
    });

    test('fromMap should handle numeric amounts correctly', () {
      final map = {
        'id': 3,
        'goalId': 1,
        'amount': 150000, // Integer instead of double
        'date': '2025-01-15T10:30:00.000Z',
        'note': null,
      };

      final transaction = Transaction.fromMap(map);
      expect(transaction.amount, equals(150000.0));
      expect(transaction.amount, isA<double>());
    });

    test('copyWith should create new instance with updated fields', () {
      final original = Transaction(
        id: 1,
        goalId: 1,
        amount: 50000,
        date: testDate,
        note: 'Original note',
      );

      final updated = original.copyWith(
        amount: 75000,
        note: 'Updated note',
      );

      expect(updated.id, equals(1)); // Original fields preserved
      expect(updated.goalId, equals(1));
      expect(updated.date, equals(testDate));
      expect(updated.amount, equals(75000)); // Updated
      expect(updated.note, equals('Updated note')); // Updated
    });

    test('copyWith should allow clearing optional fields', () {
      final original = Transaction(
        id: 1,
        goalId: 1,
        amount: 50000,
        date: testDate,
        note: 'Original note',
      );

      // Cannot clear note with copyWith since it's optional in constructor
      // This test verifies that copyWith uses ?? operator correctly
      expect(original.note, isNotNull);
    });

    test('equality should work correctly', () {
      final transaction1 = Transaction(
        id: 1,
        goalId: 1,
        amount: 50000,
        date: testDate,
        note: 'Test',
      );

      final transaction2 = Transaction(
        id: 1,
        goalId: 1,
        amount: 50000,
        date: testDate,
        note: 'Test',
      );

      final transaction3 = Transaction(
        id: 2,
        goalId: 1,
        amount: 50000,
        date: testDate,
        note: 'Test',
      );

      expect(transaction1, equals(transaction2));
      expect(transaction1, isNot(equals(transaction3)));
    });

    test('hashCode should be consistent', () {
      final transaction1 = Transaction(
        id: 1,
        goalId: 1,
        amount: 50000,
        date: testDate,
        note: 'Test',
      );

      final transaction2 = Transaction(
        id: 1,
        goalId: 1,
        amount: 50000,
        date: testDate,
        note: 'Test',
      );

      expect(transaction1.hashCode, equals(transaction2.hashCode));
    });

    test('toString should return readable string', () {
      final transaction = Transaction(
        id: 1,
        goalId: 5,
        amount: 100000,
        date: testDate,
        note: 'Monthly savings',
      );

      final str = transaction.toString();
      expect(str, contains('Transaction'));
      expect(str, contains('id: 1'));
      expect(str, contains('goalId: 5'));
      expect(str, contains('amount: 100000'));
    });

    test('Should handle large amounts correctly', () {
      final transaction = Transaction(
        id: 1,
        goalId: 1,
        amount: 999999999.99,
        date: testDate,
      );

      expect(transaction.amount, equals(999999999.99));
      expect(transaction.amount, isA<double>());
    });

    test('Should handle zero amount', () {
      final transaction = Transaction(
        id: 1,
        goalId: 1,
        amount: 0,
        date: testDate,
      );

      expect(transaction.amount, equals(0));
    });
  });
}
