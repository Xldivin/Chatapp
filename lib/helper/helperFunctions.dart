import 'package:shared_preferences/shared_preferences.dart';
class HelperFunctions {
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";

  //saving data to shared preference
static Future<bool>saveUserLoggedInSharedPreference(bool userLoggedIn) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setBool(sharedPreferenceUserLoggedInKey, userLoggedIn);
}
static Future<bool>saveUserNameSharedPreference(String userName) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString(sharedPreferenceUserNameKey, userName);
}
static Future<bool>saveUserEmailSharedPreference(String userEmail) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString(sharedPreferenceUserEmailKey, userEmail);
}
static Future<bool?>getUserLoggedInSharedPreference() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(sharedPreferenceUserLoggedInKey);
}
static Future<String?>getUserNameSharedPreference() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(sharedPreferenceUserNameKey);
}
static Future<bool?>getUserEmailSharedPreference() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(sharedPreferenceUserEmailKey);
}
}
