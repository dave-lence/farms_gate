import 'package:carousel_slider/carousel_slider.dart';
import 'package:farms_gate_marketplace/model/product_model.dart';
import 'package:farms_gate_marketplace/providers/cart_provider.dart';
import 'package:farms_gate_marketplace/providers/product_provider.dart';
import 'package:farms_gate_marketplace/repositoreis/product_repo.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/screens/cart_screen.dart';
import 'package:farms_gate_marketplace/ui/screens/product_details_screen.dart';
import 'package:farms_gate_marketplace/ui/widgets/app_text_field.dart';
import 'package:farms_gate_marketplace/ui/widgets/category_title_component.dart';
import 'package:farms_gate_marketplace/ui/widgets/product_item_card.dart';
import 'package:farms_gate_marketplace/utils/custom_circler_loader.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  final searchController = TextEditingController();
  final CarouselSliderController _controller = CarouselSliderController();
  Map<String, dynamic> responseData = {};
  late Future<List<ProductModel>> _productFuture;
  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  var groupedProducts = <String, List<ProductModel>>{};
  String searchQuery = '';
  final ProductRepo _productService = ProductRepo();

////// paginition logic start ///////
  final Map<String, ScrollController> scrollControllers = {};
  int urlPage = 1;
  bool isMoreDataLoading = false;

  Future<void> scrollListener() async {
    print('scroll');
    if (isMoreDataLoading) return;
    for (var controller in scrollControllers.values) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() {
          isMoreDataLoading = true;
        });

        await _productService.getAllProducts(urlPage + 1, context);

        setState(() {
          isMoreDataLoading = false;
        });
      }
    }
  }

  // List<CategoryModel> categoryList = [];

  final List<String> imgList = [
    'assets/carosel_img_1.png',
    'assets/carosel_img_2.png',
  ];

  final List<Map<String, dynamic>> productImageList = [
    {
      "image": 'assets/product_mini_card.png',
      "name": 'Animals',
    },
    {"image": 'assets/product_mini_card_4.png', 'name': 'Crops'},
    {"image": 'assets/product_mini_card_3.png', 'name': 'Produce'},
  ];

  void filterProducts(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredProducts = allProducts.where((product) {
        final name = product.name.toLowerCase();
        final category = product.category!.toLowerCase();
        return name.contains(searchQuery) || category.contains(searchQuery);
      }).toList();
    });

    groupedProducts = groupProductsByCategory(filteredProducts);
  }

  Map<String, List<ProductModel>> groupProductsByCategory(
      List<ProductModel> products) {
    final Map<String, List<ProductModel>> groupedProducts = {};
    for (var product in products) {
      groupedProducts.putIfAbsent(product.category!, () => []).add(product);
    }
    return groupedProducts;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProductProvider>(context, listen: false)
          .fetchAllProducts(context);
    });
    _productFuture = ProductRepo().getAllProducts(urlPage, context);

    for (var controller in scrollControllers.values) {
      controller.addListener(scrollListener);
    }
    super.initState();
  }

  Future<void> refreshProducts() async {
    _productFuture = ProductRepo().getAllProducts(urlPage, context);
  }

  @override
  void dispose() {
    for (var controller in scrollControllers.values) {
      controller.dispose();
    }
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
            appBar: AppBar(
              forceMaterialTransparency: true,
              automaticallyImplyLeading: false,
              elevation: 0,
              toolbarHeight: 118,
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
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: AppTextField(
                            isAppBar: true,
                            showPrefixIcon: true,
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: Colors.grey.shade400,
                            ),
                            onTextChange: (value) => filterProducts(value),
                            labelText: '',
                            hintText: 'Search...',
                            controller: searchController),
                      ),
                      Stack(
                        children: [
                          IconButton(
                              onPressed: () {
                                PersistentNavBarNavigator.pushNewScreen(context,
                                    withNavBar: false,
                                    screen: const CartScreen());
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
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 170,
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
                                padEnds: false,
                                height: 130,
                                enableInfiniteScroll: false,
                                aspectRatio: 1.9),
                            items: imgList
                                .map((item) => Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      height: 130,
                                      child: Center(
                                          child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.asset(item,
                                            fit: BoxFit.cover, width: 1000),
                                      )),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 7),
                          AnimatedSmoothIndicator(
                            activeIndex: currentIndex,
                            count: imgList.length,
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
                  SizedBox(
                    height: 110,
                    child: Center(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        scrollDirection: Axis.horizontal,
                        itemCount: productImageList.length,
                        itemBuilder: (context, index) {
                          final data = productImageList[index];
                          return ProductMiniCard(
                            imgUrl: data['image'],
                            name: data['name'],
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.55,
                    child: FutureBuilder<List<ProductModel>>(
                      future: _productFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Display loading shimmer
                          return ListView.builder(
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.only(left: 5),
                                margin: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  children: [
                                    const CategoryTitleComponent(
                                      isLoading: true,
                                    ),
                                    const SizedBox(height: 15),
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: List.generate(
                                            4,
                                            (index) => const ProductItemCard(
                                                isLoading: true),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No products found.'),
                          );
                        } else {
                          allProducts = snapshot.data!;
                          groupedProducts = groupProductsByCategory(
                            searchQuery.isEmpty
                                ? allProducts
                                : filteredProducts,
                          );

                          // Display data grouped by category
                          return RefreshIndicator(
                            backgroundColor: Colors.white,
                            strokeWidth: 1,
                            color: AppColors.primary,
                            onRefresh: refreshProducts,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 120),
                              shrinkWrap: true,
                              itemCount: groupedProducts.keys.length,
                              itemBuilder: (context, categoryIndex) {
                                final category = groupedProducts.keys
                                    .elementAt(categoryIndex);

                                final products = groupedProducts[category]!;

                                return SizedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CategoryTitleComponent(
                                        categoryName: category,
                                      ),
                                      const SizedBox(height: 15),
                                      SizedBox(
                                        height: 200,
                                        child: ListView.builder(
                                          controller:
                                              scrollControllers[category],
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: isMoreDataLoading
                                              ? products.length + 1
                                              : products.length,
                                          itemBuilder: (context, productIndex) {
                                            if (productIndex <
                                                products.length) {
                                              final product =
                                                  products[productIndex];

                                              return ProductItemCard(
                                                location: product.location!,
                                                productPrice: product
                                                    .marketPrice
                                                    .toString(),
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
                                                productImag:
                                                    product.images.first,
                                                productName: product.name,
                                              );
                                            } else {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Center(
                                                  child: CustomCircularLoader(
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              );
                                            }
                                            // final product =
                                            //     products[productIndex];

                                            // return ProductItemCard(
                                            //   location: product.location!,
                                            //   productPrice: product.marketPrice
                                            //       .toString(),
                                            //   onTap: () {
                                            //     Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             ProductDetailsScreen(
                                            //           productModel: product,
                                            //         ),
                                            //       ),
                                            //     );
                                            //   },
                                            //   productImag: product.images.first,
                                            //   productName: product.name,
                                            // );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            )));
  }
}

class ProductMiniCard extends StatelessWidget {
  final String imgUrl;
  final String name;
  const ProductMiniCard({super.key, required this.imgUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.transparent,
        width: 104,
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: 103,
              height: 64,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
              child: Image.asset(
                imgUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: Theme.of(context).copyWith().textTheme.bodySmall,
            )
          ],
        ),
      ),
    );
  }
}
