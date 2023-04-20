import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SocialMedia extends StatefulWidget {
  const SocialMedia({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  File? file;
  bool isUploading = false;
  String? imageUrl;
  final TextEditingController descriptionController = TextEditingController();
  final CollectionReference postsRef = FirebaseFirestore.instance.collection('posts');
  List<Post> posts = [];
  FirebaseAuth get auth => FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> uploadImage(File file) async {
    final path =
        'posts/${DateTime.now().millisecondsSinceEpoch}-yourUsername-my-image';

    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);
    String url = await ref.getDownloadURL();
    createPostInFireStore(url);
  }

  Future<String?> getUserNameFromFirestore(String userId) async {
    final doc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    if (doc.exists) {
      return doc['displayName'];
    } else {
      return null;
    }
  }

  Future<void> createPostInFireStore(String postUrl) async {
    final User? currentUser = auth.currentUser;

    if (currentUser != null) {
      DocumentReference docRef = FirebaseFirestore.instance.collection('posts').doc();
      final String postId = docRef.id;
      final String userId = currentUser.uid;

      // Get the user's display name from Firestore
      final String? username = await getUserNameFromFirestore(userId);

      final String description = descriptionController.text;

      await docRef.set({
        'postId': postId,
        'userId': userId,
        'username': username,
        'imageUrl': postUrl,
        'description': description,
        'timestamp': DateTime.now(),
      });

      setState(() {
        imageUrl = postUrl;
        isUploading = false;
        file = null;
        descriptionController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to be logged in to create a post')),
      );
    }
  }
  Future<List<Post>> fetchPosts() async {
    QuerySnapshot querySnapshot = await postsRef
        .orderBy('timestamp', descending: true)
        .get();
    return querySnapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
  }

  takePhoto() async {
    XFile? post = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (post != null) {
      setState(() {
        file = File(post.path);
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
      });
    }
  }
  Widget buildPostWidget(Post post) {
    return Column(
      children: [
        ListTile(
          title: Text(post.username ?? "Anonymous"), // Display "Anonymous" when the username is null
          subtitle: Text(post.description),
          trailing: const Icon(Icons.more_vert),
        ),
        Image.network(post.imageUrl),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 20.0, top: 10.0),
            ),
            Icon(Icons.favorite_border, size: 28.0),
            SizedBox(width: 20.0),
            Icon(Icons.chat_bubble_outline, size: 28.0),
          ],
        ),
        const Divider(),
      ],
    );
  }



  Scaffold postFunction(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
          future: fetchPosts(),
          builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Failed to load posts'));
            } else {
              List<Post> posts = snapshot.data!;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (BuildContext context, int index) {
                  Post post = posts[index];
                  return buildPostWidget(post);
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                title: const Text("Upload"),
                children: <Widget>[
                  SimpleDialogOption(
                    onPressed: () async {
                      Navigator.pop(context);
                      takePhoto();
                    },
                    child: const Text('Camera'),
                  ),
                  SimpleDialogOption(
                    onPressed: () async {
                      Navigator.pop(context);
                      takeFromGallery();
                    },
                    child: const Text('Camera Roll'),
                  ),
                  SimpleDialogOption(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
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
                if (file != null) {
                  uploadImage(file!);
                }
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
        body: ListView(
          children: <Widget>[
            Container(
              height: 220.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(file!),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
            padding: EdgeInsets.only(top: 10.0),
            ),
            TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(
            hintText: "Write a description...",
            border: OutlineInputBorder(),
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

class Post {
  //post
  final String postId;
  final String userId;
  final String? username;
  final String imageUrl;
  final String description;
  final DateTime timestamp;
  //like



  Post({
    required this.postId,
    required this.userId,
    this.username,
    required this.imageUrl,
    required this.description,
    required this.timestamp,
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc['postId'],
      userId: doc['userId'],
      username: doc['username'], // This field can now be nullable
      imageUrl: doc['imageUrl'],
      description: doc['description'],
      timestamp: (doc['timestamp'] as Timestamp).toDate(),
    );
  }
}

