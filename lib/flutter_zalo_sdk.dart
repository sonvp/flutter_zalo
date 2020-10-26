
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterZaloSdk {
  static const MethodChannel _channel =
      const MethodChannel('flutter.native/channelPayOrder');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
