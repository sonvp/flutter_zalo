package com.flutterzalopay.flutter_zalo_sdk;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import vn.zalopay.sdk.Environment;
import vn.zalopay.sdk.ZaloPayError;
import vn.zalopay.sdk.ZaloPaySDK;
import vn.zalopay.sdk.listeners.PayOrderListener;

/** FlutterZaloSdkPlugin */
public class FlutterZaloSdkPlugin implements FlutterPlugin, MethodCallHandler, PluginRegistry.NewIntentListener{
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  private Activity moActivity;

  public FlutterZaloSdkPlugin(Activity poActivity) {
    this.moActivity = poActivity;
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter.native/channelPayOrder");
    channel.setMethodCallHandler(this);
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter.native/channelPayOrder");
    channel.setMethodCallHandler(new FlutterZaloSdkPlugin(registrar.activity()));
    ZaloPaySDK.init(2553, Environment.SANDBOX); // Merchant AppID
  }

  @Override
  public void onMethodCall(@NonNull MethodCall poCall, @NonNull final Result poResult) {
    switch (poCall.method) {
      case "payOrder":
        final String tagSuccess = "[OnPaymentSucceeded]";
        final String tagError = "[onPaymentError]";
        final String tagCanel = "[onPaymentCancel]";
        String token = (String) poCall.argument("zptoken");
        ZaloPaySDK.getInstance().payOrder(moActivity, token, "demozpdk://app", new PayOrderListener() {

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
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public boolean onNewIntent(Intent intent) {
    Log.d("newIntent", intent.toString());
    ZaloPaySDK.getInstance().onResult(intent);
    return true;
  }
}
