// ignore_for_file: sized_box_for_whitespace

import 'package:cached_network_image/cached_network_image.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/utils/custom_circler_loader.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class CartItemCard extends StatelessWidget {
  final bool isLoading;
  final String imgUrl;
  final String productName;
  final String farmName;
  final String productPrice;
  final String productItemLength;
  final Function()? removeCartItem;
  final Function()? addCartItem;
  final Function()? removeAllCart;
  const CartItemCard(
      {super.key,
      this.isLoading = false,
      this.addCartItem,
      this.removeCartItem,
      this.removeAllCart,
      this.imgUrl = '',
      this.productItemLength = '',
      this.productName = '',
      this.farmName = 'N/A',
      this.productPrice = ''});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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
                    // Minus Button Placeholder
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    // Quantity Placeholder
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 24,
                        width: 24,
                        color: Colors.grey.shade300,
                      ),
                    ),
                    const SizedBox(width: 5),
                    // Add Button Placeholder
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 24,
                        width: 24,
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
      margin: const EdgeInsets.only(bottom: 20),
      height: 111.5,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap:removeAllCart,
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
                        child:CachedNetworkImage(
                          height: 120,
                          width: 140,
                          imageUrl: imgUrl,
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
                        Text(productName,
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
                            text: farmName,
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
                        Text('₦ $productPrice/item',
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
              Row(
                children: [
                  GestureDetector(
                    onTap: removeCartItem,
                    child: SizedBox(
                        height: 24,
                        width: 24,
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4)),
                          child: const Center(
                            child: Icon(
                              Icons.remove,
                              size: 10,
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                      height: 24,
                      width: 24,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4)),
                        child: Center(
                            child: Text(
                          productItemLength,
                          style: const TextStyle(color: Colors.black),
                        )),
                      )),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: addCartItem,
                    child: SizedBox(
                        height: 24,
                        width: 24,
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4)),
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              size: 10,
                              color: Colors.white,
                            ),
                          ),
                        )),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
