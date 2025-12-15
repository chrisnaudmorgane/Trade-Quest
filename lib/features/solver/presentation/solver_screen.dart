import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_quest/core/theme/app_colors.dart';
import 'package:trade_quest/core/services/supabase_service.dart';
import 'dart:math';

class SolverScreen extends StatefulWidget {
  const SolverScreen({super.key});

  @override
  State<SolverScreen> createState() => _SolverScreenState();
}

class _SolverScreenState extends State<SolverScreen> {
  // Simulator State
  double _initialCapital = 100000; // in FCFA
  double _monthlyContribution = 25000;
  double _annualRate = 0.08; // 8%
  int _years = 10;
  
  // Profile Gating State
  bool _isLoading = true;
  bool _needsCalibration = false;
  final _incomeController = TextEditingController();
  String? _selectedGoal;

  @override
  void initState() {
    super.initState();
    _checkProfileCalibration();
  }

  Future<void> _checkProfileCalibration() async {
    final user = SupabaseService().currentUser;
    if (user != null) {
      final profile = await SupabaseService().getProfile(user.id);
      if (profile != null) {
        if (profile['income_range'] == null || profile['financial_goal'] == null) {
          setState(() {
            _needsCalibration = true;
            _isLoading = false;
          });
        } else {
          setState(() {
            _needsCalibration = false;
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _saveCalibration() async {
    final user = SupabaseService().currentUser;
    if (user == null) return;

    if (_selectedGoal == null || _incomeController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Données requises pour le calcul.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await SupabaseService().updateProfile(
      userId: user.id,
      incomeRange: _incomeController.text, // Simply storing text for now
      financialGoal: _selectedGoal,
    );
    
    setState(() {
      _needsCalibration = false;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(child: CircularProgressIndicator(color: AppColors.neonPurple)),
      );
    }

    if (_needsCalibration) {
      return _buildCalibrationModal();
    }

    return _buildSimulator();
  }

  Widget _buildCalibrationModal() {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
               Text(
                'Calibrage Tactique',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPurple,
                ),
              ).animate().fadeIn().slideX(),
              const SizedBox(height: 16),
              Text(
                'Pour assurer la précision de la simulation, l\'IA doit connaître vos paramètres financiers actuels.',
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
              ),
              const SizedBox(height: 40),
              
              // Goal Input
              Text('OBJECTIF PRINCIPAL', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                dropdownColor: const Color(0xFF1E293B),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                hint: const Text('Sélectionner...', style: TextStyle(color: Colors.white54)),
                value: _selectedGoal,
                items: const [
                  DropdownMenuItem(value: 'Wealth', child: Text('Devenir Riche (Croissance)')),
                  DropdownMenuItem(value: 'Safety', child: Text('Sécurité / Épargne')),
                  DropdownMenuItem(value: 'Project', child: Text('Grand Projet (Immo/Auto)')),
                ],
                onChanged: (v) => setState(() => _selectedGoal = v),
              ),

              const SizedBox(height: 24),

              // Income Input
              Text('TRANCHE REVENUS (FCFA)', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                dropdownColor: const Color(0xFF1E293B),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                hint: const Text('Sélectionner...', style: TextStyle(color: Colors.white54)),
                onChanged: (v) => _incomeController.text = v ?? '',
                items: const [
                  DropdownMenuItem(value: '0-50k', child: Text('Moins de 50.000')),
                  DropdownMenuItem(value: '50k-150k', child: Text('50.000 - 150.000')),
                  DropdownMenuItem(value: '150k-500k', child: Text('150.000 - 500.000')),
                  DropdownMenuItem(value: '500k+', child: Text('Plus de 500.000')),
                ],
              ),

              const Spacer(),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveCalibration,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neonPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('ACTIVER LE SIMULATEUR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimulator() {
    // Basic Compound Interest Logic
    // A = P(1 + r/n)^(nt) + PMT * ... simplified for annual
    // Future Value = P * (1+r)^t + PMT * [ ((1+r)^t - 1) / r ]
    
    double futureValue = _initialCapital * pow(1 + _annualRate, _years) +
        (_monthlyContribution * 12) * ((pow(1 + _annualRate, _years) - 1) / _annualRate);
        
    double totalContributed = _initialCapital + (_monthlyContribution * 12 * _years);
    double totalInterests = futureValue - totalContributed;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text('Simulateur Intérêts', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Result Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.neonBlue.withOpacity(0.2), AppColors.neonPurple.withOpacity(0.2)]),
                 borderRadius: BorderRadius.circular(24),
                 border: Border.all(color: AppColors.neonBlue.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text('VALEUR FUTURE ESTIMÉE', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, letterSpacing: 1)),
                  const SizedBox(height: 8),
                  Text(
                    '${futureValue.toStringAsFixed(0)} FCFA',
                    style: GoogleFonts.spaceGrotesk(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStat('Capital', '${totalContributed.toStringAsFixed(0)}'),
                      _buildStat('Gains (Intérêts)', '+${totalInterests.toStringAsFixed(0)}', color: AppColors.neonGreen),
                    ],
                  )
                ],
              ),
            ).animate().fadeIn().scale(),

            const SizedBox(height: 32),
            
            // Sliders
            _buildSlider('Capital de Départ', _initialCapital, 0, 1000000, (v) => setState(() => _initialCapital = v)),
            _buildSlider('Ajout Mensuel', _monthlyContribution, 0, 200000, (v) => setState(() => _monthlyContribution = v)),
            _buildSlider('Durée (Années)', _years.toDouble(), 1, 40, (v) => setState(() => _years = v.toInt())),
            _buildSlider('Taux Annuel (%)', _annualRate * 100, 1, 15, (v) => setState(() => _annualRate = v / 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, {Color color = Colors.white}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text(label, style: const TextStyle(color: Colors.white)),
             Text(value > 100 ? '${value.toStringAsFixed(0)}' : '${value.toStringAsFixed(1)}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
           ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: AppColors.primary,
          inactiveColor: Colors.white10,
          onChanged: onChanged,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
