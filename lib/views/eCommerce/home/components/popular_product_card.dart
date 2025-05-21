// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ready_ecommerce/components/ecommerce/add_to_cart_bottom_sheet.dart';
import 'package:ready_ecommerce/components/ecommerce/increment_button.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/common/master_controller.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/models/eCommerce/cart/hive_cart_model.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

class PopularProductCard extends ConsumerWidget {
  final Product product;
  final void Function()? onTap;
  const PopularProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder<Box<HiveCartModel>>(
        valueListenable:
            Hive.box<HiveCartModel>(AppConstants.cartModelBox).listenable(),
        builder: (context, cartBox, _) {
          bool inCart = false;
          late int productQuantity;
          late int index;
          final cartItems = cartBox.values.toList();
          for (int i = 0; i < cartItems.length; i++) {
            final cartProduct = cartItems[i];
            if (cartProduct.productId == product.id) {
              inCart = true;
              productQuantity = cartProduct.productsQTY;
              index = i;
              break;
            }
          }
          return Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Material(
              borderRadius: BorderRadius.circular(8.0.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(8.0.r),
                onTap: onTap,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                  ).copyWith(top: 12.h),
                  width: 170.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 240.h,
                        // flex: 18,
                        // fit: FlexFit.tight,
                        child: Stack(
                          children: [
                            SizedBox(
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
                              Positioned(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 1.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: EcommerceAppColor.red,
                                  ),
                                  child: Text(
                                    '-${product.discountPercentage}%',
                                    style: AppTextStyle(context)
                                        .bodyTextSmall
                                        .copyWith(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w700,
                                          color: colors(context).light,
                                        ),
                                  ),
                                ),
                              ),
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
                                      style: AppTextStyle(context)
                                          .subTitle
                                          .copyWith(
                                            color: colors(context).light,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        fit: FlexFit.tight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Gap(5.h),
                            Text(
                              "${product.name}\n",
                              style: AppTextStyle(context)
                                  .bodyText
                                  .copyWith(fontWeight: FontWeight.w500),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Gap(5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  product.productSizeList.isNotEmpty
                                      ? "${product.productSizeList.first.name} KG"
                                      : "",
                                  style: AppTextStyle(context)
                                      .bodyTextSmall
                                      .copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                Text(
                                  '${product.totalSold} ${S.of(context).sold}',
                                  style: AppTextStyle(context)
                                      .bodyTextSmall
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp),
                                )
                              ],
                            ),
                            // const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (product.discountPrice > 0) ...[
                                      Text(
                                        GlobalFunction.price(
                                          currency: ref
                                              .read(masterControllerProvider
                                                  .notifier)
                                              .materModel
                                              .data
                                              .currency
                                              .symbol,
                                          position: ref
                                              .read(masterControllerProvider
                                                  .notifier)
                                              .materModel
                                              .data
                                              .currency
                                              .position,
                                          price:
                                              product.discountPrice.toString(),
                                        ),
                                        style: AppTextStyle(context)
                                            .bodyText
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ] else ...[
                                      Text(
                                        GlobalFunction.price(
                                          currency: ref
                                              .read(masterControllerProvider
                                                  .notifier)
                                              .materModel
                                              .data
                                              .currency
                                              .symbol,
                                          position: ref
                                              .read(masterControllerProvider
                                                  .notifier)
                                              .materModel
                                              .data
                                              .currency
                                              .position,
                                          price: product.price.toString(),
                                        ),
                                        style: AppTextStyle(context)
                                            .bodyText
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                    Visibility(
                                      visible: product.discountPrice > 0,
                                      child: Text(
                                        GlobalFunction.price(
                                          currency: ref
                                              .read(masterControllerProvider
                                                  .notifier)
                                              .materModel
                                              .data
                                              .currency
                                              .symbol,
                                          position: ref
                                              .read(masterControllerProvider
                                                  .notifier)
                                              .materModel
                                              .data
                                              .currency
                                              .position,
                                          price: product.price.toString(),
                                        ),
                                        style: AppTextStyle(context)
                                            .bodyText
                                            .copyWith(
                                              color:
                                                  EcommerceAppColor.lightGray,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              decorationColor:
                                                  EcommerceAppColor.lightGray,
                                              fontSize: inCart ? 12.sp : null,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                IncrementButton(
                                  onTap: () {
                                    ref
                                        .refresh(
                                            selectedProductColorIndex.notifier)
                                        .state;
                                    ref
                                        .refresh(
                                            selectedProductSizeIndex.notifier)
                                        .state;
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      isDismissible: false,
                                      barrierColor: colors(context)
                                          .accentColor!
                                          .withOpacity(0.8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.r),
                                      ),
                                      context: context,
                                      builder: (_) => AddToCartBottomSheet(
                                        product: product,
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                            Gap(product.discountPrice > 0 ? 10.h : 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
