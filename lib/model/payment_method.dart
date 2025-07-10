class PaymentMethod {
  String? idPaymentMethod;
  String? paymentMethod;
  bool? state;

  PaymentMethod({
    required this.idPaymentMethod,
    required this.paymentMethod,
    required this.state,
  });

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    idPaymentMethod = json["_id"];
    paymentMethod = json["paymentMethod"];
    state = json["state"];
  }
}
