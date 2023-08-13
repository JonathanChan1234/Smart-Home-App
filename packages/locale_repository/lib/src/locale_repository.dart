import 'package:shared_preferences/shared_preferences.dart';

class LocaleRepository {
  const LocaleRepository({
    required SharedPreferences plugin,
  }) : _plugin = plugin;

  static const kLanguageCodeKey = '__language_code_key__';
  final SharedPreferences _plugin;

  Future<void> saveLanguagePreference(String? languageCode) {
    return _plugin.setString(kLanguageCodeKey, languageCode ?? '');
  }

  String? getLanguagePreference() {
    final code = _plugin.getString(kLanguageCodeKey);
    return code == null || code == '' ? null : code;
  }
}

class LanguageCode {
  static const english = 'en';
  static const chinese = 'zh';
  static const und = 'und';
}
