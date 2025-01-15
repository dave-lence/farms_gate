import 'package:farms_gate_marketplace/apis/urls.dart';
import 'package:farms_gate_marketplace/providers/transaction_provider.dart';
import 'package:farms_gate_marketplace/providers/wallet_provider.dart';
import 'package:farms_gate_marketplace/repositoreis/wallet_repo.dart';
import 'package:farms_gate_marketplace/ui/widgets/app_text_field.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:farms_gate_marketplace/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopWalletModel extends StatefulWidget {
  const TopWalletModel({
    super.key,
  });

  @override
  _TopWalletModelState createState() => _TopWalletModelState();
}

class _TopWalletModelState extends State<TopWalletModel> {
  final WalletRepo walletRepo = WalletRepo();
  final TextEditingController topUpController = TextEditingController();
  bool btLoader = false;
  final url = Urls();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    topUpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);

    Future<void> topUpWallet() async {
      FocusScope.of(context).unfocus();

      setState(() {
        btLoader = true;
      });

      try {
        await walletProvider.topUpWallet(
            context, int.tryParse(topUpController.text) ?? 0);
      } catch (e) {
        showCustomToast(context, '$e', '', ToastType.error);
      } finally {
        topUpController.clear();
        setState(() {
          btLoader = false;
        });
      }
    }

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
                      'Wallet Topup',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        walletProvider.fetchWalletDetails(context);
                        transactionProvider.fetchTransactions(context, 1);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        child: const Icon(Icons.close, size: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                AppTextField(
                  labelText: 'Amount',
                  hintText: 'Enter top up amount',
                  controller: topUpController,
                  onTextChange: (value) {
                    setState(() {
                      topUpController.text = value;
                    });
                  },
                  showsuffixIcon: false,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: CustomButton(
                    buttonLoading: btLoader,
                    onPressed: btLoader || topUpController.text.isEmpty
                        ? null
                        : topUpWallet,
                    text: 'Top up',
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
