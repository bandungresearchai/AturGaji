import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing app preferences
///
/// This class handles persistent storage of user settings like:
/// - Notification preferences
/// - Selected language
/// - Premium status
/// - Custom themes
class SharedPrefsService {
  static final SharedPrefsService _instance = SharedPrefsService._internal();

  factory SharedPrefsService() {
    return _instance;
  }

  SharedPrefsService._internal();

  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ============ NOTIFICATION SETTINGS ============

  /// Get notification enable status
  Future<bool> isNotificationEnabled() async {
    return _prefs?.getBool('notification_enabled') ?? true;
  }

  /// Set notification enable status
  Future<void> setNotificationEnabled(bool enabled) async {
    await _prefs?.setBool('notification_enabled', enabled);
  }

  /// Get daily reminder time (format: "HH:mm")
  Future<String> getDailyReminderTime() async {
    return _prefs?.getString('daily_reminder_time') ?? '09:00';
  }

  /// Set daily reminder time
  Future<void> setDailyReminderTime(String time) async {
    await _prefs?.setString('daily_reminder_time', time);
  }

  // ============ LANGUAGE & LOCALIZATION ============

  /// Get selected language code
  Future<String> getLanguage() async {
    return _prefs?.getString('language') ?? 'id';
  }

  /// Set language code
  Future<void> setLanguage(String languageCode) async {
    await _prefs?.setString('language', languageCode);
  }

  // ============ PREMIUM STATUS ============

  /// Check if user has premium
  Future<bool> isPremium() async {
    return _prefs?.getBool('is_premium') ?? false;
  }

  /// Set premium status
  Future<void> setPremium(bool premium) async {
    await _prefs?.setBool('is_premium', premium);
  }

  /// Get premium purchase ID
  Future<String?> getPremiumPurchaseId() async {
    return _prefs?.getString('premium_purchase_id');
  }

  /// Set premium purchase ID
  Future<void> setPremiumPurchaseId(String purchaseId) async {
    await _prefs?.setString('premium_purchase_id', purchaseId);
  }

  // ============ THEME SETTINGS ============

  /// Get selected theme (light/dark)
  Future<String> getTheme() async {
    return _prefs?.getString('theme') ?? 'light';
  }

  /// Set theme
  Future<void> setTheme(String theme) async {
    await _prefs?.setString('theme', theme);
  }

  /// Get selected color scheme (0-2 for 3 options)
  Future<int> getColorScheme() async {
    return _prefs?.getInt('color_scheme') ?? 0;
  }

  /// Set color scheme
  Future<void> setColorScheme(int scheme) async {
    await _prefs?.setInt('color_scheme', scheme);
  }

  // ============ ONBOARDING ============

  /// Check if user has completed onboarding
  Future<bool> hasCompletedOnboarding() async {
    return _prefs?.getBool('onboarding_completed') ?? false;
  }

  /// Set onboarding completed
  Future<void> setOnboardingCompleted() async {
    await _prefs?.setBool('onboarding_completed', true);
  }

  // ============ ANALYTICS & TRACKING ============

  /// Get app open count
  Future<int> getAppOpenCount() async {
    return _prefs?.getInt('app_open_count') ?? 0;
  }

  /// Increment app open count
  Future<void> incrementAppOpenCount() async {
    final count = await getAppOpenCount();
    await _prefs?.setInt('app_open_count', count + 1);
  }

  /// Get last review prompt date
  Future<DateTime?> getLastReviewPromptDate() async {
    final dateString = _prefs?.getString('last_review_prompt_date');
    if (dateString == null) return null;
    return DateTime.parse(dateString);
  }

  /// Set last review prompt date
  Future<void> setLastReviewPromptDate() async {
    await _prefs?.setString(
      'last_review_prompt_date',
      DateTime.now().toIso8601String(),
    );
  }

  // ============ GENERAL HELPERS ============

  /// Clear all preferences
  Future<void> clearAll() async {
    await _prefs?.clear();
  }

  /// Clear specific key
  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  /// Check if key exists
  bool containsKey(String key) {
    return _prefs?.containsKey(key) ?? false;
  }

  /// Get all keys
  Set<String> getKeys() {
    return _prefs?.getKeys() ?? {};
  }
}
