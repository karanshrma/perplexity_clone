import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:perplexity_clone/pages/chat_page.dart';
import 'package:perplexity_clone/services/auth_service.dart';
import 'package:perplexity_clone/services/chat_web_service.dart';
import 'package:perplexity_clone/theme/colors.dart';
import 'package:perplexity_clone/widgets/search_bar_button.dart';

class SearchSection extends StatefulWidget {
  const SearchSection({super.key});

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late final AuthService authService;
  final queryController = TextEditingController();
  bool isAttached = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource imageSource) async {
    final XFile? image = await _picker.pickImage(source: imageSource);
    setState(() {
      _selectedImage = File(image!.path);
    });
  }

  @override
  void initState() {
    super.initState();
    authService = AuthService(firebaseAuth);
  }

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      // Show bottom sheet to choose between camera, gallery, or file
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      print('Error showing picker options: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to open file picker'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> signIn() async {
    final userCredential = await authService.signInWithGoogle();
    if (userCredential != null) {
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _handleSubmit() async {
    // final userId = await AuthService.getUserId();
    // if (userId == null) {
    //   return showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: TextButton(
    //           onPressed: signIn,
    //           child: Text(
    //             'Sign in to continue',
    //             textAlign: TextAlign.center,
    //             style: TextStyle(color: Colors.black),
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // }
    final query = queryController.text.trim();

    if (query.isEmpty) {
      return;
    }
    print('query is $query');

    ChatWebService().chat(query);


    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => ChatPage(question: query)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Where knowledge begins',
          style: GoogleFonts.ibmPlexMono(
            fontSize: 40,
            fontWeight: FontWeight.w400,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          width: 700,
          decoration: BoxDecoration(
            color: AppColors.searchBar,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.searchBarBorder, width: 1.5),
          ),
          child: (isAttached == true)
              ? Row(
                  children: [
                    Image.file(_selectedImage!, height: 200),

                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  autofocus: true,
                                  controller: queryController,
                                  decoration: InputDecoration(
                                    hintText: 'Search anything...',
                                    hintStyle: TextStyle(
                                      color: AppColors.textGrey,
                                      fontSize: 16,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onSubmitted: (_) => _handleSubmit(),
                                ),
                              ),
                              GestureDetector(
                                onTap: _pickImageFromGallery,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.searchBarBorder
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.attach_file,
                                    color: AppColors.textGrey,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              SearchBarButton(
                                icon: Icons.auto_awesome_outlined,
                                text: 'Focus',
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: _handleSubmit,
                                child: Container(
                                  padding: EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                    color: AppColors.submitButton,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    color: AppColors.background,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              autofocus: true,
                              controller: queryController,
                              decoration: InputDecoration(
                                hintText: 'Search anything...',
                                hintStyle: TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onSubmitted: (_) => _handleSubmit(),
                            ),
                          ),
                          GestureDetector(
                            onTap: _pickImageFromGallery,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.searchBarBorder.withOpacity(
                                  0.1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.attach_file,
                                color: AppColors.textGrey,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          SearchBarButton(
                            icon: Icons.auto_awesome_outlined,
                            text: 'Focus',
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: _handleSubmit,
                            child: Container(
                              padding: EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: AppColors.submitButton,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: AppColors.background,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
