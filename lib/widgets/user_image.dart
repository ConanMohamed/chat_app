import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImage extends StatefulWidget {
  const UserImage({super.key, required this.onselectImage});

  final void Function(File pickedImage) onselectImage;

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  File? _pickedImageFile;
  void _pickImage() async {
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 150,
      imageQuality: 50,
    );
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });
    widget.onselectImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedImageFile == null ? null : FileImage(_pickedImageFile!),
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: Text(
            'Add Image',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}
