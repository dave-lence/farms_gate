// ignore_for_file: prefer_const_constructors

import 'package:farms_gate_marketplace/providers/address_provider.dart';
import 'package:farms_gate_marketplace/providers/cart_provider.dart';
import 'package:farms_gate_marketplace/providers/forgot_passwordProvider.dart';
import 'package:farms_gate_marketplace/providers/login_provider.dart';
import 'package:farms_gate_marketplace/providers/orders_provider.dart';
import 'package:farms_gate_marketplace/providers/product_provider.dart';
import 'package:farms_gate_marketplace/providers/register_provider.dart';
import 'package:farms_gate_marketplace/providers/saved_item_provider.dart';
import 'package:farms_gate_marketplace/providers/transaction_provider.dart';
import 'package:farms_gate_marketplace/providers/wallet_provider.dart';
import 'package:farms_gate_marketplace/routes/app_route.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/theme/app_theme.dart';
import 'package:farms_gate_marketplace/ui/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:uni_links5/uni_links.dart';
// import 'package:uni_links/uni_links.dart';
// import 'package:uni_links/uni_links.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => RegisterProvider()),
    ChangeNotifierProvider(create: (_) => LoginProvider()),
    ChangeNotifierProvider(
      create: (_) => ForgotPasswordProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => ProductProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => CartProvider()..loadCartFromDatabase(),
    ),
    ChangeNotifierProvider(
      create: (_) => SavedItemProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => AddressProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => WalletProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => OrdersProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => TransactionProvider(),
    ),
  ], child: const MyApp()));
  // initDeepLinkListener(context); // Initialize deep link listener
}

// void initDeepLinkListener(BuildContext context) {
//   uriLinkStream.listen((Uri? uri) {
//     if (uri != null && uri.host == "home") {
//       // Ensure you have set up a named route '/home' in your MaterialApp
//       Navigator.pushNamed(context, '/home');
//     }
//   });
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);

    // initDeepLinkListener(context);
    // uriLinkStream.listen((Uri? uri) {
    //   if (uri != null &&
    //       uri.scheme == 'com.example.farms_gate_marketplace' &&
    //       uri.host == '/bottom_nav_bar') {
    //     final status = uri.queryParameters['status'];
    //     if (status == 'success') {
    //       _controller.index = 2;

    //       // Handle successful redirection
    //       // showCustomToast(
    //       //     context, 'Returned to app successfully', '', ToastType.success);
    //     }
    //   }
    // });
    void handleUriRedirection(PersistentTabController _controller) {
      uriLinkStream.listen((Uri? uri) {
        if (uri != null &&
            uri.scheme == 'farmsgate' &&
            uri.host == 'bottom_nav_bar') {
          // Log the received URI for debugging
          print('Received deep link: $uri');

          final status = uri.queryParameters['status'];
          if (status == 'success') {
            // Navigate to a specific tab (e.g., tab index 2)
            _controller.index = 2;

            // Optional: Show a success toast if implemented
            print('Successfully redirected to tab 2');
            // Uncomment if you have a custom toast function
            // showCustomToast(context, 'Returned to app successfully', '', ToastType.success);
          } else {
            print('Deep link status is not success: $status');
          }
        } else {
          print('Invalid or unhandled URI: $uri');
        }
      });
    }
  }

  void initDeepLinkListener(BuildContext context) async {
    try {
      final initialLink =
          await getInitialLink(); // Get the initial deep link (if any)
      if (initialLink != null) {
        _handleDeepLink(initialLink, context);
      }

      // Listen for any new deep links
      linkStream.listen((String? link) {
        if (link != null) {
          _handleDeepLink(link, context);
        }
      });
    } catch (e) {
      print("Failed to handle deep link: $e");
    }
  }

  void _handleDeepLink(String link, BuildContext context) {
    Uri uri = Uri.parse(link);
    if (uri.scheme == "farms_gate_marketplace") {
      if (uri.host == "/cart_screen") {
        // Navigate to the order details screen
        Navigator.pushNamed(context, '/cart_screen');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.primary,
    ));

    return MaterialApp(
      routes: getAppRoutes(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
