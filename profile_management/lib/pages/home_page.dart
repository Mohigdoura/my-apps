import 'package:flutter/material.dart';
import 'package:profile_management/components/user_tile.dart';
import 'package:profile_management/pages/chat_page.dart';
import 'package:profile_management/services/auth/auth_service.dart';
import 'package:profile_management/components/my_drawer.dart';
import 'package:profile_management/services/posts_service/chat_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authService = AuthService();
  final chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: MyDrawer(),
      body: _buildPostsList(),
    );
  }

  Widget _buildPostsList() {
    return StreamBuilder(
      stream: chatService.getUserStream(),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children:
              snapshot.data!
                  .map<Widget>(
                    (userData) => _buildUserListItem(userData, context),
                  )
                  .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
    Map<String, dynamic> userData,
    BuildContext context,
  ) {
    if (userData['email'] != authService.currentUser!.email) {
      return UserTile(
        text: userData['name'],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ChatPage(
                    receiverEmail: userData['email'],
                    receiverId: userData['id'],
                  ),
            ),
          );
        },
      );
    } else {
      return const SizedBox(); // Return an empty widget if the condition is met
    }
  }
}
