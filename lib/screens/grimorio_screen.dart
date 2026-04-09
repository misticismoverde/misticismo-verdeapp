import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/carta_model.dart';
import '../services/storage_service.dart';

class GrimorioScreen extends StatefulWidget {
  const GrimorioScreen({super.key});

  @override
  State<GrimorioScreen> createState() => _GrimorioScreenState();
}

class _GrimorioScreenState extends State<GrimorioScreen> {
  List<CartaModel> _cartas = [];

  @override
  void initState() {
    super.initState();
    _carregarCartas();
  }

  void _carregarCartas() {
    _cartas = StorageService.getGrimorio();
    setState(() {});
  }

  void _removerCarta(int index) async {
    // Recarregar lista para garantir dados atualizados
    _cartas = StorageService.getGrimorio();
    if (index < _cartas.length) {
      // Nota: Esta é uma implementação simples. Em produção, você precisaria
      // remover do storage service também
      setState(() {
        _cartas.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        title: const Text('📖 Meu Grimório'),
      ),
      body: _cartas.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '📚',
                    style: TextStyle(fontSize: 64),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Seu grimório está vazio',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      color: const Color(0xFF8D5524),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Guarde seus Sussurros favoritos aqui',
                    style: GoogleFonts.openSans(
                      color: const Color(0xFF8D5524),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _cartas.length,
              itemBuilder: (context, index) {
                final carta = _cartas[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: _parseHexColor(carta.cor),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    carta.planta,
                                    style: GoogleFonts.playfairDisplay(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF0A3D1F),
                                    ),
                                  ),
                                ),
                                Text(
                                  carta.data,
                                  style: GoogleFonts.openSans(
                                    fontSize: 12,
                                    color: const Color(0xFF8D5524),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              carta.mensagem,
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: const Color(0xFF2C1810),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Ritual: ${carta.ritual}',
                              style: GoogleFonts.openSans(
                                fontSize: 12,
                                color: const Color(0xFF8D5524),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
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
}