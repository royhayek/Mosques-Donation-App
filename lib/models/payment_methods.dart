import 'package:mosques_donation_app/models/payment_method.dart';

class MyFatoorahPaymentMethods {
  List<MyFatoorahPaymentMethod> paymentMethods;

  MyFatoorahPaymentMethods({this.paymentMethods});

  factory MyFatoorahPaymentMethods.fromJson(Map<String, dynamic> json) {
    return MyFatoorahPaymentMethods(
      paymentMethods: json['PaymentMethods'] != null
          ? List<MyFatoorahPaymentMethod>.from(json["PaymentMethods"]
              .map((x) => MyFatoorahPaymentMethod.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.paymentMethods != null) {
      data['PaymentMethods'] =
          this.paymentMethods.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
