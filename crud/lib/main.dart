import 'package:flutter/material.dart';
import 'package:form_app/src/pages/bloc/provider.dart';
import 'package:form_app/src/pages/home_page.dart';
import 'package:form_app/src/pages/login_page.dart';
import 'package:form_app/src/pages/product_page.dart';
import 'package:form_app/src/pages/register_page.dart';
import 'package:form_app/src/pages/user_preferences/user_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPreferences();
  await prefs.initPrefs();



  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final prefs = new UserPreferences();
    print(prefs.token);
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialRoute: 'login',
        routes: {
          'login'    : (BuildContext context) => LoginPage(),
          'register' : (BuildContext context) => RegisterPage(),
          'home'     : (BuildContext context) => HomePage(),
          'product'  : (BuildContext context) => ProductPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
        ),
      ),
    );






  }
}


