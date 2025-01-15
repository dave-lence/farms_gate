// ignore_for_file: sized_box_for_whitespace, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:farms_gate_marketplace/data_base/cart_db_helper.dart';
import 'package:farms_gate_marketplace/model/product_model.dart';
import 'package:farms_gate_marketplace/providers/cart_provider.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:farms_gate_marketplace/utils/custom_circler_loader.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SavedItemCard extends StatefulWidget {
  final bool isLoading;

  final void Function()? removeSavedItem;
  final String imgUrl;
  final String farmName;
  final String productName;
  final bool isInCart;

  final double productPrice;
  ProductModel? productModel;
  SavedItemCard(
      {super.key,
      this.isLoading = false,
      this.imgUrl = '',
      this.removeSavedItem,
      this.farmName = '',
      this.isInCart = false,
      this.productModel,
      this.productName = '',
      this.productPrice = 0});

  @override
  State<SavedItemCard> createState() => _SavedItemCardState();
}

class _SavedItemCardState extends State<SavedItemCard> {
  CartDatabaseHelper dbHelper = CartDatabaseHelper();

  @override
  void initState() {
    // if (widget.productModel != null) {
    //   // checkIfProductInCart();
    // }
    super.initState();
  }

  // void checkIfProductInCart() async {
  //   bool exists = await dbHelper
  //       .productExistsInCart(widget.productModel?.id.toString() ?? '');

  //   if (mounted) {
  //     setState(() {
  //       isInCart = exists;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final isInCart = cartProvider.isProductInCart(widget.productModel!);
    //  final itemQuatinty = cartProvider.productQuantities[widget.productModel!.id] ?? 0;

    if (widget.isLoading) {
      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 111.5,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          children: [
            // Top Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 16,
                    height: 16,
                    color: Colors.grey.shade300,
                  ),
                ),
                const SizedBox(width: 4),
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Placeholder
                        Container(
                          height: 80,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text placeholders
                            Container(
                              height: 14,
                              width: 120,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 5),
                            Container(
                              height: 12,
                              width: 100,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 5),
                            Container(
                              height: 15,
                              width: 90,
                              color: Colors.grey.shade300,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Bottom Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 30,
                        width: 104,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8, top: 8),
      height: 111.5,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: widget.removeSavedItem,
                child: Image.asset(
                  'assets/delete.png',
                  width: 16,
                  height: 16,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Container(
                height: 80,
                width: MediaQuery.of(context).size.width * 0.90,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      width: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          height: 120,
                          width: 140,
                          imageUrl: widget.imgUrl,
                          key: UniqueKey(),
                          fadeInCurve: Curves.easeIn,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => const SizedBox(
                              height: 30,
                              width: 30,
                              child: Center(
                                  child: CustomCircularLoader(
                                color: AppColors.primary,
                              ))),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.productName,
                            style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.textPrimary)),
                        const SizedBox(
                          height: 5,
                        ),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: 'Farm:',
                            style: GoogleFonts.plusJakartaSans(
                                letterSpacing: 0.6,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: const Color(0xff248D0E)),
                          ),
                          TextSpan(
                            text: widget.farmName,
                            style: GoogleFonts.plusJakartaSans(
                                letterSpacing: 0.6,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: const Color(0xff248D0E)),
                          )
                        ])),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                            '₦${NumberFormat('#,##0').format(widget.productPrice)}.00',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.black))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 112,
                height: 30,
                child: CustomButton(
                  onPressed: () {
                    if (isInCart) {
                      try {
                        cartProvider.removeAllSingleProd(
                            widget.productModel!, context);
                      } catch (e) {}
                    } else {
                      try {
                        cartProvider.addToCart(widget.productModel!, context);
                      } catch (e) {}
                    }
                  },
                  isWidget: true,
                  container: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: 9,
                      ),
                      const SizedBox(width: 2),
                      isInCart
                          ? Text('Clear cart',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white))
                          : Text('Add to cart',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white))
                    ],
                  ),
                ),
              )
            ],
          )

          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     SizedBox(
          //       width: 112,
          //       height: 30,
          //       child: CustomButton(
          //         onPressed: () {
          //           if (isInCart) {
          //             cartProvider.removeAllSingleProd(
          //                 widget.productModel!, context);
          //           } else {
          //             cartProvider.addToCart(widget.productModel!, context);
          //           }
          //         },
          //         isWidget: true,
          //         container: Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             const Icon(
          //               Icons.shopping_cart,
          //               color: Colors.white,
          //               size: 9,
          //             ),
          //             const SizedBox(width: 2),
          //             isInCart
          //                 ? Text('Clear cart',
          //                     style: GoogleFonts.plusJakartaSans(
          //                         fontSize: 10,
          //                         fontWeight: FontWeight.w500,
          //                         color: Colors.white))
          //                 : Text('Add to cart',
          //                     style: GoogleFonts.plusJakartaSans(
          //                         fontSize: 10,
          //                         fontWeight: FontWeight.w500,
          //                         color: Colors.white))
          //           ],
          //         ),
          //       ),
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}
