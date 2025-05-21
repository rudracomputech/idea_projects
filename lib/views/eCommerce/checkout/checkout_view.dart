// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ready_ecommerce/views/eCommerce/checkout/layouts/checkout_layout.dart';

class EcommerceCheckoutView extends StatelessWidget {
  final bool isBuyNow;
  final double payableAmount;
  final String? couponCode;

  const EcommerceCheckoutView({
    Key? key,
    required this.payableAmount,
    required this.couponCode,
    this.isBuyNow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EcommerceCheckoutLayout(
      payableAmount: payableAmount,
      couponCode: couponCode,
      isBuyNow: isBuyNow,
    );
  }
}
