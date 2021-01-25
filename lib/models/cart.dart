import 'package:mosques_donation_app/models/product.dart';

class Cart {
  int id;
  String name;
  String image;
  int status;
  int templateId;
  List<Product> products;
  num count;
  num total;

  Cart({
    this.id,
    this.name,
    this.image,
    this.status,
    this.templateId,
    this.products,
    this.count,
    this.total,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      status: json['status'],
      templateId: json['templateId'],
      products: json['products'] != null
          ? List<Product>.from(json["products"].map((x) => Product.fromJson(x)))
          : null,
      total: json['total'].toDouble(),
      count: json['count'],
    );
  }
}
