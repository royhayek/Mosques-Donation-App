class Order {
  int id;
  String userId;
  int categoryId;
  int subcategoryId;
  String donorName;
  String phoneNo;
  String deliveryNotes;
  int orderStatus;
  int paymentStatus;
  String mosque;
  String cemetry;
  String by;
  String city;
  String address;
  String coordination;
  int cartId;
  int totalProducts;
  num serviceFee;
  num deliveryFee;
  num totalPrice;
  String createdAt;
  String updatedAt;

  Order(
      {this.id,
      this.userId,
      this.categoryId,
      this.subcategoryId,
      this.donorName,
      this.phoneNo,
      this.deliveryNotes,
      this.orderStatus,
      this.paymentStatus,
      this.mosque,
      this.cemetry,
      this.by,
      this.address,
      this.city,
      this.coordination,
      this.cartId,
      this.totalProducts,
      this.serviceFee,
      this.deliveryFee,
      this.totalPrice,
      this.createdAt,
      this.updatedAt});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      categoryId: json['categoryId'],
      subcategoryId: json['subcategoryId'],
      donorName: json['donorName'],
      phoneNo: json['phoneNo'],
      deliveryNotes: json['deliveryNotes'],
      orderStatus: json['orderStatus'],
      paymentStatus: json['paymentStatus'],
      mosque: json['mosque'],
      cemetry: json['cemetry'],
      by: json['by'],
      address: json['address'],
      city: json['city'],
      coordination: json['coordination'],
      cartId: json['cartId'],
      serviceFee: json['serviceFee'],
      deliveryFee: json['deliveryFee'],
      totalProducts: json['totalProducts'],
      totalPrice: json['totalPrice'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> order = new Map<String, dynamic>();
    order['id'] = this.id;
    order['userId'] = this.userId;
    order['categoryId'] = this.categoryId;
    order['subcategoryId'] = this.subcategoryId;
    order['donorName'] = this.donorName;
    order['phoneNo'] = this.phoneNo;
    order['deliveryNotes'] = this.deliveryNotes;
    order['orderStatus'] = this.orderStatus;
    order['paymentStatus'] = this.paymentStatus;
    order['mosque'] = this.mosque;
    order['cemetry'] = this.cemetry;
    order['by'] = this.by;
    order['address'] = this.address;
    order['coordination'] = this.coordination;
    order['cartId'] = this.cartId;
    order['totalProducts'] = this.totalProducts;
    order['serviceFee'] = this.serviceFee;
    order['deliveryFee'] = this.deliveryFee;
    order['totalPrice'] = this.totalPrice;
    order['created_at'] = this.createdAt;
    order['updated_at'] = this.updatedAt;
    return order;
  }
}
