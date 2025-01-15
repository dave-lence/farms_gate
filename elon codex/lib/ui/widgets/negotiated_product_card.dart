import 'package:cached_network_image/cached_network_image.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/utils/custom_circler_loader.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NegotiatedProductCard extends StatefulWidget {
  final String name;
  final String farmName;
  final String status;
  final String proposedPrice;
  final String productImag;
  final String currentPrice;
  const NegotiatedProductCard({
    super.key,
    this.name = '',
    this.farmName = '',
    this.status = '',
    this.productImag = '',
    this.proposedPrice = '',
    this.currentPrice = '',
  });

  @override
  State<NegotiatedProductCard> createState() => _NegotiatedProductCardState();
}

class _NegotiatedProductCardState extends State<NegotiatedProductCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          SizedBox(
            height: 95,
            width: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  height: 120,
                  width: 140,
                  imageUrl: widget.productImag,
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
            ),
          ),
          ////// Right part card item //////////
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              // height: 80,
              width: MediaQuery.of(context).size.width * 0.65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.name,
                        style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: AppColors.textPrimary),
                      ),
                      Container(
                          height: 21,
                          width: 75,
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: widget.status == 'IN_VIEW'
                                  ? const Color(0xffFEF3EB)
                                  : const Color(0xffEFFAF6)),
                          child: Row(
                            children: [
                              Image.asset(
                                widget.status == 'IN_VIEW'
                                    ? 'assets/ongoing.png'
                                    : 'assets/completed.png',
                                width: 7.5,
                                height: 7.5,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                widget.status == 'IN_VIEW'
                                    ? 'Pending'
                                    : 'Accepted',
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: widget.status == 'IN_VIEW'
                                        ? const Color(0xffF17B2C)
                                        : const Color(0xff09BF7D)),
                              ),
                            ],
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 3,
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
                    height: 17,
                  ),

                  ////////////////////// status box //////
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Price',
                            style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                                color: const Color(0xff7D8398)),
                          ),
                          Text(
                            '₦${widget.currentPrice}/Item',
                            style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Proposed Price',
                            style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w400,
                                fontSize: 10,
                                color: const Color(0xff7D8398)),
                          ),
                          Text(
                            '₦${widget.proposedPrice}/Item',
                            style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.textPrimary),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
