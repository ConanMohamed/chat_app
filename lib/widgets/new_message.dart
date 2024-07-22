import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  _sendMessage() async {
    final User user = FirebaseAuth.instance.currentUser!;
    final enteredmessage = _messageController.text;
    if (enteredmessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredmessage,
      'createdAt': Timestamp.now(),
      'userID': user.uid,
      'username': userData.data()!['username'],
      'userimage': userData.data()!['mainimage'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 2,
        bottom: 14,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              enableSuggestions: true,
              keyboardType: TextInputType.text,
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: 'message...',
                filled: true,
                fillColor: Colors.grey[200],
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: IconButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 26, 223, 115),
                    )),
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: _sendMessage,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
