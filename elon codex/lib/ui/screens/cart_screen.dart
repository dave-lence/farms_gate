import 'package:farms_gate_marketplace/providers/cart_provider.dart';
import 'package:farms_gate_marketplace/repositoreis/product_repo.dart';
import 'package:farms_gate_marketplace/ui/widgets/cart_item_card.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:farms_gate_marketplace/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = true;
  bool btnLoading = false;
  final ProductRepo productRepo = ProductRepo();

  void loadingState() async {
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // _loadCartFuture = context.read<CartProvider>().loadCartFromDatabase();
    loadingState();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    Future<void> postCartItems() async {
      setState(() {
        btnLoading = true;
      });
      final cartBody = cartProvider.cartList.map((product) {
        return {
          "productId": product.productId,
          "quantity": cartProvider.productQuantities[product.productId] ?? 1
        };
      }).toList();

      try {
        await productRepo.postCartItems(context, cartBody);
      } catch (e) {
        showCustomToast(context, 'Failed to checkout.', '', ToastType.error);
      } finally {
        setState(() {
          btnLoading = false;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: true,
        elevation: 0,
        toolbarHeight: 118,
        title: Center(
          child: Text('My Cart',
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
                  height: 84,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cart Summary',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff333232))),
                          Text('(${value.cartLength} Items)',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff248D0E)))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 26,
                              width: 81,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade600,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.white),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: 6,
                                      width: 6,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(3)),
                                    ),
                                    const Text(
                                      'Subtotal',
                                    ),
                                  ],
                                ),
                              )),
                          Text(
                              '₦${NumberFormat('#,##0').format(value.cartTotal)}',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black)),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey.shade400,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Expanded(
                  child: value.cartLength == 0
                      ? const Center(child: Text('Your cart is empty'))
                      : SizedBox(
                          child: ListView.builder(
                            itemCount: value.cartLength,
                            itemBuilder: (context, index) {
                              final product = value.cartList[index];
                              final quantity =
                                  value.productQuantities[product.productId] ??
                                      0;
                              return CartItemCard(
                                farmName: product.farmName,
                                removeAllCart: () =>
                                    value.removeAllSingleProd(product, context),
                                addCartItem: () =>
                                    value.addToCart(product, context),
                                removeCartItem: () =>
                                    value.removeFromCart(product, context),
                                imgUrl: product.images.isNotEmpty
                                    ? product.images.first
                                    : 'assets/info.png',
                                productItemLength: quantity.toString(),
                                productName: product.name,
                                productPrice: NumberFormat('#,##0')
                                    .format(product.marketPrice),
                              );
                            },
                          ),
                        ),
                ),
                Container(
                    margin: const EdgeInsets.only(bottom: 20, top: 8),
                    width: MediaQuery.of(context).copyWith().size.width,
                    child: CustomButton(
                      buttonLoading: btnLoading,
                      isDisabled:
                          value.cartLength == 0 || btnLoading ? true : false,
                      onPressed: postCartItems,
                      text:
                          'Checkout  (₦${NumberFormat('#,##0').format(value.cartTotal)})',
                    ))
              ],
            ),
          ),
        );
      }),
    );
  }
}
