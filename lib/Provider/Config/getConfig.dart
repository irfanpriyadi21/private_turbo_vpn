

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:vpn_mobile/Model/ModelConfig.dart';
import '../../Model/http_exceptions.dart';
import '../base_url.dart';

class GetConfig with ChangeNotifier{


  Future<ModelConfig> config() async {
    final url = UrlApi.getConfig;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token")!;

    try {
      final response = await http.post(
          Uri.parse(url),
          body: {
            'token': token.toString(),
          }
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['status']) {
        ModelConfig imp = ModelConfig.fromJson(responseData);
        return imp;
      } else {
        String message = responseData['message'];
        throw StringHttpException(message);
      }
    } catch (e) {
      rethrow;
    }
  }
}