import 'package:flutter/material.dart';
import 'package:profile_management/services/auth/auth_service.dart';
import 'package:profile_management/services/posts_service/chat_service.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverId;

  ChatPage({super.key, required this.receiverEmail, required this.receiverId});

  // text controller
  final TextEditingController messageController = TextEditingController();

  // auth and chat services
  final authService = AuthService();
  final chatService = ChatService();

  // send message function
  void sendMessage() async {
    String message = messageController.text;
    if (message.isNotEmpty) {
      await chatService.sendMessage(message, receiverId);
      messageController.clear(); // clear the text field after sending
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(receiverEmail)),
      body: Column(
        children: [
          // message list
          Expanded(child: _buildMessageList()),

          // user input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    final userId = authService.currentUser!.id;

    return StreamBuilder(
      stream: chatService.getMessages(userId, receiverId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No messages yet'));
        }

        return ListView.builder(
          reverse: true,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            return _buildMessageItem(messageData, userId);
          },
        );
      },
    );
  }

  Widget _buildMessageItem(
    Map<String, dynamic> messageData,
    String currentUserId,
  ) {
    // Determine if message is from current user
    final isCurrentUser = messageData['sender_id'] == currentUserId;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          messageData['message'],
          style: TextStyle(color: isCurrentUser ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
