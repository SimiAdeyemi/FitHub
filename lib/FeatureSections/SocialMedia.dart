import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:firebase_core/firebase_core.dart';

//to do list
//1. uploads posts to data base
//2. display all the posts




class SocialMedia extends StatefulWidget {
  const SocialMedia({Key? key}) : super(key: key);

  @override
  _SocialMediaState createState() => _SocialMediaState();
}




class _SocialMediaState extends State<SocialMedia> {
  File? file;


  takePhoto() async {
    XFile? post = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (post != null) {
      setState(() {
        file = File(post.path);
        debugPrint("jeru File path: ${file?.path}");//proves that the picture is being stored in file
        const path = 'posts/my-image';
        final ref = FirebaseStorage.instance.ref().child(path);
        ref.putFile(file!);

      });
      //then we display picture send it to database then set file to null
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
        //uploading post to firebase
        file = File(post.path);
        const path = 'posts/my-image';
        final ref = FirebaseStorage.instance.ref().child(path);
        ref.putFile(file!);
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

  @override
  Widget build(BuildContext context) {
    return postFunction(context);
  }
}
