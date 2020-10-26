import Flutter
import UIKit
import 'ZaloPaySDK.h'

public class SwiftFlutterZaloSdkPlugin: NSObject, FlutterPlugin , ZPPaymentDelegate {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_zalo_sdk", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterZaloSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
    if(call.method=="payOrder"){
        let args = call.arguments as? [String: Any]
        let  _zptoken = args?["zptoken"] as? String
        ZaloPaySDK.sharedInstance()?.paymentDelegate = self
        ZaloPaySDK.sharedInstance()?.payOrder(_zptoken)
        result("Processing...")
    }
  }

    func paymentDidSucceeded(_ transactionId: String!, zpTranstoken: String!, appTransId: String!) {
        //Handle Success
        guard let eventSink = eventSink else {
          return
        }
        eventSink(["errorCode": PAYMENTCOMPLETE, "zpTranstoken": zpTranstoken ?? "", "transactionId": transactionId ?? "", "appTransId": appTransId ?? ""])
    }
    func paymentDidCanceled(_ zpTranstoken: String!, appTransId: String!) {
        //Handle Canceled
        guard let eventSink = eventSink else {
          return
        }
        eventSink(["errorCode": PAYMENTCANCELED, "zpTranstoken": zpTranstoken ?? "", "appTransId": appTransId ?? ""])
    }
    func paymentDidError(_ errorCode: ZPPaymentErrorCode, zpTranstoken: String!, appTransId: String!) {
        guard let eventSink = eventSink else {
          return
        }
        eventSink(["errorCode": PAYMENTERROR, "zpTranstoken": zpTranstoken ?? "", "appTransId": appTransId ?? ""])
    }
}
