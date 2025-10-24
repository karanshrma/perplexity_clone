import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:perplexity_clone/services/chat_web_service.dart';
import 'package:perplexity_clone/theme/colors.dart';
import 'package:perplexity_clone/widgets/search_section.dart';
import 'package:perplexity_clone/widgets/side_bar.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => HomePage());

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    ChatWebService().connect();
    print("[HomePage] ChatWebService.connect() called");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            kIsWeb
                ? () {
                    return SideBar();
                  }()
                : () {
                    return SizedBox();
                  }(),
            Expanded(
              child: Padding(
                padding: !kIsWeb ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
                child: Column(
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
                    SearchSection(),
                    // footer
                    kIsWeb
                        ? () {
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  _footerItem("Pro"),
                                  _footerItem("Enterprise"),
                                  _footerItem("Store"),
                                  _footerItem("Blog"),
                                  _footerItem("Careers"),
                                  _footerItem("English (English)"),
                                ],
                              ),
                            );
                          }()
                        : () {
                            return SizedBox();
                          }(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _footerItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, color: AppColors.footerGrey),
      ),
    );
  }
}
