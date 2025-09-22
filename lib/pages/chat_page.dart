import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:perplexity_clone/theme/colors.dart';
import 'package:perplexity_clone/widgets/answer_section.dart';
import 'package:perplexity_clone/widgets/side_bar.dart';
import 'package:perplexity_clone/widgets/sources_section.dart';

class ChatPage extends StatelessWidget {
  final String question;

  const ChatPage({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    print("[ChatPage] build() called with question: $question");

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            kIsWeb
                ? () {
                    print("[ChatPage] Showing SideBar on Web");
                    return SideBar();
                  }()
                : () {
                    print("[ChatPage] Hiding SideBar on Mobile");
                    return const SizedBox();
                  }(),
            kIsWeb
                ? () {
                    print("[ChatPage] Adding spacing (100px) on Web");
                    return const SizedBox(width: 100);
                  }()
                : const SizedBox(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      () {
                        print("[ChatPage] Rendering question text");
                        return Text(
                          question,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }(),
                      const SizedBox(height: 24),
                      () {
                        print("[ChatPage] Rendering SourcesSection");
                        return SourcesSection();
                      }(),
                      const SizedBox(height: 24),
                      () {
                        print("[ChatPage] Rendering AnswerSection");
                        return AnswerSection();
                      }(),
                    ],
                  ),
                ),
              ),
            ),
            kIsWeb
                ? () {
                    print("[ChatPage] Rendering Placeholder on Web");
                    return const Placeholder(
                      strokeWidth: 0,
                      color: AppColors.background,
                    );
                  }()
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
