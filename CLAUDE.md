# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get                                          # install dependencies
dart run build_runner build --delete-conflicting-outputs # regenerate Freezed/Riverpod/JSON code (*.g.dart, *.freezed.dart)
dart run build_runner watch --delete-conflicting-outputs # same, watching for changes
flutter analyze                                           # static analysis (must pass before a PR)
flutter run --dart-define-from-file=env.json              # run on a connected device/emulator
flutter devices                                           # list available targets, pick one with -d <id>
flutter test                                               # run tests (test/widget_test.dart is currently the only one)
```

There is no lint-fix or format-check script beyond `flutter analyze`; `analysis_options.yaml` just includes `package:flutter_lints/flutter.yaml` with no project-specific overrides.

## Environment / secrets

Supabase URL/anon key and the Gemini API key are **not** hardcoded — they're injected at build time via `--dart-define-from-file=env.json` and read in `lib/main.dart` with `String.fromEnvironment(...)`. `env.json` is gitignored; copy `env.example.json` to `env.json` and fill in real values before running. `.vscode/launch.json` already passes this flag for F5 debugging.

## Architecture

Feature-first layout under `lib/`:
- `lib/core/` — router (`GoRouter`), theme, Riverpod providers, and the service layer.
- `lib/features/<name>/presentation/` — screens/widgets per feature (auth, dashboard, lesson, leaderboard, onboarding, profile, settings, social, solver). Only `lesson` and `social` currently have a `domain/` subfolder for models; other features keep everything in `presentation/` and talk to `core/services` directly.
- `lib/l10n/` — ARB-based localization (French `fr` is the primary language used throughout prompts and copy; English `en` is also supported).

**Backend abstraction is centralized in one class**: `lib/core/services/supabase_service.dart` (`SupabaseService`, a singleton) is the *only* place that should call the Supabase client — auth, `profiles`, `quests`, `user_quests`, `badges`, `user_badges` tables. Screens call `SupabaseService()` methods directly rather than going through a repository/domain layer, so when adding a new query or mutation, add a method here rather than reaching for `Supabase.instance.client` from a widget.

**AI content generation**: `lib/core/services/gemini_service.dart` (`GeminiService`, singleton, `google_generative_ai` package) generates lesson JSON (`generateLesson`, `generateRemedialLesson`) and quest suggestions (`getAvailableQuests`) from large structured French-language prompts. Responses are expected to be raw JSON (`RETURN ONLY JSON` in the prompt); `_extractJson()` strips markdown fences and slices out the outermost `{...}`/`[...]` before `jsonDecode`. `lib/core/services/deepseek_service.dart` and `lib/core/services/flux_image_service.dart` are drop-in alternatives (DeepSeek for text via OpenAI-compatible `chat/completions`, FLUX.1 schnell on Fireworks AI for images, the latter with on-disk caching keyed by prompt hash since it's a paid call) — same method signatures as `GeminiService`, not yet wired into `main.dart`.

**Lesson content flow**: a quest topic/level goes to `GeminiService.generateLesson`, which returns a JSON tree parsed into `lib/features/lesson/domain/lesson_models.dart` (Freezed models — regenerate with `build_runner` after editing). `LessonEngineScreen` walks the `screens` list; illustrations are fetched live from `https://image.pollinations.ai/prompt/<encoded visual_description>` in `lesson_content_view.dart` (no API key, free).

**Auth flow**: Google OAuth via `SupabaseService.signInWithGoogle()` (deep link `io.supabase.tradequest://login-callback/`, registered in `AndroidManifest.xml` and `ios/Runner/Info.plist`). `main.dart` subscribes to `client.auth.onAuthStateChange` and calls `SupabaseService.ensureProfileExists()` on every session so a `profiles` row (username/avatar from Google's `user_metadata`) always exists — don't assume a `profiles` row exists without this having run. `app_router.dart`'s `redirect` (driven by a `GoRouterRefreshStream` wrapping the same auth stream) sends signed-out users to `/` and signed-in users away from `/login`.

**Database**: Supabase Postgres with RLS enabled on `profiles`, `quests`, `badges`, `user_quests`, `user_badges`. `quests.user_id` is nullable — `NULL` means a public/shared quest, a real UUID means a user-authored "Custom Request" quest (see `SupabaseService.createCustomQuest`); the privacy filter in `getQuests()` is `user_id.is.null OR user_id.eq.<current user>`.
