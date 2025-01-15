import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:farms_gate_marketplace/model/order_model.dart';
import 'package:farms_gate_marketplace/providers/cart_provider.dart';
import 'package:farms_gate_marketplace/providers/orders_provider.dart';
import 'package:farms_gate_marketplace/repositoreis/product_repo.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/screens/cart_screen.dart';
import 'package:farms_gate_marketplace/ui/widgets/app_text_field.dart';
import 'package:farms_gate_marketplace/ui/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});
  static String id = 'myorderscreen';

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  final searchController = TextEditingController();
  int currentIndex = 0;
  late Future<List<MyOrderModel>> futureOrders;
  bool isLoading = true;
  List<MyOrderModel> orders = [];
  final ProductRepo productRepo = ProductRepo();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);

    _tabController.addListener(() {
      setState(() {
        currentIndex = _tabController.index;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<OrdersProvider>(context, listen: false).fetchOrders(context);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    // final ordersProvider = Provider.of<OrdersProvider>(context);

    return VisibilityDetector(
      key: Key(MyOrdersScreen.id),
      onVisibilityChanged: (VisibilityInfo info) {
        WidgetsBinding.instance.addPostFrameCallback((
          timeStamp,
        ) {
           final ordersProvider =
              Provider.of<OrdersProvider>(context, listen: false);
          if (!ordersProvider.wasPopped) {
            ordersProvider.fetchOrders(context);
          }
        //   Provider.of<OrdersProvider>(context, listen: false)
        //       .fetchOrders(context);
        });
        
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
          body: Consumer<OrdersProvider>(
              builder: (context, orderProvider, child) {
            if (orderProvider.isLoading) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.90,
                child: ListView.builder(
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    itemCount: isLoading ? 10 : orders.length,
                    itemBuilder: (context, index) {
                      return const MyOrderCard(
                        loading: true,
                      );
                    }),
              );
            }
            return Column(children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.80,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ContainedTabBarView(
                    onChange: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    tabBarProperties: TabBarProperties(
                        height: 48,
                        indicatorSize: TabBarIndicatorSize.tab,
                        unselectedLabelColor: Colors.grey,
                        unselectedLabelStyle: TextStyle(
                            fontStyle: GoogleFonts.plusJakartaSans().fontStyle,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.grey.shade400)),
                    tabs: [
                      Text('Complete/Ongoing',
                          style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: AppColors.textPrimary)),
                      Text('Canceled',
                          style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: AppColors.textPrimary)),
                    ],
                    views: [
                      buildOrderList(orderProvider.ongoingOrders,
                          "No ongoing or completed orders yet."),
                      buildOrderList(orderProvider.cancelledOrders,
                          "No canceled orders yet."),
                    ],
                  ))
            ]);
          })),
    );
  }

  Widget buildOrderList(List<MyOrderModel> orders, String emptyMessage) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 20),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return MyOrderCard(
          productImag: order.images[0],
          orderModel: order,
          name: order.productName,
          orderId: "#${order.orderNo}",
          status: order.status,
          date: order.createdAt,
          qty: order.quantity.toString(),
        );
      },
    );
  }
}
