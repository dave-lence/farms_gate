import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:farms_gate_marketplace/data_base/address_db.dart';
import 'package:farms_gate_marketplace/model/address_model.dart';
import 'package:farms_gate_marketplace/providers/address_provider.dart';
import 'package:farms_gate_marketplace/providers/cart_provider.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/screens/cart_screen.dart';
import 'package:farms_gate_marketplace/ui/widgets/app_text_field.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:farms_gate_marketplace/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nigerian_states_and_lga/nigerian_states_and_lga.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class AddAdressScreen extends StatefulWidget {
  const AddAdressScreen({super.key});

  @override
  State<AddAdressScreen> createState() => _AddAdressScreenState();
}

class _AddAdressScreenState extends State<AddAdressScreen> {
  final formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phone2Controller = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final addressDB = AddressDatabaseHelper();
  bool setDefaultaddress = false;
  final random = Random();
  bool btnLoading = false;
  String stateValue = NigerianStatesAndLGA.allStates[0];
  String lgaValue = 'Select a Local Government Area';
  String selectedLGAFromAllLGAs = NigerianStatesAndLGA.getAllNigerianLGAs()[0];
  List<String> statesLga = [];
  String countryCode = '+234';

  String formatPhoneNumber(String? input) {
    if (input == null || input.isEmpty) return '';

    String phoneNumber = input.trim();
    if (phoneNumber.startsWith('0')) {
      phoneNumber = phoneNumber.substring(1);
    }

    return '$countryCode$phoneNumber';
  }

  final phoneRegex = RegExp(r'^(0(7|8|9)(0|1)\d{8}|\+234(7|8|9)(0|1)\d{8})$');

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);

    void saveAddress() async {
      FocusScope.of(context).unfocus();
      FocusScope.of(context).requestFocus(FocusNode());
      if (firstNameController.text.isEmpty &&
          lastNameController.text.isEmpty &&
          phoneController.text.isEmpty &&
          addressController.text.isEmpty &&
          regionController.text.isEmpty &&
          cityController.text.isEmpty) {
        showCustomToast(
            context, 'All fields are required', '', ToastType.error);
        return;
      } else if (!phoneRegex.hasMatch(phoneController.text) &&
          !phoneRegex.hasMatch(phone2Controller.text)) {
        showCustomToast(
            context, 'Enter a valid phone number', '', ToastType.error);
      } else {
        btnLoading = true;
        setState(() {});

         String formattedPhone = phoneController.text.startsWith('+234')
            ? phoneController.text
            : '+234${phoneController.text.replaceFirst(RegExp(r'^0'), '')}';

        String formattedPhone2 = phone2Controller.text.startsWith('+234')
            ? phone2Controller.text
            : '+234${phone2Controller.text.replaceFirst(RegExp(r'^0'), '')}';

        int randomId = random.nextInt(1000000);

        final addressData = AddressModel(
            id: randomId,
            firstname: firstNameController.text,
            lastname: lastNameController.text,
            phonenumber: formattedPhone,
            address: addressController.text,
            email: formattedPhone2,
            state: regionController.text,
            city: cityController.text,
            isDefault: setDefaultaddress);
        

        addressProvider.addToAddress(addressData, context);
        setState(() {
          btnLoading = false;
        });
        Navigator.pop(context);
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: true,
          elevation: 0,
          toolbarHeight: 118,
          title: Center(
            child: Text(
              'Add Address',
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
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
                        keyboardType: TextInputType.text,
                        controller: firstNameController,
                        onSaved: (value) => formData['firstName'] = value,
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
                        keyboardType: TextInputType.text,
                        controller: lastNameController,
                        onSaved: (value) => formData['lastName'] = value,
                      ),
                      AppTextField(
                        keyboardType: TextInputType.number,
                        labelText: 'Phone Number',
                        hintText: '080 142 386',
                        obscureText: false,
                        showPrefixIcon: true,
                        prefixIcon: const Icon(
                          Icons.phone,
                          color: Colors.grey,
                          size: 16,
                        ),
                        obscureTextFormField: false,
                        controller: phoneController,
                        onSaved: (value) {
                          String formattedNumber = formatPhoneNumber(value);
                          formData['phoneNumber'] = formattedNumber;
                        },
                      ),
                      AppTextField(
                        prefixIcon: const Icon(
                          Icons.mail,
                          color: Colors.grey,
                          size: 20,
                        ),
                        showPrefixIcon: true,
                        obscureTextFormField: false,
                        labelText: 'Additional Phone Number',
                        hintText: '08162059206',
                        keyboardType: TextInputType.phone,
                        controller: phone2Controller,
                        onSaved: (value) {
                          String formattedNumber = formatPhoneNumber(value);
                          formData['additionalPhoneNumber'] = formattedNumber;
                        },
                      ),
                      AppTextField(
                        prefixIcon: const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 20,
                        ),
                        showPrefixIcon: true,
                        obscureTextFormField: false,
                        labelText: 'Address',
                        hintText: 'crescent avenue...',
                        keyboardType: TextInputType.text,
                        controller: addressController,
                        onSaved: (value) => formData['deliveryAddress'] = value,
                      ),

                      ////// STATE DROPDWN ///////
                      Theme(
                        data: Theme.of(context).copyWith(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                              buttonStyleData: const ButtonStyleData(
                                height: 40,
                              ),
                              isDense: true,
                              barrierDismissible: true,
                              style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                  fontStyle:
                                      GoogleFonts.plusJakartaSans().fontStyle),
                              customButton: AppTextField(
                                enabled: false,
                                prefixIcon: const Icon(
                                  Icons.map_rounded,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                showPrefixIcon: true,
                                showsuffixIcon: true,
                                suffixIcon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                obscureTextFormField: false,
                                labelText: 'Region',
                                hintText: 'Lagos',
                                keyboardType: TextInputType.text,
                                controller: regionController,
                                onSaved: (value) => formData['region'] = value,
                              ),
                              alignment: Alignment.center,
                              dropdownStyleData: DropdownStyleData(
                                  scrollbarTheme: ScrollbarThemeData(
                                    trackColor: WidgetStateProperty.all(
                                        Colors.grey.shade300),
                                    thumbColor:
                                        WidgetStateProperty.all(Colors.green),
                                    radius: const Radius.circular(8),
                                    thickness: WidgetStateProperty.all(1),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.70,
                                  scrollPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  useRootNavigator: true,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(
                                            30,
                                          ))),
                                  useSafeArea: true),
                              key: const ValueKey('States'),
                              value: stateValue,
                              isExpanded: true,
                              hint: const Text('Select a Nigerian state'),
                              items: NigerianStatesAndLGA.allStates
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  alignment: Alignment.center,
                                  value: value,
                                  child: Container(
                                    decoration: const BoxDecoration(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(value),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        const Divider(
                                          thickness: 0.3,
                                          color: AppColors.primary,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                lgaValue = 'Select a Local Government Area';
                                statesLga.clear();
                                statesLga.add(lgaValue);
                                statesLga.addAll(
                                    NigerianStatesAndLGA.getStateLGAs(val!));
                                setState(() {
                                  stateValue = val;
                                  regionController.text = stateValue;
                                });
                              }),
                        ),
                      ),

                      ////// City DROPDWN ///////
                      Theme(
                        data: Theme.of(context).copyWith(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                              buttonStyleData: const ButtonStyleData(
                                height: 40,
                              ),
                              isDense: true,
                              barrierDismissible: true,
                              style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                  fontStyle:
                                      GoogleFonts.plusJakartaSans().fontStyle),
                              customButton: AppTextField(
                                prefixIcon: const Icon(
                                  Icons.location_city,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                enabled: false,
                                showPrefixIcon: true,
                                showsuffixIcon: true,
                                suffixIcon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                obscureTextFormField: false,
                                labelText: 'City',
                                hintText: 'Abuja Wuse 2',
                                keyboardType: TextInputType.text,
                                controller: cityController,
                                onSaved: (value) => formData['city'] = value,
                              ),
                              alignment: Alignment.center,
                              dropdownStyleData: DropdownStyleData(
                                  width: MediaQuery.of(context).size.width,
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.70,
                                  scrollPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  useRootNavigator: true,
                                  scrollbarTheme: ScrollbarThemeData(
                                    trackColor: WidgetStateProperty.all(
                                        Colors.grey.shade300),
                                    thumbColor:
                                        WidgetStateProperty.all(Colors.green),
                                    radius: const Radius.circular(8),
                                    thickness: WidgetStateProperty.all(1),
                                  ),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(
                                            30,
                                          ))),
                                  useSafeArea: true),
                              key: const ValueKey('Local governments'),
                              value: lgaValue,
                              isExpanded: true,
                              hint: const Text('Select a Lga'),
                              items: statesLga.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  alignment: Alignment.center,
                                  value: value,
                                  child: Container(
                                    decoration: const BoxDecoration(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(value),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        const Divider(
                                          thickness: 0.3,
                                          color: AppColors.primary,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  lgaValue = val!;
                                  cityController.text = lgaValue;
                                });
                              }),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: CustomButton(
                    buttonLoading: btnLoading,
                    onPressed: btnLoading ? null : saveAddress,
                    text: 'Save Address',
                  )),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Checkbox(
                      value: setDefaultaddress,
                      onChanged: (value) {
                        // addressProvider
                        //     .setDefaultAddress(addressController.text);
                        setState(() {
                          setDefaultaddress = value!;
                        });
                      }),
                  Text(
                    'Set as Default Address',
                    style: Theme.of(context).copyWith().textTheme.bodyLarge,
                  )
                ],
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
