import 'package:chat_app/models/message.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverName;
  final String receiverEmail;
  final String receiverId;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  List<Message> messages = [];
  DocumentSnapshot? lastDocument;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);

    _focusNode.addListener(() {
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollToBottom();
      });
    });
    loadInitialMessages();
  }

  void _handleScroll() {
    // Prevent loading more messages when the keyboard is visible
    if (MediaQuery.of(context).viewInsets.bottom == 0 &&
        _scrollController.position.pixels <=
            _scrollController.position.minScrollExtent + 100 &&
        !isLoadingMore) {
      loadMoreMessages();
    }
  }

  void loadInitialMessages() async {
    String currentUser = _authService.getCurrentUser()!.uid;
    List<QueryDocumentSnapshot> docs = await _chatService.getMessagesPaginated(
      userId: currentUser,
      otherUserId: widget.receiverId,
    );

    setState(() {
      messages =
          docs
              .map(
                (doc) => Message.fromMap(
                  doc.data() as Map<String, dynamic>,
                  id: doc.id,
                ),
              )
              .toList()
              .reversed
              .toList();
      if (docs.isNotEmpty) lastDocument = docs.last;
    });
  }

  void loadMoreMessages() async {
    setState(() => isLoadingMore = true);

    String currentUser = _authService.getCurrentUser()!.uid;
    List<QueryDocumentSnapshot> docs = await _chatService.getMessagesPaginated(
      userId: currentUser,
      otherUserId: widget.receiverId,
      startAfter: lastDocument,
    );

    if (docs.isNotEmpty) {
      setState(() {
        final newMessages =
            docs
                .map(
                  (doc) => Message.fromMap(
                    doc.data() as Map<String, dynamic>,
                    id: doc.id,
                  ),
                )
                .toList()
                .reversed
                .toList();
        messages = [...newMessages, ...messages];
        lastDocument = docs.last;
      });
    }

    setState(() => isLoadingMore = false);
  }

  void sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    _focusNode.unfocus();

    await _chatService.sendMessage(widget.receiverId, _messageController.text);

    setState(() {
      messages.add(
        Message(
          id: _authService.getCurrentUser()!.uid,
          senderId: _authService.getCurrentUser()!.uid,
          senderEmail: _authService.getCurrentUser()!.email!,
          receiverId: widget.receiverId,
          message: _messageController.text,
          timestamp: Timestamp.now(),
        ),
      );
    });

    _messageController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
  }

  void scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.receiverName),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(child: SafeArea(child: _buildMessageList())),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: messages.length,
      reverse: false,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message.senderId == _authService.getCurrentUser()!.uid;
        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.grey.shade600,
              borderRadius: BorderRadius.circular(25),
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Text(
              message.message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageController,
              focusNode: _focusNode,
              hintText: 'Type a message...',
              obsecureText: false,
              onSubmitted: (value) => sendMessage(),
            ),
          ),
          IconButton(icon: const Icon(Icons.send), onPressed: sendMessage),
        ],
      ),
    );
  }
}
