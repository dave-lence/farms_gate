import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:farms_gate_marketplace/model/order_model.dart';
import 'package:farms_gate_marketplace/providers/cart_provider.dart';
import 'package:farms_gate_marketplace/providers/orders_provider.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/screens/cart_screen.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:farms_gate_marketplace/utils/custom_circler_loader.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OrderDetailsScreen extends StatefulWidget {
  final MyOrderModel? orderModel;
  const OrderDetailsScreen({super.key, this.orderModel});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  int currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<OrdersProvider>(context, listen: false)
                  .setWasPopped(true);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        elevation: 0,
        toolbarHeight: 118,
        title: Center(
          child: Text(
            'Order Detail',
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.orderModel!.orderNo,
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
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
                                  'QTY:${widget.orderModel!.quantity}nos',
                                  style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black)),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Date: ${widget.orderModel!.createdAt}',
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xff7D8398),
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height: 26,
                            width: 149,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade600,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.white),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: 6,
                                    width: 6,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(3)),
                                  ),
                                  Text(
                                    'Total Order Items : ${widget.orderModel!.quantity}',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xff525866),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Text(
                            'Total: ₦ ${NumberFormat('#,##0').format(widget.orderModel!.amount * widget.orderModel!.quantity)}.00',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.black)),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 0.7,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 10),
              SizedBox(
                  height: 195,
                  child: Column(
                    children: [
                      CarouselSlider(
                        carouselController: _controller,
                        options: CarouselOptions(
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          padEnds: widget.orderModel!.images.length > 1
                              ? false
                              : true,
                          height: 180,
                          enableInfiniteScroll: false,
                        ),
                        items: widget.orderModel!.images
                            .map((item) => Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  width: widget.orderModel!.images.length > 1
                                      ? MediaQuery.of(context).size.width * 0.78
                                      : MediaQuery.of(context).size.width,
                                  height: 130,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: CachedNetworkImage(
                                      width: widget.orderModel!.images.length >
                                              1
                                          ? 220
                                          : MediaQuery.of(context).size.width,
                                      imageUrl: item.toString(),
                                      key: UniqueKey(),
                                      fadeInCurve: Curves.easeIn,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          const SizedBox(
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
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 7),
                      AnimatedSmoothIndicator(
                        activeIndex: currentIndex,
                        count: widget.orderModel!.images.length,
                        effect: ScrollingDotsEffect(
                          activeDotColor: AppColors.primary,
                          dotColor: Colors.grey.shade400,
                          dotHeight: 4,
                          dotWidth: 4,
                        ),
                        onDotClicked: (index) {
                          _controller.animateToPage(index);
                        },
                      ),
                    ],
                  )),
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.orderModel!.productName,
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary),
                        ),
                        Text('Farm: ${widget.orderModel!.farmName}',
                            style: Theme.of(context)
                                .copyWith()
                                .textTheme
                                .labelSmall),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          height: 19,
                          // width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: const Color(0xFFFEF3EB)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Icon(Icons.access_time_filled,
                                  size: 7, color: Color(0xFFF17B2C)),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(widget.orderModel!.location,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 9,
                                    color: const Color(0xFFF17B2C),
                                  )),
                            ],
                          ),
                        ),
                        Text(
                            '₦ ${NumberFormat('#,##0').format(widget.orderModel?.amount)}/item',
                            style: Theme.of(context)
                                .copyWith()
                                .textTheme
                                .labelMedium),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey.shade200,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(widget.orderModel!.description,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary)),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),

              /////////// BUTTON ////////////
              SizedBox(
                height: MediaQuery.of(context).copyWith().size.width * 0.36,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 70),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 90,
                      child: CustomButton(
                          isWidget: true,
                          container: SizedBox(
                            height: 48,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.repeat_rounded,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Order Item Again',
                                    style: Theme.of(context)
                                        .copyWith()
                                        .textTheme
                                        .titleMedium,
                                  )
                                ],
                              ),
                            ),
                          ),
                          onPressed: () {
                            // cartProvider.addToCart(
                            //     widget.productModel, context);
                          })),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
