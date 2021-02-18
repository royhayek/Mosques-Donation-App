import 'package:mosques_donation_app/models/product_attributes.dart';

class Product {
  final int cartId;
  final int id;
  final String name;
  final String image;
  final String description;
  final num buyingPrice;
  final num price;
  final num productPrice;
  final num salePrice;
  final int quantityInStock;
  final int status;
  final int attributeId;
  final String productType;
  final int stockStatus;
  final String createdAt;
  final String updatedAt;
  final int categoryId;
  final int subcategoryId;
  final int quantity;
  final ProductAttributes attribute;

  Product({
    this.cartId,
    this.id,
    this.name,
    this.image,
    this.description,
    this.buyingPrice,
    this.price,
    this.productPrice,
    this.salePrice,
    this.quantityInStock,
    this.status,
    this.attributeId,
    this.productType,
    this.stockStatus,
    this.createdAt,
    this.updatedAt,
    this.subcategoryId,
    this.quantity,
    this.categoryId,
    this.attribute,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      cartId: json['cartId'] != null ? json['cartId'] : null,
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      buyingPrice: json['buyingPrice'],
      price: json['price'],
      productPrice: json['productPrice'] != null ? json['productPrice'] : 0.0,
      salePrice: json['salePrice'] != null ? json['salePrice'] : 0.0,
      attributeId: json['attributeId'] != null ? json['attributeId'] : 0,
      stockStatus: json['stockStatus'],
      productType: json['productType'],
      quantityInStock: json['quantityInStock'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      categoryId: json['categoryId'],
      subcategoryId: json['subcategoryId'],
      quantity: json['quantity'] != null ? json['quantity'] : 0,
      attribute: json['attribute'] != null
          ? new ProductAttributes.fromJson(json['attribute'])
          : null,
    );
  }
}
