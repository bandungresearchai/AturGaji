# 🎯 Nabung Challenge - Aplikasi Menabung

<div align="center">

**Making Savings Easy for Indonesian Young Professionals**

![Status](https://img.shields.io/badge/status-In%20Development-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue)
![License](https://img.shields.io/badge/license-MIT-green)

</div>

## 📋 Project Overview

- **App Name:** Nabung Challenge  
- **Target Market:** Indonesian young professionals (22-30 years old)  
- **Platform:** Android (Flutter)  
- **Timeline:** 8-10 weeks  
- **Budget:** Free tools + Rp 500k for testing/launch
- **Goal:** Help Indonesians build consistent saving habits through gamified challenges

## 🎯 Key Features

- 💰 Create multiple saving goals with target amounts and dates
- 🏺 Visual progress tracking with animated jar filling
- 🎮 Pre-set challenges (Nabung 10K Sehari, No Jajan Challenge, etc.)
- 📊 Transaction history and detailed goal tracking
- 🔔 Daily reminder notifications
- 🏆 Motivational quotes and milestone celebrations
- 📱 Local database (offline-first)
- 🎯 Premium features (unlimited goals, dark mode, analytics)

## 🛠️ Tech Stack

- **Framework:** Flutter 3.0+
- **Language:** Dart
- **State Management:** Provider
- **Local Database:** SQLite (sqflite)
- **Notifications:** flutter_local_notifications
- **Analytics:** Google Analytics (optional)
- **Monetization:** Google AdMob + In-App Purchase

## 📁 Project Structure

```
lib/
├── main.dart                           # App entry point
├── screens/
│   ├── splash_screen.dart             # Splash/loading screen
│   ├── home_screen.dart               # Main dashboard
│   ├── create_goal_screen.dart        # Goal creation form
│   ├── goal_detail_screen.dart        # Goal details & transactions
│   ├── challenge_screen.dart          # Challenge selection
│   └── settings_screen.dart           # App settings
├── models/
│   ├── saving_goal.dart               # Goal data model
│   ├── transaction.dart               # Transaction data model
│   └── challenge.dart                 # Challenge model
├── services/
│   ├── database_service.dart          # SQLite operations
│   ├── notification_service.dart      # Local notifications
│   └── shared_prefs_service.dart      # Shared preferences
├── widgets/
│   ├── goal_card.dart                 # Goal list card
│   ├── progress_jar.dart              # Animated jar widget
│   ├── challenge_button.dart          # Challenge button
│   └── transaction_item.dart          # Transaction list item
├── providers/
│   ├── goal_provider.dart             # Goal state management
│   └── settings_provider.dart         # Settings state management
├── utils/
│   ├── constants.dart                 # App constants & themes
│   ├── helpers.dart                   # Utility functions
│   └── validators.dart                # Form validators
└── assets/                            # Images, icons, fonts
    ├── images/
    ├── icons/
    └── fonts/
```

## 🚀 Development Timeline

### Phase 1: Foundation (Week 1-2)
- [ ] Learn Dart & Flutter basics
- [ ] Setup development environment

### Phase 2: Core Development (Week 3-5)
- [ ] App structure & navigation
- [ ] Database implementation
- [ ] UI implementation

### Phase 3: Polish & Features (Week 6-7)
- [ ] Advanced features (challenges, animations)
- [ ] Monetization setup

### Phase 4: Testing & Launch (Week 8-10)
- [ ] Testing and bug fixes
- [ ] Launch preparation
- [ ] Store listing & release

*Detailed development plan available in the code repository documentation*

## 📦 Dependencies

Key packages used:
- `provider: ^6.1.1` - State management
- `sqflite: ^2.3.0` - Local database
- `path_provider: ^2.1.1` - File system access
- `fl_chart: ^0.65.0` - Charts & graphs
- `flutter_local_notifications: ^16.3.0` - Notifications
- `google_mobile_ads: ^4.0.0` - AdMob integration
- `in_app_purchase: ^3.1.11` - In-app purchases
- `shared_preferences: ^2.2.2` - User preferences
- `intl: ^0.18.1` - Internationalization
- `google_fonts: ^6.1.0` - Google Fonts

## 🎮 Getting Started

### Prerequisites
- Flutter 3.0 or higher
- Android SDK 24 (Android 7.0) or higher
- Android Studio or VS Code with Flutter extension

### Installation

```bash
# Clone the repository
git clone https://github.com/bandungresearchai/AturGaji.git
cd AturGaji

# Get dependencies
flutter pub get

# Run on emulator/device
flutter run
```

## 💰 Monetization Strategy

- **Free Version:** 1 saving goal limit, ads, basic features
- **Premium Version (Rp 25,000):** Unlimited goals, no ads, advanced analytics
- **Revenue Model:** Premium subscriptions + AdMob ads

## 📊 Success Metrics

- Month 1: 500+ downloads, 4.0+ star rating
- Month 3: 2,000+ downloads, 5% premium conversion
- Month 6: 5,000+ users, break-even point

## 🎓 Learning Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [Dart Language Guide](https://dart.dev/guides)
- [SQLite in Flutter](https://docs.flutter.dev/cookbook/persistence/sqlite)
- [Flutter Communities](https://flutter.dev/community)

## 📝 Development Notes

### Week 1-2 Progress
- [ ] Environment setup
- [ ] First Flutter app
- [ ] Dart fundamentals mastered

### Week 3-5 Progress
- [ ] Navigation implemented
- [ ] Database schema designed
- [ ] Core screens built

### Week 6-7 Progress
- [ ] Advanced features added
- [ ] Monetization integrated
- [ ] Performance optimized

### Week 8-10 Progress
- [ ] Comprehensive testing completed
- [ ] App Store ready
- [ ] Launch executed

## 🤝 Contributing

This is a learning project. Contributions and feedback are welcome!

## 📞 Contact & Support

- **Issues:** Report bugs via GitHub Issues
- **Communities:** Flutter Indonesia communities on Facebook, Telegram, Discord
- **Email:** [Project maintainer contact]

## 📜 License

This project is licensed under the MIT License - see LICENSE file for details.

## 🎉 Acknowledgments

- Inspired by saving challenges popular in Indonesia
- Built to help young professionals achieve financial goals
- Special thanks to Flutter and Dart communities

---

**Last Updated:** February 2026  
**Status:** Phase 1 - Foundation In Progress  
**Target Launch:** April 2026