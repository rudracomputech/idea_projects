import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/components/ecommerce/add_to_cart_bottom_sheet.dart';
import 'package:ready_ecommerce/components/ecommerce/increment_button.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/common/master_controller.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

import '../../../../models/eCommerce/product/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final void Function()? onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0.r),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0.r),
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: colors(context).accentColor!,
                offset: const Offset(0, 2),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(context: context),
              _buildProductInformation(context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage({required BuildContext context}) {
    return Stack(
      children: [
        SizedBox(
          height: 220.h,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.r),
            child: CachedNetworkImage(
              imageUrl: product.thumbnail ?? '',
              fit: BoxFit.fill,
            ),
          ),
        ),
        if (product.discountPercentage != 0)
          _buildDiscountBadge(context: context),
        if (product.quantity == 0) ...[
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.r),
                color: Colors.black.withOpacity(0.6),
              ),
              child: Center(
                child: Text(
                  S.of(context).outOfStock,
                  style: AppTextStyle(context).subTitle.copyWith(
                        color: colors(context).light,
                      ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDiscountBadge({required BuildContext context}) {
    return Positioned(
      top: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          color: EcommerceAppColor.red,
        ),
        child: Text(
          '-${product.discountPercentage}%',
          style: AppTextStyle(context).bodyTextSmall.copyWith(
                color: colors(context).light,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }

  Widget _buildProductInformation({required BuildContext context}) {
    return Stack(
      children: [
        SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(5.h),
              Text(
                '${product.name}\n',
                style: AppTextStyle(context)
                    .bodyText
                    .copyWith(fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(5.h),
              _buildReviewAndSoldCount(context: context),
              Gap(product.discountPrice > 0 ? 8.h : 10.h),
              _buildPriceAndAddToCart(context: context),
            ],
          ),
        ),
        if (product.quantity == 0 || product.quantity < 0)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: colors(context).accentColor!.withOpacity(0.4),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReviewAndSoldCount({required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              product.productSizeList.isNotEmpty
                  ? "${product.productSizeList.first.name} KG"
                  : "",
              style: AppTextStyle(context).bodyTextSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
        Text(
          '${product.totalSold} Sold',
          style: AppTextStyle(context).bodyTextSmall.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  Widget _buildPriceAndAddToCart({required BuildContext context}) {
    return Consumer(builder: (context, ref, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              if (product.discountPrice > 0) ...[
                Text(
                  GlobalFunction.price(
                    currency: ref
                        .read(masterControllerProvider.notifier)
                        .materModel
                        .data
                        .currency
                        .symbol,
                    position: ref
                        .read(masterControllerProvider.notifier)
                        .materModel
                        .data
                        .currency
                        .position,
                    price: product.discountPrice.toString(),
                  ),
                  style: AppTextStyle(context)
                      .bodyText
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ] else ...[
                Text(
                  GlobalFunction.price(
                    currency: ref
                        .read(masterControllerProvider.notifier)
                        .materModel
                        .data
                        .currency
                        .symbol,
                    position: ref
                        .read(masterControllerProvider.notifier)
                        .materModel
                        .data
                        .currency
                        .position,
                    price: product.price.toString(),
                  ),
                  style: AppTextStyle(context)
                      .bodyText
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
              if (product.discountPrice > 0) ...[
                Text(
                  GlobalFunction.price(
                    currency: ref
                        .read(masterControllerProvider.notifier)
                        .materModel
                        .data
                        .currency
                        .symbol,
                    position: ref
                        .read(masterControllerProvider.notifier)
                        .materModel
                        .data
                        .currency
                        .position,
                    price: product.price.toString(),
                  ),
                  style: AppTextStyle(context).bodyText.copyWith(
                        color: EcommerceAppColor.lightGray,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: EcommerceAppColor.lightGray,
                      ),
                ),
              ]
            ],
          ),
          IncrementButton(
            onTap: () {
              ref.refresh(selectedProductSizeIndex.notifier).state;
              ref.refresh(selectedProductColorIndex.notifier).state;
              showModalBottomSheet(
                isScrollControlled: true,
                isDismissible: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                context: context,
                builder: (_) => AddToCartBottomSheet(
                  product: product,
                ),
              );
            },
          )
        ],
      );
    });
  }
}
