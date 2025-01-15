import 'dart:convert';
import 'package:farms_gate_marketplace/apis/urls.dart';
import 'package:farms_gate_marketplace/model/product_model.dart';
import 'package:farms_gate_marketplace/providers/cart_provider.dart';
import 'package:farms_gate_marketplace/ui/widgets/app_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:farms_gate_marketplace/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NegotiationModal extends StatefulWidget {
  final ProductModel product;

  const NegotiationModal({super.key, required this.product});

  @override
  _NegotiationModalState createState() => _NegotiationModalState();
}

class _NegotiationModalState extends State<NegotiationModal> {
  final TextEditingController currentPrice = TextEditingController();
  final TextEditingController propsedPrice = TextEditingController();
  bool btLoader = false;
  final url = Urls();

  @override
  void initState() {
    super.initState();
    currentPrice.text = '₦ ${widget.product.marketPrice}';
    propsedPrice.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    currentPrice.dispose();
    propsedPrice.dispose();
    super.dispose();
  }

  Future<void> postNegotiationPrice() async {
    FocusScope.of(context).unfocus();

    setState(() {
      btLoader = true;
    });

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final int quantityValue =
        cartProvider.productQuantities[widget.product.id] ?? 1;

    final negoData = {
      "proposedPrice": int.parse(propsedPrice.text),
      "quantity": quantityValue,
    };
    String negotiationUrl = '${url.negotiationUrl}${widget.product.productId}';
    final prefs = await SharedPreferences.getInstance();
    String bearerToken = prefs.getString('bearer') ?? '';

    try {
      final response = await http.post(
        Uri.parse(negotiationUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(negoData),
      );

      print(negoData);

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        showCustomToast(
            context, responseData['message'], '', ToastType.success);
      } else {
        final Map<String, dynamic> resBody = json.decode(response.body);
        print(resBody);
        List<String> messages = List<String>.from(resBody['message']);
        for (var message in messages) {
          showCustomToast(context, message, '', ToastType.error);
        }
      }
    } catch (e) {
      showCustomToast(context, '$e', '', ToastType.error);
    } finally {
      setState(() {
        btLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Negotiate Price',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        child: const Icon(Icons.close, size: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                AppTextField(
                  labelText: 'Current Price',
                  hintText: currentPrice.text,
                  controller: currentPrice,
                  enabled: false,
                  showsuffixIcon: true,
                  suffixIcon: const Icon(Icons.info),
                ),
                AppTextField(
                  labelText: 'Proposed Price',
                  hintText: 'Enter a proposed price',
                  controller: propsedPrice,
                  showsuffixIcon: false,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Image.asset(
                      'assets/warn.png',
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 2),
                    const Text('Minimum price ₦(Proposed price * 0.8)'),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: CustomButton(
                    buttonLoading: btLoader,
                    onPressed: btLoader || propsedPrice.text.isEmpty
                        ? null
                        : postNegotiationPrice,
                    text: 'Negotiate Price',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
