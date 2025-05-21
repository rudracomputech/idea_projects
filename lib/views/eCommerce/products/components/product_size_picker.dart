// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/eCommerce/product/product_controller.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product_details.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

class ProductSizePicker extends ConsumerStatefulWidget {
  final ProductDetails productDetails;
  const ProductSizePicker({
    super.key,
    required this.productDetails,
  });

  @override
  ConsumerState<ProductSizePicker> createState() => _ProductSizePickerState();
}

class _ProductSizePickerState extends ConsumerState<ProductSizePicker> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.refresh(selectedProductSizeIndex.notifier).state;
      ref.read(selectedSizePriceProvider.notifier).state =
          widget.productDetails.product.productSizeList[0].price;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: GlobalFunction.getContainerColor(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${S.of(context).size}:",
            style: AppTextStyle(context).bodyText.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          Gap(10.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  children: List.generate(
                    widget.productDetails.product.productSizeList.length,
                    (index) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Material(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5.r),
                          onTap: () {
                            ref.read(selectedProductSizeIndex.notifier).state =
                                index;
                            ref.read(selectedSizePriceProvider.notifier).state =
                                widget.productDetails.product
                                    .productSizeList[index].price;
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r),
                              border: Border.all(
                                color:
                                    ref.watch(selectedProductSizeIndex) == index
                                        ? EcommerceAppColor.primary
                                        : colors(context).accentColor!,
                              ),
                            ),
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  text: widget.productDetails.product
                                      .productSizeList[index].name,
                                  style: AppTextStyle(context)
                                      .bodyTextSmall
                                      .copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: ref.watch(
                                                    selectedProductSizeIndex) ==
                                                index
                                            ? EcommerceAppColor.primary
                                            : EcommerceAppColor.gray,
                                      ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: " KG".toString(),
                                      style: AppTextStyle(context)
                                          .bodyTextSmall
                                          .copyWith(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: ref.watch(
                                                        selectedProductSizeIndex) ==
                                                    index
                                                ? EcommerceAppColor.primary
                                                : EcommerceAppColor.gray,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
