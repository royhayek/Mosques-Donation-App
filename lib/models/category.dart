import 'package:mosques_donation_app/models/subcategory.dart';

class Category {
  final int id;
  final String name;
  final String image;
  final int status;
  final int templateId;
  final String createdAt;
  final String updatedAt;
  final List<Subcategory> subcategories;

  Category({
    this.id,
    this.name,
    this.image,
    this.status,
    this.templateId,
    this.createdAt,
    this.updatedAt,
    this.subcategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      status: json['status'],
      templateId: json['templateId'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      subcategories: json['subcategories'] != null
          ? List<Subcategory>.from(
              json["subcategories"].map((x) => Subcategory.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'status': status,
      'templateId': templateId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
