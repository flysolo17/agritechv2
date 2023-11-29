import 'package:flutter/material.dart';

import '../../styles/color_styles.dart';
import '../../styles/text_styles.dart';

class CustomInputContainer extends StatelessWidget {
  final containerHeight;
  final String title;
  final bool hasTitle;
  final double bottomPadding;
  final customWidget;
  final radius;
  final containerWidth;
  final horizontalPadding;
  final verticalPadding;
  final containerBorderWidth;
  final containerColor;
  final containerBorderColor;
  final onTap;
  final titleColor;
  final bool uploaded;

  const CustomInputContainer({
    super.key,
    this.uploaded = false,
    this.customWidget,
    this.onTap,
    this.titleColor = Colors.white,
    this.hasTitle = true,
    this.containerHeight,
    this.horizontalPadding = 20.0,
    this.verticalPadding = 5.0,
    this.containerBorderWidth = 1.0,
    this.containerBorderColor,
    this.title = 'Title Here',
    this.bottomPadding = 15.0,
    this.radius = 8.0,
    this.containerWidth = double.infinity,
    this.containerColor = ColorStyle.whiteColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasTitle)
            Text(
              title,
              style: MyTextStyles.inputField,
            ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: onTap,
            child: Container(
              alignment: Alignment.center,
              width: containerWidth,
              height: containerHeight,
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                  width: containerBorderWidth,
                  color:
                      containerBorderColor ?? ColorStyle.grey.withOpacity(0.2),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: uploaded
                  ? customWidget
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tap Here',
                        style: MyTextStyles.inputField,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
