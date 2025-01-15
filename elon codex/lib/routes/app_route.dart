import 'package:farms_gate_marketplace/ui/screens/add_adress_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/address_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/cart_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/forgot_password_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/my_account_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/order_details_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/reset_password_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/saved_items_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/sign_in_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/sign_up_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/update_user_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/verification_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/wallet_screen.dart';
import 'package:farms_gate_marketplace/ui/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getAppRoutes() {
  return {
    '/signin_screen': (context) => const SignInScreen(),
    '/signup_screen': (context) => const SignUpScreen(),
    '/forgot_password_screen': (context) => const ForgotPasswordScreen(), 
    '/verification_screen': (context) => const VerificationScreen(),
    '/reset_password_screen': (context) => const ResetPassword(),
    '/bottom_nav_bar': (context) => const BottomNavBar(),
    '/cart_screen': (context) => const CartScreen(),
    '/saveditem_screen': (context) => const SavedItemsScreen(),
    '/address_screen': (context) => const MyAddressScreen(),
    '/add_address_screen': (context) => const AddAdressScreen(),
    '/order_details_screen': (context) => const OrderDetailsScreen(),
     '/my_account_screen': (context) => const MyAccountScreen(),
     '/update_user_details': (context) => const UpdateUserDetailsScreen(),
     '/wallet_screen': (context) => const WalletScreen(),
  };
}
