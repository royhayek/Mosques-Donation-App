class Banner {
  final int id;
  final String title;
  final String url;
  final String image;
  final int status;
  final String createdAt;
  final String updatedAt;

  Banner({
    this.id,
    this.title,
    this.url,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      url: json['url'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'url': url,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
