import 'dart:io';

import 'package:farms_gate_marketplace/providers/cart_provider.dart';
import 'package:farms_gate_marketplace/providers/login_provider.dart';
import 'package:farms_gate_marketplace/providers/register_provider.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/screens/cart_screen.dart';
import 'package:farms_gate_marketplace/ui/widgets/app_text_field.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_button_two.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class UpdateUserDetailsScreen extends StatefulWidget {
  const UpdateUserDetailsScreen({super.key});

  @override
  State<UpdateUserDetailsScreen> createState() =>
      _UpdateUserDetailsScreenState();
}

class _UpdateUserDetailsScreenState extends State<UpdateUserDetailsScreen> {
  final formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};
  bool buttonLoading = false;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String countryCode = '+234';

  XFile? selectedImage;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  String formatPhoneNumber(String? input) {
    if (input == null || input.isEmpty) return '';

    String phoneNumber = input.trim();
    if (phoneNumber.startsWith('0')) {
      phoneNumber = phoneNumber.substring(1);
    }

    return '$countryCode$phoneNumber';
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final registerProvider = Provider.of<RegisterProvider>(context);
    final userProvider = Provider.of<LoginProvider>(context);

    void updateUserDetails() async {
      FocusScope.of(context).unfocus();
      setState(() {
        buttonLoading = true;
      });
      // formKey.currentState!.save();

      final userData = {
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'phoneNumber': formatPhoneNumber(passwordController.text),
        'password': passwordController.text,
      };
      final success = await registerProvider.updateUserDetails(
        userData,
        context,
        profileImage: selectedImage != null ? File(selectedImage!.path) : null,
      );

      if (success) {
        Navigator.pop(context);
        userProvider.fetchUserProfile(context);
      }

      setState(() {
        buttonLoading = false;
      });
    }

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
              'Account Details',
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(26)),
                      child: selectedImage != null
                          ? Image.file(File(selectedImage!.path),
                              fit: BoxFit.cover)
                          : const Icon(Icons.person,
                              size: 40, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  selectedImage != null
                      ? SizedBox(
                          width: 95,
                          height: 20,
                          child: CustomButtonTwo(
                            outlined: true,
                            onPressed: pickImage,
                            text: 'Change Image',
                          ))
                      : SizedBox(
                          width: 68,
                          height: 20,
                          child: CustomButtonTwo(
                            outlined: true,
                            onPressed: pickImage,
                            text: 'Upload',
                          )),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                      width: 68,
                      height: 20,
                      child: CustomButtonTwo(
                        outlined: true,
                        deleteBtn: true,
                        onPressed: () {
                          setState(() {
                            selectedImage = null;
                          });
                        },
                        text: 'Remove',
                      ))
                ]),
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
                        // onSaved: (value) => formData['lastName'] = value,
                      ),
                      const SizedBox(
                        height: 10,
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
                        onTextChange: (value) {
                          phoneController.text = value;
                          // phoneController.text = formattedNumber;
                          // formData['phoneNumber'] = formattedNumber;
                        },
                        // onSaved: (value) {
                        //   String formattedNumber = formatPhoneNumber(value);
                        //   formData['phoneNumber'] = formattedNumber;
                        // },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppTextField(
                        showPrefixIcon: true,
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.grey,
                          size: 16,
                        ),
                        labelText: 'Password',
                        hintText: 'Enter Your Password',
                        obscureText: true,
                        obscureTextFormField: true,
                        controller: passwordController,
                        onTextChange: (value) {
                          passwordController.text = value;
                          // formData['password'] = value;
                        },
                        // onSaved: (value) => formData['password'] = value,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: CustomButton(
                      buttonLoading: buttonLoading,
                      onPressed: buttonLoading ? null : updateUserDetails,
                      text: 'Update Details',
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
