# 📈 Trade Quest

Welcome to **Trade Quest**! A gamified, AI-powered trading education application built with Flutter. Our mission is to make learning how to trade engaging, interactive, and socially driven.

## 📱 App Previews & Features

### 1. Welcome to TradeQuest
*The gateway to your trading education journey. This onboarding screen introduces users to the core mechanics of the app, setting a professional and engaging tone right from the start.*
<p align="center">
  <img src="https://lh3.googleusercontent.com/aida/AP1WRLvGRL98yBTCs7_MxINfYEo5o__tDaDn9VHhCm_HSzCgjzIBQb1Pq-9X8ggkFh7r4uSXnvsGYZrdX1Cg_DOlsHt7KO8UOWEBEdbrNdqzTc3A5tH-GkBCLp3808gSriLj9xowq7gAbUigdHFcDhStqBadrt2b_YzPX91qRpO1f4IMvFbGWZAIryXiBzugJk1_lbDpXJY8qRGq9XUJyqouOnG3ll7pWgupaVxbS14abbBPrSBrLDgX19cxY-fn" width="250" alt="Welcome to TradeQuest" />
</p>

### 2. Lesson Flow & Mission Selection
*Navigate through diverse trading topics. The mission interface allows users to pick their path—whether it's Crypto, Stocks, or Forex—providing clear progression and XP rewards.*
<p align="center">
  <img src="https://lh3.googleusercontent.com/aida/AP1WRLvzcB5hYMh7PFy6VmUqFaBsDuuhGT_Kwt5SWJIX5gs1-a9Ui0IRMISJPeCZPRwqEwGWMBPTBR1Kx7xc5eqOtin90pTLmT2tojhd8NjVlwZq3a0nEPkmW8c4KZgJRtNEMoafC9-dnlgkKdJYPEEVoQyw0WCEa0wK-zNf9p309vn4pfR8y7XkF_h1syPKx0PLY-NlkY77_Bachh34acWpNYmwvM7j1X3zSM2-peKxoxEuziWcNa5z7UZO0LZL" width="250" alt="Lesson Flow Interface" />
</p>

### 3. Quiz & Interaction
*Put your knowledge to the test. Interactive quizzes reinforce learning with real-time feedback and AI-driven hints to ensure deep understanding of complex financial concepts.*
<p align="center">
  <img src="https://lh3.googleusercontent.com/aida/AP1WRLvQ9EOS4aGEOx4U6u7rFkJnOP-yC-7Ald_8poYAocze1j99q7CxVn0aOwYD-RQroIWdFwvz2qCZhjkP5lNI9fzfogG35fkO8-VDXks2U-NGzorcmnvObW4ZHhLujE96NwTYSovUSkz5JYoQh0zYYmCrGtMnKfmW5iZiMCCS7lJIniz_dg-SmzSdhI4RW4nIatG6cCU65kD6nlTYohVyYyRJcl7teqiqWeldExuXCpodaINf1emSAhqGhQG3" width="250" alt="Quiz & Interaction" />
</p>

### 4. Global Leaderboard
*Compete and climb the ranks! The leaderboard fosters a healthy, competitive environment by showcasing top traders and their XP, encouraging continuous learning and engagement.*
<p align="center">
  <img src="https://lh3.googleusercontent.com/aida/AP1WRLvv--aGw5TZUqg6OQ6A3amYPdOiGJ2LZokoWTtGjSK7KMeVlZtdVQ5_EJnJEfNm73pgsj9X3oMqKe8oxqDHOXJXuTxK-_3lA-tIGF1cgLO5f6utkFR4XDQaBicApaaDmUccHbrrl6kufHSMYR2O3HaLXjW6SyjZbFv4IZiFlbY5MjOCeq3nA856Ot1tvtiPRHLGh6HeCS9U-aHFEVPp7blnOkm60cXKPlUUBTQHlnM-pIUW6bXqKdOkR_k" width="250" alt="Global Leaderboard" />
</p>

### 5. Share Achievement
*Show off your progress. A beautifully designed achievement screen that users can easily share on social networks to celebrate their trading milestones and invite friends.*
<p align="center">
  <img src="https://lh3.googleusercontent.com/aida/AP1WRLsqXUmuOe4Bk2DMoTgQQMte-UqHg1l0pLriL7Vsl8PqzI9xLn8osybL077EWY-x8xKtM72bI7APpmgC2Jx2voUOCCAf7go7_JZERlmm831_578GepS-_eROrvNSV20JOb5tdCJcaoKnZhAg3VqvrbmX0_EX5l8Rnrr21BG5G1Q6Epe9moKaTHMg_vZsea6HQ_OhzlgdUuFb7JcqMnNYilRde58MeBB4dWaSgwjBbQgGoK96EwFAO8yklpZD" width="250" alt="Share Achievement" />
</p>

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
