/// Form validators for the app
class AppValidators {
  /// Validate goal name
  static String? validateGoalName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama target tidak boleh kosong';
    }
    if (value.length < 3) {
      return 'Nama target minimal 3 karakter';
    }
    if (value.length > 100) {
      return 'Nama target maksimal 100 karakter';
    }
    return null;
  }

  /// Validate target amount
  static String? validateTargetAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Target amount tidak boleh kosong';
    }
    
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Masukkan jumlah yang valid';
    }
    
    if (amount <= 0) {
      return 'Jumlah harus lebih dari Rp 0';
    }
    
    if (amount > 999999999) {
      return 'Jumlah maksimal Rp 999.999.999';
    }
    
    return null;
  }

  /// Validate current amount
  static String? validateCurrentAmount(
    String? value, {
    double? maxAmount,
  }) {
    if (value == null || value.isEmpty) {
      return 'Jumlah tidak boleh kosong';
    }
    
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Masukkan jumlah yang valid';
    }
    
    if (amount < 0) {
      return 'Jumlah tidak boleh negatif';
    }
    
    if (maxAmount != null && amount > maxAmount) {
      return 'Jumlah tidak boleh lebih dari target';
    }
    
    return null;
  }

  /// Validate transaction amount
  static String? validateTransactionAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Jumlah tabungan tidak boleh kosong';
    }
    
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Masukkan jumlah yang valid';
    }
    
    if (amount <= 0) {
      return 'Jumlah tabungan harus lebih dari Rp 0';
    }
    
    if (amount > 999999999) {
      return 'Jumlah maksimal Rp 999.999.999';
    }
    
    return null;
  }

  /// Validate transaction note
  static String? validateNote(String? value) {
    if (value != null && value.length > 500) {
      return 'Catatan maksimal 500 karakter';
    }
    return null;
  }

  /// Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    
    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(pattern);
    
    if (!regex.hasMatch(value)) {
      return 'Email tidak valid';
    }
    
    return null;
  }

  /// Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    
    return null;
  }

  /// Validate phone number
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    
    const pattern = r'^[0-9]{10,13}$';
    final regex = RegExp(pattern);
    
    if (!regex.hasMatch(value.replaceAll('-', '').replaceAll('+', ''))) {
      return 'Nomor telepon tidak valid';
    }
    
    return null;
  }

  /// Validate URL
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL tidak boleh kosong';
    }
    
    try {
      Uri.parse(value);
      if (!value.startsWith('http://') && !value.startsWith('https://')) {
        return 'URL harus dimulai dengan http:// atau https://';
      }
      return null;
    } catch (e) {
      return 'URL tidak valid';
    }
  }

  /// Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  /// Validate field length
  static String? validateLength(
    String? value,
    int minLength,
    int maxLength,
    String fieldName,
  ) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    
    if (value.length < minLength) {
      return '$fieldName minimal $minLength karakter';
    }
    
    if (value.length > maxLength) {
      return '$fieldName maksimal $maxLength karakter';
    }
    
    return null;
  }

  /// Validate numeric string
  static String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    
    if (double.tryParse(value) == null) {
      return '$fieldName harus berupa angka';
    }
    
    return null;
  }

  /// Validate that two fields match
  static String? validateMatch(
    String? value,
    String? compareValue,
    String fieldName,
  ) {
    if (value != compareValue) {
      return '$fieldName tidak cocok';
    }
    return null;
  }

  /// Validate date is not in the past
  static String? validateFutureDate(DateTime? date, String fieldName) {
    if (date == null) {
      return '$fieldName tidak boleh kosong';
    }
    
    final now = DateTime.now();
    if (date.isBefore(now)) {
      return '$fieldName harus di masa depan';
    }
    
    return null;
  }

  /// Validate date is not in the future
  static String? validatePastDate(DateTime? date, String fieldName) {
    if (date == null) {
      return '$fieldName tidak boleh kosong';
    }
    
    final now = DateTime.now();
    if (date.isAfter(now)) {
      return '$fieldName harus di masa lalu';
    }
    
    return null;
  }
}
