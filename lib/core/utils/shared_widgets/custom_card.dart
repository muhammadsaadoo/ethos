import 'package:expence_management/core/utils/theme/appcolor/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final double width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;

  const CustomCard({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Container(
        width: width,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            // color: borderColor ?? AppColors.borderHalf,
            color: Get.isDarkMode ? AppColors.darkCard : AppColors.borderHalf,
            width: 1,
          ),
          boxShadow:
              boxShadow ??
              const [
                BoxShadow(
                  color: AppColors.shadowSoft,
                  offset: Offset(0, 8),
                  blurRadius: 30,
                ),
              ],
        ),

        // Height automatically adapts to child
        child: child,
      ),
    );
  }
}
