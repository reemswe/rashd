import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rashd/Dashboard/dashboard.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  late MockUser user; //Data of the Current User
  late MockFirebaseAuth firebaseAuth;
  late FakeFirebaseFirestore firestore;
  late FirebaseDatabase firebaseDatabase;
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    user = MockUser(email: 'test@example.com', uid: 'mock_uid');
    firebaseAuth = MockFirebaseAuth(mockUser: user);
    firestore = FakeFirebaseFirestore();
    firebaseAuth.createUserWithEmailAndPassword(
        email: 'test@example.com', password: '123123');
  });
  group('Dashboard Goal tests', () {
    const houseName = 'البيت';
    setUp(() async {
      await firestore.collection('houseAccount').doc('testHouseId').set({
        'OwnerID': 'mock_uid',
        'houseID': 'testHouseId',
        'houseName': 'houseName',
        'isNotificationSent': false,
        'goal': '100',
        'totalConsumption': 0,
        'totalConsumptionPercentage': 0
      });
      firestore
          .collection('houseAccount')
          .doc('testHouseId')
          .collection('houseDevices')
          .add({
        'ID': 'testDeviceID',
        'color': 'Color(0xffbde0fe)',
        'name': 'test',
        'status': true
      });
      await firestore.collection('userAccount').doc('mock_uid').set({
        "email": 'email',
        "userId": 'mock_uid',
        "full_name": 'fullname',
        "phone_number": 'number',
        "token": ""
      });
      var fakeData = {
        'HouseID': 'testHouseId',
        'status': 'OFF',
        'consumption': {
          'currentConsumption': 20,
          'monthlyConsumption': {'2023-april': 50, '2023-march': 10}
        }
      };
      MockFirebaseDatabase.instance
          .ref('devicesList/testDeviceID')
          .set(fakeData);
      firebaseDatabase = MockFirebaseDatabase.instance;
    });

    testWidgets('TC_38 Valid Goal', (WidgetTester tester) async {
      await tester.runAsync(() => tester.pumpWidget(MaterialApp(
            home: dashboard(
                houseID: 'testHouseId',
                auth: firebaseAuth,
                firestore: firestore,
                realDB: firebaseDatabase),
          )));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      await tester.enterText(
          find.widgetWithText(TextFormField, '300kWh'), '1000');
      await tester.tap(find.widgetWithText(ElevatedButton, 'تحديد'));
      await tester.pumpAndSettle();
      final snapshot =
          await firestore.collection('houseAccount').doc('testHouseId').get();
      Map<String, dynamic> testData = {
        'OwnerID': 'mock_uid',
        'houseID': 'testHouseId',
        'houseName': 'houseName',
        'isNotificationSent': false,
        'goal': '1000',
        'totalConsumption': 0,
        'totalConsumptionPercentage': 0
      };
      expect(snapshot.data(), testData);
    });

    testWidgets('TC_39 Empty Goal', (WidgetTester tester) async {
      await tester.runAsync(() => tester.pumpWidget(MaterialApp(
            home: dashboard(
                houseID: 'testHouseId',
                auth: firebaseAuth,
                firestore: firestore,
                realDB: firebaseDatabase),
          )));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      var form = tester.state(find.byType(Form)) as FormState;

      await tester.enterText(find.widgetWithText(TextFormField, '300kWh'), ' ');
      await tester.tap(find.widgetWithText(ElevatedButton, 'تحديد'));
      expect(form.validate(), isFalse);
    });

    testWidgets('Dashboard Page', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: dashboard(
            houseID: 'testHouseId',
            auth: firebaseAuth,
            firestore: firestore,
            realDB: firebaseDatabase),
      ));
    });
  });
}
