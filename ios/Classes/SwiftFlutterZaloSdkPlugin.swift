import Flutter
import UIKit
import zpdk

class StreamHandler: NSObject, FlutterStreamHandler{
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        SwiftFlutterZaloSdkPlugin.eventSink = events
        return nil;
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }

    
}
public class SwiftFlutterZaloSdkPlugin: NSObject, FlutterPlugin ,ZPPaymentDelegate {

    let PAYMENTCOMPLETE = 1
    let PAYMENTERROR = -1
    let PAYMENTCANCELED = 4
    static var eventSink: FlutterEventSink?
    
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter.native/channelPayOrder", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(name: "flutter.native/eventPayOrder", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterZaloSdkPlugin()
    ZaloPaySDK.sharedInstance()?.initWithAppId(2553, uriScheme: "demozpdk://app", environment: .sandbox)
    registrar.addMethodCallDelegate(instance, channel: channel)
    eventChannel.setStreamHandler(StreamHandler())
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    if(call.method=="payOrder"){
        let args = call.arguments as? [String: Any]
        let  _zptoken = args?["zptoken"] as? String
        ZaloPaySDK.sharedInstance()?.paymentDelegate = self
        ZaloPaySDK.sharedInstance()?.payOrder(_zptoken)
        //result("Processing...")
    }
  }

    public func paymentDidSucceeded(_ transactionId: String!, zpTranstoken: String!, appTransId: String!) {
        //Handle Success
        guard let eventSink = SwiftFlutterZaloSdkPlugin.eventSink else {
          return
        }
        eventSink(["errorCode": PAYMENTCOMPLETE, "zpTranstoken": zpTranstoken ?? "", "transactionId": transactionId ?? "", "appTransId": appTransId ?? ""])
    }
    public func paymentDidCanceled(_ zpTranstoken: String!, appTransId: String!) {
        //Handle Canceled
        guard let eventSink = SwiftFlutterZaloSdkPlugin.eventSink else {
          return
        }
        eventSink(["errorCode": PAYMENTCANCELED, "zpTranstoken": zpTranstoken ?? "", "appTransId": appTransId ?? ""])
    }
    public func paymentDidError(_ errorCode: ZPPaymentErrorCode, zpTranstoken: String!, appTransId: String!) {
        guard let eventSink = SwiftFlutterZaloSdkPlugin.eventSink else {
          return
        }
        eventSink(["errorCode": PAYMENTERROR, "zpTranstoken": zpTranstoken ?? "", "appTransId": appTransId ?? ""])
    }
}
