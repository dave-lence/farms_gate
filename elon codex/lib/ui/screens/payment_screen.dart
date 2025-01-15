import 'dart:convert';

import 'package:farms_gate_marketplace/providers/cart_provider.dart';
import 'package:farms_gate_marketplace/repositoreis/wallet_repo.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/utils/custom_circler_loader.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String userEmail = '';
  final WalletRepo walletRepo = WalletRepo();
  bool transactionLoading = false;

  Future<void> getEmailFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userDataString = prefs.getString('userData');

    if (userDataString != null) {
      final Map<String, dynamic> userData = jsonDecode(userDataString);
      setState(() {
        userEmail = userData['email'];
      });
    }
  }

  @override
  void initState() {
    getEmailFromPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: true,
        elevation: 0,
        toolbarHeight: 118,
        title: Center(
          child: Text('Confirm Order',
              style: TextStyle(
                  fontStyle: GoogleFonts.plusJakartaSans().fontStyle,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
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
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.025,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(children: [
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        minTileHeight: 44,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0),
                        title: Text('Pay with Wallet',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                        trailing: const Icon(Icons.arrow_forward,
                            size: 16, color: Colors.black),
                        onTap: () {},
                      ),
                      const Divider(),
                      ListTile(
                        minTileHeight: 44,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 0),
                        title: Text(
                          'Pay with Bank',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        trailing: const Icon(Icons.arrow_forward,
                            size: 16, color: Colors.black),
                        onTap: transactionLoading
                            ? null
                            : () async {
                                setState(() {
                                  transactionLoading = true;
                                });
                                try {
                                  await walletRepo
                                      .initiateFlutterwavePayment(context);
                                  cartProvider.clearCartItems();
                                } catch (e) {
                                  print(e);
                                } finally {
                                  setState(() {
                                    transactionLoading = false;
                                  });
                                }
                              },
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              ])),
          if (transactionLoading)
            const Center(child: CustomCircularLoader(color: AppColors.primary))
        ],
      ),
    );
  }
}
