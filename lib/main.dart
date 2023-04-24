import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:rashd/HouseAccount/list_of_houseAccounts.dart';
import 'Registration/login.dart';
import 'Registration/register.dart';
import 'Registration/welcomePage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

late Box box;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  box = await Hive.openBox('devicesInfo');

  //! FCM
  FirebaseMessaging.instance.onTokenRefresh.listen((String token) async {
    print("New token: $token");
    if (FirebaseAuth.instance.currentUser!.uid != null) {
      await FirebaseFirestore.instance
          .collection('userAccount')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'token': token}, SetOptions(merge: true));
    }
  });

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

  // This widget is the root of your application.
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
        MonthYearPickerLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("ar", "SA"), // OR Locale('ar', 'AE') OR Other RTL locales
      ],
      locale: const Locale("ar", "SA"),
    );
  }
}

class global {
  static var index = 0;
}

class GlobalContextService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
