import 'package:shared_preferences/shared_preferences.dart';

class LanguageUtils {
  static const String _languageKey = 'selected_language';

  // Save language selection
  Future<void> saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
  }

  // Get saved language selection
  Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey);
  }
}