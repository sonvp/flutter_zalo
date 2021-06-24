import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

part 'flutter_zalopay_payment_status.dart';


class FlutterZaloPaySdk {
  static const MethodChannel _channel =
      const MethodChannel('flutter.native/channelPayOrder');

  static const EventChannel _eventChannel =
      const EventChannel('flutter.native/eventPayOrder');

  static Stream<FlutterZaloPayStatus> payOrder({required String zpToken}) async*{
    if (Platform.isIOS) {
      _eventChannel.receiveBroadcastStream().listen((event) { });
      await _channel.invokeMethod('payOrder', {"zptoken": zpToken});
      Stream<dynamic> _eventStream = _eventChannel.receiveBroadcastStream();
      await for (var event in _eventStream) {
        var res = Map<String, dynamic>.from(event);
        if (res["errorCode"] == 1) {
          yield FlutterZaloPayStatus.success;
        } else if (res["errorCode"] == 4) {
          yield FlutterZaloPayStatus.cancelled;
        } else {
          yield FlutterZaloPayStatus.failed;
        }
      }
    } else{
      final String result =
      await _channel.invokeMethod('payOrder', {"zptoken": zpToken});
      switch(result) {
        case "User hủy thanh toán":
          yield FlutterZaloPayStatus.cancelled;
          break;
        case "Thanh Toán Thành Công":
          yield FlutterZaloPayStatus.success;
          break;
        case "Giao dịch thất bại":
          yield FlutterZaloPayStatus.failed;
          break;
        default:
          yield FlutterZaloPayStatus.failed;
          break;
      }
    }
  }
}
