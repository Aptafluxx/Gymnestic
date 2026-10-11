import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService extends GetxService {
  late final SharedPreferences _prefs;

  static const String _keyHasSeenOnboarding = 'has_seen_onboarding';

  Future<PreferencesService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  bool get hasSeenOnboarding => _prefs.getBool(_keyHasSeenOnboarding) ?? false;

  Future<bool> setHasSeenOnboarding(bool value) async {
    return await _prefs.setBool(_keyHasSeenOnboarding, value);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
