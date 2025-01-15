// ignore_for_file: must_be_immutable

import 'package:farms_gate_marketplace/model/product_model.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/screens/product_details_screen.dart';
import 'package:farms_gate_marketplace/ui/widgets/category_title_component.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:farms_gate_marketplace/ui/widgets/product_item_card.dart';
import 'package:farms_gate_marketplace/utils/custom_circler_loader.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class AllListingsWidget extends StatefulWidget {
  AllListingsWidget(
      {super.key,
      required this.screenHeight,
      required this.filters,
      required this.productFuture,
      required this.searchQuery,
      required this.allProducts,
      required this.filteredProducts,
      required this.groupedProducts,
      required this.scrollController,
      required this.isMoreProdLoading,
      required this.groupProductsByCategory,
      required this.onTap});

  final double screenHeight;
  final List<String> filters;
  String searchQuery;

  ScrollController scrollController;
  bool isMoreProdLoading;

  List<ProductModel> allProducts;
  List<ProductModel> filteredProducts;
  Map<String, List<ProductModel>> groupedProducts;
  final Map<String, List<ProductModel>> Function(List<ProductModel>)
      groupProductsByCategory;
  final void Function(String)? onTap;
  final Future<List<ProductModel>> productFuture;

  @override
  State<AllListingsWidget> createState() => _AllListingsWidgetState();
}

class _AllListingsWidgetState extends State<AllListingsWidget> {
  String? selectedFilter;
  // List<ProductModel> allProducts = [];
  // List<ProductModel> filteredProducts = [];
  // var groupedProducts = <String, List<ProductModel>>{};

  // Map<String, List<ProductModel>> groupProductsByCategory(
  //     List<ProductModel> products) {
  //   final Map<String, List<ProductModel>> groupedProducts = {};
  //   for (var product in products) {
  //     groupedProducts.putIfAbsent(product.category, () => []).add(product);
  //   }
  //   return groupedProducts;
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final crossAxisCount = screenWidth > 600 ? 3 : 2;
    final crossAxisSpacing = screenWidth * 0.02;
    final mainAxisSpacing = screenHeight * 0.02;
    final childAspectRatio =
        (screenWidth / crossAxisCount) / (screenHeight * 0.4);

    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 78,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.filters.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.3,
            ),
            itemBuilder: (context, index) {
              final filterby = widget.filters[index];

              return filterby == 'Reset'
                  ? SizedBox(
                      width: 49,
                      height: 26,
                      child: CustomButton(
                        outlined: true,
                        text: 'Reset',
                        onPressed: () {
                          setState(() {
                            selectedFilter = '';
                          });
                        },
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        if (widget.onTap != null) {
                          widget.onTap!(filterby);
                        }
                        setState(() {
                          selectedFilter = filterby;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        height: 28,
                        decoration: BoxDecoration(
                            color: selectedFilter == widget.filters[index]
                                ? AppColors.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: selectedFilter == widget.filters[index]
                                  ? Colors.transparent
                                  : Colors.grey.shade400,
                              width: 1,
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              filterby,
                              style: GoogleFonts.plusJakartaSans(
                                  color: selectedFilter == widget.filters[index]
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: selectedFilter == widget.filters[index]
                                  ? Colors.white
                                  : Colors.black,
                            )
                          ],
                        ),
                      ),
                    );
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: widget.screenHeight * 0.63,
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<List<ProductModel>>(
                  future: widget.productFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: 10,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: crossAxisSpacing,
                          mainAxisSpacing: mainAxisSpacing,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: const ProductItemCard(isLoading: true),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      // Display error message
                      return Center(
                        heightFactor: 25,
                        child: Text(
                          'Error fetching products: ${snapshot.error}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        heightFactor: 25,
                        child: Text('No products found.'),
                      );
                    } else {
                      widget.allProducts = snapshot.data!;
                      widget.groupedProducts = widget.groupProductsByCategory(
                        widget.searchQuery.isEmpty
                            ? widget.allProducts
                            : widget.filteredProducts,
                      );

                      //    if (widget.allProducts.isEmpty) {
                      //   widget.allProducts = snapshot.data!;
                      //   widget.filteredProducts =
                      //       widget.allProducts;
                      //   widget.groupedProducts = widget.groupProductsByCategory(widget.allProducts);
                      // }

                      // Determine which products to display
                      // final productsToDisplay =
                      //     widget.searchQuery.isEmpty ? widget.allProducts : widget.filteredProducts;

                      // if (productsToDisplay.isEmpty) {
                      //   return const Center(
                      //     heightFactor: 4,
                      //     child: Text('No products match your search.'),
                      //   );
                      // }

                      // widget.groupedProducts =
                      //     widget.groupProductsByCategory(productsToDisplay);

                      // final groupedProducts = <String, List<ProductModel>>{};
                      // for (var product in snapshot.data!) {
                      //   groupedProducts
                      //       .putIfAbsent(product.category, () => [])
                      //       .add(product);
                      // }

                      // Display data grouped by category
                      return ListView.builder(
                        controller: widget.scrollController,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.isMoreProdLoading
                            ? widget.groupedProducts.keys.length + 1
                            : widget.groupedProducts.keys.length,
                        itemBuilder: (context, categoryIndex) {
                          final category = widget.groupedProducts.keys
                              .elementAt(categoryIndex);
                          if (categoryIndex <
                              widget.groupedProducts.keys.length) {
                            final products = widget.groupedProducts[category]!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 25),
                                CategoryTitleComponent(categoryName: category),
                                const SizedBox(height: 10),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: crossAxisSpacing,
                                    mainAxisSpacing: mainAxisSpacing,
                                    childAspectRatio: childAspectRatio,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 10),
                                  itemCount: products.length,
                                  itemBuilder: (context, productIndex) {
                                    final product = products[productIndex];
                                    return ProductItemCard(
                                      width: 146,
                                      location: product.location!,
                                      productPrice:
                                          product.marketPrice.toString(),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailsScreen(
                                              productModel: product,
                                            ),
                                          ),
                                        );
                                      },
                                      productImag: product.images.first,
                                      productName: product.name.length > 10
                                          ? '${product.name.substring(0, 10)}...'
                                          : product.name,
                                    );
                                  },
                                ),
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
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
