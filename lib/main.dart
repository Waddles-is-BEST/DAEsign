import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'daesign_loading.dart';
import 'daesign_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DÆsign',
      home: const DaeSignLoadingPage(),  // Change this line
    );
  }
}

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  var postController = TextEditingController();

  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Create Post",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
                padding:  EdgeInsets.all(16),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black12,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                FirebaseAuth.instance.currentUser?.displayName ?? "User",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),

                          const SizedBox(height: 16),


                          TextFormField(
                            controller: postController,
                            maxLines: null,
                            style: const TextStyle(fontSize: 16),
                            decoration: const InputDecoration(
                              hintText: "What's on your mind?",
                              border: InputBorder.none,
                            ),
                          ),

                          SizedBox(height: 20),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () async {
                                  final pickedImage = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);

                                  if (pickedImage != null) {
                                    setState(() {
                                      selectedImage = File(pickedImage.path);
                                    });
                                  }
                                },
                                child: const Row(
                                  children: [
                                    Icon(Icons.photo, color: Colors.green),
                                    SizedBox(width: 5),
                                    Text("Photo"),
                                  ],
                                ),
                              ),

                              const Row(
                                children: [
                                  Icon(Icons.videocam, color: Colors.red),
                                  SizedBox(width: 5),
                                  Text("Video"),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          selectedImage == null
                              ? const SizedBox()
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.file(
                                    selectedImage!,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ]),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  try {
                    var content = postController.text;

                    String? uploadedImageUrl;

                    if (selectedImage != null) {
                      String fileName =
                          DateTime.now().millisecondsSinceEpoch.toString();

                      Reference storageRef = FirebaseStorage.instance
                          .ref()
                          .child("post_images")
                          .child("$fileName.jpg");

                      await storageRef.putFile(selectedImage!);

                      uploadedImageUrl = await storageRef.getDownloadURL();
                    }

                    await FirebaseFirestore.instance.collection('tbl_posts').add({
                      'contentAT': content,
                      'imageurlAT': uploadedImageUrl,
                      'createdAT': FieldValue.serverTimestamp(),
                      'user_idAT':
                          FirebaseAuth.instance.currentUser?.displayName ??
                              "User",
                      'nooflikeAT': 0,
                      'noofcommentsAT': 0,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Post submitted')),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DaeSignHomePage(),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("$e")),
                    );
                  }
                },
                child: const Text(
                  "Post",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}