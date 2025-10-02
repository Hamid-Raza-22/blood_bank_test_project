import 'package:flutter/material.dart';

import '../../constant/colors.dart';
import '../../constant/size_helper.dart';
import '../widgets/custom_onboarding.dart';
import '../widgets/custom_orboarding_with_buttons.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, String>> onboardingData = [
    {
      "image": "assets/gif/blood_1.gif",
      "title": "Easy Donor Search",
      "subtitle": "Easy to find available donors nearby \n you will verify when they near your location.",
    },
    {
      "image": "assets/gif/blood_2.gif",
      "title": "Track Your Donor",
      "subtitle": "You can track your donor's location \n and know the estimated time to arrive",
    },
    {
      "image": "assets/gif/blood_3.gif",
      "title": "Emergency Post",
      "subtitle": "You can post when you have emergency \n situation and the donors can find you \n easily to donate ",
    },
    {
      "image": "assets/gif/blood_4.gif",
      "title": "Get Started Now",
      "subtitle": "Choose an option below to continue.",
    },
  ];

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToLast() {
    _pageController.jumpToPage(3);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingData.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      if (index == 3) {
                        return FourthOnboardingPage(
                          image: onboardingData[index]["image"]!,
                          title: onboardingData[index]["title"]!,
                          subtitle: onboardingData[index]["subtitle"]!,
                          //imageHeight: SizeConfig.blockHeight * 35, // bigger image
                        );
                      } else {
                        return CustomOnboardingPage(
                          image: onboardingData[index]["image"]!,
                          title: onboardingData[index]["title"]!,
                          subtitle: onboardingData[index]["subtitle"]!,
                         // imageHeight: SizeConfig.blockHeight * 35, // bigger image
                        );
                      }
                    },
                  ),
                ),
                if (_currentPage != 3)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockWidth * 6,
                        vertical: SizeConfig.blockHeight * 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Prev Button
                        if (_currentPage > 0)
                          TextButton(
                            onPressed: _prevPage,
                            child: Text(
                              "Prev",
                              style: TextStyle(
                                  color: AppColors.primary, fontSize: 16),
                            ),
                          )
                        else
                          const SizedBox(width: 60),

                        // ✅ Custom Indicator
                        Row(
                          children: List.generate(
                            onboardingData.length - 1,
                                (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin:
                              const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentPage == index ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? AppColors.primary
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        // Next Button
                        TextButton(
                          onPressed: _nextPage,
                          child: const Text(
                            "Next",
                            style: TextStyle(
                                color: AppColors.primary, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            // ✅ Skip Button (top-right only for screens 0-2)
            if (_currentPage != 3)
              Positioned(
                top: SizeConfig.blockHeight * 2,
                right: SizeConfig.blockWidth * 4,
                child: GestureDetector(
                  onTap: _skipToLast,
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
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
