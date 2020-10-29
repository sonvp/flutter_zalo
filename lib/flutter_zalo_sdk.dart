
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class FlutterZaloPaySdk {

   static const MethodChannel _channel =
      const MethodChannel('flutter.native/channelPayOrder');

   static const EventChannel _eventChannel = const
      EventChannel('flutter.native/eventPayOrder');
   static String currentStatus;

   static void _onEvent(Object event) {
     print("_onEvent: '$event'.");
     var res = Map<String, dynamic>.from(event);
     print("errorCode: "+ res["errorCode"].toString());
     String payResult;
       if (res["errorCode"] == 1) {
         payResult = "Thanh toán thành công";
       } else if  (res["errorCode"] == 4) {
         payResult = "User hủy thanh toán";
       }else {
         payResult = "Giao dịch thất bại";
       }
       currentStatus = payResult;
       print("CurrentStatus: $currentStatus");
   }

   static void _onError(Object error) {
     print("_onError: '$error'.");
       String payResult = "Giao dịch thất bại";
       currentStatus =  payResult;
   }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> payOrder({String zpToken}) async {
    try {
      if(Platform.isIOS){
        await _channel.invokeMethod('payOrder', {"zptoken": zpToken});
        _eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
      } else{
       final String result = await _channel.invokeMethod(
          'payOrder', {"zptoken": zpToken});
      print("payOrder Result: '$result'.");
      currentStatus = result;
      }
    } on PlatformException catch (e){
      print("Failed to Invoke: '${e.message}'.");
      throw PlatformException(code: e.code, message: e.message, details: e.details);
    }
  }
}
