import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Loading indicator widget
class LoadingWidget extends StatelessWidget {
  final Color? color;
  final double size;
  final String? message;

  const LoadingWidget({
    super.key,
    this.color,
    this.size = 40,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppColors.primary,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                color: color ?? AppColors.greyDark,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Loading overlay widget
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: LoadingWidget(
              color: AppColors.white,
              message: message,
            ),
          ),
      ],
    );
  }
}
