import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/colors.dart';
import '../../constant/size_helper.dart';
import '../../controller/onboarding_controller.dart';
import '../widgets/custom_onboarding.dart';
import '../widgets/custom_orboarding_with_buttons.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final controller = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    itemCount: controller.onboardingData.length,
                    onPageChanged: controller.onPageChanged,
                    itemBuilder: (context, index) {
                      final data = controller.onboardingData[index];
                      if (index == 3) {
                        return FourthOnboardingPage(
                          image: data["image"]!,
                          title: data["title"]!,
                          subtitle: data["subtitle"]!,
                        );
                      } else {
                        return CustomOnboardingPage(
                          image: data["image"]!,
                          title: data["title"]!,
                          subtitle: data["subtitle"]!,
                        );
                      }
                    },
                  ),
                ),
                Obx(() {
                  return controller.currentPage.value != 3
                      ? Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockWidth * 6,
                        vertical: SizeConfig.blockHeight * 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (controller.currentPage.value > 0)
                          TextButton(
                            onPressed: controller.prevPage,
                            child: Text(
                              "Prev",
                              style: TextStyle(
                                  color: AppColors.primary, fontSize: 16),
                            ),
                          )
                        else
                          const SizedBox(width: 60),

                        // ✅ Indicator
                        Row(
                          children: List.generate(
                            controller.onboardingData.length - 1,
                                (index) => AnimatedContainer(
                              duration:
                              const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 4),
                              width: controller.currentPage.value == index
                                  ? 24
                                  : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color:
                                controller.currentPage.value == index
                                    ? AppColors.primary
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        // ✅ Next Button
                        TextButton(
                          onPressed: controller.nextPage,
                          child: const Text(
                            "Next",
                            style: TextStyle(
                                color: AppColors.primary, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  )
                      : const SizedBox.shrink();
                }),
              ],
            ),

            // ✅ Skip Button
            Obx(() {
              return controller.currentPage.value != 3
                  ? Positioned(
                top: SizeConfig.blockHeight * 2,
                right: SizeConfig.blockWidth * 4,
                child: GestureDetector(
                  onTap: controller.skipToLast,
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
                  : const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
