import 'package:cached_network_image/cached_network_image.dart';
import 'package:farms_gate_marketplace/apis/urls.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/utils/custom_circler_loader.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ProductItemCard extends StatelessWidget {
  final String productName;
  final String productImag;
  final String productPrice;
  final String location;
  final bool isLoading;
  final double width;
  final Function()? onTap;
  const ProductItemCard(
      {super.key,
      this.location = '',
      this.isLoading = false,
      this.productName = '',
      this.productImag = '',
      this.productPrice = '',
      this.width = 140,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    Urls url = Urls();
    if (isLoading) {
      return Container(
        height: 190,
        width: 140,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 190,
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                height: 120,
                width: 140,
                imageUrl: productImag?.toString() ?? url.imgErrorUrl,
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
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            SizedBox(
              width: 140,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    productName.length > 15
                        ? '${productName.substring(0, 15)}...'
                        : productName,
                    style: Theme.of(context).copyWith().textTheme.bodySmall,
                  ),
                  const Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                    size: 14,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              '₦${NumberFormat('#,##0').format(double.parse(productPrice))}/item',
              style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(
              height: 3,
            ),
            Row(
              children: [
                Container(
                  height: 19,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: const Color(0xFFFEF3EB)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(Icons.access_time_filled,
                          size: 7, color: Color(0xFFF17B2C)),
                      Text(location,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w400,
                            fontSize: 9,
                            color: const Color(0xFFF17B2C),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
