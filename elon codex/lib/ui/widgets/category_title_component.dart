import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class CategoryTitleComponent extends StatelessWidget {
  final String categoryName;
  final bool isLoading;
  const CategoryTitleComponent(
      {super.key, this.categoryName = '', this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return  Container(
        height: 66,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                  baseColor: Colors.grey[400]!,
                  highlightColor: Colors.grey[300]!,
                  child: Container(
                    height: 10,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
             Shimmer.fromColors(
                  baseColor: Colors.grey[400]!,
                  highlightColor: Colors.grey[300]!,
                  child: Container(
                    height: 10,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )),
            ],
          ),
        ),
      );
    }
    return SizedBox(
      height: 66,
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 66,
        decoration: const BoxDecoration(color: Color(0xFFFFFAF3)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoryName.toUpperCase(),
                  style:  GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Stay ahead with the latest offerings',
                  style: Theme.of(context).copyWith().textTheme.bodyMedium,
                )
              ],
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward))
          ],
        ),
      ),
    );
  }
}
