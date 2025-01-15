import 'package:farms_gate_marketplace/model/user_model.dart';
import 'package:farms_gate_marketplace/providers/cart_provider.dart';
import 'package:farms_gate_marketplace/providers/login_provider.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/screens/cart_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/sign_in_screen.dart';
import 'package:farms_gate_marketplace/utils/custom_circler_loader.dart';
import 'package:farms_gate_marketplace/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<UserProfile>? _userProfile;
  bool isLoggingout = false;
  final List<Map<String, dynamic>> settingsItems = [
    {'title': 'Wallet', 'path': '/wallet_screen'},
    {'title': 'My Negotiations', 'path': '/negotiation_screen'},
    {'title': 'Saved Items', 'path': '/saveditem_screen'},
    {'title': 'Voucher', 'path': '/voucher_screen'},
    {'title': 'My Address', 'path': '/address_screen'},
    {'title': 'Notification', 'path': ''},
    {'title': 'Customer Support', 'path': '/customer_support'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      Provider.of<LoginProvider>(context, listen: false).fetchUserProfile(context);
    });
    _userProfile = LoginProvider().fetchUserProfile(context);
  }

  @override
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: true,
          elevation: 0,
          toolbarHeight: 118,
          leading: Container(
            margin: const EdgeInsets.only(left: 12),
            child: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.person_4_rounded,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
          title: Center(
            child: Text(
              'My Account',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
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
            // Image.asset(
            //   'assets/white_search.png',
            //   width: 18,
            //   height: 18,
            // ),
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 2,
                ),
                isLoggingout
                    ? const LinearProgressIndicator(
                        color: AppColors.primary,
                        minHeight: 2,
                      )
                    : const SizedBox(
                        height: 3,
                      ),
                const SizedBox(
                  height: 47,
                ),
                FutureBuilder<UserProfile>(
                  future: _userProfile,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: CustomCircularLoader(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      showCustomToast(context, snapshot.error.toString(), '',
                          ToastType.error);
                    }

                    String firstName = snapshot.data!.firstName.toString();

                    String lastName = snapshot.data!.lastName.toString();

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/my_account_screen');
                      },  
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                '${firstName[0].toUpperCase()} ${lastName[0].toUpperCase()}',
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${snapshot.data!.firstName ?? ''} ${snapshot.data!.lastName ?? ''}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                snapshot.data!.email.toString(),
                                style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: AppColors.textSecondary),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.59,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: settingsItems.length,
                        itemBuilder: (context, index) {
                          final item = settingsItems[index];
                          return Column(
                            children: [
                              ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                title: Text(
                                  item['title'],
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
                                  Navigator.of(context).pushNamed(item['path']);
                                },
                              ),
                            ],
                          );
                        })),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLoggingout = true;
                    });
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
                          settings:
                              const RouteSettings(name: '/signin_screen'), //
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
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
                      showCustomToast(
                          context, e.toString(), '', ToastType.error);
                    }
                    setState(() {
                      isLoggingout = false;
                    });
                  },
                  child: Text(
                    'Log Out',
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
        ));
  }
}
