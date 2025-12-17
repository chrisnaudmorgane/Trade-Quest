import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../features/lesson/domain/lesson_models.dart';

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  
  late final GenerativeModel _model;
  bool _isInitialized = false;

  factory GeminiService() {
    return _instance;
  }

  GeminiService._internal();

  void initialize({required String apiKey}) {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );
    _isInitialized = true;
  }

  Future<Map<String, dynamic>> generateLesson(String topic, String level) async {
    if (!_isInitialized) throw Exception('GeminiService not initialized');

    final prompt = '''
    ### RÔLE ET PERSONA
    Tu es le **Lead Architect & Content Engine** de "TradeQuest".
    Ta mission : Générer une expérience d'apprentissage financier mobile, gamifiée et visuelle.

    ### 1. LA PÉDAGOGIE DU "JUSTE MILIEU" (CRUCIAL)
    Tes leçons ne doivent être ni trop courtes (superficielles), ni trop longues (ennuyeuses).
    * **Règle du "Concept Unique" :** Un écran = Une idée majeure + Une analogie + Un exemple visuel.
    * **Densité :** Pas de murs de texte. Utilise des phrases percutantes. Mais ne sacrifie pas la nuance technique. Si c'est complexe, découpe-le en 3, 4 ou 5 écrans successifs plutôt que de tout mettre sur un seul.
    * **Exemples Obligatoires :** Ne dis jamais "Le marché fluctue". Dis "Si le Bitcoin passe de 20k à 30k...".

    ### 2. FEATURE "OPEN MIC" (DEMANDE UTILISATEUR)
    À la fin de certains modules majeurs, l'IA doit proposer un écran "Open Mic" où l'utilisateur peut demander d'apprendre un sujet spécifique.

    **Logique de Traitement de la Demande Utilisateur :**
    - User Request: "$topic"
    1.  **ANALYSE DU SUJET :**
        * **Si Non-Finance (ex: Cuisine, Code Python, Sport) :** 🛑 REFUSER. Répondre : "Je suis expert en finance, pas en [Sujet]. Revenons à nos graphiques."
        * **Si Finance (ex: "Explique le Staking") :** ✅ ACCEPTER.
    2.  **VÉRIFICATION DU CURRICULUM (Anti-Spoiler) :**
        * **Si le sujet est dans un module futur (Bloqué) :** 🔒 NE PAS DONNER LE COURS COMPLET. Répondre : "Excellente question ! C'est le sujet exact du Niveau [X] que tu débloqueras bientôt. Concentre-toi sur le module actuel pour y arriver vite !"
        * **Si le sujet est Hors-Piste (Bonus) :** 🎁 GÉNÉRER UNE "SIDE QUEST". Créer une mini-leçon immédiate sur ce sujet spécifique pour satisfaire la curiosité sans casser la progression principale.

    ### 3. PROTOCOLE JSON (STRUCTURE DES DONNÉES)
    L'API Gemini génère le contenu sous forme de JSON strict.

    **Structure JSON attendue :**
    {
      "response_type": "lesson" | "refusal" | "teaser", 
      "praise_or_scold": "Remarque spirituelle basée sur le contexte.",
      "content": {
        "lesson_id": "string",
        "title": "Titre de la leçon",
        "screens": [
          {
            "type": "theory_balanced",
            "text_content": "Explication claire (max 300 caractères).",
            "analogy_highlight": "Analogie marquante (ex: Le levier, c'est comme conduire vite...)",
            "visual_description": "Description précise pour l'illustration (ou code Mermaid)"
          },
          {
            "type": "interactive_check",
            "question": "Question de vérification",
            "options": ["A", "B", "C"],
            "correct_idx": 1
          }
        ],
        "final_quiz": {
          "question": "Question finale bloquante",
          "options": ["A", "B", "C", "D"],
          "correct_idx": 1,
          "retry_on_fail": true
        }
    }
    
    ### 4. TÂCHE IMMÉDIATE
    Génère MAINTENANT le contenu pour :
    - Sujet : "$topic"
    - Niveau : "$level"
    
    ### STRUCTURE REQUISE (OBLIGATOIRE)
    - **Minimum 5 Écrans de Contenu**.
    - **Tu DOIS inclure 4 'interactive_check' (Quiz Intermédiaires)** répartis intelligemment dans la leçon.
    - Le dernier élément est le 'final_quiz' (Le 5ème test).
    
    RETURN ONLY JSON. NO MARKDOWN. TOUT LE CONTENU DOIT ÊTRE EN FRANÇAIS.
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final responseText = response.text;

      if (responseText == null) {
        throw Exception('Empty response from AI');
      }

      return jsonDecode(_extractJson(responseText));
    } catch (e) {
      print('AI Generation Error: $e');
      return {
        "title": "Fallback Lesson: $topic",
        "modules": [
          {
            "type": "intro",
            "content": "Could not generate content. Please check API key."
          }
        ]
      };
    }
  }

  Future<Map<String, dynamic>> generateRemedialLesson(String topic, String level, {String? userFeedback}) async {
    if (!_isInitialized) throw Exception('GeminiService not initialized');

    final feedbackContext = userFeedback != null && userFeedback.isNotEmpty
        ? "FEEDBACK UTILISATEUR (Pourquoi j'ai échoué) : \"$userFeedback\". TIENS-EN COMPTE POUR L'EXPLICATION."
        : "Pas de feedback utilisateur.";

    final prompt = '''
    ### ROLE: Moteur de Réparation Pédagogique
    L'utilisateur a ÉCHOUÉ le quiz sur : "$topic" ($level).
    $feedbackContext
    
    ### MISSION
    4.  **Re-Test** : Génère une NOUVELLE structure de leçon de rattrapage.
    
    ### STRUCTURE REQUISE POUR LE RATTRAPAGE
    - **Minimum 4 Écrans**.
    - **Tu DOIS inclure 3 'interactive_check' (Quiz Intermédiaires)** avant le Final Quiz.
    - Le 4ème test est le 'final_quiz'.
    
    ### STRUCTURE JSON (Stricte)
    {
      "response_type": "lesson",
      "praise_or_scold": "T'inquiète, on va reprendre ça tranquillement.",
      "content": {
        "lesson_id": "remedial_1",
        "title": "$topic (Revue)",
        "screens": [
          {
             "type": "theory_balanced",
             "text_content": "Explication ultra-simple (max 200 chars).",
             "analogy_highlight": "Nouvelle analogie simple (ex: Pizza, Football, Jardinage).",
             "visual_description": "Description visuelle simple."
          }
        ],
        "final_quiz": {
          "question": "Nouvelle Question Plus Simple",
          "options": ["A", "B", "C"],
          "correct_idx": 0,
          "retry_on_fail": false
        }
      }
    }
    
    RETURN ONLY JSON. TOUT LE CONTENU DOIT ÊTRE EN FRANÇAIS.
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final responseText = response.text;

      if (responseText == null) throw Exception('Empty response from AI');

      return jsonDecode(_extractJson(responseText));
    } catch (e) {
      print('Remedial Generation Error: $e');
      return {
        "title": "Retry",
        "content": null
      };
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableQuests({
    List<String> excludedTitles = const [],
    String language = 'fr',
  }) async {
    if (!_isInitialized) {
       return [
         {'title': 'Wallet Security', 'subtitle': 'Cyber Defense', 'tag': 'Beginner', 'xp': 500, 'icon': 'wallet'},
         {'title': 'Chart Patterns', 'subtitle': 'Tech Analysis', 'tag': 'Intermediate', 'xp': 1200, 'icon': 'chart'},
       ];
    }

    final exclusionText = excludedTitles.isNotEmpty 
        ? "DO NOT GENERATE quests with these titles (they already exist): ${excludedTitles.join(', ')}." 
        : "";

    final languageInstruction = language == 'fr' 
        ? "LANGUAGE: FRENCH (All titles and descriptions must be in French)."
        : "LANGUAGE: ENGLISH (All titles and descriptions must be in English).";

    final prompt = '''
    ROLE: TradeQuest Ultimate Money Mentor.
    $languageInstruction
    TASK: Generate a list of 3 DIVERSE financial education quests.
    CONTEXT: $exclusionText
    
    SCOPE (MUST COVER EVERYTHING MONEY-RELATED):
    1. Markets: Crypto, Stocks (Bourse), Forex, Indices, ETF.
    2. Smart Money: Arbitrage, DeFi, Yield Farming, Liquidity Pools.
    3. Corporate & Law: Holdings, LLC vs Corp, Tax Optimization, Dividends, Legal Structures.
    4. Real Life: Personal Finance, Budgeting, Debt, Credit Score.
    5. Macro: Inflation, Rates, Central Banks, Gold/Silver.
    6. Mindset: Psychology, Risk Management, Stoicism in Trading.
    7. Business: Real Estate (Immo), Cash Flow, Fundraising (Levée de fonds).

    FORMAT: JSON array of objects.
    
    CONSTRAINTS:
    - RFC 8259 compliant JSON.
    - NO trailing commas.
    - NO comments.
    - Double quotes for all keys and strings.
    - VARY the categories (Don't give 3 Crypto quests).
    
    EACH OBJECT SCHEMA:
    {
      "title": "Short catchy title (max 25 chars, e.g., 'Holding vs SAS')",
      "subtitle": "Specific concept (e.g., 'Fiscalité' or 'Structure')",
      "tag": "Beginner" | "Intermediate" | "Expert" | "Legendary" | "Entrepreneur",
      "xp": integer between 300 and 1500,
      "icon": "wallet" | "chart" | "warning" | "currency" | "brain" | "house" | "globe" | "robot" | "shield" | "rocket" | "building" | "briefcase",
      "description": "Punchy one-sentence summary encouraging action.",
      "category": "Crypto" | "Stocks" | "Forex" | "DeFi" | "PersonalFinance" | "Psychology" | "Economics" | "RealEstate" | "Arbitrage" | "Business" | "Law"
    }
    
    RETURN ONLY THE RAW JSON ARRAY.
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final text = response.text;
      
      print('DEBUG: Raw AI Response: $text'); // Debug log
      
      if (text == null) throw Exception('No response');
      
      final jsonString = _extractJson(text);
      print('DEBUG: Extracted JSON: $jsonString'); // Debug log

      final List<dynamic> json = jsonDecode(jsonString);
      return List<Map<String, dynamic>>.from(json);
    } catch (e) {
      print('Error fetching quests: $e');
      return [];
    }
  }

  String _extractJson(String text) {
    // Remove markdown code fences first
    text = text.replaceAll('```json', '').replaceAll('```', '').trim();
    
    // Attempt to find the outermost brackets or braces
    final arrayStart = text.indexOf('[');
    final objectStart = text.indexOf('{');
    
    int start = -1;
    int end = -1;

    // Determine if we are looking for an object or array based on which comes first
    if (arrayStart != -1 && (objectStart == -1 || arrayStart < objectStart)) {
      start = arrayStart;
      end = text.lastIndexOf(']');
    } else if (objectStart != -1) {
      start = objectStart;
      end = text.lastIndexOf('}');
    }

    if (start != -1 && end != -1 && end > start) {
      return text.substring(start, end + 1);
    }
    
    return text; // Fallback to original if no structure found
  }
}
