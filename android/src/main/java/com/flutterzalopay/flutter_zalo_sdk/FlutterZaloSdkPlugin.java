package com.flutterzalopay.flutter_zalo_sdk;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.NewIntentListener;
import vn.zalopay.sdk.Environment;
import vn.zalopay.sdk.ZaloPayError;
import vn.zalopay.sdk.ZaloPaySDK;
import vn.zalopay.sdk.listeners.PayOrderListener;

/** FlutterZaloSdkPlugin */

public class FlutterZaloSdkPlugin implements FlutterPlugin, ActivityAware, MethodCallHandler, NewIntentListener {
  private final String META_DATA_SDK_ZALO_APP_ID = "com.vng.zalo.sdk.APP_ID";
  private final String META_DATA_SDK_ZALO_URI_SCHEME = "com.vng.zalo.sdk.URI_SCHEME";
  private final String META_DATA_SDK_ZALO_ENVIRONMENT = "com.vng.zalo.sdk.ENVIRONMENT";

  private Activity activity;
  private Context context;
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    // Register a method channel that the Flutter app may invoke
    MethodChannel channel = new MethodChannel(binding.getBinaryMessenger(), "flutter.native/channelPayOrder");
    // Handle method calls (onMethodCall())
    channel.setMethodCallHandler(this);
    context = binding.getApplicationContext();
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
    // Listen for new intents (notification clicked)
    binding.addOnNewIntentListener(this);
    Log.d(FlutterZaloSdkPlugin.class.getSimpleName(), "App Id Zalo: "+getAppIdZalo());
    Log.d(FlutterZaloSdkPlugin.class.getSimpleName(), "Environment: "+getAppEnvironment());
    Log.d(FlutterZaloSdkPlugin.class.getSimpleName(), "Uri Scheme: "+getAppUriScheme());
    ZaloPaySDK.init(getAppIdZalo(), getAppEnvironment());
  }

  public Bundle getMetaDataFromApplication(Context context) throws PackageManager.NameNotFoundException {
    return context.getPackageManager().getApplicationInfo(context.getPackageName(), PackageManager.GET_META_DATA).metaData;
  }

  public Bundle getMetaDataFromActivity(Activity activity) throws PackageManager.NameNotFoundException {
    return context.getPackageManager().getActivityInfo(activity.getComponentName(), PackageManager.GET_META_DATA).metaData;
  }

  public int getAppIdZalo(){
    try {

      Bundle bundleApplication = getMetaDataFromApplication(context);
      Bundle bundleActivity = getMetaDataFromActivity(activity);

      if (bundleApplication.containsKey(META_DATA_SDK_ZALO_APP_ID)) {
        return bundleApplication.getInt(META_DATA_SDK_ZALO_APP_ID);
      } else if (bundleActivity.containsKey(META_DATA_SDK_ZALO_APP_ID)) {
        return bundleActivity.getInt(META_DATA_SDK_ZALO_APP_ID);
      }
    } catch (PackageManager.NameNotFoundException e) {
      e.printStackTrace();
    }
    Toast.makeText(activity, R.string.not_find_app_id, Toast.LENGTH_LONG).show();
    throw new IllegalStateException(context.getString(R.string.not_find_app_id));
  }

  public String getAppUriScheme(){
    try {

      Bundle bundleApplication = getMetaDataFromApplication(context);
      Bundle bundleActivity = getMetaDataFromActivity(activity);

      if (bundleApplication.containsKey(META_DATA_SDK_ZALO_URI_SCHEME)) {
        return bundleApplication.getString(META_DATA_SDK_ZALO_URI_SCHEME);
      } else if (bundleActivity.containsKey(META_DATA_SDK_ZALO_URI_SCHEME)) {
        return bundleActivity.getString(META_DATA_SDK_ZALO_URI_SCHEME);
      }
    } catch (PackageManager.NameNotFoundException e) {
      e.printStackTrace();
    }
    Toast.makeText(activity, R.string.not_find_uri_scheme, Toast.LENGTH_LONG).show();
    throw new IllegalStateException(context.getString(R.string.not_find_uri_scheme));
  }

  public Environment getAppEnvironment(){
    try {

      Bundle bundleApplication = getMetaDataFromApplication(context);
      Bundle bundleActivity = getMetaDataFromActivity(activity);

      if (bundleApplication.containsKey(META_DATA_SDK_ZALO_ENVIRONMENT)) {
        String environment=bundleApplication.getString(META_DATA_SDK_ZALO_ENVIRONMENT);
        return getAppEnvironment(environment);
      } else if (bundleActivity.containsKey(META_DATA_SDK_ZALO_ENVIRONMENT)) {
        String environment=bundleActivity.getString(META_DATA_SDK_ZALO_ENVIRONMENT);
        return getAppEnvironment(environment);
      }
    } catch (PackageManager.NameNotFoundException e) {
      e.printStackTrace();
    }
    return Environment.SANDBOX;
  }

  public Environment getAppEnvironment( String environment){
    if (environment!=null) {
      if(environment.equals(Environment.SANDBOX.name())){
        return Environment.SANDBOX;
      }else if(environment.equals(Environment.PRODUCTION.name())){
        return Environment.PRODUCTION;
      }
    }
    return Environment.SANDBOX;
  }

  @Override
  public boolean onNewIntent(Intent intent) {
    ZaloPaySDK.getInstance().onResult(intent);
    // Handled
    return true;
  }

  @Override
  public void onMethodCall(MethodCall poCall, final Result poResult) {
    switch (poCall.method) {
      case "payOrder":
        final String tagSuccess = "[OnPaymentSucceeded]";
        final String tagError = "[onPaymentError]";
        final String tagCanel = "[onPaymentCancel]";
        String token = (String) poCall.argument("zptoken");
        ZaloPaySDK.getInstance().payOrder(activity, token, getAppUriScheme(), new PayOrderListener() {

          public void onPaymentCanceled(@Nullable String zpTransToken, @Nullable String appTransID) {
            Log.d(tagCanel, String.format("[TransactionId]: %s, [appTransID]: %s", zpTransToken, appTransID));
            poResult.success("User hủy thanh toán");
          }

          @Override
          public void onPaymentSucceeded(String transactionId, String transToken, String appTransID) {
            Log.d(tagSuccess, String.format("[TransactionId]: %s, [TransToken]: %s, [appTransID]: %s", transactionId, transToken, appTransID));
            poResult.success("Thanh Toán Thành Công");
          }

          @Override
          public void onPaymentError(ZaloPayError zaloPayErrorCode, String zpTransToken, String appTransID) {
            Log.d(tagError, String.format("[zaloPayErrorCode]: %s, [zpTransToken]: %s, [appTransID]: %s", zaloPayErrorCode.toString(), zpTransToken, appTransID));
            poResult.success("Giao dịch thất bại");
          }
        });
        break;
      default:
        poResult.notImplemented();
        break;
    }
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
  }

  @Override
  public void onDetachedFromActivity() {
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }
}
