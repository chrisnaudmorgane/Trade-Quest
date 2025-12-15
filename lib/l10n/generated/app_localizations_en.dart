// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TradeQuest';

  @override
  String get appTitlePart1 => 'Trade';

  @override
  String get appTitlePart2 => 'Quest';

  @override
  String get heroSubtitle =>
      'Master the simulation.\nLevel up your real-world portfolio.';

  @override
  String get loginWithGoogle => 'Log in with Google';

  @override
  String get secureAuth => 'Secure authentication powered by Google';

  @override
  String get footerByContinuing => 'By continuing, you agree to TradeQuest\'s ';

  @override
  String get footerTerms => 'Terms of Service';

  @override
  String get footerAnd => ' and ';

  @override
  String get footerPrivacy => 'Privacy Policy';

  @override
  String get startMission => 'Start Mission 🚀';

  @override
  String get alreadyAgent => 'Already an agent? Log in';

  @override
  String get missionControl => 'Mission Control';

  @override
  String get selectMission => 'Select Mission';

  @override
  String get searchPlaceholder => 'Search topics, keywords...';

  @override
  String get level => 'Lvl';

  @override
  String get locked => 'LOCKED';
}
