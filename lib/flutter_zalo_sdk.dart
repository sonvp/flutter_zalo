
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class FlutterZaloSdk {

   static const MethodChannel _channel =
      const MethodChannel('flutter.native/channelPayOrder');

   static const EventChannel _eventChannel = const
      EventChannel('flutter.native/eventPayOrder');

   static String _onEvent(Object event) {
     print("_onEvent: '$event'.");
     var res = Map<String, dynamic>.from(event);
     String payResult;
       if (res["errorCode"] == 1) {
         payResult = "Thanh toán thành công";
       } else if  (res["errorCode"] == 4) {
         payResult = "User hủy thanh toán";
       }else {
         payResult = "Giao dịch thất bại";
       }
       return payResult;
   }

   static String _onError(Object error) {
     print("_onError: '$error'.");
       String payResult = "Giao dịch thất bại";
       return payResult;
   }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> payOrder({String zpToken}) async {
    if (Platform.isIOS) {
      _eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
    }
    try {
      final String result = await _channel.invokeMethod(
          'payOrder', {"zptoken": zpToken});
      print("payOrder Result: '$result'.");
      return result;
    } on PlatformException catch (e){
      print("Failed to Invoke: '${e.message}'.");
      throw PlatformException(code: e.code, message: e.message, details: e.details);
    }
  }
}
