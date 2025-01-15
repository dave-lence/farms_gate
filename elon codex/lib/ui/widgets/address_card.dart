import 'package:farms_gate_marketplace/providers/address_provider.dart';
import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddressCard extends StatefulWidget {
  final int id;
  final String name;
  final String phone;
  final String city;
  final bool checkOut;
  final String address;
  final String state;
  bool defaultSate;
  AddressCard({
    super.key,
    required this.id,
    required this.address,
    required this.name,
    required this.phone,
    this.checkOut = false,
    required this.city,
    required this.state,
    this.defaultSate = false,
  });

  @override
  State<AddressCard> createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: 100,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.name,
                style: GoogleFonts.plusJakartaSans(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
              Row(
                children: [
                  Text(
                    widget.checkOut ? '' : 'Default Address',
                    style: GoogleFonts.plusJakartaSans(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w400,
                        fontSize: 10),
                  ),
                  widget.checkOut
                      ? const SizedBox()
                      : Checkbox(
                          value: widget.defaultSate,
                          onChanged: (value) {
                            if (value == true) {
                              context
                                  .read<AddressProvider>()
                                  .setDefaultAddress(widget.id);
                            }
                          }),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.phone,
                style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
              ),
              Text(
                widget.city,
                style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 3),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.5),
                color: widget.checkOut
                    ? const Color(0xffF2F2F2)
                    : const Color(0xfffef3eb)),
            child: Row(
              children: [
                Image.asset(
                  widget.checkOut
                      ? 'assets/checkout-address-img.png'
                      : 'assets/address_icon.png',
                  height: 7,
                  width: 7,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  softWrap: true,
                  ' ${widget.address}, ${widget.city},  ${widget.state}',
                  style: GoogleFonts.plusJakartaSans(
                      color: widget.checkOut
                          ? const Color(0xff7D8398)
                          : const Color(0xffF17B2C),
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
