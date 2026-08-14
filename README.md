# 📈 Trade Quest

Welcome to **Trade Quest**! A gamified, AI-powered trading education application built with Flutter. Our mission is to make learning how to trade engaging, interactive, and socially driven.

## 🚀 Features

- **Gamified Learning**: Complete trading lessons and quests to level up.
- **AI Solver & Assistant**: Integrated with Google Generative AI to provide smart hints, analysis, and tutoring.
- **Leaderboard & Social**: Compete with friends and the community.
- **Real-time Backend**: Powered by Supabase for authentication, real-time data sync, and storage.
- **Push Notifications**: Stay up to date with Firebase Cloud Messaging.

## 🛠 Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) (SDK ^3.7.0)
- **State Management:** [Riverpod](https://riverpod.dev/) (with `riverpod_annotation`)
- **Backend (BaaS):** [Supabase](https://supabase.com/)
- **Routing:** [GoRouter](https://pub.dev/packages/go_router)
- **AI Integration:** [Google Generative AI](https://pub.dev/packages/google_generative_ai)
- **Code Generation:** [Freezed](https://pub.dev/packages/freezed) & JSON Serializable

## 📁 Project Architecture

This project follows a **Feature-first / Clean Architecture** approach to maintain scalability and separation of concerns.

```text
lib/
├── core/         # App-wide configurations (Router, Theme, Base Services, Global Providers)
├── features/     # Feature modules (Auth, Dashboard, Leaderboard, Lesson, Solver, etc.)
│   ├── auth/     
│   ├── dashboard/
│   └── ...       # Each feature contains its own UI, domain, and data layers
├── shared/       # Reusable UI components, extensions, and utilities
└── l10n/         # Localization files
```

### 📏 Architectural Rules
As a contributor, please respect the following guidelines:
1. **Passive UI:** The UI should only display data and dispatch events. No business logic should reside in widgets.
2. **Domain-Driven:** All business logic resides in the domain layer.
3. **Backend Abstraction:** **No direct calls** to Supabase or Firebase from the UI. Always go through repositories/services.

## 💻 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Version 3.7.0 or higher)
- A Supabase Project (for backend services)
- A Firebase Project (for push notifications)

### Installation

1. Clone the repository:
   ```bash
   git clone <your-repo-url>
   cd Trade-Quest
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate code (for Riverpod and Freezed):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. Set up your environment variables (Supabase URL/Key, AI API Keys).

5. Run the app:
   ```bash
   flutter run
   ```

## 🤝 How to Contribute

We welcome contributions! Here is how you can help:

1. **Fork the repository** and create your feature branch from `main`.
2. **Follow the Architecture:** Ensure your code adheres to our feature-first structure and architectural rules.
3. **Use Code Generation:** If you add new models or providers, remember to run `build_runner`.
4. **Write Clean Code:** Keep functions small (single responsibility), use explicit naming, and handle errors properly. Do not use `any` or dynamic types unless absolutely necessary.
5. **Create a Pull Request:** Describe your changes clearly and link any relevant issues.

Please ensure your code passes the analyzer before submitting a PR:
```bash
flutter analyze
```

---
Happy Coding! 🚀
