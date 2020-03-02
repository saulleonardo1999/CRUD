import 'dart:convert';

import 'package:form_app/src/pages/user_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;


class UserProvider{
  final String _firebaseToken = 'AIzaSyBCwSHg-fAENqG-z0ltv1gaYlEWiFSgjAU';
  final _prefs = new UserPreferences();

  Future<Map<String,dynamic>> login(String email, String password)async{
    final authData = {
      'email'              :   email,
      'password'           :   password,
      'returnSecureToken'  : true,
    };

    final ans = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
        body: json.encode(authData)
    );

    Map<String, dynamic> decodedAns = json.decode(ans.body);
    print(decodedAns);
    if (decodedAns.containsKey('idToken')){
      _prefs.token = decodedAns['idToken'];
      return {'ok' : true, 'token': decodedAns['idToken']};
    }else{
      return{'ok' : false, 'message' : decodedAns['error']['message']};
    }

  }





  Future<Map<String,dynamic>> newUser(String email, String password) async {
    final authData = {
      'email'              :   email,
      'password'           :   password,
      'returnSecureToken'  : true,
    };

    final ans = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedAns = json.decode(ans.body);
    print(decodedAns);
    if (decodedAns.containsKey('idToken')){
      _prefs.token = decodedAns['idToken'];
      return {'ok' : true, 'token': decodedAns['idToken']};
    }else{
      return{'ok' : false, 'message' : decodedAns['error']['message']};
    }

  }
}