# flutter_zalo_sdk

A Zalo SDK.

## Getting Started

NOTE: Get your appid from Zalo in order for ZaloPaySDK to work. In this readme we will use appId = 2553, as this is demo appID from Zalo

# flutter_zalo

A Flutter Wrapper for ease of interacting with ZaloPaySDK. 

https://docs.zalopay.vn/docs/apptoapp/api.html#ngu-canh-su-dung


### Android setup:

* Set up your ```AndroidManifest.xml``` as below:

```xml
 <activity
      ...
     android:launchMode="singleTask"
     ...>
   <intent-filter>
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="demozpdk"
                    android:host="app" />
    </intent-filter>
  
   <meta-data
            android:name="com.vng.zalo.sdk.APP_ID"
            android:value="2553" />
</activity>
           
```

### iOS setup:

* Set up your ```Info.plist``` as below

```xml
<key>CFBundleURLTypes</key>
    	<array>
    		<dict>
    			<key>CFBundleTypeRole</key>
    			<string>Editor</string>
    			<key>CFBundleURLName</key>
    			<string>com.flutterzalopay.flutterZaloSdkExample</string>
    			<key>CFBundleURLSchemes</key>
    			<array>
    				<string>demozpdk</string>
    			</array>
    		</dict>
    		<dict>
    			<key>CFBundleTypeRole</key>
    			<string>Editor</string>
    			<key>CFBundleURLName</key>
    			<string>com.flutterzalopay.flutterZaloSdkExample</string>
    			<key>CFBundleURLSchemes</key>
    			<array>
    				<string>zp-redirect-2553</string>
    			</array>
    		</dict>
    	</array>
<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>zalo</string>
		<string>zalopay</string>
		<string>zalopay.api.v2</string>
	</array>
```

* Add the following to your ``AppDelegate.swift``` file

```swift
...
import zpdk

override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ZaloPaySDK.sharedInstance().application(app, open:url, sourceApplication: "vn.com.vng.zalopay", annotation:nil)
    }
```

* In didFinishLaunchingWithOptions, add the line:

```swift 
  ZaloPaySDK.sharedInstance()?.initWithAppId(2553, uriScheme: "demozpdk://app", environment: .sandbox)
```



