part of 'flutter_zalopay_sdk.dart';

class FlutterZaloPaymentStatus{
  static String get PROCESSING => "Đang xử lý";
  static String get FAILED =>  "Giao dịch thất bại";
  static String get SUCCESS => "Thanh Toán Thành Công";
  static String get CANCELLED => "User hủy thanh toán";
}
