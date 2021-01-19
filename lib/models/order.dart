class Order {
  int id;
  String userId;
  int categoryId;
  String donorName;
  String phoneNo;
  String deliveryNotes;
  int orderStatus;
  int paymentStatus;
  String mosque;
  String cemetry;
  String by;
  String address;
  int cartId;
  String createdAt;
  String updatedAt;

  Order(
      {this.id,
      this.userId,
      this.categoryId,
      this.donorName,
      this.phoneNo,
      this.deliveryNotes,
      this.orderStatus,
      this.paymentStatus,
      this.mosque,
      this.cemetry,
      this.by,
      this.address,
      this.cartId,
      this.createdAt,
      this.updatedAt});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      categoryId: json['categoryId'],
      donorName: json['donorName'],
      phoneNo: json['phoneNo'],
      deliveryNotes: json['deliveryNotes'],
      orderStatus: json['orderStatus'],
      paymentStatus: json['paymentStatus'],
      mosque: json['mosque'],
      cemetry: json['cemetry'],
      by: json['by'],
      address: json['address'],
      cartId: json['cartId'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> order = new Map<String, dynamic>();
    order['id'] = this.id;
    order['userId'] = this.userId;
    order['categoryId'] = this.categoryId;
    order['donorName'] = this.donorName;
    order['phoneNo'] = this.phoneNo;
    order['deliveryNotes'] = this.deliveryNotes;
    order['orderStatus'] = this.orderStatus;
    order['paymentStatus'] = this.paymentStatus;
    order['mosque'] = this.mosque;
    order['cemetry'] = this.cemetry;
    order['by'] = this.by;
    order['address'] = this.address;
    order['cartId'] = this.cartId;
    order['created_at'] = this.createdAt;
    order['updated_at'] = this.updatedAt;
    return order;
  }
}
