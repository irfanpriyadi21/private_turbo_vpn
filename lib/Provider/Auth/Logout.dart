import 'package:shared_preferences/shared_preferences.dart';

Future<void>Logout()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  await prefs.remove('loginStatus');
  await prefs.remove("id");
  await prefs.remove("username");
  await prefs.remove("email");

}