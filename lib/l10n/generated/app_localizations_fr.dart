// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'TradeQuest';

  @override
  String get appTitlePart1 => 'Trade';

  @override
  String get appTitlePart2 => 'Quest';

  @override
  String get heroSubtitle =>
      'Maîtrisez la simulation.\nAméliorez votre portefeuille réel.';

  @override
  String get loginWithGoogle => 'Se connecter avec Google';

  @override
  String get secureAuth => 'Authentification sécurisée par Google';

  @override
  String get footerByContinuing => 'En continuant, vous acceptez les ';

  @override
  String get footerTerms => 'Conditions d\'utilisation';

  @override
  String get footerAnd => ' et la ';

  @override
  String get footerPrivacy => 'Politique de confidentialité';

  @override
  String get startMission => 'Commencer la Mission 🚀';

  @override
  String get alreadyAgent => 'Déjà agent ? Connexion';

  @override
  String get missionControl => 'Contrôle de Mission';

  @override
  String get selectMission => 'Choisir une Mission';

  @override
  String get systemOnline => 'SYSTÈME EN LIGNE';

  @override
  String get searchPlaceholder => 'Rechercher sujets, mots-clés...';

  @override
  String get level => 'Niv';

  @override
  String get locked => 'VERROUILLÉ';
}
