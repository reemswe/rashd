import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Devices/listOfDevices.dart';
import 'Firebase/firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //! Firebase
  await Firebase.initializeApp(
    name: 'Rashd',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'رشد',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        backgroundColor: Colors.white,
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
            contentPadding: EdgeInsets.fromLTRB(20, 12, 20, 12),
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
      home: const listOfDevices(),
    );
  }
}

class global {
  static var index = 0;
}
