import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreference {
  static late SharedPreferences preferences;
  static const tracks = "tracks";
  static Future init() async =>
      preferences = await SharedPreferences.getInstance();

  static Future setTrack(List<String> ls) async =>
      await preferences.setStringList(tracks, ls);

  static List<String>? getTracks() => preferences.getStringList(tracks);
}
