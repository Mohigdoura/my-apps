class MenuItem {
  String?
  id; // Made nullable since you're not providing it when creating a new item
  String name;
  String desc;
  double price; // Changed from String to double
  String type;
  String imageUrl;
  bool isavailable;

  MenuItem({
    this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.type,
    required this.imageUrl,
    required this.isavailable,
  });
  MenuItem copyWith({
    String? id,
    String? name,
    String? desc,
    double? price,
    String? type,
    String? imageUrl,
    bool? isavailable,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      price: price ?? this.price,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      isavailable: isavailable ?? this.isavailable,
    );
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json["id"].toString(),
      name: json["name"],
      desc: json["desc"],
      // Handle different price formats
      price:
          json["price"] is int
              ? (json["price"] as int).toDouble()
              : (json["price"] is String
                  ? double.tryParse(json["price"]) ?? 0.0
                  : json["price"] as double),
      type: json["type"],
      imageUrl: json["image_url"],
      isavailable: json["is_available"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "desc": desc,
      "price": price,
      "type": type,
      "image_url": imageUrl,
      "is_available": isavailable,
    };
  }
}
