import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class LuaRituaisScreen extends StatelessWidget {
  const LuaRituaisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faseLua = _getFaseLua();
    final ritual = _getRitualPorFase(faseLua);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        title: const Text('🌙 Rituais da Lua'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fase atual
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0A3D1F), Color(0xFF4CAF50)],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  Text(
                    faseLua['icone']!,
                    style: const TextStyle(fontSize: 58),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    faseLua['nome']!,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    faseLua['data']!,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Ritual sugerido
            Text(
              '🌿 Ritual Sugerido',
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0A3D1F),
              ),
            ),
            const SizedBox(height: 12),
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
                    ritual['titulo']!,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8D5524),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    ritual['descricao']!,
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      height: 1.5,
                      color: const Color(0xFF2C1810),
                    ),
                  ),
                  if (ritual['ingredientes'] != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      '🍃 Ingredientes:',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0A3D1F),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...(ritual['ingredientes'] as List<dynamic>).map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 12, bottom: 6),
                        child: Row(
                          children: [
                            const Text('🌱 '),
                            Expanded(
                              child: Text(
                                item,
                                style: GoogleFonts.openSans(
                                  fontSize: 15,
                                  color: const Color(0xFF2C1810),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Banho de ervas sugerido
            Text(
              '💧 Banho de Ervas',
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0A3D1F),
              ),
            ),
            const SizedBox(height: 12),
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
                    ritual['banho']!,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    ritual['comoFazer']!,
                    style: GoogleFonts.openSans(
                      fontSize: 15,
                      height: 1.5,
                      color: const Color(0xFF2C1810),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Mensagem final
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFD4A017)),
              ),
              child: Text(
                '🌕 A lua rege as marés, as plantas e a sua energia. Aproveite este momento para se conectar com a floresta.',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF8D5524),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, String> _getFaseLua() {
    final now = DateTime.now();
    final formatador = DateFormat('dd/MM/yyyy');

    // Cálculo simplificado das fases da lua
    final dataReferencia = DateTime(2026, 4, 9);
    final diff = now.difference(dataReferencia).inDays;
    final ciclo = diff % 29.53;

    String fase;
    String icone;

    if (ciclo < 1) {
      fase = 'Lua Nova';
      icone = '🌑';
    } else if (ciclo < 7.4) {
      fase = 'Lua Crescente';
      icone = '🌒';
    } else if (ciclo < 8.5) {
      fase = 'Quarto Crescente';
      icone = '🌓';
    } else if (ciclo < 14.8) {
      fase = 'Lua Gibosa Crescente';
      icone = '🌔';
    } else if (ciclo < 15.8) {
      fase = 'Lua Cheia';
      icone = '🌕';
    } else if (ciclo < 22.2) {
      fase = 'Lua Gibosa Minguante';
      icone = '🌖';
    } else if (ciclo < 23.2) {
      fase = 'Quarto Minguante';
      icone = '🌗';
    } else if (ciclo < 28.5) {
      fase = 'Lua Minguante';
      icone = '🌘';
    } else {
      fase = 'Lua Nova';
      icone = '🌑';
    }

    return {
      'nome': fase,
      'icone': icone,
      'data': formatador.format(now),
    };
  }

  Map<String, dynamic> _getRitualPorFase(Map<String, String> fase) {
    switch (fase['nome']) {
      case 'Lua Nova':
        return {
          'titulo': '🌑 Ritual de Intenções e Plantio',
          'descricao':
              'Momento de semear desejos, iniciar projetos e plantar sementes espirituais. Escreva em um papel tudo o que quer cultivar nos próximos dias. Enterre o papel em um vaso com terra e regue com água de lua nova (água deixada em um copo de vidro durante a noite).',
          'ingredientes': [
            'Papel e caneta',
            'Vaso com terra',
            'Água em copo de vidro',
            'Sementes de manjericão (opcional)'
          ],
          'banho': '🌿 Banho de Arruda e Alecrim',
          'comoFazer':
              'Ferva 1 litro de água com 3 ramos de arruda e 3 ramos de alecrim. Coe e deixe amornar. Tome seu banho normal e depois jogue da cabeça para baixo, pedindo à lua nova que receba suas intenções.'
        };
      case 'Lua Crescente':
        return {
          'titulo': '🌒 Ritual de Atração e Movimento',
          'descricao':
              'Energia de crescimento e ação. Acenda uma vela verde e escreva 3 ações concretas que você fará nos próximos dias para alcançar seus objetivos. Leia em voz alta com convicção.',
          'ingredientes': ['Vela verde', 'Papel e caneta', 'Incenso de canela'],
          'banho': '💧 Banho de Manjericão e Louro',
          'comoFazer':
              'Ferva 1 litro de água com 5 folhas de manjericão e 3 folhas de louro. Coe, amorne e tome após o banho habitual. Mentalize movimento e prosperidade.'
        };
      case 'Quarto Crescente':
        return {
          'titulo': '🌓 Ritual de Decisões e Clareza',
          'descricao':
              'Período de tomar decisões importantes. Pegue uma bússola (ou o app do celular) e aponte-se para o Norte. Feche os olhos e respire 7 vezes. Pergunte à sua intuição qual caminho seguir.',
          'ingredientes': ['Bússola', 'Vela branca', 'Quartzo transparente'],
          'banho': '🍃 Banho de Hortelã e Camomila',
          'comoFazer':
              'Ferva 1 litro de água com um punhado de hortelã e flores de camomila. Coe e use após o banho. Acalma a mente e clareia os pensamentos.'
        };
      case 'Lua Gibosa Crescente':
        return {
          'titulo': '🌔 Ritual de Preparação e Foco',
          'descricao':
              'Aproxime-se da plenitude. Medite por 5 minutos visualizando seu objetivo já realizado. Sinta a emoção da conquista. Escreva como você vai se sentir quando alcançar.',
          'ingredientes': [
            'Caderno de gratidão',
            'Vela dourada',
            'Flor de lótus (imagem)'
          ],
          'banho': '🌿 Banho de Rosas e Canela',
          'comoFazer':
              'Ferva 1 litro de água com pétalas de rosa vermelha e 3 paus de canela. Coe e tome do pescoço para baixo. Atrai amor-próprio e realizações.'
        };
      case 'Lua Cheia':
        return {
          'titulo': '🌕 Ritual de Gratidão e Manifestação',
          'descricao':
              'A energia está no ápice. Agradeça tudo o que já conquistou. Coloque cristais e objetos de poder sob a luz da lua para energizar. Faça uma lista de 10 coisas pelas quais é grato.',
          'ingredientes': [
            'Cristais (quartzo, ametista)',
            'Água em taça de vidro',
            'Lista de gratidão',
            'Vela branca'
          ],
          'banho': '🌕 Banho de Lua Cheia com Jasmin',
          'comoFazer':
              'Prepare 1 litro de água com flores de jasmin (ou 7 gotas de óleo essencial) e mel. Deixe na janela sob a luz da lua por 2 horas. Tome o banho e mentalize plenitude.'
        };
      case 'Lua Gibosa Minguante':
        return {
          'titulo': '🌖 Ritual de Desapego e Limpeza',
          'descricao':
              'Momento de soltar o que não serve mais. Escreva em um papel tudo o que quer eliminar da sua vida (medos, hábitos, relações). Queime o papel em um local seguro (pote de barro).',
          'ingredientes': [
            'Papel e caneta',
            'Pote de barro',
            'Fósforos',
            'Sálvia para defumação'
          ],
          'banho': '💧 Banho de Limpeza com Sal Grosso e Arruda',
          'comoFazer':
              'Dissolva 3 colheres de sal grosso em 1 litro de água morna com folhas de arruda. Tome seu banho normal e depois jogue esta água dos ombros para baixo, pedindo que leve tudo o que é pesado.'
        };
      case 'Quarto Minguante':
        return {
          'titulo': '🌗 Ritual de Perdão e Libertação',
          'descricao':
              'Perdoe a si mesmo e aos outros. Escreva uma carta de perdão para alguém (não precisa enviar). Depois, rasgue a carta e jogue fora. Sinta o peso saindo do seu coração.',
          'ingredientes': ['Papel e caneta', 'Vela rosa', 'Flor de lis (imagem)'],
          'banho': '🍃 Banho de Alfazema e Erva-Doce',
          'comoFazer':
              'Ferva 1 litro de água com alfazema e sementes de erva-doce. Coe e tome do pescoço para baixo. Traz paz e alívio emocional.'
        };
      case 'Lua Minguante':
        return {
          'titulo': '🌘 Ritual de Descanso e Reflexão',
          'descricao':
              'A energia diminui, é hora de descansar e se recolher. Medite sobre o que aprendeu no ciclo. Faça uma massagem nos pés com óleo de coco e agradeça ao seu corpo.',
          'ingredientes': [
            'Óleo de coco ou amêndoas',
            'Vela azul escura',
            'Manta para meditação',
            'Chá de camomila'
          ],
          'banho': '🌙 Banho de Camomila e Mel',
          'comoFazer':
              'Ferva 1 litro de água com flores de camomila e 1 colher de mel. Coe e tome antes de dormir. Acalma e prepara para o novo ciclo.'
        };
      default:
        return {
          'titulo': '🌙 Ritual de Conexão com a Floresta',
          'descricao':
              'A lua está em transição. Aproveite para se conectar com a natureza. Coloque os pés descalços na terra por 5 minutos e respire profundamente. Sinta a energia da floresta.',
          'ingredientes': [
            'Terra/grama',
            'Música ambiente da floresta',
            'Pedra ou cristal'
          ],
          'banho': '🌿 Banho de Ervas Amazônicas',
          'comoFazer':
              'Ferva 1 litro de água com folhas de alecrim, guiné e arruda. Coe e tome após o banho. Protege e fortalece a espiritualidade.'
        };
    }
  }
}