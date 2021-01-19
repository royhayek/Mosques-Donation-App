import 'package:mosques_donation_app/models/product.dart';

class Cart {
  final int id;
  final List<Product> products;
  final double total;
  final int count;

  Cart({this.id, this.products, this.total, this.count});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      products: json['products'] != null
          ? List<Product>.from(json["products"].map((x) => Product.fromJson(x)))
          : null,
      total: json['total'].toDouble(),
      count: json['count'],
      id: json['id'],
    );
  }
}
