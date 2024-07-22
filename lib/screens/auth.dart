import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../widgets/user_image.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

final _firebase = FirebaseAuth.instance;

class _AuthScreenState extends State<AuthScreen> {
  var _isUploading = false;
  File? _selectedImage;
  var _enteredEmail = '';
  var _enteredUsername = '';
  var _enteredPassword = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _islogin = true;
  void _submitForm() async {
    final valid = _formKey.currentState!.validate();
    if (!valid || (!_islogin && _selectedImage == null)) {
      return;
    }
    try {
      setState(() {
        _isUploading = true;
      });
      if (_islogin) {
        await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final UserCredential userCredential =
            await _firebase.createUserWithEmailAndPassword(
                email: _enteredEmail, password: _enteredPassword);

        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredential.user!.uid}.jpg');
        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'mainimage': imageUrl,
        });
      }
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Authentication Fialed!'),
        ),
      );
      setState(() {
        _isUploading = false;
      });
    }
    _formKey.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Builder(builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 30,
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  width: 200,
                  child: Image.asset('assets/chat.png'),
                ),
                Card(
                  margin: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (!_islogin)
                              UserImage(
                                onselectImage: (File pickedImage) {
                                  _selectedImage = pickedImage;
                                },
                              ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Emaril Address'),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              onSaved: (newValue) => _enteredEmail = newValue!,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return 'Please enter a valid email address.';
                                }
                                return null;
                              },
                            ),
                            if (!_islogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Username'),
                                keyboardType: TextInputType.name,
                                onSaved: (newValue) =>
                                    _enteredUsername = newValue!,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 5) {
                                    return 'Username must be at least 5 characters long.';
                                  }
                                  return null;
                                },
                              ),
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Password'),
                              obscureText: true,
                              onSaved: (newValue) =>
                                  _enteredPassword = newValue!,
                              validator: (value) {
                                if (value == null || value.trim().length < 8) {
                                  return 'Password must be at least 8 characters long.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            if (_isUploading) const CircularProgressIndicator(),
                            if (!_isUploading)
                              ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                child: Text(_islogin ? 'Login' : 'Signup'),
                              ),
                            if (!_isUploading)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _islogin = !_islogin;
                                  });
                                },
                                child: Text(_islogin
                                    ? 'Create an account'
                                    : 'I already have an account'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
