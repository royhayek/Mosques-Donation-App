class MyFatoorahPaymentMethod {
  int paymentMethodId;
  String paymentMethodAr;
  String paymentMethodEn;
  String paymentMethodCode;
  bool isDirectPayment;
  double serviceCharge;
  double totalAmount;
  String currencyIso;
  String imageUrl;

  MyFatoorahPaymentMethod(
      {this.paymentMethodId,
      this.paymentMethodAr,
      this.paymentMethodEn,
      this.paymentMethodCode,
      this.isDirectPayment,
      this.serviceCharge,
      this.totalAmount,
      this.currencyIso,
      this.imageUrl});

  factory MyFatoorahPaymentMethod.fromJson(Map<String, dynamic> json) {
    return MyFatoorahPaymentMethod(
      paymentMethodId: json['PaymentMethodId'],
      paymentMethodAr: json['PaymentMethodAr'],
      paymentMethodEn: json['PaymentMethodEn'],
      paymentMethodCode: json['PaymentMethodCode'],
      isDirectPayment: json['IsDirectPayment'],
      serviceCharge: json['ServiceCharge'],
      totalAmount: json['TotalAmount'],
      currencyIso: json['CurrencyIso'],
      imageUrl: json['ImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PaymentMethodId'] = this.paymentMethodId;
    data['PaymentMethodAr'] = this.paymentMethodAr;
    data['PaymentMethodEn'] = this.paymentMethodEn;
    data['PaymentMethodCode'] = this.paymentMethodCode;
    data['IsDirectPayment'] = this.isDirectPayment;
    data['ServiceCharge'] = this.serviceCharge;
    data['TotalAmount'] = this.totalAmount;
    data['CurrencyIso'] = this.currencyIso;
    data['ImageUrl'] = this.imageUrl;
    return data;
  }
}
