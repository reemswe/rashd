import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rashd/Registration/login.dart';
import 'package:rashd/Registration/register.dart';
import 'package:rashd/Registration/welcomePage.dart';

void main() {
  late MockUser user; //Data of the Current User
  late MockFirebaseAuth firebaseAuth;
  late FakeFirebaseFirestore firestore;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    user = MockUser(
      email: 'used@example.com',
      uid: 'testId',
    );
    firebaseAuth = MockFirebaseAuth();
    firestore = FakeFirebaseFirestore();
  });

  group('Login tests', () {
    var email = 'test@example.com';
    var password = 'Aa123456';

    setUp(() {
      firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    });
    testWidgets('TC_1 Valid Login', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Login(auth: firebaseAuth),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      await tester.enterText(
          find.widgetWithText(TextFormField, 'البريد الإلكتروني'), email);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'كلمة المرور'), password);
      await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل الدخول'));
      expect(form.validate(), isTrue);

      await tester.pumpAndSettle();
    });
    testWidgets('TC_2 Empty Email', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Login(auth: firebaseAuth),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
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
      await tester.pumpWidget(MaterialApp(
        home: Login(auth: firebaseAuth),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      await tester.enterText(
          find.widgetWithText(TextFormField, 'البريد الإلكتروني'), email);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'كلمة المرور'), '');
      await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل الدخول'));
      await tester.pump();

      expect(form.validate(), isFalse);
      expect(find.text('الرجاء إدخال كلمة المرور.'), findsOneWidget);
    });

    testWidgets('TC_4 Invalid Email', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Login(auth: firebaseAuth),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'البريد الإلكتروني'), 'reem');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'كلمة المرور'), password);

      await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل الدخول'));

      await tester.pump();

      expect(
          find.text(
            'البريد إلكتروني/ كلمة المرور غير صالحة، يرجى المحاولة مرة أخرى.',
          ),
          findsOneWidget);
    });

    testWidgets('TC_5 Wrong Password', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Login(auth: firebaseAuth),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      password = 'wrong-password';
      await tester.enterText(
          find.widgetWithText(TextFormField, 'البريد الإلكتروني'), email);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'كلمة المرور'), password);
      await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل الدخول'));
      await tester.pump();

      expect(
          find.text(
            'البريد إلكتروني/ كلمة المرور غير صالحة، يرجى المحاولة مرة أخرى.',
          ),
          findsOneWidget);
    });
  });

  group('Register tests', () {
    var email = 'test@example.com';
    var password = 'Aa123456';
    var name = 'ريم الموسى';
    var phoneNum = '0512345678';

    testWidgets('TC_6 Valid Register', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: register(auth: firebaseAuth, firestore: firestore),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
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
      await tester.pump();
      final snapshot = await firestore.collection('userAccount').get();
      Map<String, dynamic> testData = {
        "email": email,
        "userId": snapshot.docs[0].id,
        "full_name": name,
        "phone_number": phoneNum,
        "token": ""
      };
      expect(snapshot.docs[0].data(), testData);
    });

    testWidgets('TC_7 Empty Fields', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: register(
          auth: firebaseAuth,
          firestore: firestore,
        ),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();

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
      await tester.pumpWidget(MaterialApp(
        home: register(
          auth: firebaseAuth,
          firestore: firestore,
        ),
      ));
      var form = tester.state(find.byType(Form)) as FormState;

      form.reset();
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
      await tester.pumpWidget(MaterialApp(
        home: register(
          auth: firebaseAuth,
          firestore: firestore,
        ),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
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
      await tester.pumpWidget(MaterialApp(
        home: register(
          auth: firebaseAuth,
          firestore: firestore,
        ),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
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
      await tester.pumpWidget(MaterialApp(
        home: register(
          auth: firebaseAuth,
          firestore: firestore,
        ),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
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
      await tester.pumpWidget(MaterialApp(
        home: register(
          auth: firebaseAuth,
          firestore: firestore,
        ),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
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
      await tester.pumpWidget(MaterialApp(
        home: register(
          auth: firebaseAuth,
          firestore: firestore,
        ),
      ));
      var form = tester.state(find.byType(Form)) as FormState;

      form.reset();

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
      await firestore
          .collection('userAccount')
          .add({'phone_number': '0512345668'});
      await tester.pumpWidget(MaterialApp(
        home: register(
          auth: firebaseAuth,
          firestore: firestore,
        ),
      ));

      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      await tester.enterText(
          find.widgetWithText(TextFormField, 'البريد الإلكتروني'), email);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'كلمة المرور'), password);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'تأكيد كلمة المرور'), password);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'الاسم الكامل'), name);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رقم الهاتف'), '0512345668');
      await tester.tap(find.widgetWithText(ElevatedButton, 'تسجيل'));
      await tester.pumpAndSettle();
      await tester.pump();
      expect(form.validate(), isFalse);
      expect(
          find.text('رقم الهاتف تم التسجيل به سابقًا، الرجاء إدخال رقم آخر.'),
          findsOneWidget);
    });

    testWidgets('Welcome Page', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: welcomePage(),
      ));
    });
  });
}
