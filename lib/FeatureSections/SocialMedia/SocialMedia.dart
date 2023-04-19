import 'dart:io';
import 'package:flutter/material.dart';
import 'package:group_project/globals.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:firebase_core/firebase_core.dart';

//line to make code different for push
//to do list
//1. uploads posts to data base
//2. display all the posts

class SocialMedia extends StatefulWidget {
  const SocialMedia({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  File? file;

  Future<void> uploadImage(File file) async {
    // Generate a unique path using the current time in milliseconds

    final path =
        'posts/${DateTime.now().millisecondsSinceEpoch}-$displayName-my-image';

    // Upload the file to Firebase Storage

    final ref = FirebaseStorage.instance.ref().child(path);

    await ref.putFile(file);

    String url = await ref.getDownloadURL();

    createPostInFireStore(url);
  }

  createPostInFireStore(String postUrl) {}

  takePhoto() async {
    XFile? post = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );

    if (post != null) {
      setState(() {
        file = File(post.path);

        debugPrint("jeru File path: ${file?.path}");

        uploadImage(file!); // Upload the file to Firebase Storage
      });
    }
  }

  takeFromGallery() async {
    XFile? post = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1080,
    );

    if (post != null) {
      setState(() {
        file = File(post.path);

        uploadImage(file!); // Upload the file to Firebase Storage
      });
    }
  }

  //https://stacksecrets.com/flutter/build-an-image-picker-wrapper-widget-in-flutter

  //https://stackoverflow.com/questions/49809351/how-to-create-a-circle-icon-button-in-flutter

  Scaffold postFunction(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: const Text("Upload"),
                  children: <Widget>[
                    SimpleDialogOption(
                      onPressed: () async {
                        Navigator.pop(context); // close the dialog box

                        takePhoto();
                      },
                      child: const Text('Camera'),
                    ),
                    SimpleDialogOption(
                      onPressed: () async {
                        Navigator.pop(context);

                        takeFromGallery(); // close the dialog box
                      },
                      child: const Text('Camera Roll'),
                    ),
                    SimpleDialogOption(
                      onPressed: () async {
                        Navigator.pop(context); // close the dialog box
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: Colors.green,
            elevation: 0,
          ),
          child: const Icon(
            Icons.camera_alt,
            size: 24,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {},
        child: const Icon(Icons.person),
      ),
    );
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,

        centerTitle: true,
        // center the title

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: clearImage,
        ),

        title: const Text(
          "Upload Post",
          style: TextStyle(color: Colors.black),
        ),

        actions: [
          TextButton(
            onPressed: () {
              // do something
            },
            child: const Text(
              "Post",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? postFunction(context) : buildUploadForm();
  }
}
