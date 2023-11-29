import 'package:flutter/material.dart';

import '../../styles/color_styles.dart';
import '../../styles/text_styles.dart';

class InputField extends StatefulWidget {
  final bool hasPreffix;
  final bool hasSuffix;
  final bool isEventTitle;
  final bool isEventDuration;
  final bool isEventDescription;
  final suffixIcon;
  String textValue;
  final suffixText;
  final preffixIcon;
  final String hintText;
  final int maxLines;
  final double containerHeight;
  final mycolor;
  final String title;
  final bool hasTitle;
  final double bottomPadding;
  final controller;
  final inputType;
  final radius;
  final containerWidth;
  final containerColor;
  final bool isObsured;
  final bool? isEmail;

  InputField({
    super.key,
    this.isEmail = false,
    this.isEventDescription = false,
    this.isEventDuration = false,
    this.isEventTitle = false,
    this.textValue = '',
    this.controller,
    this.hasTitle = true,
    this.hasPreffix = false,
    this.hasSuffix = false,
    this.suffixIcon,
    this.suffixText,
    this.isObsured = false,
    this.inputType,
    this.preffixIcon,
    this.hintText = '',
    this.maxLines = 1,
    this.containerHeight = 60.0,
    this.mycolor = ColorStyle.grey,
    this.title = 'Title Here',
    this.bottomPadding = 15.0,
    this.radius = 5.0,
    this.containerWidth = double.infinity,
    this.containerColor = ColorStyle.whiteColor,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.hasTitle)
            Text(
              widget.title,
              style: MyTextStyles.inputField.copyWith(
                fontWeight: FontWeight.w700,
                color: ColorStyle.blackColor,
              ),
            ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.center,
            width: widget.containerWidth,
            height: widget.containerHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius),
              border: Border.all(
                width: 1,
                color: ColorStyle.grey.withOpacity(0.2),
              ),
              color: widget.containerColor,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Can't be empty";
                } else if (widget.isEmail!) {
                  Pattern emailPattern =
                      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,}$';
                  RegExp regex = RegExp(emailPattern.toString());
                  if (!regex.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                }
                return null;
              },
              onChanged: (value) {
                return setState(() {
                  print(value);
                });
              },
              controller: widget.controller,
              maxLines: widget.maxLines,
              obscureText: widget.isObsured,
              keyboardType: widget.inputType,
              style: MyTextStyles.inputField
                  .copyWith(color: ColorStyle.blackColor),
              decoration: InputDecoration(
                  suffixText: widget.suffixText,
                  border: InputBorder.none,
                  hintText: widget.hintText,
                  hintStyle: MyTextStyles.inputField.copyWith(
                    color: ColorStyle.blackColor.withOpacity(0.6),
                  ),
                  suffixIcon: widget.hasSuffix
                      ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: widget.suffixIcon,
                        )
                      : null,
                  prefixIcon: widget.hasPreffix
                      ? Padding(
                          padding: const EdgeInsets.only(right: 25.0),
                          child: widget.preffixIcon,
                        )
                      : null),
            ),
          ),
        ],
      ),
    );
  }
}
