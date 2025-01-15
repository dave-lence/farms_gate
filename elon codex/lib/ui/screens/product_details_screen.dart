// ignore_for_file: prefer_const_constructors, collection_methods_unrelated_type

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:farms_gate_marketplace/apis/urls.dart';
import 'package:farms_gate_marketplace/data_base/cart_db_helper.dart';
import 'package:farms_gate_marketplace/data_base/saved_item_db.dart';
import 'package:farms_gate_marketplace/model/product_model.dart';
import 'package:farms_gate_marketplace/providers/cart_provider.dart';
import 'package:farms_gate_marketplace/providers/saved_item_provider.dart';
import 'package:farms_gate_marketplace/repositoreis/product_repo.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/screens/cart_screen.dart';

import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:farms_gate_marketplace/ui/widgets/negotiation_bottom_sheet.dart';
import 'package:farms_gate_marketplace/utils/custom_circler_loader.dart';
import 'package:farms_gate_marketplace/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel productModel;
  const ProductDetailsScreen({super.key, required this.productModel});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool toggleBookMark = false;
  double value = 4.5;
  bool showProductFeedBack = false;
  int currentIndex = 0;
  bool isInCart = false;
  bool isSaved = false;
  bool saveLoadingState = false;

  final searchController = TextEditingController();
  final CarouselSliderController _controller = CarouselSliderController();
  CartDatabaseHelper dbHelper = CartDatabaseHelper();
  SavedItemDatabaseHelper saveddbHelper = SavedItemDatabaseHelper();
  final productRepo = ProductRepo();
  final url = Urls();

  final List<String> imgList = [
    'assets/cow_2.png',
    'assets/cow_2.png',
    'assets/cow_2.png'
  ];

  @override
  void initState() {
    // checkIfProductInCart();
    checkIfProductIsSaved();
    super.initState();
  }

  // void checkIfProductInCart() async {
  //   if (await dbHelper.productExistsInCart(widget.productModel.id.toString())) {
  //     setState(() {
  //       isInCart = true;
  //     });
  //   } else {
  //     setState(() {
  //       isInCart = false;
  //     });
  //   }
  // }

  void checkIfProductIsSaved() {
    final savedItemProvider =
        Provider.of<SavedItemProvider>(context, listen: false);

    setState(() {
      isSaved = savedItemProvider.isSaved(widget.productModel);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // checkIfProductInCart();
    checkIfProductIsSaved();
    final cartProvider = Provider.of<CartProvider>(context);
    final savedItemProvider = Provider.of<SavedItemProvider>(context);
    final quantity =
        cartProvider.productQuantities[widget.productModel.productId] ?? 0;

    Future<void> toggleSavedItem() async {
      setState(() {
        saveLoadingState = true;
      });
      try {
        if (isSaved) {
          await productRepo.deleteFavouriteItems( 
            widget.productModel.id,
            context,
            widget.productModel,
          );
        } else {
          await productRepo.postFavouriteItems(
            widget.productModel.productId!,
            context,
            widget.productModel,
          );
        }
      } catch (e) {
        showCustomToast(context, 'Failed to update saved item status.', '',
            ToastType.error);
      }
      setState(() {
        saveLoadingState = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: true,
        elevation: 0,
        toolbarHeight: 118,
        title: Center(
          child: Text('Details',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
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
        ),
        actions: [
          Image.asset('assets/bar_search.png', width: 18, height: 18),
          const SizedBox(
            width: 10,
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
                        style: TextStyle(
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
              const SizedBox(
                height: 2,
              ),
              saveLoadingState
                  ? const LinearProgressIndicator(
                      color: AppColors.primary,
                      minHeight: 2,
                    )
                  : const SizedBox(
                      height: 3,
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
                          padEnds: widget.productModel.images.length > 1
                              ? false
                              : true,
                          height: 180,
                          enableInfiniteScroll: false,
                        ),
                        items: widget.productModel.images
                            .map((item) => Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  width: widget.productModel.images.length > 1
                                      ? MediaQuery.of(context).size.width * 0.78
                                      : MediaQuery.of(context).size.width,
                                  height: 130,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: CachedNetworkImage(
                                      width: widget.productModel.images.length >
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
                        count: widget.productModel.images.length,
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
                          widget.productModel.name,
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary),
                        ),
                        Text('Farm: ${widget.productModel.farmName}',
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
                          padding: EdgeInsets.symmetric(horizontal: 5),
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
                              Text(widget.productModel.location!,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 9,
                                    color: const Color(0xFFF17B2C),
                                  )),
                            ],
                          ),
                        ),
                        Text(
                            '₦ ${NumberFormat('#,##0').format(widget.productModel.marketPrice)}/item',
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
                    Text(widget.productModel.description,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary)),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RatingStars(
                              value: value,
                              onValueChanged: (v) {
                                //
                                setState(() {
                                  value = v;
                                });
                              },
                              starBuilder: (index, color) => Icon(
                                Icons.star,
                                color: color,
                              ),
                              starCount: 5,
                              starSize: 20,
                              maxValue: 5,
                              starSpacing: 2,
                              maxValueVisibility: true,
                              valueLabelVisibility: false,
                              animationDuration:
                                  const Duration(milliseconds: 1000),
                              starOffColor: const Color(0xffe7e8ea),
                              starColor: const Color(0xffF2AE40),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                Text(
                                  value.toString(),
                                  style: Theme.of(context)
                                      .copyWith()
                                      .textTheme
                                      .bodySmall,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Container(
                                  height: 2,
                                  width: 2,
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                    text: '4.5K Ratings',
                                    style: Theme.of(context)
                                        .copyWith()
                                        .textTheme
                                        .bodySmall,
                                  ),
                                ]))
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: toggleSavedItem,
                              child: Icon(
                                savedItemProvider.savedItems
                                        .contains(widget.productModel)
                                    ? Icons.bookmark
                                    : Icons.bookmark_outline_outlined,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Image.asset('assets/forward.png',
                                width: 24, height: 24),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.productModel.inStock} units left',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 14, color: const Color(0xff9F6000)),
                        ),
                        Row(
                          children: [
                            Image.asset('assets/count_down.png',
                                width: 10, height: 10),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () =>
                                  negotiationBottomSheet(widget.productModel),
                              child: Text(
                                'Negotiate Price',
                                style: GoogleFonts.plusJakartaSans(
                                    decorationStyle: TextDecorationStyle.solid,
                                    decorationThickness: 2,
                                    decoration: TextDecoration.underline,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /////////// BUTTON ////////////
              SizedBox(
                height: MediaQuery.of(context).copyWith().size.width * 0.20,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 70),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child:
                        // Consumer<CartProvider>(
                        //     builder: (context, cartProvider, child) {
                        //   // final isInCart =
                        //   //     cartProvider.isProductInCart(widget.productModel.id);

                        quantity != 0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () => cartProvider.removeFromCart(
                                        widget.productModel, context),
                                    child: SizedBox(
                                        height: 48,
                                        width: 50,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: const Center(
                                            child: Icon(
                                              Icons.remove,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                      height: 48,
                                      width: 50,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Center(
                                            child: Text(
                                          quantity.toString(),
                                          style: TextStyle(color: Colors.black),
                                        )),
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () => cartProvider.addToCart(
                                        widget.productModel, context),
                                    child: SizedBox(
                                        height: 48,
                                        width: 50,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: const Center(
                                            child: Icon(
                                              Icons.add,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )),
                                  )
                                ],
                              )
                            : SizedBox(
                                width: MediaQuery.of(context).size.width * 90,
                                child: CustomButton(
                                    isWidget: true,
                                    container: SizedBox(
                                      height: 48,
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.shopping_cart,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Add to cart',
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
                                      setState(() {
                                        saveLoadingState = true;
                                      });
                                      try {
                                        cartProvider.addToCart(
                                            widget.productModel, context);
                                      } catch (e) {}
                                      setState(() {
                                        saveLoadingState = false;
                                      });
                                    }))
                    // })
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void negotiationBottomSheet(ProductModel product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      elevation: 5,
      useSafeArea: true,
      useRootNavigator: true,
      isDismissible: true,
      enableDrag: true,
      showDragHandle: true,
      sheetAnimationStyle: AnimationStyle(
          curve: Curves.easeIn, duration: const Duration(milliseconds: 300)),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return NegotiationModal(product: product);
      },
    );
  }
}
