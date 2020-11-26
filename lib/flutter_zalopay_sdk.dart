import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

part 'flutter_zalopay_payment_status.dart';

class FlutterZaloPaySdk {
  static const MethodChannel _channel =
      const MethodChannel('flutter.native/channelPayOrder');

  static const EventChannel _eventChannel =
      const EventChannel('flutter.native/eventPayOrder');
  static String currentStatus = '';
  static void _onEvent(Object event) {
    print("_onEvent: '$event'.");
    var res = Map<String, dynamic>.from(event);
    print("errorCode: " + res["errorCode"].toString());
    String payResult;
    if (res["errorCode"] == 1) {
      payResult = FlutterZaloPaymentStatus.SUCCESS;
    } else if (res["errorCode"] == 4) {
      payResult = FlutterZaloPaymentStatus.CANCELLED;
    } else {
      payResult = FlutterZaloPaymentStatus.FAILED;
    }
    currentStatus = payResult;
  }

  static void _onError(Object error) {
    print("_onError: '$error'.");
    String payResult = FlutterZaloPaymentStatus.CANCELLED;
    currentStatus = payResult;
  }

//  static Future<void> payOrder({String zpToken,Function onEvent, Function onError}) async {
//    try {
//      if (Platform.isIOS) {
//        _eventChannel
//            .receiveBroadcastStream()
//            .listen(onEvent, onError: _onError);
//        currentStatus = await _channel.invokeMethod('payOrder', {"zptoken": zpToken});
//      } else {
//        final String result =
//            await _channel.invokeMethod('payOrder', {"zptoken": zpToken});
//        print("payOrder Result: '$result'.");
//        currentStatus = result;
//      }
//    } on PlatformException catch (e) {
//      print("Failed to Invoke: '${e.message}'.");
//      throw PlatformException(
//          code: e.code, message: e.message, details: e.details);
//    }
//  }


  static Future<void> payOrder({String zpToken,Function(dynamic event) function}) async {
    try {
      if (Platform.isIOS) {
        _eventChannel
            .receiveBroadcastStream()
            .listen(function, onError: _onError);
        await _channel.invokeMethod('payOrder', {"zptoken": zpToken});

      } else {
        final String result =
        await _channel.invokeMethod('payOrder', {"zptoken": zpToken});
        //function(result);
        print("payOrder Result: '$result'.");
        currentStatus = result;
      }
    } on PlatformException catch (e) {
      print("Failed to Invoke: '${e.message}'.");
      throw PlatformException(
          code: e.code, message: e.message, details: e.details);
    }
  }


}
