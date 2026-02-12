import 'package:intl/intl.dart';

/// Utility helper functions for the app
class AppHelpers {
  /// Format currency (Rp)
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Format currency without symbol
  static String formatCurrencyNoSymbol(double amount) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(amount.toInt());
  }

  /// Parse currency string to double
  static double parseCurrency(String currencyString) {
    // Remove Rp symbol and spaces, then parse
    final cleaned = currencyString
        .replaceAll('Rp ', '')
        .replaceAll('.', '')
        .replaceAll(',', '')
        .trim();
    return double.tryParse(cleaned) ?? 0;
  }

  /// Format date to readable string (id_ID locale)
  static String formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy', 'id_ID').format(date);
  }

  /// Format date to short format (dd/MM/yyyy)
  static String formatDateShort(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Format date time to full string with time
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('d MMMM yyyy HH:mm', 'id_ID').format(dateTime);
  }

  /// Get relative time string (e.g., "2 hari lalu")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} minggu lalu';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} bulan lalu';
    } else {
      return '${(difference.inDays / 365).floor()} tahun lalu';
    }
  }

  /// Calculate progress percentage
  static double calculateProgress(double current, double target) {
    if (target == 0) return 0;
    return (current / target) * 100;
  }

  /// Calculate remaining amount
  static double calculateRemaining(double current, double target) {
    return target - current;
  }

  /// Calculate days until target date
  static int daysUntilDate(DateTime targetDate) {
    final now = DateTime.now();
    return targetDate.difference(now).inDays;
  }

  /// Calculate estimated daily savings needed
  static double estimatedDailySavings(
    double remainingAmount,
    DateTime targetDate,
  ) {
    final daysLeft = daysUntilDate(targetDate);
    if (daysLeft <= 0) return 0;
    return remainingAmount / daysLeft;
  }

  /// Check if goal is completed
  static bool isGoalCompleted(double current, double target) {
    return current >= target;
  }

  /// Get goal status string
  static String getGoalStatus(double current, double target) {
    if (current >= target) {
      return 'Selesai';
    } else if (current > 0) {
      return 'Sedang berjalan';
    } else {
      return 'Belum dimulai';
    }
  }

  /// Get progress color based on percentage
  static String getProgressColor(double progress) {
    if (progress >= 100) {
      return '✅ Selesai';
    } else if (progress >= 75) {
      return '🔥 Hampir selesai';
    } else if (progress >= 50) {
      return '⭐ Setengah jalan';
    } else if (progress >= 25) {
      return '💪 Mulai terbentuk';
    } else {
      return '🚀 Baru dimulai';
    }
  }

  /// Validate amount input
  static String? validateAmount(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Jumlah tidak boleh kosong';
    }
    final amount = double.tryParse(value!);
    if (amount == null) {
      return 'Masukkan jumlah yang valid';
    }
    if (amount <= 0) {
      return 'Jumlah harus lebih dari Rp 0';
    }
    return null;
  }

  /// Validate goal name
  static String? validateGoalName(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Nama target tidak boleh kosong';
    }
    if (value!.length > 100) {
      return 'Nama target tidak boleh lebih dari 100 karakter';
    }
    return null;
  }

  /// Convert milliseconds to readable duration
  static String formatDuration(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '$hours jam $minutes menit';
    } else if (minutes > 0) {
      return '$minutes menit $seconds detik';
    } else {
      return '$seconds detik';
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is this month
  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  /// Check if date is this year
  static bool isThisYear(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year;
  }

  /// Get month name in Indonesian
  static String getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }

  /// Get day name in Indonesian
  static String getDayName(int weekday) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return days[weekday - 1];
  }

  /// Generate unique ID
  static String generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Check if string is numeric
  static bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  /// Capitalize first letter of string
  static String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  /// Get initials from string
  static String getInitials(String name) {
    return name
        .split(' ')
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join()
        .substring(0, 2)
        .toUpperCase();
  }

  /// Truncate string to max length with ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }
}
