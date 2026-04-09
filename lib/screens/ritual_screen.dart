import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/carta_model.dart';
import '../services/storage_service.dart';

class RitualScreen extends StatefulWidget {
  final CartaModel carta;
  final VoidCallback onRitualConcluido;

  const RitualScreen({
    super.key,
    required this.carta,
    required this.onRitualConcluido,
  });

  @override
  State<RitualScreen> createState() => _RitualScreenState();
}

class _RitualScreenState extends State<RitualScreen> {
  late int _segundosRestantes;
  late Timer _timer;
  bool _ritualConcluido = false;
  bool _tocandoSom = false;

  @override
  void initState() {
    super.initState();
    _segundosRestantes = widget.carta.tempoRitual * 60;
  }

  void _iniciarTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_segundosRestantes > 0) {
          _segundosRestantes--;
        } else {
          _timer.cancel();
          _ritualConcluido = true;
        }
      });
    });
  }

  Future<void> _concluirRitual() async {
    if (_timer.isActive) _timer.cancel();

    final hoje = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final ultimoAcesso = StorageService.getUltimoAcesso();
    int streakAtual = StorageService.getStreak();

    if (ultimoAcesso == null) {
      streakAtual = 1;
    } else {
      final ultimaData = DateTime.parse(ultimoAcesso);
      final diff = DateTime.now().difference(ultimaData).inDays;

      if (diff == 1) {
        streakAtual++;
      } else if (diff > 1) {
        streakAtual = 1;
      }
    }

    await StorageService.saveStreak(streakAtual);
    await StorageService.saveUltimoAcesso(hoje);
    await StorageService.saveCartaNoGrimorio(widget.carta);

    widget.onRitualConcluido();
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✨ Ritual concluído! Sua árvore agora tem $streakAtual dias de conexão.',
          ),
          backgroundColor: const Color(0xFF0A3D1F),
        ),
      );
    }
  }

  @override
  void dispose() {
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  String _formatarTempo() {
    final minutos = _segundosRestantes ~/ 60;
    final segundos = _segundosRestantes % 60;
    return '${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        title: Text(
          '🌿 Ritual da ${widget.carta.planta}',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📜 O Ritual',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0A3D1F),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.carta.ritual,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      height: 1.5,
                      color: const Color(0xFF2C1810),
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
                gradient: const LinearGradient(
                  colors: [Color(0xFF0A3D1F), Color(0xFF4CAF50)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Text(
                    _formatarTempo(),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tempo sugerido para o ritual',
                    style: GoogleFonts.openSans(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (!_ritualConcluido && _segundosRestantes > 0)
                    ElevatedButton(
                      onPressed: _iniciarTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0A3D1F),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Iniciar Timer'),
                    ),
                  if (_ritualConcluido || _segundosRestantes == 0)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 48,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _concluirRitual,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4A017),
                  foregroundColor: const Color(0xFF2C1810),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  '✅ Concluir Ritual',
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '✨ Ao concluir, você fortalece sua conexão com a floresta e sua árvore cresce.',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 12,
                color: Color(0xFF8D5524),
              ),
            ),
          ],
        ),
      ),
    );
  }
}