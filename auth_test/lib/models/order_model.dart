// ignore_for_file: non_constant_identifier_names

class OrderModel {
  final int? id;
  final String clientId;
  final String? clientName;
  final String? instructions; // make it nullable
  final String status;
  final DateTime? created_at;

  OrderModel({
    this.id,
    required this.clientId,
    this.clientName,
    this.instructions,
    this.status = 'pending',
    this.created_at,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      clientId: json['clientId'] as String,
      clientName: json['clientName'] as String,
      // safely handle null or empty
      instructions:
          (json['instructions'] as String?)?.trim().isEmpty ?? true
              ? null
              : json['instructions'] as String?,
      status: json['status'] as String,
      created_at:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null,
    );
  }

  OrderModel copyWith({
    int? id,
    String? clientId,
    String? instructions,
    String? clientName,
    String? status,
  }) {
    return OrderModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      instructions: instructions ?? this.instructions,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "clientId": clientId,
      "clientName": clientName,
      "instructions": instructions,
      'status': status,
    };
  }
}
