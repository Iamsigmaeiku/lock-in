# 🍅 Pomodoro Timer - Flutter App

A beautiful and feature-rich Pomodoro Timer application built with Flutter and Material Design 3.

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-3.5.4-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.5.4-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

</div>

## ✨ Features

### 🎯 Core Functionality
- **Pomodoro Timer**: Customizable work (25 min), short break (5 min), and long break (15 min) sessions
- **Task Management**: Create, edit, delete, and track tasks with estimated Pomodoro counts
- **Statistics**: Comprehensive analytics with daily/weekly stats, charts, and heatmaps
- **Notifications**: Get notified when timer completes
- **Data Persistence**: All data stored locally using Hive

### 🎨 Beautiful UI
- Material Design 3 implementation
- Smooth animations and transitions
- Gradient circular timer with progress indicator
- 5 theme color options
- Full dark mode support
- Responsive layout

### ⚙️ Customization
- Adjust work/break durations
- Configure long break intervals
- Toggle notifications and sounds
- Theme color selection
- Dark/light mode toggle

## 📸 Screenshots

> Add your screenshots here

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.5.4 or higher
- Dart SDK 3.5.4 or higher

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/pomodoro-timer-flutter.git
cd pomodoro-timer-flutter
```

2. Install dependencies
```bash
flutter pub get
```

3. Generate Hive adapters
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app
```bash
# For macOS
flutter run -d macos

# For iOS
flutter run -d ios

# For Android
flutter run -d android

# For Web
flutter run -d chrome
```

## 🏗️ Architecture

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models
│   ├── task.dart
│   ├── pomodoro_session.dart
│   └── statistics.dart
├── providers/                   # State management
│   ├── timer_provider.dart
│   ├── task_provider.dart
│   ├── settings_provider.dart
│   └── statistics_provider.dart
├── services/                    # Business logic
│   └── notification_service.dart
├── screens/                     # UI screens
│   ├── home_screen.dart
│   ├── tasks_screen.dart
│   ├── statistics_screen.dart
│   └── settings_screen.dart
└── widgets/                     # Reusable widgets
    ├── circular_timer.dart
    ├── task_card.dart
    └── time_picker_dialog.dart
```

## 🛠️ Tech Stack

- **Framework**: Flutter 3.5.4
- **State Management**: Provider
- **Local Storage**: Hive + SharedPreferences
- **Notifications**: flutter_local_notifications
- **Charts**: fl_chart
- **Design**: Material Design 3

## 📦 Main Dependencies

```yaml
dependencies:
  provider: ^6.0.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.0
  flutter_local_notifications: ^17.0.0
  fl_chart: ^0.69.0
  uuid: ^4.0.0
  intl: ^0.19.0
```

## 🎯 Roadmap

- [ ] Custom sound effects
- [ ] Focus mode (lock device)
- [ ] Cloud sync
- [ ] More chart types
- [ ] Achievement system
- [ ] Friends leaderboard
- [ ] Data export
- [ ] Widget support

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👏 Acknowledgments

- Inspired by the Pomodoro Technique by Francesco Cirillo
- Material Design 3 guidelines by Google
- Flutter community for amazing packages

## 📧 Contact

Your Name - [@yourtwitter](https://twitter.com/yourtwitter)

Project Link: [https://github.com/yourusername/pomodoro-timer-flutter](https://github.com/yourusername/pomodoro-timer-flutter)

---

<div align="center">
Made with ❤️ and Flutter
</div>
