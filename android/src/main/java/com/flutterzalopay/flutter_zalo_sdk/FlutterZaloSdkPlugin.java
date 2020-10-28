package com.flutterzalopay.flutter_zalo_sdk;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
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
   Activity mActivity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    // Register a method channel that the Flutter app may invoke
    MethodChannel channel = new MethodChannel(binding.getBinaryMessenger(), "flutter.native/channelPayOrder");
    // Handle method calls (onMethodCall())
    channel.setMethodCallHandler(this);
    ZaloPaySDK.init(2553, Environment.SANDBOX);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    mActivity = binding.getActivity();
    // Listen for new intents (notification clicked)
    binding.addOnNewIntentListener(this);
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
        ZaloPaySDK.getInstance().payOrder(mActivity, token, "demozpdk://app", new PayOrderListener() {

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
            poResult.success("Thanh toán thất bại");
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
