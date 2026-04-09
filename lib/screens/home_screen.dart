import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/carta_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../widgets/bottom_nav_bar.dart';
import 'ritual_screen.dart';
import 'grimorio_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  bool _loading = true;
  CartaModel? _carta;
  String _email = '';
  String? _bannerMensagem;
  String? _erroFatal;

  @override
  void initState() {
    super.initState();
    _email = StorageService.getEmail();
    _carregarCarta();
  }

  Future<void> _carregarCarta() async {
    setState(() {
      _loading = true;
      _erroFatal = null;
      _bannerMensagem = null;
    });

    try {
      final carta = await _apiService.fetchSussurroHoje();
      if (!mounted) return;
      setState(() {
        _carta = carta;
      });
    } on NoInternetException {
      final cache = StorageService.getCachedCarta();
      if (!mounted) return;

      if (cache != null) {
        setState(() {
          _carta = cache;
          _bannerMensagem =
              '🌿 A floresta está com conexão instável. Usando última mensagem.';
        });
        _showSnack('Sem internet. Usando dados salvos.');
      } else {
        setState(() {
          _erroFatal =
              '🌿 A floresta está com conexão instável. Tente novamente.';
        });
        _showSnack('Sem internet. Usando dados salvos.');
      }
    } on ApiTimeoutException {
      final cache = StorageService.getCachedCarta();
      if (!mounted) return;

      if (cache != null) {
        setState(() {
          _carta = cache;
          _bannerMensagem =
              '🌿 A floresta está com conexão instável. Usando última mensagem.';
        });
        _showSnack('Tempo de resposta excedido. Usando dados salvos.');
      } else {
        setState(() {
          _erroFatal =
              '🌿 A floresta está com conexão instável. Tente novamente.';
        });
      }
    } on ApiFailureException {
      final cache = StorageService.getCachedCarta();
      if (!mounted) return;

      if (cache != null) {
        setState(() {
          _carta = cache;
          _bannerMensagem =
              '🌿 A floresta está com conexão instável. Usando última mensagem.';
        });
        _showSnack(
          'Não foi possível atualizar o Sussurro do Dia. Usando a última mensagem salva.',
        );
      } else {
        setState(() {
          _erroFatal =
              '🌿 A floresta está com conexão instável. Tente novamente.';
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _erroFatal = '🌿 A floresta está com conexão instável. Tente novamente.';
      });
      _showSnack('🌿 A floresta está com conexão instável. Tente novamente.');
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  void _showSnack(String text) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: const Color(0xFF2C1810),
        ),
      );
    });
  }

  Color _parseHexColor(String hex) {
    final cleaned = hex.replaceAll('#', '');
    final buffer = StringBuffer();
    if (cleaned.length == 6) {
      buffer.write('ff');
    }
    buffer.write(cleaned);
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Future<void> _guardarNoGrimorio() async {
    if (_carta == null) return;
    await StorageService.saveCartaNoGrimorio(_carta!);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📖 Carta guardada no Grimório.'),
        backgroundColor: Color(0xFF0A3D1F),
      ),
    );
  }

  void _abrirGrimorio() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GrimorioScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final carta = _carta;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sussurro do Dia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.book),
            onPressed: _abrirGrimorio,
            tooltip: 'Grimório',
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0A3D1F),
              ),
            )
          : _erroFatal != null && carta == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '🌿',
                          style: TextStyle(fontSize: 58),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _erroFatal!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            color: const Color(0xFFC62828),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _carregarCarta,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A3D1F),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _carregarCarta,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      if (_bannerMensagem != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFFD4A017),
                            ),
                          ),
                          child: Text(
                            _bannerMensagem!,
                            style: GoogleFonts.openSans(
                              color: const Color(0xFF8D5524),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: _parseHexColor(carta?.cor ?? '#0A3D1F'),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(24),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Bom dia, ${_email.split('@').first}',
                                      style: GoogleFonts.openSans(
                                        fontSize: 16,
                                        color: const Color(0xFF8D5524),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    '🌿',
                                    style: TextStyle(fontSize: 64),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    carta?.planta ?? 'Carregando...',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF0A3D1F),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    carta?.mensagem ?? '',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.openSans(
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic,
                                      color: const Color(0xFF8D5524),
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        if (carta != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => RitualScreen(
                                                carta: carta,
                                                onRitualConcluido: _carregarCarta,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.self_improvement),
                                      label: Text(
                                        '🌿 Fazer o Ritual Agora',
                                        style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF0A3D1F),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('😊'),
                                      SizedBox(width: 16),
                                      Text('😐'),
                                      SizedBox(width: 16),
                                      Text('😔'),
                                      SizedBox(width: 16),
                                      Text('🌿'),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      onPressed: _guardarNoGrimorio,
                                      icon: const Icon(Icons.save_alt),
                                      label: Text(
                                        '📖 Guardar no Grimório',
                                        style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFF0A3D1F),
                                        side: const BorderSide(
                                          color: Color(0xFFD4A017),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '✨ Toque na planta para abrir o ritual completo',
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