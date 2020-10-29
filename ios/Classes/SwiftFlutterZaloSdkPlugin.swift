import Flutter
import UIKit
import zpdk

class StreamHandler: NSObject, FlutterStreamHandler, ZPPaymentDelegate{
    let PAYMENTCOMPLETE = 1
    let PAYMENTERROR = -1
    let PAYMENTCANCELED = 4
    
    func paymentDidSucceeded(_ transactionId: String!, zpTranstoken: String!, appTransId: String!) {
        //Handle Success
        print("Success payment")
        guard let eventSink = SwiftFlutterZaloSdkPlugin.eventSink else {
          return
        }
        eventSink(["errorCode": PAYMENTCOMPLETE, "zpTranstoken": zpTranstoken ?? "", "transactionId": transactionId ?? "", "appTransId": appTransId ?? ""])
    }
    func paymentDidCanceled(_ zpTranstoken: String!, appTransId: String!) {
        //Handle Canceled
        print("Cancelled payment")
        guard let eventSink = SwiftFlutterZaloSdkPlugin.eventSink else {
          return
        }
        eventSink(["errorCode": PAYMENTCANCELED, "zpTranstoken": zpTranstoken ?? "", "appTransId": appTransId ?? ""])
    }
    func paymentDidError(_ errorCode: ZPPaymentErrorCode, zpTranstoken: String!, appTransId: String!) {
        print("Error Payment")
        guard let eventSink = SwiftFlutterZaloSdkPlugin.eventSink else {
          return
        }
        eventSink(["errorCode": PAYMENTERROR, "zpTranstoken": zpTranstoken ?? "", "appTransId": appTransId ?? ""])
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        SwiftFlutterZaloSdkPlugin.eventSink = events
        return nil;
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }

    
}
public class SwiftFlutterZaloSdkPlugin: NSObject, FlutterPlugin {

    let PAYMENTCOMPLETE = 1
    let PAYMENTERROR = -1
    let PAYMENTCANCELED = 4
    static var eventSink: FlutterEventSink?
    
    var streamHandler = StreamHandler()
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter.native/channelPayOrder", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(name: "flutter.native/eventPayOrder", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterZaloSdkPlugin()
    eventChannel.setStreamHandler(StreamHandler())
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method=="payOrder"){
        let args = call.arguments as? [String: Any]
        let  _zptoken = args?["zptoken"] as? String
        ZaloPaySDK.sharedInstance()?.paymentDelegate = streamHandler
        ZaloPaySDK.sharedInstance()?.payOrder(_zptoken)
        //result("Processing...")
    }
  }

    
}
