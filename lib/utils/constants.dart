import 'package:flutter/material.dart';
import '../models/challenge.dart';

/// App-wide constants
class AppConstants {
  // App Info
  static const String appName = 'Nabung Challenge';
  static const String appVersion = '1.0.0';
  static const String appAuthor = 'BandungResearchAI';

  // Currency
  static const String currencyCode = 'IDR';
  static const String currencySymbol = 'Rp';

  // Feature Limits (Free vs Premium)
  static const int freeUserGoalLimit = 1;
  static const int premiumUserGoalLimit = 999; // Unlimited in practice

  // Database
  static const String databaseName = 'nabung_challenge.db';
  static const int databaseVersion = 1;

  // Notification IDs
  static const int dailyReminderNotificationId = 1;
  static const int milestoneNotificationBaseId = 100;
  static const int goalCompletedNotificationId = 999;

  // Preferences Keys
  static const String premiumStatusKey = 'is_premium';
  static const String notificationEnabledKey = 'notification_enabled';
  static const String dailyReminderTimeKey = 'daily_reminder_time';
  static const String languageKey = 'language';
  static const String themeKey = 'theme';
  static const String colorSchemeKey = 'color_scheme';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String appOpenCountKey = 'app_open_count';

  // Thresholds
  static const int reviewPromptThreshold = 5; // Show review after 5 opens
  static const double milestoneThreshold = 0.25; // 25% for milestone notifications
}

/// Goal categories with emojis and colors
class GoalCategory {
  final String id;
  final String title;
  final String emoji;
  final Color color;

  GoalCategory({
    required this.id,
    required this.title,
    required this.emoji,
    required this.color,
  });

  static final List<GoalCategory> categories = [
    GoalCategory(
      id: 'wedding',
      title: 'Pernikahan',
      emoji: '💒',
      color: const Color(0xFFec4899),
    ),
    GoalCategory(
      id: 'emergency',
      title: 'Dana Darurat',
      emoji: '🆘',
      color: const Color(0xFFef4444),
    ),
    GoalCategory(
      id: 'vehicle',
      title: 'Kendaraan',
      emoji: '🚗',
      color: const Color(0xFF3b82f6),
    ),
    GoalCategory(
      id: 'vacation',
      title: 'Liburan',
      emoji: '✈️',
      color: const Color(0xFF06b6d4),
    ),
    GoalCategory(
      id: 'education',
      title: 'Pendidikan',
      emoji: '📚',
      color: const Color(0xFF8b5cf6),
    ),
    GoalCategory(
      id: 'house',
      title: 'Rumah',
      emoji: '🏠',
      color: const Color(0xFF f59e0b),
    ),
    GoalCategory(
      id: 'gadget',
      title: 'Gadget',
      emoji: '📱',
      color: const Color(0xFF14b8a6),
    ),
    GoalCategory(
      id: 'investment',
      title: 'Investasi',
      emoji: '📈',
      color: const Color(0xFF10b981),
    ),
    GoalCategory(
      id: 'other',
      title: 'Lainnya',
      emoji: '💰',
      color: const Color(0xFF6b7280),
    ),
  ];

  static GoalCategory getById(String id) {
    return categories.firstWhere(
      (cat) => cat.id == id,
      orElse: () => categories.last,
    );
  }
}

/// Pre-set saving challenges
class ChallengeConstants {
  static final List<Challenge> challenges = [
    Challenge(
      id: 'daily_10k',
      name: 'Nabung 10K Sehari',
      description: 'Nabung Rp 10.000 setiap hari selama 30 hari',
      dailyAmount: '10000',
      durationDays: 30,
      difficulty: 'easy',
    ),
    Challenge(
      id: 'daily_50k',
      name: 'Nabung 50K Sehari',
      description: 'Nabung Rp 50.000 setiap hari selama 30 hari',
      dailyAmount: '50000',
      durationDays: 30,
      difficulty: 'medium',
    ),
    Challenge(
      id: 'no_jajan',
      name: 'No Jajan Challenge',
      description: 'Hemat uang jajan selama 1 bulan, targetkan Rp 750.000',
      targetAmount: 750000,
      durationDays: 30,
      difficulty: 'hard',
    ),
    Challenge(
      id: '52_weeks',
      name: '52 Minggu Challenge',
      description: 'Nabung mulai dari Rp 10.000 minggu 1, meningkat tiap minggu',
      targetAmount: 13650000,
      durationDays: 364,
      difficulty: 'hard',
    ),
    Challenge(
      id: 'weekend_100k',
      name: 'Weekend 100K',
      description: 'Nabung Rp 100.000 setiap akhir pekan',
      dailyAmount: '100000',
      durationDays: 14,
      difficulty: 'easy',
    ),
  ];
}

/// Motivational quotes for users
class MotivationalQuotes {
  static final List<String> quotes = [
    'Sedikit demi sedikit, lama-lama menjadi bukit',
    'Nabung hari ini = masa depan cerah besok',
    'Setiap rupiah yang Kamu tabung adalah investasi masa depan',
    'Mulai dari sekarang, berapa pun jumlahnya',
    'Disiplin nabung adalah kunci kesuksesan finansial',
    'Jangan besar mimpi, besar usaha nabungnya',
    'Nabung bukan beban, tapi investasi untuk bahagia',
    'Hari ini menabung, besok lebih tenang',
    'Kecil-kecilan bisa jadi berkah',
    'Konsisten nabung = impian menjadi kenyataan',
  ];

  static String getRandomQuote() {
    quotes.shuffle();
    return quotes.first;
  }
}

/// Custom app colors
class AppColors {
  // Primary Green (prosperity)
  static const Color primary = Color(0xFF10b981);
  static const Color primaryDark = Color(0xFF059669);
  static const Color primaryLight = Color(0xFFd1fae5);

  // Secondary Colors
  static const Color success = Color(0xFF22c55e);
  static const Color warning = Color(0xFFf59e0b);
  static const Color error = Color(0xFFef4444);
  static const Color info = Color(0xFF3b82f6);

  // Neutral Colors
  static const Color dark = Color(0xFF1f2937);
  static const Color darkGrey = Color(0xFF4b5563);
  static const Color grey = Color(0xFF6b7280);
  static const Color lightGrey = Color(0xFFe5e7eb);
  static const Color lightestGrey = Color(0xFFF3F4F6);
  static const Color white = Color(0xFFFFFFFF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Text styles for consistent typography
class AppTextStyles {
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.dark,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.dark,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.dark,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.dark,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.dark,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

/// Localization strings (Indonesian)
class AppStrings {
  // Common
  static const String save = 'Simpan';
  static const String cancel = 'Batal';
  static const String delete = 'Hapus';
  static const String edit = 'Edit';
  static const String add = 'Tambah';
  static const String close = 'Tutup';
  static const String loading = 'Memuat...';
  static const String error = 'Terjadi kesalahan';
  static const String success = 'Berhasil';

  // Navigation
  static const String home = 'Beranda';
  static const String settings = 'Pengaturan';
  static const String about = 'Tentang';

  // Goals
  static const String noGoals = 'Belum ada target nabung';
  static const String createGoal = 'Buat Target Nabung';
  static const String goalName = 'Nama Target';
  static const String targetAmount = 'Target Amount';
  static const String currentAmount = 'Jumlah Saat Ini';
  static const String daysLeft = 'Hari Tersisa';
  static const String progress = 'Progress';

  // Notifications
  static const String dailyReminder =
      'Jangan lupa nabung hari ini! Yuk, mulai konsisten mencapai target.';
  static const String milestoneReached = 'Selamat! Kamu sudah mencapai milestone';
  static const String goalCompleted = 'Selamat! Target nabung tercapai!';

  // Premium
  static const String premiumFeature = 'Fitur Premium';
  static const String unlockPremium = 'Buka Premium';
  static const String alreadyPremium = 'Kamu sudah premium!';

  // Validation
  static const String fieldRequired = 'Field ini tidak boleh kosong';
  static const String invalidAmount = 'Masukkan jumlah yang valid';
  static const String amountMustBePositive = 'Jumlah harus lebih dari 0';
}
