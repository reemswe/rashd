import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'register.dart';

class accsessShared extends StatefulWidget {
  const accsessShared({
    Key? key,
  }) : super(key: key);
  _accsessSharedState createState() => _accsessSharedState();
}

TextEditingController codeController = TextEditingController();

void clearForm() {
  codeController.text = '';
}

class _accsessSharedState extends State<accsessShared> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        foregroundColor: Colors.black87,
        centerTitle: true,
        title: Text(
          'لوحة المنزل المشتركة',
        ),
        leading: //Icon(Icons.more_vert)
            Text(''),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
            ),
            onPressed: () {
              clearForm();
              Navigator.of(context).pop();
            },
          ),
        ],
        // elevation: 15,
      ),
      body: loginForm(),
    );
  }
}

class loginForm extends StatefulWidget {
  loginFormState createState() {
    return loginFormState();
  }
}

bool _passwordVisible = false;

class loginFormState extends State<loginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  ScrollController _scrollController = ScrollController();

  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('الثلاجة', 350),
      ChartData('المكيف', 230),
      ChartData('التلفاز', 340),
      ChartData('المايكرويف', 250),
      ChartData('الفريزر', 400)
    ];
    // ChartData('الثلاجة', 35),
    //   ChartData( 'المكيف', 23),
    //   ChartData('التلفاز', 34),
    //   ChartData('المايكرويف', 25),
    //   ChartData('الفريزر', 40)
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(children: <Widget>[
          Image.asset(
            'assets/images/logo.png',
            height: 200,
            width: 200,
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(6, 12, 0, 0),
              child: TextFormField(
                //     style: TextStyle(color: Colors.black),
                // maxLength: 20,
                readOnly: true,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  hintText: 'رمز لوحة المعلومات ',
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  border: InputBorder.none,
                ),
              )),
          Container(
              padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
              child: TextFormField(
                // maxLength: 20,
                textAlign: TextAlign.right,
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'الرمز',
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: const BorderSide(color: Colors.grey)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: BorderSide(color: Colors.grey.shade400)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0)),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      (value.trim()).isEmpty) {
                    return 'Please enter a title.';
                  }
                  return null;
                },
              )),

          //button
          Container(
              child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate())
                //       Navigator.push(
                // context,
                // MaterialPageRoute(
                //   builder: (context) => homePage(),
                // ));
                clearForm();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('تم تسجيل دخولك بنجاح'),
                    backgroundColor: Colors.green),
              );
            },
            child: Text('تحقق من الرمز'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          )),
          // SfCartesianChart(
          //     primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Devices')),
          //     primaryYAxis: NumericAxis(title: AxisTitle(text: 'kWh')),
          //     series: <ChartSeries<ChartData, String>>[
          //       // Renders column chart
          //       ColumnSeries<ChartData, String>(
          //           borderRadius: BorderRadius.all(Radius.circular(20)),
          //           dataSource: chartData,
          //           dataLabelSettings: DataLabelSettings(isVisible: true),
          //           xValueMapper: (ChartData data, _) => data.x,
          //           yValueMapper: (ChartData data, _) => data.y),
          //     ]),
        ]),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
