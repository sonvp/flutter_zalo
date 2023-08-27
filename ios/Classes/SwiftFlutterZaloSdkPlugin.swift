import Flutter
import UIKit
import zpdk

let PAYMENTCOMPLETE = 1
let PAYMENTERROR = -1
let PAYMENTCANCELED = 4


class ZPPaymentResultHandler : NSObject, ZPPaymentDelegate {
    
    private var result: FlutterResult
    
    required init(result: @escaping FlutterResult) {
        self.result = result
    }
    
    func paymentDidSucceeded(_ transactionId: String!, zpTranstoken: String!, appTransId: String!) {
        result(["errorCode": PAYMENTCOMPLETE, "zpTranstoken": zpTranstoken ?? "", "transactionId": transactionId ?? "", "appTransId": appTransId ?? ""])
    }
    
    func paymentDidCanceled(_ zpTranstoken: String!, appTransId: String!) {
        result(["errorCode": PAYMENTCANCELED, "zpTranstoken": zpTranstoken ?? "", "appTransId": appTransId ?? ""])
    }
    
    func paymentDidError(_ errorCode: ZPPaymentErrorCode, zpTranstoken: String!, appTransId: String!) {
        switch errorCode {
        case .appNotInstall:
            ZaloPaySDK.sharedInstance().navigateToZaloPayStore();
        default:
            result(["errorCode": PAYMENTERROR, "zpTranstoken": zpTranstoken ?? "", "appTransId": appTransId ?? ""])
        }
    }
    
    
}

public class SwiftFlutterZaloSdkPlugin: NSObject, FlutterPlugin{
        
    static var channel : FlutterMethodChannel!
    static var paymentHandler: ZPPaymentResultHandler!
    public static func register(with registrar: FlutterPluginRegistrar) {
    channel = FlutterMethodChannel(name: "flutter.native/channelPayOrder", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterZaloSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        paymentHandler = ZPPaymentResultHandler(result: result);
      if(call.method=="payOrder"){
          let args = call.arguments as? [String: Any]
          let  _zptoken = args?["zptoken"] as? String
          ZaloPaySDK.sharedInstance()?.paymentDelegate = paymentHandler
          ZaloPaySDK.sharedInstance()?.payOrder(_zptoken)
      }
    }
}
