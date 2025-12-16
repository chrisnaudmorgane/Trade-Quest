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
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
