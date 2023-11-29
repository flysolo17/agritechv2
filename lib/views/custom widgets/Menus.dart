import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../styles/color_styles.dart';
import '../../styles/text_styles.dart';

class Menu extends StatelessWidget {
  final icon;
  final String title;
  final page;
  final forHome;
  final bool isLogout;

  Menu({
    super.key,
    this.isLogout = false,
    required this.title,
    required this.icon,
    this.page,
    this.forHome,
  });
  // var eventList = Get.put(EventListManager());
  // var logout = Get.put(LogoutManager());
  var eventId;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // if (isLogout) {
        //   late final prefs;
        //   prefs = await SharedPreferences.getInstance();
        //   var deviceToken = prefs.getString('deviceToken');
        //   print(deviceToken);
        //   var details = {"device_token": "$deviceToken"};
        //   await logout.logoutController(details);
        //   deviceToken = await prefs.remove('deviceToken');
        //   print(
        //       'this should be null: ${deviceToken} it is ${prefs.getString('deviceToken')}');
        // }
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        // Get.to(
        //   () => page,
        //   arguments: eventId,
        // );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25.0),
        child: ListTile(
          leading: Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset('lib/assets/svg_icons/Light/$icon'),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(title,
                style: MyTextStyles.text.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    color: ColorStyle.blackColor)),
          ),
        ),
      ),
    );
  }
}
