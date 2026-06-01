// core/utils/shared_widgets/custom_card.dart

import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final double width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const CustomCard({
    super.key,
    required this.child,
    this.width = double.infinity,
    this.padding,
    this.margin,
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
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color(0x80E1E3E4), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D0F172A),
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
