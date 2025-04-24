import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {"title": "Welcome to PhotoAid"},
    {
      "animation": "assets/lottie/select_profile.json",
      "title": "Request Help Instantly",
    },
    {
      "animation": "assets/lottie/share_location.json",
      "title": "Share Location with Helpers",
    },
    {
      "animation": "assets/lottie/Take_photo.json",
      "title": "Capture the Moment",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // PageView
            PageView.builder(
              controller: _controller,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child:
                          index == 0
                              ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedOpacity(
                                    opacity: 1,
                                    duration: const Duration(
                                      milliseconds: 1000,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 20,
                                            spreadRadius: 5,
                                          ),
                                        ],
                                      ),
                                      child: Image.asset(
                                        'assets/images/photoaid_logo.png',
                                        height: 180,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  const Text(
                                    "Welcome to PhotoAid",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 30,
                                    ),
                                    child: Text(
                                      "Connecting people to capture unforgettable moments.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              : Lottie.asset(
                                onboardingData[index]['animation']!,
                              ),
                    ),
                    if (index != 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          onboardingData[index]['title']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 100),
                  ],
                );
              },
            ),

            // Skip Button
            Positioned(
              top: 20,
              left: 20,
              child: Visibility(
                visible: currentIndex != onboardingData.length - 1,
                child: TextButton(
                  onPressed: () {
                    _controller.jumpToPage(onboardingData.length - 1);
                  },
                  child: const Text("Skip"),
                ),
              ),
            ),

            // Page Indicator
            Positioned(
              bottom: 70,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: onboardingData.length,
                  effect: const WormEffect(dotHeight: 10, dotWidth: 10),
                ),
              ),
            ),

            // Next or Get Started Button
            Positioned(
              bottom: 20,
              right: 20,
              child:
                  currentIndex == onboardingData.length - 1
                      ? ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text("Get Started"),
                      )
                      : ElevatedButton(
                        onPressed: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text("Next"),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
