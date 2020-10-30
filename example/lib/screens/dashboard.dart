import 'package:flutter/material.dart';
import 'package:flutter_zalo_sdk_example/screens/home_zalo_pay.dart';

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
