class Message {
  final String? id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime? createdAt;

  Message({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'created_at':
          createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }
}
