import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:perplexity_clone/theme/colors.dart';
import 'package:perplexity_clone/widgets/answer_section.dart';
import 'package:perplexity_clone/widgets/side_bar.dart';
import 'package:perplexity_clone/widgets/sources_section.dart';
import '../widgets/search_section.dart';

class ChatPage extends StatefulWidget {
  final String question;

  const ChatPage({super.key, required this.question});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    final bool isWeb = kIsWeb;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Sidebar visible only on web
            if (isWeb) const SideBar(),

            // ✅ Main content
            Expanded(
              child: Column(
                children: [
                  // 🧠 Scrollable content
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ✅ Question text
                              Text(
                                widget.question,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 32),

                              // ✅ Sources Section
                              const SourcesSection(),

                              const SizedBox(height: 32),

                              // ✅ Answer Section
                              const AnswerSection(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 🧭 SearchSection fixed at bottom
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      border: Border(
                        top: BorderSide(color: Colors.white24, width: 0.3),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 900),
                      child: SearchSection(),
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Optional right placeholder for web layout symmetry
            if (isWeb && screenWidth > 1300)
              Container(
                width: 260,
                color: AppColors.background,
              ),
          ],
        ),
      ),
    );
  }
}
