import UIKit
import Flutter
import zpdk

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ZaloPaySDK.sharedInstance().application(app, open:url, sourceApplication: "vn.com.vng.zalopay", annotation:nil)
    }
    
    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        ZaloPaySDK.sharedInstance()?.initWithAppId(2553, uriScheme: "demozpdk://app", environment: .sandbox)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
