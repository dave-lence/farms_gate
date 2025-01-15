import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:farms_gate_marketplace/apis/urls.dart';
import 'package:farms_gate_marketplace/model/bank_model.dart';
import 'package:farms_gate_marketplace/providers/transaction_provider.dart';
import 'package:farms_gate_marketplace/providers/wallet_provider.dart';
import 'package:farms_gate_marketplace/repositoreis/wallet_repo.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:farms_gate_marketplace/ui/widgets/app_text_field.dart';
import 'package:farms_gate_marketplace/ui/widgets/custom_btn.dart';
import 'package:farms_gate_marketplace/utils/custom_circler_loader.dart';
import 'package:farms_gate_marketplace/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransferModel extends StatefulWidget {
  const TransferModel({
    super.key,
  });

  @override
  _TransferModelState createState() => _TransferModelState();
}

class _TransferModelState extends State<TransferModel> {
  final GlobalKey<DropdownButton2State> dropdownKey =
      GlobalKey<DropdownButton2State>();

  final WalletRepo walletRepo = WalletRepo();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController bankController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  bool btLoader = false;
  bool hideBalance = true;
  final url = Urls();
  final _walletRepo = WalletRepo();
  List<BankModel> banks = [];
  BankModel? selectedBank;
  String? bankUserName;
  bool bankNameLoading = false;

  @override
  void initState() {
    _loadBanks();
    super.initState();
  }

  Future<void> _loadBanks() async {
    try {
      final fetchedBanks = await _walletRepo.fetchBanks(context);
      setState(() {
        banks = fetchedBanks;
      });
    } catch (e) {
      showCustomToast(
          context, 'Failed to fetch banks: $e', '', ToastType.error);
    }
  }

  @override
  void dispose() {
    accountController.dispose();
    amountController.dispose();
    bankController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);

    Future<void> getTxOtp() async {
      FocusScope.of(context).unfocus();

      setState(() {
        btLoader = true;
      });

      try {
        await walletRepo.getOtp(context);
      } catch (e) {
        showCustomToast(context, '$e', '', ToastType.error);
      } finally {
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
                      'Transfer From Wallet',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
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
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current Balance',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          hideBalance = !hideBalance;
                        });
                      },
                      child: Text(
                          hideBalance
                              ? "₦*******.00"
                              : '₦${NumberFormat('#,##0').format(walletProvider.walletData!.balance)}.00',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          )),
                    ),
                  ],
                ),
                Divider(color: Colors.grey.shade300),
                const SizedBox(height: 20),
                AppTextField(
                  showPrefixIcon: true,
                  prefixIcon: const Icon(
                    Icons.money,
                    size: 15,
                    color: Colors.grey,
                  ),
                  labelText: 'Amount to transfer',
                  hintText: '2,000',
                  controller: amountController,
                  onTextChange: (value) {
                    setState(() {
                      amountController.text = value;
                    });
                  },
                  showsuffixIcon: false,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Destination of Funds',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.grey.shade300),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<BankModel>(
                        buttonStyleData: const ButtonStyleData(
                          height: 40,
                        ),
                        isDense: true,
                        barrierDismissible: true,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                          fontStyle:
                              Theme.of(context).textTheme.bodyLarge!.fontStyle,
                        ),
                        customButton: AppTextField(
                          enabled: false,
                          prefixIcon: const Icon(
                            Icons.account_balance,
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
                          labelText: 'Bank Name',
                          hintText: 'Select Bank',
                          controller: bankController,
                        ),
                        alignment: Alignment.center,
                        dropdownStyleData: DropdownStyleData(
                          direction: DropdownDirection.left,
                          useRootNavigator: true,
                          useSafeArea: false,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          width: MediaQuery.of(context).size.width,
                          scrollbarTheme: ScrollbarThemeData(
                            thickness: WidgetStateProperty.all(2),
                            radius: const Radius.circular(10),
                            thumbColor: WidgetStateProperty.all(Colors.grey),
                          ),
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                        ),
                        value: selectedBank,
                        isExpanded: false,
                        hint: const Text('Select a Bank'),
                        items: banks.isEmpty
                            ? [
                                DropdownMenuItem<BankModel>(
                                  value: null,
                                  child: Text('No banks available',
                                      style: TextStyle(color: Colors.grey)),
                                ),
                              ]
                            : banks.map((bank) {
                                return DropdownMenuItem<BankModel>(
                                  value: bank,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(bank.name!),
                                      const SizedBox(height: 2),
                                      const Divider(
                                          thickness: 0.3, color: Colors.grey),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                );
                              }).toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedBank = val;
                            bankController.text = selectedBank?.name ?? '';
                          });
                          print(selectedBank?.code);
                        },
                      ),
                    ),
                  ),
                ),
                AppTextField(
                  showPrefixIcon: false,
                  prefixIcon: const Icon(
                    Icons.person_rounded,
                    size: 15,
                    color: Colors.grey,
                  ),
                  labelText: 'Account Number',
                  hintText: '2119408994',
                  controller: accountController,
                  onTextChange: (value) async {
                    setState(() {
                      accountController.text = value;
                    });
                    if (value.length == 10) {
                      FocusScope.of(context).unfocus();
                      try {
                        setState(() {
                          bankNameLoading = true;
                        });
                        final response = await _walletRepo.validateBankDetails(
                            context,
                            '044',
                            // selectedBank!.code!,
                            '0690000032'
                            // accountController.text
                            );
                        if (response != null) {
                          setState(() {
                            bankUserName =
                                response['data']['data']['account_name'];
                          });
                        }
                        setState(() {
                          bankNameLoading = false;
                        });
                      } catch (e) {
                        setState(() {
                          bankNameLoading = false;
                        });
                        debugPrint('Error validating bank details: $e');
                      } finally {
                        setState(() {
                          bankNameLoading = false;
                        });
                      }
                    }
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  showsuffixIcon: false,
                  keyboardType: TextInputType.number,
                ),
                bankNameLoading
                    ? Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: CustomCircularLoader(
                          color: AppColors.primary,
                        ),
                      )
                    : bankUserName != null
                        ? Container(
                            margin: const EdgeInsets.only(top: 3),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.5),
                                color: const Color(0xfffef3eb)),
                            child: Row(
                              children: [
                                Text(
                                  softWrap: true,
                                  bankUserName!,
                                  style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xffF17B2C),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                const SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: CustomButton(
                    buttonLoading: btLoader,
                    onPressed: btLoader || accountController.text.isEmpty ? null : getTxOtp,

                  
                    text: 'Continue',
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
