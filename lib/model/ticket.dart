class Ticket {
  String? id;
  String? idOrder;
  String? seatNumber;
  String? paymentStatus;

  Ticket({
    required this.id,
    required this.idOrder,
    required this.seatNumber,
    required this.paymentStatus,
  });

  Ticket.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    idOrder = json["idOrder"];
    seatNumber = json["seatNumber"];
    paymentStatus = json["paymentStatus"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["idOrder"] = idOrder;
    data["seatNumber"] = seatNumber;
    data["paymentStatus"] = paymentStatus;
    return data;
  }
}
