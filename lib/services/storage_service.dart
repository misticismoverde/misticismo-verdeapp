import 'package:shared_preferences/shared_preferences.dart';

import '../models/carta_model.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static const String onboardingVistoKey = 'onboarding_visto';
  static const String emailUsuarioKey = 'email_usuario';
  static const String streakKey = 'streak';
  static const String ultimoAcessoKey = 'ultimo_acesso';
  static const String primeiroAcessoKey = 'primeiro_acesso';
  static const String cacheUltimaCartaKey = 'cache_ultima_carta';
  static const String grimorioKey = 'grimorio';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool isOnboardingSeen() {
    return _prefs.getBool(onboardingVistoKey) ?? false;
  }

  static Future<bool> setOnboardingSeen(bool value) {
    return _prefs.setBool(onboardingVistoKey, value);
  }

  static String getEmail() {
    return _prefs.getString(emailUsuarioKey) ?? '';
  }

  static Future<bool> saveEmail(String email) {
    return _prefs.setString(emailUsuarioKey, email);
  }

  static int getStreak() {
    return _prefs.getInt(streakKey) ?? 0;
  }

  static Future<bool> saveStreak(int value) {
    return _prefs.setInt(streakKey, value);
  }

  static String? getUltimoAcesso() {
    return _prefs.getString(ultimoAcessoKey);
  }

  static Future<bool> saveUltimoAcesso(String value) {
    return _prefs.setString(ultimoAcessoKey, value);
  }

  static String? getPrimeiroAcesso() {
    return _prefs.getString(primeiroAcessoKey);
  }

  static Future<bool> savePrimeiroAcesso(String value) {
    return _prefs.setString(primeiroAcessoKey, value);
  }

  static Future<bool> cacheCarta(CartaModel carta) {
    return _prefs.setString(cacheUltimaCartaKey, carta.toJson());
  }

  static CartaModel? getCachedCarta() {
    final raw = _prefs.getString(cacheUltimaCartaKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      return CartaModel.fromJson(raw);
    } catch (_) {
      return null;
    }
  }

  static List<CartaModel> getGrimorio() {
    final rawList = _prefs.getStringList(grimorioKey) ?? <String>[];
    return rawList.map((item) {
      try {
        return CartaModel.fromJson(item);
      } catch (_) {
        return null;
      }
    }).whereType<CartaModel>().toList();
  }

  static Future<bool> saveCartaNoGrimorio(CartaModel carta) async {
    final atual = _prefs.getStringList(grimorioKey) ?? <String>[];
    final cartas = getGrimorio();

    final duplicada = cartas.any(
      (c) => c.planta == carta.planta && c.data == carta.data,
    );

    if (!duplicada) {
      atual.insert(0, carta.toJson());
      return _prefs.setStringList(grimorioKey, atual);
    }

    return true;
  }

  static Future<void> clearAll() async {
    await _prefs.clear();
  }
}