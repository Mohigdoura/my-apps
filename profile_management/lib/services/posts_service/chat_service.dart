import 'package:profile_management/models/message.dart';
import 'package:profile_management/services/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final authService = AuthService();

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _supabaseClient
        .from('users')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  // Function to send a message
  Future<void> sendMessage(String message, String recipientId) async {
    // get current user id
    String currentUserId = authService.currentUser!.id;

    // create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      receiverId: recipientId,
      message: message,
    );

    // insert message into the database
    await _supabaseClient.from('messages').insert(newMessage.toMap());

    // Create chat room ID
    List<String> ids = [currentUserId, recipientId];
    ids.sort(); // sort to ensure consistent order
    String chatRoomId = ids.join('_');

    // Check if chat room exists first
    final existingRoom =
        await _supabaseClient
            .from('chat_rooms')
            .select()
            .eq('id', chatRoomId)
            .maybeSingle();

    // Only insert if it doesn't exist
    if (existingRoom == null) {
      await _supabaseClient.from('chat_rooms').insert({
        'id': chatRoomId,
        'user1_id': ids[0],
        'user2_id': ids[1],
      });
    }
  }

  // Get messages between two users
  Stream<List<Map<String, dynamic>>> getMessages(
    String userId,
    String otherUserId,
  ) {
    return _supabaseClient
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: true);
  }
}
