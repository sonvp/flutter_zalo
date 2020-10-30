class CreateOrderResponse {
  final String zptranstoken;
  final String orderurl;
  final int returncode;
  final String returnmessage;
  final int subreturncode;
  final String subreturnmessage;
  final String ordertoken;

  CreateOrderResponse(
      {this.zptranstoken,
      this.orderurl,
      this.returncode,
      this.returnmessage,
      this.subreturncode,
      this.subreturnmessage,
      this.ordertoken});

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponse(
      zptranstoken: json['zp_trans_token'] as String,
      orderurl: json['order_url'] as String,
      returncode: json['return_code'] as int,
      returnmessage: json['return_message'] as String,
      subreturncode: json['sub_return_code'] as int,
      subreturnmessage: json['sub_return_message'] as String,
      ordertoken: json["order_token"] as String,
    );
  }
}
