import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:trade_quest/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/services/supabase_service.dart';
import 'core/services/gemini_service.dart';
import 'core/providers/locale_provider.dart';
import 'core/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';

const String _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const String _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
const String _geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  assert(
    _supabaseUrl.isNotEmpty && _supabaseAnonKey.isNotEmpty && _geminiApiKey.isNotEmpty,
    'Missing SUPABASE_URL / SUPABASE_ANON_KEY / GEMINI_API_KEY. '
    'Run with --dart-define-from-file=env.json (see env.example.json).',
  );

  // Initialize Services
  await SupabaseService().initialize(
    url: _supabaseUrl,
    anonKey: _supabaseAnonKey,
  );

  // Create the `profiles` row on first sign-in (and on every subsequent
  // sign-in, as a no-op upsert) so username/avatar are never empty.
  SupabaseService().client.auth.onAuthStateChange.listen((data) {
    final user = data.session?.user;
    if (user == null) return;
    final metadata = user.userMetadata ?? {};
    SupabaseService().ensureProfileExists(
      userId: user.id,
      email: user.email ?? '',
      username: metadata['full_name'] as String? ?? metadata['name'] as String?,
      avatarUrl: metadata['avatar_url'] as String? ?? metadata['picture'] as String?,
    );
  });

  await Firebase.initializeApp();
  await NotificationService().initialize();

  GeminiService().initialize(apiKey: _geminiApiKey);

  runApp(const ProviderScope(child: TradeQuestApp()));
}

class TradeQuestApp extends ConsumerWidget {
  const TradeQuestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    
    return MaterialApp.router(
      title: 'Trade Quest',
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('fr'), // French
      ],
      locale: locale,
    );
  }
}
