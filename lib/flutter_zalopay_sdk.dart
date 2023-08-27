import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

part 'flutter_zalopay_payment_status.dart';


class FlutterZaloPaySdk {
  static const MethodChannel _channel =
      const MethodChannel('flutter.native/channelPayOrder');

  static Future<FlutterZaloPayStatus> payOrder({required String zpToken}) async {
        final String result =
        await _channel.invokeMethod('payOrder', {"zptoken": zpToken});
        switch(result) {
          case "User hủy thanh toán":
            return FlutterZaloPayStatus.cancelled;
          case "Thanh Toán Thành Công":
            return FlutterZaloPayStatus.success;
          case "Giao dịch thất bại":
            return FlutterZaloPayStatus.failed;
          default:
            return FlutterZaloPayStatus.failed;
        }
      }
  }
}
