import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/index.dart';

/// Service for handling all database operations
///
/// This class manages SQLite database for storing:
/// - Saving goals
/// - Transactions
/// - User preferences
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  static Database? _database;

  /// Get database instance, initialize if needed
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initializeDatabase();
    return _database!;
  }

  /// Initialize the database and create tables
  Future<Database> _initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'nabung_challenge.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
      onUpgrade: _upgradeTables,
    );
  }

  /// Create tables on first initialization
  Future<void> _createTables(Database db, int version) async {
    // Create saving_goals table
    await db.execute('''
      CREATE TABLE saving_goals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        targetAmount REAL NOT NULL,
        currentAmount REAL NOT NULL DEFAULT 0,
        category TEXT NOT NULL,
        startDate TEXT NOT NULL,
        targetDate TEXT,
        imageUrl TEXT NOT NULL DEFAULT '',
        isCompleted INTEGER NOT NULL DEFAULT 0,
        completedDate TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Create transactions table
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        goalId INTEGER NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        note TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (goalId) REFERENCES saving_goals (id) ON DELETE CASCADE
      )
    ''');

    // Create index for faster queries
    await db.execute('''
      CREATE INDEX idx_transactions_goalId ON transactions(goalId)
    ''');
  }

  /// Handle database upgrades
  Future<void> _upgradeTables(Database db, int oldVersion, int newVersion) async {
    // TODO: Handle future schema changes here
    // Example:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE saving_goals ADD COLUMN newColumn TEXT');
    // }
  }

  // ============ SAVING GOALS OPERATIONS ============

  /// Create a new saving goal
  Future<int> createGoal(SavingGoal goal) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    
    final goalData = goal.toMap();
    goalData['createdAt'] = now;
    goalData['updatedAt'] = now;
    
    return await db.insert('saving_goals', goalData);
  }

  /// Get all saving goals
  Future<List<SavingGoal>> getAllGoals() async {
    final db = await database;
    final maps = await db.query('saving_goals', orderBy: 'createdAt DESC');
    return List.generate(
      maps.length,
      (i) => SavingGoal.fromMap(maps[i]),
    );
  }

  /// Get all active (non-completed) goals
  Future<List<SavingGoal>> getActiveGoals() async {
    final db = await database;
    final maps = await db.query(
      'saving_goals',
      where: 'isCompleted = ?',
      whereArgs: [0],
      orderBy: 'createdAt DESC',
    );
    return List.generate(
      maps.length,
      (i) => SavingGoal.fromMap(maps[i]),
    );
  }

  /// Get a single goal by ID
  Future<SavingGoal?> getGoalById(int id) async {
    final db = await database;
    final maps = await db.query(
      'saving_goals',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return SavingGoal.fromMap(maps.first);
  }

  /// Update a saving goal
  Future<int> updateGoal(SavingGoal goal) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    
    final goalData = goal.toMap();
    goalData['updatedAt'] = now;

    return await db.update(
      'saving_goals',
      goalData,
      where: 'id = ?',
      whereArgs: [goal.id],
    );
  }

  /// Delete a saving goal and its transactions
  Future<int> deleteGoal(int id) async {
    final db = await database;
    return await db.delete(
      'saving_goals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get goals count (used for free user limit check)
  Future<int> getGoalsCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM saving_goals WHERE isCompleted = 0'
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ============ TRANSACTIONS OPERATIONS ============

  /// Add a transaction (deposit) to a goal
  Future<int> addTransaction(Transaction transaction) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    final transData = transaction.toMap();
    transData['createdAt'] = now;

    return await db.insert('transactions', transData);
  }

  /// Get all transactions for a goal
  Future<List<Transaction>> getGoalTransactions(int goalId) async {
    final db = await database;
    final maps = await db.query(
      'transactions',
      where: 'goalId = ?',
      whereArgs: [goalId],
      orderBy: 'date DESC',
    );

    return List.generate(
      maps.length,
      (i) => Transaction.fromMap(maps[i]),
    );
  }

  /// Get transaction by ID
  Future<Transaction?> getTransactionById(int id) async {
    final db = await database;
    final maps = await db.query(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return Transaction.fromMap(maps.first);
  }

  /// Update a transaction
  Future<int> updateTransaction(Transaction transaction) async {
    final db = await database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  /// Delete a transaction
  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get total transactions count for a goal
  Future<int> getTransactionCount(int goalId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM transactions WHERE goalId = ?',
      [goalId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get transactions within date range
  Future<List<Transaction>> getTransactionsByDateRange(
    int goalId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    final maps = await db.query(
      'transactions',
      where: 'goalId = ? AND date BETWEEN ? AND ?',
      whereArgs: [
        goalId,
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
      orderBy: 'date DESC',
    );

    return List.generate(
      maps.length,
      (i) => Transaction.fromMap(maps[i]),
    );
  }

  /// Calculate total saved amount for a goal
  Future<double> getTotalSavedAmount(int goalId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE goalId = ?',
      [goalId],
    );
    final total = Sqflite.firstIntValue(result);
    return total != null ? total.toDouble() : 0.0;
  }

  /// Get statistics for dashboard
  Future<Map<String, dynamic>> getDashboardStats() async {
    final db = await database;

    // Total goals
    final goalCount = await db.rawQuery(
      'SELECT COUNT(*) as count FROM saving_goals WHERE isCompleted = 0'
    );
    final totalGoals = Sqflite.firstIntValue(goalCount) ?? 0;

    // Total saved
    final totalSaved = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions'
    );
    final totalAmount = Sqflite.firstIntValue(totalSaved) ?? 0;

    // Completed goals
    final completedCount = await db.rawQuery(
      'SELECT COUNT(*) as count FROM saving_goals WHERE isCompleted = 1'
    );
    final completedGoals = Sqflite.firstIntValue(completedCount) ?? 0;

    return {
      'totalGoals': totalGoals,
      'totalSaved': totalAmount.toDouble(),
      'completedGoals': completedGoals,
    };
  }

  /// Close the database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
