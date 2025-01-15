import 'package:farms_gate_marketplace/providers/cart_provider.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

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
            'Vouchers',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
                heightFactor: 2,
                child: Column(
          children: [
            Image.asset(
              'assets/voucher.png',
              width: 154,
              height: 154,
            ),
            const SizedBox(height: 10),
            Text(
              'Ooops!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 6),
            Text(
              'You currently have no Voucher yet.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 35),
           
          ],
                ),
              ),
        ),
      ),
    );
  }
}