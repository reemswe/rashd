import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'HouseAccount/list_of_house_accounts.dart';
import 'Registration/login.dart';
import 'Registration/register.dart';
import 'Registration/welcomePage.dart';

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
      home: auth ? ListOfHouseAccounts() : welcomePage(),
      title: 'رشد',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          button: TextStyle(
            wordSpacing: 3,
            letterSpacing: 1,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
            contentPadding: EdgeInsets.fromLTRB(10, 13, 10, 13),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2)),
            errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0)),
            focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0)),
            floatingLabelStyle: TextStyle(fontSize: 22, color: Colors.blue),
            helperStyle: TextStyle(fontSize: 14)),
        // labelStyle: TextStyle(fontSize: 4, color: Colors.blue)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: const Color(0xFFfcfffe),
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.all(5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0))),
        ),
      ),
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("ar", "SA"), // OR Locale('ar', 'AE') OR Other RTL locales
      ],
      locale: const Locale(
          "ar", "SA"), // OR Locale('ar', 'AE') OR Other RTL locales,
      // home: const listOfDevices(),
    );
  }
}

class global {
  static var index = 0;
}
