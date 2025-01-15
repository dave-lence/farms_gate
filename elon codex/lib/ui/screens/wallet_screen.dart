import 'package:farms_gate_marketplace/model/transaction_model.dart';
import 'package:farms_gate_marketplace/providers/transaction_provider.dart';
import 'package:farms_gate_marketplace/providers/wallet_provider.dart';
import 'package:farms_gate_marketplace/repositoreis/wallet_repo.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:farms_gate_marketplace/ui/widgets/enter_trx_pin_model.dart';
import 'package:farms_gate_marketplace/ui/widgets/top_wallet_modal.dart';
import 'package:farms_gate_marketplace/ui/widgets/transfer_modal.dart';
import 'package:farms_gate_marketplace/ui/widgets/transfer_successfull)_modal.dart';
import 'package:farms_gate_marketplace/utils/custom_circler_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool showWalletAmount = false;
  final scrollController = ScrollController();
  int urlPage = 1;
  bool isMoreDataLoading = false;
  final WalletRepo walletRepo = WalletRepo();

  final String accountNumber = "004567889";

  void copyText(BuildContext context) {
    Clipboard.setData(ClipboardData(text: accountNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Text copied to clipboard!')),
    );
  }

  void toggleWalletAmount() {
    setState(() {
      showWalletAmount = !showWalletAmount;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WalletProvider>(context, listen: false)
          .fetchWalletDetails(context);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(context, listen: false)
          .fetchTransactions(context, 1);
    });
    scrollController.addListener(scrollListener);
  }

  Future<void> scrollListener() async {
    if (isMoreDataLoading) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isMoreDataLoading = true;
      });

      await walletRepo.fetchTransactions(
        context,
        urlPage + 1,
      );

      setState(() {
        isMoreDataLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    final walletProvider = Provider.of<WalletProvider>(context);

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: true,
        elevation: 0,
        toolbarHeight: 118,
        title: Center(
          child: Text(
            'My Wallet',
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
        ),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.10,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        strokeWidth: 1,
        color: AppColors.primary,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () async {
          await walletProvider.fetchWalletDetails(context);
          await transactionProvider.fetchTransactions(context, 1);
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => toggleWalletAmount(),
                      child: Row(
                        children: [
                          Text(
                            'Wallet Ballance',
                            style: GoogleFonts.plusJakartaSans(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Icon(
                            showWalletAmount
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 10,
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => copyText(context),
                      child: Container(
                        height: 23,
                        width: 124,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: const Color(0xffE3F6E0)),
                        child: Row(
                          children: [
                            Text(
                              'Wema Bank: $accountNumber',
                              style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xff248D0E),
                                  fontSize: 8,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Image.asset(
                              'assets/copy.png',
                              height: 8,
                              width: 8,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                walletProvider.isLoading
                    ? const Center(
                        child: CustomCircularLoader(
                          color: AppColors.primary,
                        ),
                      )
                    : walletProvider.errorMessage.isNotEmpty
                        ? Center(
                            child: Text(
                              'Error, try refreshing the page.',
                              style: const TextStyle(color: Colors.red),
                            ),
                          )
                        : walletProvider.walletData == null
                            ? const Center(
                                child: Text('No data available'),
                              )
                            : Text(
                                showWalletAmount
                                    ? '₦${NumberFormat('#,##0').format(walletProvider.walletData!.balance)}.00'
                                    : "₦*******.00",
                                style: GoogleFonts.plusJakartaSans(
                                    color: Colors.black,
                                    fontSize: 34,
                                    fontWeight: FontWeight.w700),
                              ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 30,
                      width: 100,
                      child: CustomButton(
                        onPressed: () => topUpBottomSheet(context),
                        container: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/arrow_down.png',
                                height: 8,
                                width: 8,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Deposit',
                                style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                        isWidget: true,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 30,
                      width: 100,
                      child: CustomButton(
                        onPressed: () => transferBottomSheet(context),
                        container: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/double_arrow.png',
                                height: 8,
                                width: 8,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Transfer',
                                style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                        outlined: true,
                        isWidget: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'Transaction  History',
                  style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: transactionProvider.isLoading
                        ? Center(
                            child: CustomCircularLoader(
                            color: AppColors.primary,
                          ))
                        : ListView.builder(
                            controller: scrollController,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 100),
                            itemCount: isMoreDataLoading
                                ? transactionProvider.transactions.length + 1
                                : transactionProvider.transactions.length,
                            itemBuilder: (context, index) {
                              if (index <
                                  transactionProvider.transactions.length) {
                                final transaction =
                                    transactionProvider.transactions[index];

                                return Column(
                                  children: [
                                    ListTile(
                                      onTap: () => showTransactionBottomSheet(
                                          transaction),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 0),
                                      title: RichText(
                                        text: TextSpan(
                                          text: transaction.title,
                                          style: GoogleFonts.plusJakartaSans(
                                              color: AppColors.textPrimary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                          children:
                                              transaction.type == 'purchased'
                                                  ? [
                                                      TextSpan(
                                                        text:
                                                            ' (Fresh Tomato 25kg)',
                                                        style: GoogleFonts
                                                            .plusJakartaSans(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ]
                                                  : [],
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Date: ${transaction.date!.toLocal().toString().split(' ')[0]}',
                                        style: GoogleFonts.plusJakartaSans(
                                            color: AppColors.textSecondary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${transaction.status == 'credit' ? '+' : '-'}₦${transaction.amount.toStringAsFixed(2)}',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  transaction.status == 'credit'
                                                      ? const Color(0xff09BF7D)
                                                      : Colors.red,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Container(
                                            height: 19,
                                            width: 83,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: Colors.grey.shade200),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  transaction.status == 'credit'
                                                      ? 'assets/completed.png'
                                                      : 'assets/ongoing.png',
                                                  height: 8,
                                                  width: 8,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  transaction.status!,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 10,
                                                      color: transaction
                                                                  .status ==
                                                              'credit'
                                                          ? const Color(
                                                              0xff09BF7D)
                                                          : transaction
                                                                      .status ==
                                                                  'pending'
                                                              ? Colors.orange
                                                              : Colors.red),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      thickness: 0.8,
                                      color: Colors.grey.shade200,
                                    )
                                  ],
                                );
                              } else {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Center(
                                    child: CustomCircularLoader(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                );
                              }
                            }))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showTransactionBottomSheet(TransactionModel transaction) {
    showModalBottomSheet(
      isDismissible: true,
      backgroundColor: Colors.white,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      elevation: 20,
      showDragHandle: true,
      context: context,
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Transaction Details',
                        style: GoogleFonts.plusJakartaSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15)),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade100,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 15,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),

                //////// TRANSACTION TYPE ///////////
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Transaction Type',
                            style: GoogleFonts.plusJakartaSans(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 12)),
                        Text(
                            transaction.status == 'credit' ? 'Credit' : 'Debit',
                            style: GoogleFonts.plusJakartaSans(
                                color: transaction.status == 'credit'
                                    ? AppColors.primary
                                    : AppColors.error,
                                fontWeight: FontWeight.w500,
                                fontSize: 12)),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Divider(
                      thickness: 0.8,
                      color: Colors.grey.shade200,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),

                //////// TRANSACTION TYPE ///////////
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Date',
                            style: GoogleFonts.plusJakartaSans(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 12)),
                        Text(transaction.date.toString(),
                            style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 12)),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Divider(
                      thickness: 0.8,
                      color: Colors.grey.shade200,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),

                //////// TRANSACTION TYPE ///////////
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Amount',
                            style: GoogleFonts.plusJakartaSans(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 12)),
                        Text(
                            '${transaction.status == 'credit' ? '+' : '-'}₦${transaction.amount.toStringAsFixed(2)}',
                            style: GoogleFonts.plusJakartaSans(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 12)),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Divider(
                      thickness: 0.8,
                      color: Colors.grey.shade200,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),

                //////// TRANSACTION TYPE ///////////
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Status',
                            style: GoogleFonts.plusJakartaSans(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 12)),
                        Text(transaction.status!.toUpperCase(),
                            style: GoogleFonts.plusJakartaSans(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 12)),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Divider(
                      thickness: 0.8,
                      color: Colors.grey.shade200,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),

                //////// TRANSACTION TYPE ///////////
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description',
                        style: GoogleFonts.plusJakartaSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 12)),
                    const SizedBox(height: 10),
                    Text(transaction.description!,
                        style: GoogleFonts.plusJakartaSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 12)),
                    const SizedBox(
                      height: 8,
                    ),
                    Divider(
                      thickness: 0.8,
                      color: Colors.grey.shade200,
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void topUpBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      elevation: 5,
      useSafeArea: true,
      useRootNavigator: true,
      isDismissible: false,
      enableDrag: false,
      showDragHandle: true,
      sheetAnimationStyle: AnimationStyle(
          curve: Curves.easeIn, duration: const Duration(milliseconds: 300)),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return TopWalletModel();
      },
    );
  }
}

void transferBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    elevation: 5,
    useSafeArea: true,
    useRootNavigator: true,
    isDismissible: false,
    enableDrag: false,
    showDragHandle: true,
    sheetAnimationStyle: AnimationStyle(
        curve: Curves.easeIn, duration: const Duration(milliseconds: 300)),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Material(
        color: Colors.white,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: Navigator(
            initialRoute: '/',
            onGenerateRoute: (RouteSettings settings) {
              WidgetBuilder builder;
              switch (settings.name) {
                case '/':
                  builder = (BuildContext context) => TransferModel();
                  break;
                case '/enter_txn_pin_model':
                  builder = (BuildContext context) => EnterTrxPinModel();
                  break;
                case '/trans_success_model':
                  builder =
                      (BuildContext context) => TransferSuccessfullModal();
                  break;
                default:
                  throw Exception('Invalid route: ${settings.name}');
              }
              return MaterialPageRoute(builder: builder, settings: settings);
            },
          ),
        ),
      );
    },
  );
}

class Transaction {
  final String type;
  final DateTime date;
  final double amount;
  final String status;

  Transaction({
    required this.type,
    required this.date,
    required this.amount,
    required this.status,
  });

  String get title {
    if (type == 'received') return 'Cash Received';
    if (type == 'purchased') return 'Purchased';
    if (type == 'withdrawn') return 'Cash Withdrawn';
    return 'Transaction';
  }
}
