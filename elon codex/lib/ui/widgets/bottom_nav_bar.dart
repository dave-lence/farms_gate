import 'package:farms_gate_marketplace/providers/orders_provider.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/screens/add_adress_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/address_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/customer_care_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/my_account_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/negotiation_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/saved_items_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/update_user_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/voucher_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:farms_gate_marketplace/ui/screens/category.dart';
import 'package:farms_gate_marketplace/ui/screens/home.dart';
import 'package:farms_gate_marketplace/ui/screens/my_orders_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/profile.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  final int dynamicIndex;
  const BottomNavBar({super.key, this.dynamicIndex = 0});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late PersistentTabController _controller;
  final List<ScrollController> _scrollControllers = [
    ScrollController(),
    ScrollController(),
  ];

  NavBarStyle _navBarStyle = NavBarStyle.simple;

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentIndex = 0;
    });
    _currentIndex = widget.dynamicIndex;
    _controller = PersistentTabController(initialIndex: _currentIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    for (final element in _scrollControllers) {
      element.dispose();
    }
    super.dispose();
  }

  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoryScreen(),
    const MyOrdersScreen(),
    const ProfileScreen(),
  ];

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Image.asset(
          'assets/home.png',
          width: 18,
          height: 18,
        ),
        inactiveIcon: Image.asset(
          'assets/home_inactive.png',
          width: 18,
          height: 18,
        ),
        title: ("Home"),
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey.shade400,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset(
          'assets/category.png',
          width: 18,
          height: 18,
        ),
        inactiveIcon: Image.asset(
          'assets/category_inactive.png',
          width: 18,
          height: 18,
        ),
        title: ("Categories"),
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey.shade400,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset(
          'assets/orders_inactive.png',
          width: 18,
          height: 18,
        ),
        inactiveIcon: Image.asset(
          'assets/orders.png',
          width: 18,
          height: 18,
        ),
        title: ("My Orders"),
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: Colors.grey.shade400,
      ),
      PersistentBottomNavBarItem(
          icon: Image.asset(
            'assets/profile_active.png',
            width: 18,
            height: 18,
          ),
          title: ("Profile"),
          inactiveIcon: Image.asset(
            'assets/profile.png',
            width: 18,
            height: 18,
          ),
          activeColorPrimary: AppColors.primary,
          inactiveColorPrimary: Colors.grey.shade400,
          routeAndNavigatorSettings: RouteAndNavigatorSettings(routes: {
            '/saveditem_screen': (context) => const SavedItemsScreen(),
            '/wallet_screen': (context) => const WalletScreen(),
            '/address_screen': (context) => const MyAddressScreen(),
            '/add_address_screen': (context) => const AddAdressScreen(),
            '/negotiation_screen': (context) => const NegotiationScreen(),
            '/voucher_screen': (context) => const VoucherScreen(),
            '/my_account_screen': (context) => const MyAccountScreen(),
            '/update_user_details': (context) =>
                const UpdateUserDetailsScreen(),
            '/customer_support': (context) => const CustomerCareScreen(),
          })),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          body: _screens[_currentIndex],
          bottomNavigationBar: PersistentTabView(
            context,
            controller: _controller,
            screens: _screens,
            items: _navBarsItems(),
            stateManagement: true,
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset: true,
            hideNavigationBarWhenKeyboardAppears: true,
            popBehaviorOnSelectedNavBarItemPress: PopBehavior.once,
            padding: const EdgeInsets.symmetric(vertical: 7),
            bottomScreenMargin: 5,
            backgroundColor: Colors.white,
            isVisible: true,
            animationSettings: const NavBarAnimationSettings(
              navBarItemAnimation: ItemAnimationSettings(
                duration: Duration(milliseconds: 400),
                curve: Curves.bounceOut,
              ),
              screenTransitionAnimation: ScreenTransitionAnimationSettings(
                animateTabTransition: true,
                duration: Duration(milliseconds: 200),
                screenTransitionAnimationType:
                    ScreenTransitionAnimationType.slide,
              ),
            ),
            onItemSelected: (index) {
              setState(() {
                _currentIndex = index;
              });

              if (index == 2) {
                Provider.of<OrdersProvider>(context, listen: false)
                    .setWasPopped(false);
              }
            },
            navBarHeight: 63,
            navBarStyle: _navBarStyle,
          )),
    );
  }
}
