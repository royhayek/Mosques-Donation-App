class ProductAttributes {
  final int id;
  final int productId;
  final String name;
  final num price;
  final num salePrice;
  final int quantityInStock;
  final int stockStatus;
  final String createdAt;
  final String updatedAt;

  ProductAttributes(
      {this.id,
      this.productId,
      this.name,
      this.price,
      this.salePrice,
      this.quantityInStock,
      this.stockStatus,
      this.createdAt,
      this.updatedAt});

  factory ProductAttributes.fromJson(Map<String, dynamic> json) {
    return ProductAttributes(
      id: json['id'],
      productId: json['productId'],
      name: json['name'],
      price: json['price'],
      salePrice: json['salePrice'],
      quantityInStock: json['quantityInStock'],
      stockStatus: json['stockStatus'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'price': price,
      'salePrice': salePrice,
      'quantityInStock': quantityInStock,
      'stockStatus': stockStatus,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
