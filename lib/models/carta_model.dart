import 'dart:convert';

class CartaModel {
  final String data;
  final String planta;
  final String mensagem;
  final String ritual;
  final int tempoRitual;
  final String cor;

  const CartaModel({
    required this.data,
    required this.planta,
    required this.mensagem,
    required this.ritual,
    required this.tempoRitual,
    required this.cor,
  });

  factory CartaModel.fromMap(Map<String, dynamic> map) {
    return CartaModel(
      data: map['data']?.toString() ?? '',
      planta: map['planta']?.toString() ?? '',
      mensagem: map['mensagem']?.toString() ?? '',
      ritual: map['ritual']?.toString() ?? '',
      tempoRitual: map['tempoRitual'] is int
          ? map['tempoRitual'] as int
          : int.tryParse(map['tempoRitual']?.toString() ?? '0') ?? 0,
      cor: map['cor']?.toString() ?? '#0A3D1F',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'planta': planta,
      'mensagem': mensagem,
      'ritual': ritual,
      'tempoRitual': tempoRitual,
      'cor': cor,
    };
  }

  factory CartaModel.fromJson(String source) {
    return CartaModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
  }

  String toJson() => jsonEncode(toMap());
}