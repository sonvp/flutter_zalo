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
        result(PAYMENTCOMPLETE)
    }
    
    func paymentDidCanceled(_ zpTranstoken: String!, appTransId: String!) {
        result(PAYMENTCANCELED)
    }
    
    func paymentDidError(_ errorCode: ZPPaymentErrorCode, zpTranstoken: String!, appTransId: String!) {
        switch errorCode {
        case .appNotInstall:
            ZaloPaySDK.sharedInstance().navigateToZaloPayStore();
        default:
            result(PAYMENTERROR)
        }
    }
    
    
}

public class SwiftFlutterZaloSdkPlugin: NSObject, FlutterPlugin{
        
    static var channel : FlutterMethodChannel!
    static var paymentHandler: ZPPaymentResultHandler!

    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: "flutter.native/channelPayOrder", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterZaloSdkPlugin()
        registrar.addApplicationDelegate(instance)
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
