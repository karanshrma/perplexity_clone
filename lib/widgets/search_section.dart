import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:perplexity_clone/pages/chat_page.dart';
import 'package:perplexity_clone/services/chat_web_service.dart';
import 'package:perplexity_clone/theme/colors.dart';
import 'package:perplexity_clone/widgets/file_preview.dart';
import 'package:perplexity_clone/widgets/search_bar_button.dart';

class SearchSection extends StatefulWidget {
  const SearchSection({super.key});

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  Uint8List? imageBytes;
  String? fileName;
  html.File? _selectedFile;
  bool isFileAttached = false;

  final queryController = TextEditingController();

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      // Create a hidden file input element
      final html.InputElement input =
          html.document.createElement('input') as html.InputElement;
      input.type = 'file';
      input.accept = 'image/*,application/pdf,.txt,.doc,.docx,.csv,.json';
      input.multiple = false;

      // Make it completely hidden
      input.style.display = 'none';
      html.document.body!.append(input);

      // Listen for file selection
      input.onChange.listen((e) async {
        final files = input.files;
        if (files == null || files.isEmpty) {
          input.remove();
          return;
        }

        final file = files[0];
        _selectedFile = file;
        print(
          'File selected: ${file.name}, Size: ${file.size} bytes, Type: ${file.type}',
        );

        final reader = html.FileReader();

        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((e) {
          final bytes = reader.result as Uint8List;

          setState(() {
            imageBytes = bytes;
            fileName = file.name;
            isFileAttached = true;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(' ${file.name} attached '),
                duration: const Duration(seconds: 2),
              ),
            );
          }

          input.remove();
        });

        reader.onError.listen((e) {
          if (mounted) {
            print('Error reading file');
          }
          input.remove();
        });
      });

      // Open file picker
      input.click();
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        print(' Failed to open file picker');
      }
    }
  }

  void _removeFile() {
    setState(() {
      imageBytes = null;
      fileName = null;
      _selectedFile = null;
      isFileAttached = false;
    });
  }

  void _handleSubmit() {
    final query = queryController.text.trim();
    if (query.isEmpty && !isFileAttached) return;

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
          child: Column(
            children: [
              if (isFileAttached && imageBytes != null && fileName != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 350,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      decoration: BoxDecoration(
                        color: AppColors.searchBar,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.searchBarBorder.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                      ),
                      child: FilePreview(
                        imageBytes: imageBytes!,
                        filename: fileName!,
                        onRemove: _removeFile,
                      ),
                    ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    SearchBarButton(
                      icon: Icons.auto_awesome_outlined,
                      text: 'Focus',
                    ),
                    const SizedBox(width: 12),
                    // GestureDetector(
                    //   onTap: _pickImageFromGallery,
                    //   child: SearchBarButton(
                    //     icon: Icons.add_circle_outline_outlined,
                    //     text: 'Attach',
                    //   ),
                    // ),
                    // const Spacer(),
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
