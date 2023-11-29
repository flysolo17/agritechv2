import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MenuIcon extends StatelessWidget {
  final onTap;

  const MenuIcon({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      padding: const EdgeInsets.only(
        left: 20,
        right: 7,
        top: 7,
        bottom: 7,
      ),
      child: InkWell(
        onTap: onTap,
        child: SvgPicture.asset(
          'lib/assets/svg_icons/CustomMenu.svg',
          height: 25,
        ),
      ),
    );
  }
}
