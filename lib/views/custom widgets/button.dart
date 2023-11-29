import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../styles/color_styles.dart';
import '../../styles/text_styles.dart';

class Button extends StatelessWidget {
  final buttonText;
  final buttonColor;
  final buttonHeight;
  final buttonWidth;
  final onTap;
  final textSize;
  final hasIcon;
  final icon;
  final radius;
  final textColor;
  final shadowColor;
  final bool isSelected;
  final borderColor;
  final borderWidth;
  final bool isLoading;

  const Button({
    super.key,
    this.isLoading = false,
    this.isSelected = true,
    this.buttonColor = ColorStyle.brandRed,
    this.buttonText = ' Text Here',
    this.buttonHeight = 50.0,
    this.buttonWidth = 320.0,
    this.onTap,
    this.textSize = 14.0,
    this.hasIcon = false,
    this.icon,
    this.radius = 5.0,
    this.textColor = ColorStyle.whiteColor,
    this.shadowColor = Colors.transparent,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? () {} : onTap,
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
          borderRadius: BorderRadius.circular(radius),
          color: isSelected ? buttonColor : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasIcon) icon,
            SizedBox(width: hasIcon ? 4 : 0),
            isLoading
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadingAnimationWidget.staggeredDotsWave(
                          color: ColorStyle.whiteColor,
                          size: 24,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Loading...',
                          style: MyTextStyles.button,
                        ),
                      ],
                    ),
                  )
                : Text(
                    buttonText,
                    textAlign: TextAlign.center,
                    style: MyTextStyles.button.copyWith(
                      color: isSelected ? textColor : ColorStyle.brandRed,
                      fontSize: textSize,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
