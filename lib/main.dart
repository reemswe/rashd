import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'accessSharedDashboard.dart';
import 'houseDevicesList.dart';
import 'list_of_house_accounts.dart';
import 'login.dart';
import 'register.dart';
import 'welcomePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    bool auth = false;
    if (user == null) {
      auth = false;
    } else {
      auth = true;
    }
    runApp(MyApp(
      auth: auth,
    ));
  });
}

class MyApp extends StatelessWidget {
  final bool auth;
  const MyApp({
    super.key,
    required this.auth,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          '/welcomePage': (ctx) => const welcomePage(),
          '/homePage': (ctx) => const ListOfHouseAccounts(),
          "/register": (ctx) => const register(),
          "/login": (ctx) => const login(),
        },
        theme: new ThemeData(
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              //Color.fromARGB(255, 147, 191, 128),
            )),
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'LamaSans',
            textTheme: TextTheme()),
        title: 'Flutter Demo',
        home: auth ? ListOfHouseAccounts() : welcomePage());
  }
}
