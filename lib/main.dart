import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rashd/HouseAccount/list_of_houseAccounts.dart';
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
      ],
      supportedLocales: const [
        Locale("ar", "SA"), // OR Locale('ar', 'AE') OR Other RTL locales
      ],
      locale: const Locale("ar", "SA"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int i = 7;
  int con = 200;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          children: [
            ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const CreateHouseAccount()));
                },
                child: const Text('create house account')),
            ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const dashboard(
                  //               dashId: 'fIgVgfieeVqGRB9oRne1',
                  //             )));
                },
                child: const Text('dashboard')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListOfHouseAccounts()));
                },
                child: const Text('houseAccounts')),
            ElevatedButton(
                onPressed: () {
                  // setData();
                },
                child: const Text('setdata')),
          ]),
    );
  }

  // Future<void> setData() async {
  //   i++;
  //   con += 100;
  //   CollectionReference houses = FirebaseFirestore.instance
  //       .collection('houseAccount')
  //       .doc('12Tk9jBwrDGhYe2Yjzrl')
  //       .collection('houseDevices');

  //   DocumentReference docReference =
  //       await houses.add({'name': 'dev$i', 'consumption': con});
  // }
}

class global {
  static var index = 0;
}
