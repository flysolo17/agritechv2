import 'package:flutter/material.dart';
import '../../styles/color_styles.dart';
import '../../styles/text_styles.dart';

class InputFields extends StatefulWidget {
  final hintText;
  final title;
  final maxLines;
  final bool hasSuffix;
  final bool hasPreffix;
  final hasObscureText;
  final suffixIcon;
  final preffixIcon;
  final pressedSuffixIcon;
  final width;
  final controller;
  final containerHeight;
  final bool? isEmail;

  const InputFields({
    super.key,
    this.isEmail = false,
    this.containerHeight = 46.0,
    this.controller,
    this.width,
    this.pressedSuffixIcon,
    this.hasSuffix = false,
    this.hasPreffix = false,
    this.title = 'Title Here',
    this.hintText = 'hint text here',
    this.maxLines = 1,
    this.hasObscureText = false,
    this.preffixIcon,
    this.suffixIcon,
  });

  @override
  State<InputFields> createState() => _InputFieldsState();
}

class _InputFieldsState extends State<InputFields> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: SizedBox(
        width: widget.width,
        height: 57,
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: widget.containerHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xffa3a3a3),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 7,
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
                    controller: widget.controller,
                    obscureText: widget.hasObscureText,
                    decoration: InputDecoration(
                        suffixIcon: widget.hasSuffix
                            ? InkWell(
                                onTap: widget.pressedSuffixIcon,
                                child: widget.suffixIcon,
                              )
                            : null,
                        prefixIcon:
                            widget.hasPreffix ? widget.preffixIcon : null,
                        border: InputBorder.none,
                        hintText: widget.hintText,
                        hintStyle: MyTextStyles.text.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: ColorStyle.grey.withOpacity(0.5))),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              top: 2,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Text(
                  widget.title,
                  style: MyTextStyles.text.copyWith(
                    color: ColorStyle.blackColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
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
