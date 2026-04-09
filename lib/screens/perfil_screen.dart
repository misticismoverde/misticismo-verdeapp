import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../services/storage_service.dart';
import '../widgets/bottom_nav_bar.dart';
import 'grimorio_screen.dart';
import 'lua_rituais_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  String _email = '';
  String? _primeiroAcesso;
  String? _ultimoAcesso;
  int _streak = 0;
  int _grimorioCount = 0;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    _email = StorageService.getEmail();
    _primeiroAcesso = StorageService.getPrimeiroAcesso();
    _ultimoAcesso = StorageService.getUltimoAcesso();
    _streak = StorageService.getStreak();
    _grimorioCount = StorageService.getGrimorio().length;
    setState(() {});
  }

  void _sair() async {
    await StorageService.clearAll();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
    }
  }

  void _abrirGrimorio() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GrimorioScreen()),
    ).then((_) => _carregarDados());
  }

  void _abrirRituaisLua() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LuaRituaisScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataInicio = _primeiroAcesso != null
        ? DateFormat('dd/MM/yyyy').format(DateTime.parse(_primeiroAcesso!))
        : '—';
    final ultimoRitual = _ultimoAcesso != null
        ? DateFormat('dd/MM/yyyy').format(DateTime.parse(_ultimoAcesso!))
        : 'Nenhum ainda';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
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
                children: [
                  const Text(
                    '👤',
                    style: TextStyle(fontSize: 56),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _email.split('@').first,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0A3D1F),
                    ),
                  ),
                  Text(
                    _email,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      color: const Color(0xFF8D5524),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📊 Estatísticas',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0A3D1F),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatRow('🌱 Jornada iniciada em', dataInicio),
                  _buildStatRow('📖 Último ritual', ultimoRitual),
                  _buildStatRow('🔥 Dias de conexão', '$_streak'),
                  _buildStatRow('📚 Cartas no Grimório', '$_grimorioCount'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _abrirGrimório,
                      icon: const Icon(Icons.book),
                      label: const Text('📖 Meu Grimório'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0A3D1F),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _abrirRituaisLua,
                      icon: const Icon(Icons.nights_stay),
                      label: const Text('🌙 Rituais da Lua'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0A3D1F),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sair,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: const Color(0xFFC62828),
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFFC62828)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('🚪 Sair'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.openSans(
              fontSize: 15,
              color: const Color(0xFF2C1810),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.openSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0A3D1F),
            ),
          ),
        ],
      ),
    );
  }
}