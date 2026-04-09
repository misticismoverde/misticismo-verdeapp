import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/storage_service.dart';
import '../widgets/bottom_nav_bar.dart';

class ArvoreScreen extends StatefulWidget {
  const ArvoreScreen({super.key});

  @override
  State<ArvoreScreen> createState() => _ArvoreScreenState();
}

class _ArvoreScreenState extends State<ArvoreScreen> {
  int _streak = 0;
  String _nivel = '';
  String _icone = '';
  String _fraseMotivacional = '';

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    _streak = StorageService.getStreak();
    _atualizarNivel();
  }

  void _atualizarNivel() {
    if (_streak <= 6) {
      _nivel = '🌱 Nível 1: Muda - Continue cuidando';
      _icone = '🌱';
      _fraseMotivacional = 'Sua árvore está nascendo. Cada dia é uma nova folha.';
    } else if (_streak <= 20) {
      _nivel = '🌿 Nível 2: Pequena - Você está florescendo';
      _icone = '🌿';
      _fraseMotivacional =
          'Sua árvore já tem $_streak dias de conexão. A floresta agradece.';
    } else if (_streak <= 65) {
      _nivel = '🌳 Nível 3: Florescendo - Que conexão linda';
      _icone = '🌳';
      _fraseMotivacional =
          'Que jornada! $_streak dias de sabedoria compartilhada.';
    } else {
      _nivel = '🏆 Nível 4: Ancestral - Guardiã da floresta';
      _icone = '🏆';
      _fraseMotivacional =
          'Você é guardiã da floresta. $_streak dias de conexão profunda.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final progresso = (_streak / 66).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Árvore Viva'),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    _icone,
                    style: const TextStyle(fontSize: 80),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '🔥 $_streak dias de conexão',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0A3D1F),
                    ),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: progresso,
                    backgroundColor: const Color(0xFFE0E0E0),
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(10),
                    minHeight: 10,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _nivel,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color: const Color(0xFF8D5524),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFD4A017)),
              ),
              child: Column(
                children: [
                  Text(
                    '💚 $_fraseMotivacional',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF2C1810),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Próximo nível: ${_streak < 7 ? 7 - _streak : _streak < 21 ? 21 - _streak : _streak < 66 ? 66 - _streak : 0} dias',
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: const Color(0xFF8D5524),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}