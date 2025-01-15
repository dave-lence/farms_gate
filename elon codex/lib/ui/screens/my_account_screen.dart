import 'package:farms_gate_marketplace/providers/cart_provider.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/screens/cart_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/sign_in_screen.dart';
import 'package:farms_gate_marketplace/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  final List<Map<String, dynamic>> settingsItems = [
    {'title': 'My Account Details', 'path': '/update_user_details'},
    {'title': 'Change Password', 'path': '/negotiation_screen'},
  ];

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: true,
        elevation: 0,
        toolbarHeight: 118,
        title: Center(
          child: Text(
            'My Account',
            style: GoogleFonts.plusJakartaSans(
                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        flexibleSpace: Container(
          padding: const EdgeInsets.only(top: 37, left: 20),
          height: 128,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.black.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              image: const DecorationImage(
                  image: AssetImage(
                    'assets/app_bar_background.png',
                  ),
                  fit: BoxFit.cover)),
          // child:
        ),
        actions: [
          Image.asset(
            'assets/white_search.png',
            width: 18,
            height: 18,
          ),
          Stack(
            children: [
              IconButton(
                  onPressed: () {
                    PersistentNavBarNavigator.pushNewScreen(context,
                        withNavBar: false, screen: const CartScreen());
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  )),
              if (cartProvider.cartList.isNotEmpty)
                Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 21,
                      width: 21,
                      decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        cartProvider.cartLength.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 8),
                      )),
                    )),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      title: Text(
                        'My Account Details',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: Colors.black,
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/update_user_details');
                      },
                    ),
                    ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0),
                        title: Text(
                          'Reset Password',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Colors.black,
                        ),
                        onTap: null),
                  ],
                )),
            GestureDetector(
              onTap: () async {
                // setState(() {
                //   isLoggingout = true;
                // });
                await Future.delayed(const Duration(seconds: 3));
                try {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.remove('bearer');
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: const SignInScreen(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.fade,
                    customPageRoute: PageRouteBuilder(
                      settings: const RouteSettings(name: '/signin_screen'), //
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const SignInScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        final tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        final offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                } catch (e) {
                  showCustomToast(context, e.toString(), '', ToastType.error);
                }
                // setState(() {
                //   isLoggingout = false;
                // });
              },
              child: Text(
                'Delete Account',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
