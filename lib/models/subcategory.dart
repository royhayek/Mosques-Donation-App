class Subcategory {
  final int id;
  final String name;
  final String image;
  final int showProductsList;
  final int status;
  final String createdAt;
  final String updatedAt;
  final int templateId;

  Subcategory({
    this.id,
    this.name,
    this.image,
    this.showProductsList,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.templateId,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      showProductsList: json['showProductsList'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      templateId: json['templateId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'showProductsList': showProductsList,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'templateId': templateId,
    };
  }
}
