import 'package:agritechv2/blocs/cart/cart_bloc.dart';
import 'package:agritechv2/blocs/messenger/messenger_bloc.dart';
import 'package:agritechv2/models/messages.dart';
import 'package:agritechv2/models/product/CartWithProduct.dart';
import 'package:agritechv2/repository/auth_repository.dart';
import 'package:agritechv2/repository/cart_repository.dart';
import 'package:agritechv2/repository/message_repository.dart';
import 'package:agritechv2/views/custom%20widgets/cart_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../styles/color_styles.dart';
import '../../styles/text_styles.dart';
import '../nav/home/dashboard.dart';
import '../nav/map/map.dart';
import '../nav/buy/buy.dart';
import '../nav/bot/bot.dart';
import '../nav/profile/profile.dart';
import 'package:badges/badges.dart' as badges;

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    DashboardPage(),
    MapPage(),
    BuyPage(),
    ChatBotPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Messenger> _unseenList = [];
  @override
  @override
  Widget build(BuildContext context) {
    String uid = context.read<AuthRepository>().currentUser?.uid ?? '';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorStyle.brandRed,
        title: const Text('agritech'),
        actions: [
          StreamBuilder<List<Messenger>>(
              stream: context.read<MessengerBloc>().messengerStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Messenger> messages = snapshot.data ?? [];
                  _unseenList = messages
                      .where((e) => e.receiverID == uid && e.seen == false)
                      .toList();
                }
                return badges.Badge(
                  position: badges.BadgePosition.topEnd(top: 0, end: 3),
                  badgeAnimation: const badges.BadgeAnimation.slide(),
                  showBadge: true,
                  badgeStyle: const badges.BadgeStyle(
                    badgeColor: Colors.red,
                  ),
                  badgeContent: Text(
                    _unseenList.length.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 8.0),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.message,
                      color: Colors.white,
                    ),
                    onPressed: () => {context.push('/messages')},
                  ), // You can replace this with your actual badge content
                );
              }),
          const SizedBox(
            width: 5.0,
          ),
          const CartAction()
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 30,
        unselectedLabelStyle: MyTextStyles.text,
        selectedItemColor: ColorStyle.brandGreen,
        unselectedItemColor: ColorStyle.grey,
        showSelectedLabels: true,
        selectedLabelStyle:
            MyTextStyles.text.copyWith(fontWeight: FontWeight.normal),
        backgroundColor: ColorStyle.whiteColor,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'lib/assets/svg_icons/Bold/Home.svg',
              color: _selectedIndex == 0 ? ColorStyle.brandGreen : Colors.grey,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 1
                  ? Icons.bug_report
                  : Icons.bug_report_outlined,
              size: 25,
            ),
            label: 'Pest Map',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 2
                  ? 'lib/assets/svg_icons/Bold/Bag.svg'
                  : 'lib/assets/svg_icons/Light/Bag.svg',
              color: _selectedIndex == 2
                  ? ColorStyle.brandGreen
                  : ColorStyle.brandGreen,
            ),
            label: 'Buy',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 3
                  ? Icons.energy_savings_leaf
                  : Icons.energy_savings_leaf_outlined,
              size: 25,
            ),
            label: 'Agri Bot',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'lib/assets/svg_icons/Bold/Profile.svg',
              color: _selectedIndex == 4 ? ColorStyle.brandGreen : Colors.grey,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
