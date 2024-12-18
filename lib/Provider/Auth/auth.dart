

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import '../../Model/http_exceptions.dart';
import '../base_url.dart';

class Auth with ChangeNotifier {
  bool? login;

  Future<void> authenticate(String username, password) async {
    final url = UrlApi.login;
    print(url);
    try {
      final response = await http.post(
          Uri.parse(url),
          body: {
            'email': username.toString(),
            'password': password.toString(),
          }
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['status']) {
        login = true;
        String token = responseData['data']['token'];
        String id = responseData['data']['id'].toString();
        String username = responseData['data']['username'];
        String email = responseData['data']['email'];
        // String lastLogin = responseData['data']['lastLogin'];
        String loginStatus = 'success';
        sharedPref(token, loginStatus, id, username, email);
      } else {
        login = false;
        String message = responseData['message'];
        throw StringHttpException(message);
      }
    } catch (e) {
      rethrow;
    }
  }

  sharedPref(String token, status, id, username, email, )async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token?? "");
    prefs.setString("loginStatus", status);
    prefs.setString("id", id);
    prefs.setString("username", username);
    prefs.setString("email", email);
  }

}