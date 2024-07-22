import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages found.'),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong...'),
            );
          }
          final loadingMessages = snapshot.data!.docs;
          return ListView.builder(
              padding: const EdgeInsets.only(
                left: 13,
                right: 13,
                bottom: 20,
              ),
              reverse: true,
              itemCount: loadingMessages.length,
              itemBuilder: (context, index) {
                final chatMessage = loadingMessages[index].data();
                final nextMessage = index + 1 < loadingMessages.length
                    ? loadingMessages[index + 1].data()
                    : null;
                final currentMessageUserId = chatMessage['userID'];
                final nextMessageUserId =
                    nextMessage != null ? nextMessage['userID'] : null;
                final bool nextUserIsSame =
                    currentMessageUserId == nextMessageUserId;
                if (nextUserIsSame) {
                  return MessageBubble.next(
                      message: chatMessage['text'],
                      isMe: authUser!.uid == currentMessageUserId);
                } else {
                  return MessageBubble.first(
                      userImage: chatMessage['userimage'],
                      username: chatMessage['username'],
                      message: chatMessage['text'],
                      isMe: authUser!.uid == currentMessageUserId);
                }
              });
        });
  }
}
