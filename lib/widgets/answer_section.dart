import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:perplexity_clone/services/chat_web_service.dart';
import 'package:perplexity_clone/theme/colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AnswerSection extends StatefulWidget {
  const AnswerSection({super.key});

  @override
  State<AnswerSection> createState() => _AnswerSectionState();
}

class _AnswerSectionState extends State<AnswerSection> {
  bool isLoading = true;
  String fullResponse = "";

  @override
  void initState() {
    super.initState();
    ChatWebService().contentStream.listen((data) {
      setState(() {
        fullResponse += data;
        print(fullResponse);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: !kIsWeb ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
      child: isLoading ? Text("") : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Perplexity',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Skeletonizer(
            effect: ShimmerEffect(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              duration: const Duration(seconds: 1),
            ),
            enabled: isLoading,
            child: Markdown(
              data: fullResponse,
              shrinkWrap: true,
              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                  .copyWith(
                    codeblockDecoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    code: const TextStyle(fontSize: 16),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
