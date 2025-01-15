// ignore_for_file: unnecessary_null_comparison

import 'package:farms_gate_marketplace/data_base/cart_db_helper.dart';
import 'package:farms_gate_marketplace/model/product_model.dart';
import 'package:farms_gate_marketplace/providers/cart_provider.dart';
import 'package:farms_gate_marketplace/providers/saved_item_provider.dart';
import 'package:farms_gate_marketplace/repositoreis/product_repo.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/screens/cart_screen.dart';
import 'package:farms_gate_marketplace/ui/widgets/saved_item_card.dart';
import 'package:farms_gate_marketplace/utils/custom_circler_loader.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class SavedItemsScreen extends StatefulWidget {
  const SavedItemsScreen({super.key});

  @override
  State<SavedItemsScreen> createState() => _SavedItemsScreenState();
}

class _SavedItemsScreenState extends State<SavedItemsScreen> {
  bool isLoading = false;
  int urlPage = 1;
  final scrollController = ScrollController();
  bool isMoreDataLoading = false;
  late Future<List<ProductModel>> productFuture;
  bool isDeleting = false;
  final ProductRepo _productService = ProductRepo();
  CartDatabaseHelper dbHelper = CartDatabaseHelper();
  bool isInCart = false;

  @override
  void initState() {
    final savedItemProvider =
        Provider.of<SavedItemProvider>(context, listen: false);
    savedItemProvider.fetchSavedProducts(context, urlPage);
    scrollController.addListener(scrollListener);

    super.initState();
  }

  Future<void> scrollListener() async {
    Provider.of<SavedItemProvider>(context, listen: false);
    if (isMoreDataLoading) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isMoreDataLoading = true;
      });

      await _productService.fetchSavedProducts(context, urlPage + 1);

      setState(() {
        isMoreDataLoading = false;
      });
    }
  }

  Future<void> refreshProducts() async {
    final savedItemProvider =
        Provider.of<SavedItemProvider>(context, listen: false);
    await savedItemProvider.fetchSavedProducts(context, urlPage);
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
              'Saved Items',
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
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
                child: Column(
              children: [
                const SizedBox(
                  height: 2,
                ),
                isDeleting
                    ? const LinearProgressIndicator(
                        color: AppColors.primary,
                        minHeight: 2,
                      )
                    : const SizedBox(
                        height: 3,
                      ),
                const SizedBox(
                  height: 3,
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: Consumer<SavedItemProvider>(
                        builder: (context, savedItemProvider, child) {
                      if (savedItemProvider.isLoading) {
                        return const Center(
                            heightFactor: 10,
                            child: CustomCircularLoader(
                              color: AppColors.primary,
                            ));
                      }
                      if (savedItemProvider.savedItems.isEmpty) {
                        return const Center(
                          child: Text('No saved items found.'),
                        );
                      }

                      return RefreshIndicator(
                        backgroundColor: Colors.white,
                        strokeWidth: 1,
                        color: AppColors.primary,
                        onRefresh: refreshProducts,
                        child: ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.only(bottom: 90),
                          itemCount: isMoreDataLoading
                              ? savedItemProvider.savedItems.length + 1
                              : savedItemProvider.savedItems.length,
                          itemBuilder: (context, index) {
                            if (index < savedItemProvider.savedItems.length) {
                              final product =
                                  savedItemProvider.savedItems[index];
                              return Column(
                                children: [
                                  SavedItemCard(
                                    farmName: product.farmName,
                                    productModel: product,
                                    productName: product.name,
                                    imgUrl: product.images[0],
                                    productPrice: product.marketPrice,
                                    removeSavedItem: () async {
                                      setState(() {
                                        isDeleting = true;
                                      });

                                      if (product != null) {
                                        try {
                                          await _productService
                                              .deleteFavouriteItems(
                                            product.productId!,
                                            context,
                                            product,
                                          );
                                        } catch (error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Failed to delete item: $error')),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Item data is incomplete.')),
                                        );
                                      }

                                      setState(() {
                                        isDeleting = false;
                                      });
                                    },
                                  ),
                                  Divider(
                                    color: Colors.grey.shade200,
                                    thickness: 1,
                                  )
                                ],
                              );
                            } else {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
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
                    })),
              ],
            ))));
  }
}
