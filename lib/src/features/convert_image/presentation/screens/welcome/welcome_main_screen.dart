// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Project imports:
import '../../../../../core/resources/app_assets.dart';
import 'widgets/welcome_screen.dart';

class WelcomeMainScreen extends StatefulWidget {
  const WelcomeMainScreen({super.key});

  @override
  _WelcomeMainScreenState createState() => _WelcomeMainScreenState();
}

class _WelcomeMainScreenState extends State<WelcomeMainScreen> {
  final _controller = PageController();
  var _currentPageIndex = 0;

  final List<Widget> pages = [
    const WelcomeScreen(
      image: "",
      headerText: "Welcome!",
      bodyText: "Let's do a quick tour of our app.",
    ),
    const WelcomeScreen(
      image: AppIcons.convert,
      headerText: "Convert to JPG PNG WEBP PDF",
      bodyText: "One or multiple images at the same time.",
    ),
    const WelcomeScreen(
      image: AppIcons.compress,
      headerText: "Compress images",
      bodyText:
          "Reduce the file size of your images. Perfect for saving space.",
    ),
    const WelcomeScreen(
      image: AppIcons.check,
      headerText: "All done!",
      bodyText: "You're ready to start using the app!",
    ),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  void _onNextPage() {
    if (_currentPageIndex < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCirc,
      );
    } else if (_currentPageIndex == pages.length - 1) {
      print(123);
      Navigator.pushReplacementNamed(context, "select_images");
    }
    // _currentPageIndex++;
  }

  void _toLastPage() {
    _controller.animateToPage(
      pages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.bounceIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = _currentPageIndex == pages.length - 1;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 30),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: _onPageChanged,
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    return pages[index];
                  },
                ),
              ),

              SmoothPageIndicator(
                controller: _controller,
                count: 4,
                effect: const ScrollingDotsEffect(
                  dotHeight: 13,
                  dotWidth: 13,
                  activeDotColor: AppColors.indicatorDotActive,
                  dotColor: AppColors.indicatorDot,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment:
                    isLastPage
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.spaceBetween,

                children: [
                  if (!isLastPage)
                    TextButton(
                      onPressed: _toLastPage,
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                    ),
                    onPressed: _onNextPage,
                    child: Row(
                      children: [
                        const Text(
                          "Continue",
                          style: TextStyle(fontSize: 16, color: AppColors.font),
                        ),
                        const SizedBox(width: 16),
                        Image.asset(AppIcons.rightArrow, width: 20, height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
