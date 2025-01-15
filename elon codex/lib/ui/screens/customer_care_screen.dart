import 'package:farms_gate_marketplace/providers/cart_provider.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/screens/cart_screen.dart';
import 'package:farms_gate_marketplace/ui/widgets/app_text_field.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class CustomerCareScreen extends StatefulWidget {
  const CustomerCareScreen({super.key});

  @override
  State<CustomerCareScreen> createState() => _CustomerCareScreenState();
}

class _CustomerCareScreenState extends State<CustomerCareScreen> {
  final formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};
  bool buttonLoading = false;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController supportController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: true,
          elevation: 0,
          toolbarHeight: 118,
          title: Center(
            child: Text(
              'Customer Support',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        AppTextField(
                          prefixIcon: const Icon(
                            Icons.person_4,
                            color: Colors.grey,
                            size: 20,
                          ),
                          showPrefixIcon: true,
                          obscureTextFormField: false,
                          labelText: 'First Name',
                          hintText: 'Taiwo',
                          keyboardType: TextInputType.emailAddress,
                          controller: firstNameController,
                          onTextChange: (value) {
                            firstNameController.text = value;
                            // formData['firstName'] = value;
                          },
                          // onSaved: (value) => formData['firstName'] = value,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AppTextField(
                          prefixIcon: const Icon(
                            Icons.person_4,
                            color: Colors.grey,
                            size: 20,
                          ),
                          showPrefixIcon: true,
                          obscureTextFormField: false,
                          labelText: 'Last Name',
                          hintText: 'Bolagi',
                          keyboardType: TextInputType.emailAddress,
                          controller: lastNameController,
                          onTextChange: (value) {
                            lastNameController.text = value;
                            // formData['lastName'] = value;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: 'Support Box',
                                  style: Theme.of(context)
                                      .copyWith()
                                      .textTheme
                                      .bodyLarge,
                                  children: [
                                    const TextSpan(
                                        text: ' ',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14))
                                  ]),
                            ),
                            const SizedBox(height: 2),
                            SizedBox(
                              height: 70,
                              child: TextFormField(
                                style: GoogleFonts.figtree(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff101828)),
                                cursorColor: AppColors.primary,
                                controller: supportController,
                                keyboardType: TextInputType.multiline,
                                maxLines: 6,
                                minLines: 4,
                                onChanged: (value) {
                                  supportController.text = value;
                                  // formData['lastName'] = value;
                                },
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  enabledBorder: null,
                                  focusedBorder: null,
                                  fillColor: Colors.white,
                                  filled: true,
                                  prefixIcon: null,
                                  hintText: 'Enter your message here',
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onPressed: () {},
                        text: 'Submit',
                      ))
                ],
              )),
        ),
      ),
    );
  }
}
