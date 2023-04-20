import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_project/globals.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';


class SocialMedia extends StatefulWidget {
  const SocialMedia({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Social Media Posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('An error occurred'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<DocumentSnapshot> posts = snapshot.data!.docs;
          if (posts.isEmpty) {
            return const Center(child: Text('No posts yet'));
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              final String imageUrl = posts[index].get('imageUrl');
              final String displayName = posts[index].get('displayName');
              final String title = posts[index].get('title');
              final Timestamp timestamp = posts[index].get('timestamp');
              final DateTime dateTime = timestamp.toDate();
              final String date = DateFormat.yMd().add_jm().format(dateTime); // Shorthand date and time

              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '$displayName - $title                       $date',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Image.network(imageUrl),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
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
                      choosePhoto(false);
                    },
                    child: const Text('Camera'),
                  ),
                  SimpleDialogOption(
                    onPressed: () async {
                      Navigator.pop(context);
                      choosePhoto(true); // close the dialog box
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
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  //comment to help commint and push

  uploadImage(File file, String title) async {
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
        'title': title,
        'timestamp': FieldValue.serverTimestamp(),
      });

    } catch (e) {
      // Handle any errors that might occur
    }
  }

  choosePhoto(bool fromGallery) async {
    final titleController = TextEditingController(); // Create a controller for the title field
    XFile? post = await ImagePicker().pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (post != null) {
      setState(() {
        file = File(post.path);
        // Show a popup dialog with the selected image, a title field, and "Post" and "Cancel" buttons
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: AlertDialog(
                title: const Text('Preview Post'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 30,
                      child: TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FractionallySizedBox(
                      widthFactor: 0.8, // Set the width to 80% of the parent container's width
                      child: Image.file(file!), // Show the selected image in the pop-up dialog
                    ),
                  ],
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
                      uploadImage(file!, titleController.text);
                    },
                    child: const Text('Post'),
                  ),
                ],
              ),
            );
          },
        );
      });
    }
  }
}
