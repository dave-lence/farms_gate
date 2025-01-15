import 'package:cached_network_image/cached_network_image.dart';
import 'package:farms_gate_marketplace/apis/urls.dart';
import 'package:farms_gate_marketplace/model/order_model.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/screens/order_details_screen.dart';
import 'package:farms_gate_marketplace/utils/custom_circler_loader.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shimmer/shimmer.dart';

class MyOrderCard extends StatelessWidget {
  final String name;
  final String orderId;
  final String status;
  final String qty;
  final String date;
  final String productImag;
  final bool loading;
  final MyOrderModel? orderModel;
  const MyOrderCard(
      {super.key,
      this.productImag = '',
      this.name = '',
      this.orderId = '',
      this.status = '',
      this.qty = '',
      this.orderModel,
      this.date = '',
      this.loading = false});

  @override
  Widget build(BuildContext context) {
        Urls url = Urls();

    if (loading) {
      return Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 25),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            // Shimmer for Image
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 80,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Shimmer for Right Section
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: SizedBox(
                height: 80,
                width: MediaQuery.of(context).size.width * 0.65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shimmer for Name and Quantity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 14,
                          width: 100,
                          color: Colors.grey.shade300,
                        ),
                        Container(
                          height: 14,
                          width: 60,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Shimmer for Order ID
                    Container(
                      height: 12,
                      width: 150,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 15),
                    // Shimmer for Status and Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 20,
                          width: 75,
                          color: Colors.grey.shade300,
                        ),
                        Container(
                          height: 12,
                          width: 50,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return status == "cancelled"
        ? GestureDetector(
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen:  OrderDetailsScreen(orderModel: orderModel!,)); 
              // Navigator.pushNamed(
              //     context, '/order_details_screen');
            },
            child: Container(
              height: 80,
              margin: EdgeInsets.only(bottom: 25),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Container(
                    height: 80,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child:  CachedNetworkImage(
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
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  ////// Right part card item //////////
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      height: 80,
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                name,
                                style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: AppColors.textPrimary),
                              ),
                              Container(
                                  height: 21,
                                  width: 61,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 6),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.grey.shade200),
                                  child: Text(
                                    'QTY:${qty}nos',
                                    style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            'Order ID $orderId',
                            style: GoogleFonts.plusJakartaSans(
                                letterSpacing: 0.6,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.grey.shade400),
                          ),

                          ////////////////////// status box //////
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 19.3,
                                width: 73.6,
                                margin: const EdgeInsets.only(top: 15),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 6),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.grey.shade200),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/cancelled.png',
                                      width: 7.5,
                                      height: 7.5,
                                    ),
                                    const SizedBox(
                                      width: 2.5,
                                    ),
                                    Text(
                                      'Cancelled',
                                      style: GoogleFonts.plusJakartaSans(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Text(
                                  date,
                                  style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      height: 1.5,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade400),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )

        : GestureDetector(
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: OrderDetailsScreen(
                    orderModel: orderModel!,
                  ));
              
              // Navigator.pushNamed(
              //     context, '/order_details_screen');
            },
            child: Container(
              height: 80,
              margin: EdgeInsets.only(bottom: 25),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Container(
                    height: 80,
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child:  CachedNetworkImage(
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
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  ////// Right part card item //////////
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      height: 80,
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                name,
                                style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: AppColors.textPrimary),
                              ),
                              Container(
                                height: 21,
                                width: 61,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 6),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.grey.shade200),
                                child: Text('QTY:${qty}nos',
                                    style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black)),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text('Order ID $orderId',
                              style: GoogleFonts.plusJakartaSans(
                                  letterSpacing: 0.6,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.grey.shade400)),

                          ////////////////////// status box //////
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 19.3,
                                width: 79.6,
                                margin: const EdgeInsets.only(top: 15),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 6),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.grey.shade200),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      status == 'completed'
                                          ? 'assets/completed.png'
                                          : 'assets/ongoing.png',
                                      width: 7.5,
                                      height: 7.5,
                                    ),
                                    const SizedBox(
                                      width: 2.5,
                                    ),
                                    Text(
                                        status == 'completed'
                                            ? 'Ongoing'
                                            : 'Ongoing',
                                        style: status == 'completed'
                                            ? GoogleFonts.plusJakartaSans(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                                color: const Color(0xff09BF7D))
                                            : GoogleFonts.plusJakartaSans(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                                color:
                                                    const Color(0xffF17B2C))),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Text(date,
                                    style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        height: 1.5,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade400)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
