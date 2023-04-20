import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_project/globals.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SocialMedia extends StatefulWidget {
  const SocialMedia({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  File? file;

  @override
  Widget build(BuildContext context) {
    //return file == null ? postFunction(context) : buildUploadForm();
    return postFunction(context);
  }

  Future<void> uploadImage(File file) async {
    try {
      // Generate a unique path using the current time in milliseconds
      final path = 'images/${DateTime.now().millisecondsSinceEpoch}-$displayName-my-image';

      // Get a reference to the Firebase Storage location to upload the file
      final Reference ref = FirebaseStorage.instance.ref().child(path);

      // Upload the file to Firebase Storage
      await ref.putFile(file);

      // Get the download URL of the uploaded file
      final String downloadUrl = await ref.getDownloadURL();

      // Save the download URL and the display name to Firestore
      await FirebaseFirestore.instance.collection('Social Media Posts').add({
        'imageUrl': downloadUrl,
        'displayName': displayName,
      });
    } catch (e) {
      // Handle any errors that might occur
      print(e.toString());
    }
  }

  //createPostInFireStore(String postUrl) {}

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
        // Show a popup dialog with the selected image and "Post" and "Cancel" buttons
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Preview Image'),
              content: Container(
                width: double.maxFinite,
                child: Image.file(file!),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog box
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog box
                    // Upload the file to Firebase Storage and save the download URL
                    uploadImage(file!);
                  },
                  child: const Text('Post'),
                ),
              ],
            );
          },
        );
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
        // Show a popup dialog with the selected image and "Post" and "Cancel" buttons
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Preview Image'),
              content: Container(
                width: double.maxFinite,
                child: Image.file(file!),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog box
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog box
                    // Upload the file to Firebase Storage and save the download URL
                    uploadImage(file!);
                  },
                  child: const Text('Post'),
                ),
              ],
            );
          },
        );
      });
    }
  }

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
}
