import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rashd/HouseAccount/add_house_member.dart';
import 'package:rashd/HouseAccount/create_house_account.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  late MockUser user; //Data of the Current User
  late MockFirebaseAuth firebaseAuth;
  late FakeFirebaseFirestore firestore;
  const memberName = 'ريم الموسى';
  const memberPhoneNumber = '0512345678';
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    //Firebase Auth Mocks
    user = MockUser(
      email: 'test@example.com',
      uid: 'testId',
    );
    firebaseAuth = MockFirebaseAuth(mockUser: user);
    //Cloud Firestore Mocks
    firestore = FakeFirebaseFirestore();
  });
  group('Create House Account tests', () {
    const houseName = 'البيت';
    setUp(() async {
      await firebaseAuth.signInWithEmailAndPassword(
          password: 'Aa123456', email: 'test@example.com');
      await firestore
          .collection('userAccount')
          .add({'phone_number': '0512345678', 'userId': 'testId2'});
      await firestore
          .collection('userAccount')
          .add({'phone_number': '0512345677', 'userId': 'testId'});
    });

    testWidgets('TC_16  Valid Creation', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CreateHouseAccount(firestore: firestore, auth: firebaseAuth),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      await tester.enterText(
          find.widgetWithText(TextFormField, 'اسم المنزل'), houseName);
      await tester.drag(
          find.byKey(const Key("formScroll")), const Offset(0, -200));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(form.validate(), isTrue);

      final snapshot = await firestore.collection('houseAccount').get();
      Map<String, dynamic> testData = {
        'OwnerID': 'testId',
        'houseID': snapshot.docs[0].id,
        'houseName': houseName,
        'isNotificationSent': false,
        'goal': '0',
        'totalConsumption': 0,
        'totalConsumptionPercentage': 0
      };
      expect(snapshot.docs[0].data(), testData);
    });

    testWidgets('TC_17  Valid Creation With Member',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CreateHouseAccount(firestore: firestore, auth: firebaseAuth),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      await tester.enterText(
          find.widgetWithText(TextFormField, 'اسم المنزل'), houseName);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'الاسم '), memberName);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رقم الهاتف'), memberPhoneNumber);
      //The default value of privilege is 'Viewer'
      await tester.drag(
          find.byKey(const Key("formScroll")), const Offset(0, -200));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(form.validate(), isTrue);
      final snapshot = await firestore.collection('houseAccount').get();
      final subSnapshot = await firestore
          .collection('houseAccount')
          .doc(snapshot.docs[0].id)
          .collection('houseMember')
          .get();
      Map<String, dynamic> testHouseData = {
        'OwnerID': 'testId',
        'houseID': snapshot.docs[0].id,
        'houseName': houseName,
        'isNotificationSent': false,
        'goal': '0',
        'totalConsumption': 0,
        'totalConsumptionPercentage': 0
      };

      Map<String, dynamic> testMemberData = {
        'memberPhoneNumber': memberPhoneNumber,
        'privilege': 'viewer',
        'nickName': memberName,
        'memberID': 'testId2'
      };
      expect(subSnapshot.docs[0].data(), testMemberData);
      expect(snapshot.docs[0].data(), testHouseData);
    });

    testWidgets('TC_18 Empty House Name', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CreateHouseAccount(),
      ));

      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'اسم المنزل'), ' ');
      await tester.drag(
          find.byKey(const Key("formScroll")), const Offset(0, -200));
      await tester.tap(find.widgetWithText(ElevatedButton, 'إنشاء'));

      await tester.pumpAndSettle();
      expect(form.validate(), isFalse);
      expect(find.text('الرجاء ادخال اسم للمنزل'), findsOneWidget);
    });

    testWidgets('TC_19 House Name Length > 20', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CreateHouseAccount(),
      ));

      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();

      await tester.enterText(find.widgetWithText(TextFormField, 'اسم المنزل'),
          'ريم ابراهيم موسى الموسى');

      expect(
          (find
                  .widgetWithText(TextFormField, 'اسم المنزل')
                  .evaluate()
                  .single
                  .widget as TextFormField)
              .controller!
              .text,
          'ريم ابراهيم موسى الم');
    });

    testWidgets('TC_20 Empty Member Name', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CreateHouseAccount(),
      ));

      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'اسم المنزل'), houseName);
      await tester.enterText(find.widgetWithText(TextFormField, 'الاسم '), ' ');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رقم الهاتف'), memberPhoneNumber);
      //The default value of privilege is 'Viewer'
      await tester.drag(
          find.byKey(const Key("formScroll")), const Offset(0, -100));
      await tester.tap(find.widgetWithText(ElevatedButton, 'إنشاء'));
      await tester.pumpAndSettle();
      expect(form.validate(), isFalse);
      expect(find.text('اختر إسمًا للعضو '), findsOneWidget);
    });

    testWidgets('TC_21 Empty Member Phone Number', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CreateHouseAccount(),
      ));

      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'اسم المنزل'), houseName);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'الاسم '), memberName);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رقم الهاتف'), ' ');
      //The default value of privilege is 'Viewer'
      await tester.drag(
          find.byKey(const Key("formScroll")), const Offset(0, -200));
      await tester.tap(find.widgetWithText(ElevatedButton, 'إنشاء'));

      await tester.pumpAndSettle();
      expect(form.validate(), isFalse);
      expect(find.text('ادخل رقمًا صحيحًا مكونًا من ١٠ أرقام'), findsOneWidget);
    });

    testWidgets('TC_22  Valid Creation With 5 Member',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CreateHouseAccount(firestore: firestore, auth: firebaseAuth),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      await tester.enterText(
          find.widgetWithText(TextFormField, 'اسم المنزل'), houseName);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'الاسم '), memberName);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رقم الهاتف'), memberPhoneNumber);
      //The default value of privilege is 'Viewer'

      await tester.tap(find.byType(TextButton));
      await tester.drag(
          find.byKey(const Key("formScroll")), const Offset(0, -200));
      await tester.tap(find.byType(TextButton));
      await tester.drag(
          find.byKey(const Key("formScroll")), const Offset(0, -200));
      await tester.tap(find.byType(TextButton));
      await tester.drag(
          find.byKey(const Key("formScroll")), const Offset(0, -200));
      await tester.tap(find.byType(TextButton));
      await tester.drag(
          find.byKey(const Key("formScroll")), const Offset(0, -200));
      await tester.tap(find.byType(TextButton));
      await tester.drag(
          find.byKey(const Key("formScroll")), const Offset(0, -200));
      await tester.tap(find.byType(TextButton));
      await tester.drag(
          find.byKey(const Key("formScroll")), const Offset(0, -200));
      await tester.tap(find.byType(TextButton));
      await tester.drag(
          find.byKey(const Key("formScroll")), const Offset(0, -200));
      await tester.tap(find.byType(TextButton));
      await tester.drag(
          find.byKey(const Key("formScroll")), const Offset(0, -200));
      await tester.tap(find.byType(TextButton));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(form.validate(), isTrue);

      final snapshot = await firestore.collection('houseAccount').get();
      final subSnapshot = await firestore
          .collection('houseAccount')
          .doc(snapshot.docs[0].id)
          .collection('houseMember')
          .get();
      Map<String, dynamic> testHouseData = {
        'OwnerID': 'testId',
        'houseID': snapshot.docs[0].id,
        'houseName': houseName,
        'isNotificationSent': false,
        'goal': '0',
        'totalConsumption': 0,
        'totalConsumptionPercentage': 0
      };

      Map<String, dynamic> testMemberData = {
        'memberPhoneNumber': memberPhoneNumber,
        'privilege': 'viewer',
        'nickName': memberName,
        'memberID': 'testId2'
      };
      expect(subSnapshot.docs[0].data(), testMemberData);
      expect(snapshot.docs[0].data(), testHouseData);
    });

    testWidgets('TC_23 Invalid Creation With > 5 Member',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CreateHouseAccount(firestore: firestore, auth: firebaseAuth),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      await tester.enterText(
          find.widgetWithText(TextFormField, 'اسم المنزل'), houseName);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'الاسم '), memberName);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رقم الهاتف'), memberPhoneNumber);
      //The default value of privilege is 'Viewer'

      await tester.tap(find.byType(TextButton));
      await tester.drag(
          find.byKey(const Key("formScroll")), const Offset(0, -200));
      await tester.tap(find.byType(TextButton));
      await tester.drag(
          find.byKey(const Key("formScroll")), const Offset(0, -200));
      await tester.tap(find.byType(TextButton));
      await tester.drag(
          find.byKey(const Key("formScroll")), const Offset(0, -200));
      await tester.tap(find.byType(TextButton));
      await tester.drag(
          find.byKey(const Key("formScroll")), const Offset(0, -200));
      await tester.tap(find.byType(TextButton));
      await tester.drag(
          find.byKey(const Key("formScroll")), const Offset(0, -200));
      await tester.tap(find.byType(TextButton));
      await tester.drag(
          find.byKey(const Key("formScroll")), const Offset(0, -200));
      await tester.tap(find.byType(TextButton));
      await tester.drag(
          find.byKey(const Key("formScroll")), const Offset(0, -200));
      await tester.tap(find.byType(TextButton));
      await tester.drag(
          find.byKey(const Key("formScroll")), const Offset(0, -200));
      await tester.tap(find.byType(TextButton));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(form.validate(), isTrue);

      final snapshot = await firestore.collection('houseAccount').get();
      final subSnapshot = await firestore
          .collection('houseAccount')
          .doc(snapshot.docs[0].id)
          .collection('houseMember')
          .get();
      Map<String, dynamic> testHouseData = {
        'OwnerID': 'testId',
        'houseID': snapshot.docs[0].id,
        'houseName': houseName,
        'isNotificationSent': false,
        'goal': '0',
        'totalConsumption': 0,
        'totalConsumptionPercentage': 0
      };

      Map<String, dynamic> testMemberData = {
        'memberPhoneNumber': memberPhoneNumber,
        'privilege': 'viewer',
        'nickName': memberName,
        'memberID': 'testId2'
      };
      expect(subSnapshot.docs[0].data(), testMemberData);
      expect(snapshot.docs[0].data(), testHouseData);
    });
  });

  group('Add Member tests', () {
    setUp(() async {
      await firebaseAuth.signInWithEmailAndPassword(
          password: 'Aa123456', email: 'test@example.com');
      await firestore
          .collection('userAccount')
          .add({'phone_number': '0512345678', 'userId': 'testId2'});
      await firestore
          .collection('userAccount')
          .add({'phone_number': '0512345677', 'userId': 'testId'});
    });

    testWidgets('TC_24 Valid Viewer Member', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: add_house_member(
            houseID: 'testHouseID', firestore: firestore, auth: firebaseAuth),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      await tester.enterText(
          find.widgetWithText(TextFormField, 'الاسم'), memberName);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رقم الهاتف'), memberPhoneNumber);
      //The default value of privilege is 'Viewer'
      await tester.tap(find.widgetWithText(ElevatedButton, 'إضافة'));
      await tester.pump();
      expect(form.validate(), isTrue);
      final snapshot = await firestore
          .collection('houseAccount')
          .doc('testHouseID')
          .collection('houseMember')
          .get();
      Map<String, dynamic> testData = {
        "memberID": 'testId2',
        'memberPhoneNumber': memberPhoneNumber,
        'nickName': memberName,
        'privilege': 'viewer',
      };
      expect(snapshot.docs[0].data(), testData);
    });

    testWidgets('TC_25 Valid Editor Member', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: add_house_member(
            houseID: 'testHouseID', firestore: firestore, auth: firebaseAuth),
      ));
      await firebaseAuth.signInWithEmailAndPassword(
          password: 'Aa123456', email: 'test@example.com');
      await firestore
          .collection('userAccount')
          .add({'phone_number': '0512345678', 'userId': 'testId2'});
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      await tester.enterText(
          find.widgetWithText(TextFormField, 'الاسم'), memberName);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رقم الهاتف'), memberPhoneNumber);
      await tester.tap(find.text('   محرر'));
      await tester.tap(find.widgetWithText(ElevatedButton, 'إضافة'));
      await tester.pumpAndSettle();
      expect(form.validate(), isTrue);
      final snapshot = await firestore
          .collection('houseAccount')
          .doc('testHouseID')
          .collection('houseMember')
          .get();
      Map<String, dynamic> testData = {
        "memberID": 'testId2',
        'memberPhoneNumber': memberPhoneNumber,
        'nickName': memberName,
        'privilege': 'editor',
      };
      expect(snapshot.docs[0].data(), testData);
    });

    testWidgets('TC_26 Empty Fields', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: add_house_member(
            houseID: 'testHouseID', firestore: firestore, auth: firebaseAuth),
      ));

      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();

      await tester.enterText(find.widgetWithText(TextFormField, 'الاسم'), ' ');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رقم الهاتف'), ' ');
      //The default value of privilege is 'Viewer'

      await tester.tap(find.widgetWithText(ElevatedButton, 'إضافة'));
      await tester.pumpAndSettle();
      expect(form.validate(), isFalse);
      expect(find.text('الرجاء ادخال اسم للعضو '), findsOneWidget);
      expect(find.text('الرجاء ادخال رقم للهاتف'), findsOneWidget);
    });

    testWidgets('TC_27 Phone Number < 10', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: add_house_member(
            houseID: 'testHouseID', firestore: firestore, auth: firebaseAuth),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'الاسم'), memberName);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رقم الهاتف'), '05');
      //The default value of privilege is 'Viewer'

      await tester.tap(find.widgetWithText(ElevatedButton, 'إضافة'));
      await tester.pumpAndSettle();
      expect(form.validate(), isFalse);
      expect(find.text('ادخل رقمًا صحيحًا مكونًا من ١٠ أرقام'), findsOneWidget);
    });

    testWidgets('TC_28 Owner Phone Number', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: add_house_member(
            houseID: 'testHouseID', firestore: firestore, auth: firebaseAuth),
      ));

      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      await tester.enterText(
          find.widgetWithText(TextFormField, 'الاسم'), memberName);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رقم الهاتف'), '0512345677');
      //The default value of privilege is 'Viewer'
      await tester.tap(find.widgetWithText(ElevatedButton, 'إضافة'));
      await tester.pumpAndSettle();
      expect(form.validate(), isTrue);
      expect(find.text('العضو هو مالك المنزل'), findsOneWidget);

      final snapshot = await firestore
          .collection('houseAccount')
          .doc('testHouseID')
          .collection('houseMember')
          .get();

      expect(snapshot.docs.length, 0);
    });

    testWidgets('TC_29 Invalid Phone Number', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: add_house_member(
            houseID: 'testHouseID', firestore: firestore, auth: firebaseAuth),
      ));

      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      await tester.enterText(
          find.widgetWithText(TextFormField, 'الاسم'), memberName);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رقم الهاتف'), '0000011111');
      //The default value of privilege is 'Viewer'
      await tester.tap(find.widgetWithText(ElevatedButton, 'إضافة'));
      await tester.pump();
      expect(form.validate(), isTrue);
      expect(find.text('العضو غير موجود بالنطام'), findsOneWidget);

      final snapshot = await firestore
          .collection('houseAccount')
          .doc('testHouseID')
          .collection('houseMember')
          .get();

      expect(snapshot.docs.length, 0);
    });

    testWidgets('TC_30 Name Length > 20', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: add_house_member(
            houseID: 'testHouseID', firestore: firestore, auth: firebaseAuth),
      ));

      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();

      await tester.enterText(find.widgetWithText(TextFormField, 'الاسم'),
          'ريم ابراهيم موسى الموسى');
      expect(
          (find.widgetWithText(TextFormField, 'الاسم').evaluate().single.widget
                  as TextFormField)
              .controller!
              .text,
          'ريم ابراهيم موسى الم');
    });
  });
}
