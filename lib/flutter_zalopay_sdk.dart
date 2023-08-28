import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

part 'flutter_zalopay_payment_status.dart';


class FlutterZaloPaySdk {
  static const MethodChannel _channel =
      const MethodChannel('flutter.native/channelPayOrder');

  static Future<FlutterZaloPayStatus> payOrder({required String zpToken}) async {
    final int result =
    await _channel.invokeMethod('payOrder', {"zptoken": zpToken});
    switch(result) {
      case 4:
        return FlutterZaloPayStatus.cancelled;
      case 1:
        return FlutterZaloPayStatus.success;
      case -1:
        return FlutterZaloPayStatus.failed;
      default:
        return FlutterZaloPayStatus.failed;
    }
  }
}
