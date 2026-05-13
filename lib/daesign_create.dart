import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'services/r2_service.dart';
import 'daesign_drawer.dart';
import 'daesign_navcircle.dart';
import 'daesign_home.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DaeSignCreatePage(),
  ));
}

class DaeSignCreatePage extends StatefulWidget {
  const DaeSignCreatePage({super.key});

  @override
  State<DaeSignCreatePage> createState() => _DaeSignCreatePageState();
}

class _DaeSignCreatePageState extends State<DaeSignCreatePage> {
  final TextEditingController _infoController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final FocusNode _infoFocus = FocusNode();
  final FocusNode _tagsFocus = FocusNode();

  File? selectedImage;

  @override
  void dispose() {
    _infoController.dispose();
    _tagsController.dispose();
    _infoFocus.dispose();
    _tagsFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme =
    GoogleFonts.titilliumWebTextTheme(Theme.of(context).textTheme);
    final deviceWidth = MediaQuery.of(context).size.width;

    // Use a single horizontal padding so both controls share identical width.
    final double horizontalPad = 44;
    final double contentWidth = deviceWidth - horizontalPad * 2;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const DaeSignDrawer(activeItem: DaeSignDrawerItem.createPost),
      // Let scaffold resize to avoid keyboard hiding fields (default true,
      // made explicit here for clarity).
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black, size: 30),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          '𝔻Æ𝕤𝕚𝕘𝕟',
          style: textTheme.titleLarge?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile tapped')),
              ),
              child: const CircleAvatar(radius: 18, backgroundColor: Colors.black54),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Scrollable content: add bottom padding equal to viewInsets so keyboard doesn't hide controls
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 18),

                    // Top image placeholder (square)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: GestureDetector(
                        onTap: () async {
                          final pickedImage = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);

                          if (pickedImage != null) {
                            setState(() {
                              selectedImage = File(pickedImage.path);
                            });
                          }
                        },
                        child: Container(
                          width: deviceWidth - 56,
                          height: deviceWidth - 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 3),
                          ),
                          child: selectedImage != null
                              ? Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                )
                              : Center(
                                  child: Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 140,
                                    color: const Color(0xFF737373),
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Information header with underline
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPad),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Information',
                            style: textTheme.headlineSmall?.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(height: 2, width: 120, color: Colors.black),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Editable Information TextField (multiline)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPad),
                      child: SizedBox(
                        width: contentWidth,
                        child: TextField(
                          controller: _infoController,
                          focusNode: _infoFocus,
                          keyboardType: TextInputType.multiline,
                          minLines: 4,
                          maxLines: 8,
                          textInputAction: TextInputAction.newline,
                          style: textTheme.bodyLarge?.copyWith(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Describe your post here...',
                            hintStyle: textTheme.bodyLarge?.copyWith(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            contentPadding: const EdgeInsets.all(14),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Tags header with underline
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPad),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tags',
                            style: textTheme.headlineSmall?.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(height: 2, width: 80, color: Colors.black),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Editable Tags TextField (single-line)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPad),
                      child: SizedBox(
                        width: contentWidth,
                        child: TextField(
                          controller: _tagsController,
                          focusNode: _tagsFocus,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Add tags (e.g. #portrait, #digital)',
                            hintStyle: textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade300,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _infoController.clear();
                                _tagsController.clear();
                                setState(() {
                                  selectedImage = null;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Cleared')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Clear',
                                style: textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  final info = _infoController.text.trim();
                                  final tags = _tagsController.text.trim();

                                  String? uploadedImageUrl;

                                  if (selectedImage != null) {
                                    String fileName =
                                        DateTime.now().millisecondsSinceEpoch.toString();

                                    uploadedImageUrl = await R2Service.uploadImage(selectedImage!, fileName);
                                  }

                                  await FirebaseFirestore.instance.collection('tbl_posts').add({
                                    'contentAT': info,
                                    'tagsAT': tags,
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Create Post',
                                style: textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Ensure space below so bottom pill doesn't overlap inputs
                    SizedBox(height: 160 + MediaQuery.of(context).viewInsets.bottom),
                  ],
                ),
              ),
            ),

            // Bottom pill nav (consistent with other pages)
            Positioned(
              left: 20,
              right: 20,
              bottom: 18,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6)),
                    ],
                    border: Border.all(color: const Color(0xFF737373), width: 2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DaeSignNavCircle(icon: Icons.home, label: 'Home', selected: false, onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Home tapped')));
                      }),
                      const SizedBox(width: 16),
                      DaeSignNavCircle(icon: Icons.add, label: 'Add', selected: true, onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add tapped')));
                      }),
                      const SizedBox(width: 16),
                      DaeSignNavCircle(icon: Icons.search, label: 'Search', selected: false, onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Search tapped')));
                      }),
                      const SizedBox(width: 16),
                      DaeSignNavCircle(icon: Icons.notifications, label: 'Alerts', selected: false, onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alerts tapped')));
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
