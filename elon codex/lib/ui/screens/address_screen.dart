import 'package:farms_gate_marketplace/data_base/address_db.dart';
import 'package:farms_gate_marketplace/model/address_model.dart';
import 'package:farms_gate_marketplace/providers/address_provider.dart';
import 'package:farms_gate_marketplace/providers/cart_provider.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/screens/cart_screen.dart';
import 'package:farms_gate_marketplace/ui/widgets/address_card.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:farms_gate_marketplace/utils/custom_circler_loader.dart';
import 'package:farms_gate_marketplace/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class MyAddressScreen extends StatefulWidget {
  const MyAddressScreen({super.key});

  @override
  State<MyAddressScreen> createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  List<AddressModel> listOfAddress = [];
  final addressDB = AddressDatabaseHelper();
  bool itemLoading = false;

  void getAllAddress() async {
    itemLoading = true;
    setState(() {});
    List<AddressModel> addresses = await addressDB.getAllAddress();
    for (var address in addresses) {
      setState(() {
        listOfAddress.add(address);
      });
    }
    itemLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getAllAddress();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddressProvider>(context, listen: false).fetchAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: true,
        elevation: 0,
        toolbarHeight: 118,
        title: Center(
          child: Text(
            'My Address',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              itemLoading
                  ? const Center(
                      heightFactor: 20,
                      child: CustomCircularLoader(
                        color: AppColors.primary,
                      ))
                  : addressProvider.addressList.isEmpty
                      ? _buildEmptyAddressView(context)
                      : Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.70,
                              child: ListView.builder(
                                padding: const EdgeInsets.only(bottom: 50),
                                itemCount: addressProvider.addressLength,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final address =
                                      addressProvider.addressList[index];
                                  return Dismissible(
                                    onDismissed: (direction) {
                                      addressProvider.removeFromAddress(
                                          address, context);
                                      setState(() {});
                                      showCustomToast(
                                          context,
                                          'Address Deleted',
                                          '',
                                          ToastType.error);
                                    },
                                    direction: DismissDirection.endToStart,
                                    key: ValueKey(address.id),
                                    child: AddressCard(
                                      id: address.id!,
                                      address: address.address,
                                      name:
                                          '${address.firstname} ${address.lastname}',
                                      city: address.city,
                                      phone: address.phonenumber,
                                      state: address.state,
                                      defaultSate: address.isDefault,
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.90,
                              child: CustomButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/add_address_screen');
                                },
                                text: 'Add New Address',
                              ),
                            )
                          ],
                        ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyAddressView(BuildContext context) {
    return Center(
      heightFactor: 2,
      child: Column(
        children: [
          Image.asset(
            'assets/address_empty.png',
            width: 154,
            height: 154,
          ),
          const SizedBox(height: 10),
          Text(
            'Ooops!',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 6),
          Text(
            'You currently have no address yet. Click to add an address.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 35),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.80,
            child: CustomButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add_address_screen');
              },
              text: 'Add New Address',
            ),
          ),
        ],
      ),
    );
  }
}
