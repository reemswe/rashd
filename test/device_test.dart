import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rashd/Devices/addDevice.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  late MockUser user; //Data of the Current User
  late MockFirebaseAuth firebaseAuth;
  late FakeFirebaseFirestore firestore;
  const deviceName = 'التلفاز';
  late FirebaseDatabase firebaseDatabase;
  var fakeData = {'HouseID': '', 'status': 'OFF'};
  MockFirebaseDatabase.instance.ref('devicesList/testDeviceID').set(fakeData);

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    firestore = FakeFirebaseFirestore();
    firebaseDatabase = MockFirebaseDatabase.instance;
  });
  group('Add Device tests', () {
    testWidgets('TC_35 Valid Addition', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AddDevice(
            ID: 'testHouseID',
            firestore: firestore,
            firebase: firebaseDatabase),
      ));
      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();
      await tester.enterText(
          find.widgetWithText(TextFormField, 'اسم الجهاز'), deviceName);
      await tester.tap(find.widgetWithText(ElevatedButton, 'إضافة الجهاز'));
      await tester.pump();
      expect(form.validate(), isTrue);
      final snapshot = await firestore
          .collection('houseAccount')
          .doc('testHouseID')
          .collection('houseDevices')
          .get();
      Map<String, dynamic> testData = {
        'ID': 'testDeviceID',
        'name': deviceName,
        'color': 'Color(0xffffffff)',
        'status': false,
      };
      fakeData = {'HouseID': 'testHouseID', 'status': 'OFF'};
      var data = await firebaseDatabase.ref('devicesList/testDeviceID').once();
      var data2 = data.snapshot.value;
      expect(data2, fakeData);
      expect(snapshot.docs[0].data(), testData);
    });

    testWidgets('TC_36 Empty Device Name', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AddDevice(ID: 'testHouseID', firestore: firestore),
      ));

      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'اسم الجهاز'), ' ');
      await tester.tap(find.widgetWithText(ElevatedButton, 'إضافة الجهاز'));
      await tester.pumpAndSettle();
      expect(form.validate(), isFalse);

      final snapshot = await firestore
          .collection('houseAccount')
          .doc('testHouseID')
          .collection('houseDevices')
          .get();

      expect(snapshot.docs.length, 0);

      expect(find.text('الرجاء ادخال اسم للجهاز'), findsOneWidget);
    });

    testWidgets('TC_37 Device Name > 15', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AddDevice(
            ID: 'testHouseID',
            firestore: firestore,
            firebase: firebaseDatabase),
      ));

      var form = tester.state(find.byType(Form)) as FormState;
      form.reset();

      await tester.enterText(find.widgetWithText(TextFormField, 'اسم الجهاز'),
          'ريم ابراهيم موسى الموسى');

      expect(
          (find
                  .widgetWithText(TextFormField, 'اسم الجهاز')
                  .evaluate()
                  .single
                  .widget as TextFormField)
              .controller!
              .text,
          'ريم ابراهيم موس');
    });
  });
}
