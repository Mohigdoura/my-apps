class OrderItemModel {
  int? id;
  int orderId;
  int menuItemId;
  int count;
  OrderItemModel({
    this.id,
    required this.orderId,
    required this.menuItemId,
    required this.count,
  });

  OrderItemModel copyWith({
    int? id,
    int? orderId,
    int? menuItemId,
    int? count,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      menuItemId: menuItemId ?? this.menuItemId,
      count: count ?? this.count,
    );
  }

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json["id"] as int,
      orderId: json["orderId"] as int,
      menuItemId: json["menuItemId"] as int,
      count: json["count"] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "orderId": orderId,
      "menuItemId": menuItemId,
      "count": count,
    };
  }
}
