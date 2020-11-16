import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zalo_sdk_example/repo/payment.dart';
import 'package:flutter_zalopay_sdk/flutter_zalopay_sdk.dart';
import 'package:flutter_zalo_sdk_example/utils/config.dart';
import 'package:flutter_zalo_sdk_example/utils/theme_data.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: myTheme,
      home: Dashboard(
        title: AppConfig.appName,
        version: AppConfig.version,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}


class Dashboard extends StatefulWidget {
  final String title;
  final String version;
  Dashboard({this.title, this.version});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          elevation: 0,
          // backgroundColor: Colors.transparent,
          leading: Center(
            child: Text(widget.version),
          ),
          title: Text(
            widget.title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        body: SafeArea(
          child: HomeZaloPay(widget.title),
        ),
      ),
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
    );
  }
}

class HomeZaloPay extends StatefulWidget {
  final String title;

  HomeZaloPay(this.title);

  @override
  _HomeZaloPayState createState() => _HomeZaloPayState();
}

class _HomeZaloPayState extends State<HomeZaloPay> {
  final textStyle = TextStyle(color: Colors.black54);
  final valueStyle = TextStyle(
      color: AppColor.accentColor, fontSize: 18.0, fontWeight: FontWeight.w400);
  String zpTransToken = "";
  String payResult = "";
  String payAmount = "10000";
  bool showResult = false;

  @override
  void initState() {
    super.initState();
  }

  // Button Create Order
  Widget _btnCreateOrder(String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
    child: GestureDetector(
      onTap: () async {
        int amount = int.parse(value);
        if (amount < 1000 || amount > 1000000) {
          setState(() {
            zpTransToken = "Invalid Amount";
          });
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              });
          var result = await createOrder(amount);
          if (result != null) {
            Navigator.pop(context);
            zpTransToken = result.zptranstoken;
            print("zpTransToken $zpTransToken'.");
            setState(() {
              zpTransToken = result.zptranstoken;
              showResult = true;
            });
          }
        }
      },
      child: Container(
          height: 50.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text("Create Order",
              style: TextStyle(color: Colors.white, fontSize: 20.0))),
    ),
  );

  /// Build Button Pay
  Widget _btnPay(String zpToken) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: Visibility(
        visible: showResult,
        child: GestureDetector(
          onTap: () async {
            String response = "";
            try {
              //final String result = await platform.invokeMethod('payOrder', {"zptoken": zpToken});
              await FlutterZaloPaySdk.payOrder(zpToken: zpToken);
              response = FlutterZaloPaySdk.currentStatus;
              FlutterZaloPaySdk.currentStatusStream.listen((event) => print(event));
              print("payOrder Result: '$response'.");
            } on PlatformException catch (e) {
              print("Failed to Invoke: '${e.message}'.");
              response = "Thanh toán thất bại";
            }
            setState(() {
              payResult = response;
            });
          },
          child: Container(
              height: 50.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text("Pay",
                  style: TextStyle(color: Colors.white, fontSize: 20.0))),
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _quickConfig,
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Amount',
              icon: Icon(Icons.attach_money),
            ),
            initialValue: payAmount,
            onChanged: (value) {
              setState(() {
                payAmount = value;
              });
            },
            keyboardType: TextInputType.number,
          ),
          _btnCreateOrder(payAmount),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Visibility(
              child: Text(
                "zptranstoken:",
                style: textStyle,
              ),
              visible: showResult,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              zpTransToken,
              style: valueStyle,
            ),
          ),
          _btnPay(zpTransToken),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Visibility(
                child: Text("Transaction status:", style: textStyle),
                visible: showResult),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              payResult,
              style: valueStyle,
            ),
          ),
        ],
      ),
    );
  }
}

/// Build Info App
Widget _quickConfig = Container(
  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text("AppID: 2553"),
          ),
        ],
      ),
      // _btnQuickEdit,
    ],
  ),
);

