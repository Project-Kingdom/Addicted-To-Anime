import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static SharedPreferences? _preferences;

  static const _keyLink = 'link';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setLink(String username) async =>
      await _preferences?.setString(_keyLink, username);

  static String? getLink() => _preferences!.getString(_keyLink);


}