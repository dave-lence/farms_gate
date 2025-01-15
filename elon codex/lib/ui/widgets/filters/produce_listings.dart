import 'package:farms_gate_marketplace/model/product_model.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/screens/product_details_screen.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:farms_gate_marketplace/ui/widgets/product_item_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ProduceListingsWidget extends StatefulWidget {
  const ProduceListingsWidget(
      {super.key,
      required this.screenHeight,
      required this.productFuture,
      required this.onTap,
      required this.filters});

  final double screenHeight;
  final List<String> filters;
  final void Function(String)? onTap;

  final Future<List<ProductModel>> productFuture;

  @override
  State<ProduceListingsWidget> createState() => _ProduceListingsWidgetState();
}

class _ProduceListingsWidgetState extends State<ProduceListingsWidget> {
  String? selectedFilter;

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
          height: 30,
        ),
        SizedBox(
          height: widget.screenHeight * 0.60,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: widget.screenHeight * 0.60,
                  child: FutureBuilder<List<ProductModel>>(
                    future: widget.productFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Display loading shimmer
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: crossAxisSpacing,
                            mainAxisSpacing: mainAxisSpacing,
                            childAspectRatio: childAspectRatio,
                          ),
                          scrollDirection: Axis.vertical,
                          itemCount: 10,
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
                          child: Text(
                            'Error fetching products: ${snapshot.error}',
                            style: Theme.of(context)
                                .copyWith()
                                .textTheme
                                .bodyMedium,
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No products found.'),
                        );
                      } else {
                        final cropProducts = snapshot.data!
                            .where((product) =>
                                product.category!.toLowerCase() == "produce")
                            .toList();

                        if (cropProducts.isEmpty) {
                          return const Center(
                            child: Text('No products found under produce.'),
                          );
                        }

                        return Center(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: GridView.builder(
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: crossAxisSpacing,
                                mainAxisSpacing: mainAxisSpacing,
                                childAspectRatio: childAspectRatio,
                              ),
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                              scrollDirection: Axis.vertical,
                              itemCount: cropProducts.length,
                              itemBuilder: (context, productIndex) {
                                final product = cropProducts[productIndex];
                                return ProductItemCard(
                                  width: 156,
                                  location: product.location!,
                                  productPrice: product.marketPrice.toString(),
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
                          ),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
