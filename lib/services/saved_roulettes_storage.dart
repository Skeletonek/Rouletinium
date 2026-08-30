import 'package:shared_preferences/shared_preferences.dart';
import '../models/saved_roulette.dart';

class SavedRoulettesStorage {
  static const String _key = 'saved_roulettes';
  static const int kMaxSaved = 50;

  Future<List<SavedRoulette>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      return SavedRoulette.decodeList(raw);
    } catch (_) {
      return [];
    }
  }

  Future<void> save(SavedRoulette roulette) async {
    final all = await loadAll();
    if (all.length >= kMaxSaved) {
      throw const MaxSavedReachedException();
    }
    all.add(roulette);
    await _persist(all);
  }

  Future<void> delete(String id) async {
    final all = await loadAll();
    all.removeWhere((e) => e.id == id);
    await _persist(all);
  }

  Future<void> _persist(List<SavedRoulette> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, SavedRoulette.encodeList(list));
  }
}

class MaxSavedReachedException implements Exception {
  const MaxSavedReachedException();
}
