import 'package:aoun_app/modules/addAdv/appPost_screen.dart';
import 'package:flutter/material.dart';

class AddPost extends StatelessWidget {
  const AddPost({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Add Post',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsetsDirectional.only(start: 10),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            ),
          ),
        ),
      ),
      body: const SingleChildScrollView(child: AddPostScreen()),
    );
  }
}
