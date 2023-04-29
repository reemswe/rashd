import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rashd/Dashboard/accessSharedDashboard.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  late MockUser user; //Data of the Current User
  late MockFirebaseAuth firebaseAuth;
  late FakeFirebaseFirestore firestore;
  const dashboardCode = '123123';
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
  group('Access Shared Dashboard Tests', () {
    setUp(() async {
      await firebaseAuth.signInWithEmailAndPassword(
          password: 'Aa123456', email: 'test@example.com');
      await firestore
          .collection('houseAccount')
          .doc('testHouseId')
          .collection('sharedCode')
          .add({'code': 123123, 'houseID': 'testHouseId', 'isExpired': false});
    });

    testWidgets('TC_31 Valid Access', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AccessSharedDashboard(firestore: firestore),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رمز لوحة المعلومات'),
          dashboardCode);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(form.validate(), isTrue);

      final snapshot = await firestore
          .collection('houseAccount')
          .doc('testHouseId')
          .collection('sharedCode')
          .where('code', isEqualTo: 123123)
          .get();

      Map<String, dynamic> testData = {
        'code': 123123,
        'houseID': 'testHouseId',
        'isExpired': true,
      };
      expect(snapshot.docs[0].data(), testData);
    });

    testWidgets('TC_32 Used Code', (WidgetTester tester) async {
      await firestore
          .collection('houseAccount')
          .doc('testHouseId')
          .collection('sharedCode')
          .add({'code': 123124, 'houseID': 'testHouseId', 'isExpired': true});
      await tester.pumpWidget(MaterialApp(
        home: AccessSharedDashboard(firestore: firestore),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رمز لوحة المعلومات'), '123124');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(form.validate(), isFalse);
      final snapshot = await firestore
          .collection('houseAccount')
          .doc('testHouseId')
          .collection('sharedCode')
          .where('code', isEqualTo: 123124)
          .get();
      Map<String, dynamic> testData = {
        'code': 123124,
        'houseID': 'testHouseId',
        'isExpired': true,
      };
      expect(snapshot.docs[0].data(), testData);
      expect(find.text('رمز لوحة المعلومات تم استخدامه بالفعل.'), findsOneWidget);
    });

    testWidgets('TC_33 Empty Code', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AccessSharedDashboard(firestore: firestore),
      ));

      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رمز لوحة المعلومات'), '  ');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(form.validate(), isFalse);

      expect(find.text('الرجاء إدخال رمز لوحة المعلومات.'), findsOneWidget);
    });

    testWidgets('TC_34 Invalid Code', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AccessSharedDashboard(firestore: firestore),
      ));

      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      await tester.enterText(
          find.widgetWithText(TextFormField, 'رمز لوحة المعلومات'), '111222');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(form.validate(), isFalse);

      final snapshot = await firestore
          .collection('houseAccount')
          .doc('testHouseId')
          .collection('sharedCode')
          .where('code', isEqualTo: 111222)
          .get();

      expect(snapshot.docs.length, 0);
      expect(find.text('رمز لوحة المعلومات غير صالح.'), findsOneWidget);
    });
  });
}
