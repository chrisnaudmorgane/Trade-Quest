import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:trade_quest/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/services/supabase_service.dart';
import 'core/services/gemini_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Services
  // TODO: Replace with your actual Supabase URL and Anon Key
  await SupabaseService().initialize(
    url: 'https://pbhvmvnqdeplujtsaefk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBiaHZtdm5xZGVwbHVqdHNhZWZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUyOTU4OTksImV4cCI6MjA4MDg3MTg5OX0.PhPd3m4msgjtUoE_xcHXTQk_i20OTs9yZSafmJ8I2Rs',
  );

  // TODO: Replace with actual Gemini API Key
  GeminiService().initialize(apiKey: 'AIzaSyCc6SvJpVdotdUKX9zqpOYZOoqeZZZAweE');

  runApp(const ProviderScope(child: TradeQuestApp()));
}

class TradeQuestApp extends StatelessWidget {
  const TradeQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TradeQuest',
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
    );
  }
}
