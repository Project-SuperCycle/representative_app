import 'package:shared_preferences/shared_preferences.dart';

class LangCache {
  Future<void> cacheLang(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('LANG', lang);
  }

  Future<String> getCachedLang() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('LANG')) return "ar";
    return prefs.getString('LANG') ?? "ar";
  }
}
