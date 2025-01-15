import 'package:farms_gate_marketplace/providers/transaction_provider.dart';
import 'package:farms_gate_marketplace/providers/wallet_provider.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TransferSuccessfullModal extends StatefulWidget {
  const TransferSuccessfullModal({super.key});

  @override
  State<TransferSuccessfullModal> createState() =>
      _TransferSuccessfullModalState();
}

class _TransferSuccessfullModalState extends State<TransferSuccessfullModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(context, rootNavigator: true).pop();
                      transactionProvider.fetchTransactions(context, 1);
                      walletProvider.fetchWalletDetails(context);
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: const Icon(Icons.close, size: 16),
                    ),
                  ),
                ],
              ),
              Center(
                heightFactor: 2,
                child: Column(
                  children: [
                  
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Image.asset(
                        'assets/check-circle.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text('successful',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 32,
                            letterSpacing: -3,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary)),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                        'NGN2,000 has been successfully sent to Idris Abbbdulkareem.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary)),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
