import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rashd/HouseAccount/list_of_houseAccounts.dart';
import 'package:rashd/Mocks.dart';
import 'package:rashd/Registration/login.dart';
import 'package:rashd/Registration/register.dart';

void main() {
  late FirebaseAuth auth;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    auth = MockFirebaseAuth();
  });

  group('Login tests', () {
    late LoginFormState loginForm;
    var email = 'test@example.com';
    var password = 'Aa123456';
    late MockUserCredential mockUserCredential;

    setUp(() {
      loginForm = LoginFormState();
      mockUserCredential = MockUserCredential();
    });

    testWidgets('TC_1 Valid Login', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Login(),
      ));
      var form = tester.state(find.byType(Form)) as FormState;

      form.reset();
      when(() =>
              auth.signInWithEmailAndPassword(email: email, password: password))
          .thenAnswer((_) async => mockUserCredential);

      await tester.enterText(
          find.widgetWithText(TextFormField, 'البريد الإلكتروني'), email);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'كلمة المرور'), password);
      expect(form.validate(), isTrue);
      await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل الدخول'));
      expect(loginForm.invalidData, false);
      await tester.pumpAndSettle();

      // Expect to navigate to the list of house account.
      expectLater(find.byType(ListOfHouseAccounts), findsOneWidget,
          reason: 'Expected to navigate after successful login');
    });

    testWidgets('TC_2 Empty Email', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Login(),
      ));
      var form = tester.state(find.byType(Form)) as FormState;

      form.reset();
      when(() =>
              auth.signInWithEmailAndPassword(email: email, password: password))
          .thenAnswer((_) async => mockUserCredential);

      await tester.enterText(
          find.widgetWithText(TextFormField, 'البريد الإلكتروني'), '');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'كلمة المرور'), password);
      await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل الدخول'));
      await tester.pump();

      expect(form.validate(), isFalse);
      expect(find.text('الرجاء ادخال البريد الإلكتروني'), findsOneWidget);
    });

    testWidgets('TC_3 Empty Password', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Login(),
      ));
      var form = tester.state(find.byType(Form)) as FormState;

      form.reset();
      when(() =>
              auth.signInWithEmailAndPassword(email: email, password: password))
          .thenAnswer((_) async => mockUserCredential);

      await tester.enterText(
          find.widgetWithText(TextFormField, 'البريد الإلكتروني'), email);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'كلمة المرور'), '');
      await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل الدخول'));
      await tester.pump();

      expect(form.validate(), isFalse);
      expect(find.text('الرجاء إدخال كلمة المرور.'), findsOneWidget);
    });

    // testWidgets('TC_4 Invalid Email', (WidgetTester tester) async {
    //   await tester.pumpWidget(const MaterialApp(
    //     home: Login(),
    //   ));
    //   var form = tester.state(find.byType(Form)) as FormState;
    //   form.reset();
    //   email = 'invalid-email';

    //   when(() =>
    //           auth.signInWithEmailAndPassword(email: email, password: password))
    //       .thenThrow(FirebaseAuthException(code: 'invalid-email'));

    //   await tester.enterText(
    //       find.widgetWithText(TextFormField, 'البريد الإلكتروني'), email);
    //   await tester.enterText(
    //       find.widgetWithText(TextFormField, 'كلمة المرور'), password);

    //   await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل الدخول'));

    //   await tester.pumpAndSettle();

    //   await tester.pump();
    //   expect(form.validate(), isFalse);

    //   expect(
    //       find.text(
    //         'البريد إلكتروني/ كلمة المرور غير صالحة، يرجى المحاولة مرة أخرى.',
    //       ),
    //       findsOneWidget);
    // });
    // // testWidgets('TC_4 Invalid Email', (WidgetTester tester) async {
    //   await tester.pumpWidget(const MaterialApp(
    //     home: Login(),
    //   ));
    //   var form = tester.state(find.byType(Form)) as FormState;

    //   form.reset();
    //   email = 'invalid-email';
    //   when(() =>
    //           auth.signInWithEmailAndPassword(email: email, password: password))
    //       .thenThrow(FirebaseAuthException(code: 'invalid-email'));

    //   await tester.enterText(
    //       find.widgetWithText(TextFormField, 'البريد الإلكتروني'), email);
    //   await tester.enterText(
    //       find.widgetWithText(TextFormField, 'كلمة المرور'), password);
    //   await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل الدخول'));
    //   // await tester.pump();
    //   expect(loginForm.invalidData, true);

    //   // expect(form.validate(), isFalse);
    //   // expect(find.text('الرجاء إدخال كلمة المرور.'), findsOneWidget);
    // });

    // test('TC_4 Invalid Email', () async {
    //   email = 'invalid-email';
    //   when(() =>
    //           auth.signInWithEmailAndPassword(email: email, password: password))
    //       .thenThrow(FirebaseAuthException(code: 'invalid-email'));

    //   await loginForm.login(email, password, auth);

    //   expect(loginForm.invalidData, true);
    // });

    // testWidgets('TC_5 Wrong Password', (WidgetTester tester) async {
    //   await tester.pumpWidget(const MaterialApp(
    //     home: Login(),
    //   ));
    //   var form = tester.state(find.byType(Form)) as FormState;
    //   form.reset();
    //   password = 'wrong-password';

    //   when(() =>
    //           auth.signInWithEmailAndPassword(email: email, password: password))
    //       .thenThrow(FirebaseAuthException(code: 'wrong-password'));

    //   await tester.enterText(
    //       find.widgetWithText(TextFormField, 'البريد الإلكتروني'), email);
    //   await tester.enterText(
    //       find.widgetWithText(TextFormField, 'كلمة المرور'), password);
    //   await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل الدخول'));
    //   await tester.pumpAndSettle();
    //   await tester.pump();
    //   expect(form.validate(), isTrue);
    //   expect(loginForm.invalidData, true);

    //   expect(
    //       find.text(
    //         'البريد إلكتروني/ كلمة المرور غير صالحة، يرجى المحاولة مرة أخرى.',
    //       ),
    //       findsOneWidget);
    // });

    test('Wrong Password', () async {
      password = 'wrong-password';
      when(() =>
              auth.signInWithEmailAndPassword(email: email, password: password))
          .thenThrow(FirebaseAuthException(code: 'wrong-password'));

      await loginForm.login(email, password, auth);

      expect(loginForm.invalidData, true);
    });
  });

  group('Register tests', () {
    late FirebaseFirestore mockFirestore;
    late CollectionReference<Map<String, dynamic>> mockCollectionRef;
    late Query<Map<String, dynamic>> mockQuery;
    late MockQuerySnapshot mockQuerySnapshot;

    var email = 'test@example.com';
    var password = 'Aa123456';
    var name = 'ريم الموسى';
    var phoneNum = '0512345678';
    late MockUserCredential mockUserCredential;

    setUp(() {
      mockUserCredential = MockUserCredential();

      //! Firestore
      mockFirestore = MockFirebaseFirestore();
      mockCollectionRef = MockCollectionReference();
      mockQuery = MockQuery();
      mockQuerySnapshot = MockQuerySnapshot();

      when(() => mockFirestore.collection('userAccount'))
          .thenReturn(mockCollectionRef);
      when(() =>
              mockCollectionRef.where('phone_number', isEqualTo: '0534567890'))
          .thenReturn(mockQuery);
      when(() => mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
    });

    testWidgets('TC_6 Valid Register', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: register(),
      ));
      var form = tester.state(find.byType(Form)) as FormState;

      form.reset();
      when(() => auth.createUserWithEmailAndPassword(
          email: email,
          password: password)).thenAnswer((_) async => mockUserCredential);

      await tester.enterText(
          find.widgetWithText(TextFormField, 'البريد الإلكتروني'), email);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'كلمة المرور'), password);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'تأكيد كلمة المرور'), password);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'الاسم الكامل'), name);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رقم الهاتف'), phoneNum);
      expect(form.validate(), isTrue);
      await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل'));
      await tester.pumpAndSettle();

      // Expect to navigate to the list of house account.
      expectLater(find.byType(ListOfHouseAccounts), findsOneWidget,
          reason: 'Expected to navigate after successful register');
    });

    testWidgets('TC_7 Empty Fields', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: register(),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      when(() => auth.createUserWithEmailAndPassword(
          email: email,
          password: password)).thenAnswer((_) async => mockUserCredential);

      await tester.enterText(
          find.widgetWithText(TextFormField, 'البريد الإلكتروني'), ' ');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'كلمة المرور'), ' ');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'تأكيد كلمة المرور'), ' ');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'الاسم الكامل'), ' ');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رقم الهاتف'), ' ');
      await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل'));
      await tester.pump();
      expect(form.validate(), isFalse);

      expect(find.text("الرجاء إدخال البريد الإلكتروني."), findsOneWidget);
      expect(find.text("الرجاء إدخال كلمة المرور."), findsOneWidget);
      expect(find.text("الرجاء تأكيد كلمة المرور"), findsOneWidget);
      expect(find.text('الرجاء إدخال الاسم الكامل.'), findsOneWidget);
      expect(find.text('الرجاء إدخال رقم الهاتف.'), findsOneWidget);
    });

    testWidgets('TC_8 Password < 8', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: register(),
      ));
      var form = tester.state(find.byType(Form)) as FormState;

      form.reset();
      when(() => auth.createUserWithEmailAndPassword(
          email: email,
          password: password)).thenAnswer((_) async => mockUserCredential);

      await tester.enterText(
          find.widgetWithText(TextFormField, 'البريد الإلكتروني'), email);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'كلمة المرور'), 'Aa123');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'تأكيد كلمة المرور'), password);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'الاسم الكامل'), name);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رقم الهاتف'), phoneNum);
      await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل'));
      await tester.pumpAndSettle();

      await tester.pump();
      expect(form.validate(), isFalse);

      expect(find.text("كلمة المرور يجب أن تكون من ٨ خانات على الاقل."),
          findsOneWidget);
    });

    testWidgets('TC_9 Password Doesn\'t Contain Upper Case Letter ',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: register(),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      when(() => auth.createUserWithEmailAndPassword(
          email: email,
          password: password)).thenAnswer((_) async => mockUserCredential);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'البريد الإلكتروني'), email);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'كلمة المرور'), 'aa123456');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'تأكيد كلمة المرور'), password);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'الاسم الكامل'), name);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رقم الهاتف'), phoneNum);
      await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل'));
      await tester.pumpAndSettle();
      await tester.pump();
      expect(form.validate(), isFalse);
      expect(
          find.text("كلمة المرور يجب أن تحتوي على حرف كبير باللغة الانجليزية."),
          findsOneWidget);
    });

    testWidgets('TC_10 Password Doesn\'t Contain Lower Case Letter ',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: register(),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      when(() => auth.createUserWithEmailAndPassword(
          email: email,
          password: password)).thenAnswer((_) async => mockUserCredential);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'البريد الإلكتروني'), email);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'كلمة المرور'), 'AA123456');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'تأكيد كلمة المرور'), password);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'الاسم الكامل'), name);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رقم الهاتف'), phoneNum);
      await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل'));
      await tester.pumpAndSettle();
      await tester.pump();
      expect(form.validate(), isFalse);
      expect(
          find.text("كلمة المرور يجب أن تحتوي على حرف صغير باللغة الانجليزية."),
          findsOneWidget);
    });

    testWidgets('TC_11 Password Doesn\'t Contain a Number',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: register(),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      when(() => auth.createUserWithEmailAndPassword(
          email: email,
          password: password)).thenAnswer((_) async => mockUserCredential);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'البريد الإلكتروني'), email);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'كلمة المرور'), 'AAAAaaaa');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'تأكيد كلمة المرور'), password);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'الاسم الكامل'), name);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رقم الهاتف'), phoneNum);
      await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل'));
      await tester.pumpAndSettle();
      await tester.pump();
      expect(form.validate(), isFalse);
      expect(find.text("كلمة المرور يجب أن تحتوي على رقم."), findsOneWidget);
    });

    testWidgets('TC_12 Two Password Doesn\'t Match',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: register(),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      when(() => auth.createUserWithEmailAndPassword(
          email: email,
          password: password)).thenAnswer((_) async => mockUserCredential);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'البريد الإلكتروني'), email);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'كلمة المرور'), password);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'تأكيد كلمة المرور'), 'Aa123123');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'الاسم الكامل'), name);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رقم الهاتف'), phoneNum);
      await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل'));
      await tester.pumpAndSettle();
      await tester.pump();
      expect(form.validate(), isFalse);
      expect(find.text("كلمة المرور غير متطابقة"), findsOneWidget);
    });

    testWidgets('TC_13 Invalid Phone Number', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: register(),
      ));
      var form = tester.state(find.byType(Form)) as FormState;

      form.reset();
      when(() => auth.createUserWithEmailAndPassword(
          email: email,
          password: password)).thenAnswer((_) async => mockUserCredential);

      await tester.enterText(
          find.widgetWithText(TextFormField, 'البريد الإلكتروني'), email);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'كلمة المرور'), password);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'تأكيد كلمة المرور'), password);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'الاسم الكامل'), name);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رقم الهاتف'), '055555');
      await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل'));
      await tester.pumpAndSettle();

      await tester.pump();
      expect(form.validate(), isFalse);

      expect(find.text('الرجاء إدخال رقم هاتف صالح.'), findsOneWidget);
    });

    testWidgets('TC_14 Used Phone Number', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: register(),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      when(() => mockQuerySnapshot.docs).thenReturn([]);
      when(() => auth.createUserWithEmailAndPassword(
          email: email,
          password: password)).thenAnswer((_) async => mockUserCredential);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'البريد الإلكتروني'), email);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'كلمة المرور'), password);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'تأكيد كلمة المرور'), password);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'الاسم الكامل'), name);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رقم الهاتف'), '0534567890');
      await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل'));
      await tester.pumpAndSettle();
      await tester.pump();
      expect(form.validate(), isFalse);
      expect(
          find.text('رقم الهاتف تم التسجيل به سابقًا، الرجاء إدخال رقم آخر.'),
          findsOneWidget);
    });

    testWidgets('TC_15 Invalid Email', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: register(),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      email = 'invalid-email';
      when(() => auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .thenThrow(FirebaseAuthException(code: 'invalid-email'));
      await tester.enterText(
          find.widgetWithText(TextFormField, 'البريد الإلكتروني'), email);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'كلمة المرور'), password);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'تأكيد كلمة المرور'), password);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'الاسم الكامل'), name);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رقم الهاتف'), phoneNum);
      await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل'));
      await tester.pumpAndSettle();
      await tester.pump();
      expect(form.validate(), isFalse);
      expect(find.text('الرجاء إدخال بريد إلكتروني صالح.'), findsOneWidget);
    });
  });
}

Future<UserCredential> signInWithEmailAndPassword(
  FirebaseAuth auth,
  String email,
  String password,
) async {
  try {
    final result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return result;
  } catch (e) {
    return Future.error(e);
  }
}
