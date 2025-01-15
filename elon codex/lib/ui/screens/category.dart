// ignore_for_file: prefer_const_constructors

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:farms_gate_marketplace/model/product_model.dart';
import 'package:farms_gate_marketplace/providers/cart_provider.dart';
import 'package:farms_gate_marketplace/repositoreis/product_repo.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/screens/cart_screen.dart';
import 'package:farms_gate_marketplace/ui/widgets/app_text_field.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:farms_gate_marketplace/ui/widgets/filters/all_listings.dart';
import 'package:farms_gate_marketplace/ui/widgets/filters/animal_listings.dart';
import 'package:farms_gate_marketplace/ui/widgets/filters/crop_listings.dart';
import 'package:farms_gate_marketplace/ui/widgets/filters/produce_listings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final searchController = TextEditingController();
  String searchQuery = '';
  late Future<List<ProductModel>> _productFuture;
  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  var groupedProducts = <String, List<ProductModel>>{};
  final scrollController = ScrollController();
  int urlPage = 1;
  bool isMoreDataLoading = false;
  final ProductRepo _productService = ProductRepo();

  // Map<String, List<ProductModel>> groupedProducts = {};
  // late Map<String, List<ProductModel>> groupedProducts;

  void filterProducts(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredProducts = allProducts.where((product) {
        final name = product.name.toLowerCase();
        final category = product.category!.toLowerCase();
        return name.contains(searchQuery) || category.contains(searchQuery);
      }).toList();
      groupedProducts = groupProductsByCategory(filteredProducts);

      print('Filtered products: ${filteredProducts.length}');
      print('grouped products: ${groupedProducts.length}');
    });
  }

  Future<void> scrollListener() async {
    print('scrolled');
    if (isMoreDataLoading) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isMoreDataLoading = true;
      });

      await _productService.getAllProducts(urlPage + 1, context);

      setState(() {
        isMoreDataLoading = false;
      });
    }
  }

  Map<String, List<ProductModel>> groupProductsByCategory(
      List<ProductModel> products) {
    final Map<String, List<ProductModel>> groupedProducts = {};
    for (var product in products) {
      groupedProducts.putIfAbsent(product.category!, () => []).add(product);
    }
    return groupedProducts;
  }

  List<String> filters = [
    'By category',
    'State',
    'Availability',
    'Date Listed',
    'Reset'
  ];

  @override
  void initState() {
    groupedProducts = {};
    _productFuture = ProductRepo().getAllProducts(urlPage, context);
    scrollController.addListener(scrollListener);

    super.initState();
  }

  @override
  void dispose() {
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
                          labelText: '',
                          onTextChange: (value) => filterProducts(value),
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
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.80,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: ContainedTabBarView(
                      tabBarProperties: TabBarProperties(
                          height: 48,
                          indicatorSize: TabBarIndicatorSize.tab,
                          unselectedLabelColor: Colors.grey,
                          unselectedLabelStyle: TextStyle(
                              fontStyle:
                                  GoogleFonts.plusJakartaSans().fontStyle,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.grey.shade400)),
                      tabs: [
                        Text('All Listings',
                            style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.textPrimary)),
                        Text('Animals',
                            style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.textPrimary)),
                        Text('Crops',
                            style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.textPrimary)),
                        Text('Produce',
                            style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.textPrimary)),
                      ],
                      views: [
                        //// ALL PRODUCTS VIEW ////
                        AllListingsWidget(
                          scrollController: scrollController,
                          isMoreProdLoading: isMoreDataLoading,
                          screenHeight: screenHeight,
                          productFuture: _productFuture,
                          searchQuery: searchQuery,
                          filters: filters,
                          onTap: (filter) =>
                              showBottomSheetFilters(context, filter),
                          allProducts: allProducts,
                          filteredProducts: filteredProducts,
                          groupProductsByCategory: groupProductsByCategory,
                          groupedProducts: groupedProducts,
                        ),
                        //// ANIMAL PRODUCT VIEW ////
                        AnimalListingsWidget(
                          screenHeight: screenHeight,
                          filters: filters,
                          productFuture: _productFuture,
                          onTap: (filter) =>
                              showBottomSheetFilters(context, filter),
                        ),

                        CropsListingsWidget(
                          screenHeight: screenHeight,
                          filters: filters,
                          productFuture: _productFuture,
                          onTap: (filter) =>
                              showBottomSheetFilters(context, filter),
                        ),
                        ProduceListingsWidget(
                          screenHeight: screenHeight,
                          filters: filters,
                          productFuture: _productFuture,
                          onTap: (filter) =>
                              showBottomSheetFilters(context, filter),
                        ),
                      ],
                    ))
              ],
            ),
          )),
    );
  }

  void showBottomSheetFilters(BuildContext context, pagTitle) {
    showModalBottomSheet(
      isDismissible: true,
      backgroundColor: Colors.white,
      useRootNavigator: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final List<String> animalCategories = ['Animals', 'Crops', 'Produce'];
        final List<String> nigerianStates = [
          'Lagos',
          'Ogun',
          'Oyo',
          'Ekiti',
          'Ondo',
          'Kwara',
          'Osun',
          'Abuja',
          'Kano',
          'Enugu',
          'Port Harcourt'
        ];
        final List<String> availabilityList = [
          'In Stock',
          'Pre - Order',
          'Out of Stock',
        ];

        final List<String> dateListed = [
          'Last 24 hours',
          'Last 7 days',
          'Last 30 days',
          'Last 90 days',
        ];
        int? selectedIndex;
        // List<String> currentList = animalCategories;

        List<String> showList() {
          if (pagTitle == 'By category') {
            return animalCategories;
          } else if (pagTitle == 'State') {
            return nigerianStates;
          } else if (pagTitle == 'Availability') {
            return availabilityList;
          } else if (pagTitle == 'Date Listed') {
            return dateListed;
          } else {
            return [];
          }
        }

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.4,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(pagTitle,
                        style: GoogleFonts.plusJakartaSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15)),
                    // Close button
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade100,
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 15,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: showList().length,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey.shade300,
                      ),
                      itemBuilder: (context, index) {
                        bool isSelected = index == selectedIndex;

                        return ListTile(
                          selected: isSelected,
                          selectedTileColor: AppColors.lightPrimary,
                          tileColor: isSelected
                              ? AppColors.lightPrimary
                              : Colors.transparent,
                          title: Center(
                            child: Text(
                              showList()[index],
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                              isSelected = true;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: CustomButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: 'Apply Filter',
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
