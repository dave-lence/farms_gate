import 'package:farms_gate_marketplace/providers/address_provider.dart';
import 'package:farms_gate_marketplace/providers/cart_provider.dart';
import 'package:farms_gate_marketplace/repositoreis/wallet_repo.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/widgets/address_card.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConfrimOrderScreen extends StatefulWidget {
  final int serviceCharge;
  final int subTotal;
  final int total;
  const ConfrimOrderScreen({super.key,  this.serviceCharge = 0, this.subTotal = 0, this.total = 0});

  @override
  State<ConfrimOrderScreen> createState() => _ConfrimOrderScreenState();
}

class _ConfrimOrderScreenState extends State<ConfrimOrderScreen> {
  final voucherController = TextEditingController();
  final int voucherPrice = 1500;
  bool applied = false;
  bool btnLoading = false;
  final WalletRepo walletRepo = WalletRepo();

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              ),
              color: Colors.white,
              position: PopupMenuPosition.under,
              popUpAnimationStyle:
                  AnimationStyle(curve: Easing.emphasizedAccelerate),
              onSelected: (value) {
                if (value == 'cart') {
                  cartProvider.clearCartItems();
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  height: 30,
                  value: 'cart',
                  child: Text('Clear Cart',
                      style: TextStyle(
                          fontStyle: GoogleFonts.plusJakartaSans().fontStyle,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                ),
              ],
            )
          ],
        ),
        body: Consumer<CartProvider>(builder: (context, value, child) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Order Summary',
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                            Text('(${value.cartLength} Items)',
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff248D0E)))
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.grey.shade400,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Item’s Total (${value.cartLength})',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff7D8398)),
                            ),
                            Text(
                                '₦${NumberFormat('#,##0').format(value.cartTotal)}',
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                          ],
                        ),
                       
                        
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Service charge',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff7D8398)),
                            ),
                            Text(
                                '₦${NumberFormat('#,##0').format(widget.serviceCharge)}',
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Voucher',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff7D8398)),
                            ),
                            applied
                                ? Text(
                                    '₦${NumberFormat('#,##0').format(voucherPrice)}',
                                    style: GoogleFonts.plusJakartaSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary))
                                : Text('₦${NumberFormat('#,##0').format(0)}.00',
                                    style: GoogleFonts.plusJakartaSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black)),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            Text(
                                applied
                                    ? '₦${NumberFormat('#,##0').format(value.cartTotal - voucherPrice)}'
                                    : '₦${NumberFormat('#,##0').format(value.cartTotal +  widget.serviceCharge)}',
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                      height: 53,
                                      child: TextFormField(
                                        controller: voucherController,
                                        onChanged: (value) {
                                          setState(() {
                                            voucherController.text = value;
                                          });
                                        },
                                        cursorColor: AppColors.primary,
                                        decoration: InputDecoration(
                                          hintText: 'Enter voucher code here',
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Image.asset(
                                              'assets/text_voucher.png',
                                              width: 16,
                                              height: 16,
                                            ),
                                          ),
                                          alignLabelWithHint: true,
                                          contentPadding:
                                              const EdgeInsets.only(left: 10),
                                          filled: true,
                                          fillColor: AppColors.surface,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            borderSide: const BorderSide(
                                                color: Color(0xffF0F1F3),
                                                width: 2),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            borderSide: const BorderSide(
                                                color: Color(0xffF0F1F3),
                                                width: 2),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            borderSide: const BorderSide(
                                                color: AppColors.primary,
                                                width: 1),
                                          ),
                                          hintStyle: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 14,
                                              fontStyle:
                                                  GoogleFonts.plusJakartaSans()
                                                      .fontStyle),
                                        ),
                                      )),
                                ),
                                TextButton(
                                    onPressed: voucherController.text.isEmpty
                                        ? null
                                        : () {
                                            setState(() {
                                              applied = !applied;
                                            });
                                          },
                                    child: Text(
                                      !applied ? 'Apply code' : 'Remove',
                                      style: GoogleFonts.spaceGrotesk(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: voucherController.text.isEmpty
                                              ? const Color(0xff98A2B3)
                                              : applied
                                                  ? Colors.red
                                                  : const Color(0xff248D0E)),
                                    ))
                              ],
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Delivery Address',
                                    style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff7D8398))),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/add_address_screen');
                                    },
                                    child: Text(
                                      'Change Delivery Address',
                                      style: GoogleFonts.plusJakartaSans(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff248D0E)),
                                    ))
                              ],
                            ),
                            Divider(
                              thickness: 0.6,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 200,
                              child: Consumer<AddressProvider>(
                                builder: (context, addressProvider, child) {
                                  addressProvider.fetchDefaultAddress();

                                  if (addressProvider.addressLength > 0 &&
                                      addressProvider
                                          .addressList[0].address.isNotEmpty) {
                                    return AddressCard(
                                      checkOut: true,
                                      id: addressProvider.addressList[0].id ??
                                          0,
                                      name:
                                          "${addressProvider.addressList[0].firstname} ${addressProvider.addressList[0].lastname}",
                                      phone: addressProvider
                                          .addressList[0].phonenumber,
                                      address: addressProvider
                                          .addressList[0].address,
                                      city: addressProvider.addressList[0].city,
                                      state:
                                          addressProvider.addressList[0].state,
                                      defaultSate: addressProvider
                                          .addressList[0].isDefault,
                                    );
                                  } else {
                                    return const Center(
                                      child: Text("No default address set"),
                                    );
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: CustomButton(
                      isDisabled: btnLoading ? true : false,
                      buttonLoading: btnLoading,
                      onPressed: () async {
                        setState(() {
                          btnLoading = true;
                        });
                        try {
                         
                          final address = Provider.of<AddressProvider>(context,
                                  listen: false)
                              .addressList[0];

                          await walletRepo.postUsersAddress(context, address);
                        } catch (e) {
                          print(e);
                        } finally {
                          setState(() {
                            btnLoading = false;
                          });
                        }
                      },
                      text: 'Confirm Order',
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
