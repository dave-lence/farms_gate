import 'package:farms_gate_marketplace/model/negotiated_product_model.dart';
import 'package:farms_gate_marketplace/repositoreis/product_repo.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/screens/cart_screen.dart';
import 'package:farms_gate_marketplace/ui/widgets/negotiated_product_card.dart';
import 'package:farms_gate_marketplace/utils/custom_circler_loader.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class NegotiationScreen extends StatefulWidget {
  const NegotiationScreen({super.key});

  @override
  State<NegotiationScreen> createState() => _NegotiationScreenState();
}

class _NegotiationScreenState extends State<NegotiationScreen> {
  final scrollController = ScrollController();
  int urlPage = 1;
  bool isMoreDataLoading = false;
  late Future<NegotiationProductResponse> productFuture;
  final ProductRepo _productService = ProductRepo();

  @override
  void initState() {
    super.initState();
    productFuture = _productService.fetchNegotiatedProducts(urlPage, context);
    scrollController.addListener(scrollListener);
  }

  Future<void> scrollListener() async {
    if (isMoreDataLoading) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isMoreDataLoading = true;
      });

      await _productService.fetchNegotiatedProducts(urlPage + 1, context);

      setState(() {
        isMoreDataLoading = false;
      });
    }
  }

  Future<void> refreshProducts() async {
    setState(() {
      productFuture = _productService.fetchNegotiatedProducts(urlPage, context);
    });
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
        title: Center(
          child: Text(
            'My Negotiations',
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: FutureBuilder<NegotiationProductResponse>(
              future: productFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      heightFactor: 10,
                      child: CustomCircularLoader(
                        color: AppColors.primary,
                      ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.result.isEmpty) {
                  return const Center(
                    heightFactor: 10,
                    child: Text('No negotiations made.'),
                  );
                } else {
                  final products = snapshot.data!.result;
                  return RefreshIndicator(
                    backgroundColor: Colors.white,
                    strokeWidth: 1,
                    color: AppColors.primary,
                    triggerMode: RefreshIndicatorTriggerMode.anywhere,
                    onRefresh: refreshProducts,
                    child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.only(bottom: 90),
                      itemCount: isMoreDataLoading
                          ? products.length + 1
                          : products.length,
                      itemBuilder: (context, index) {
                        if (index < products.length) {
                          final product = products[index];
                          return Column(
                            children: [
                              NegotiatedProductCard(
                                productImag: product.productImages[0],
                                name: product.productName,
                                proposedPrice: NumberFormat('#,##0')
                                    .format(product.proposedPrice),
                                status: product.status,
                                currentPrice: NumberFormat('#,##0')
                                    .format(product.currentPrice),
                                farmName: product.farmName ?? '',
                              ),
                              Divider(
                                color: Colors.grey.shade200,
                                thickness: 1,
                              )
                            ],
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Center(
                              child: CustomCircularLoader(
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
