// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/common/master_controller.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product_details.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';

class ShopInformation extends StatelessWidget {
  final ProductDetails productDetails;
  const ShopInformation({
    Key? key,
    required this.productDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: GlobalFunction.getContainerColor(),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 5,
                child: SizedBox(
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: CachedNetworkImage(
                            imageUrl: productDetails.product.shop.logo,
                            width: 24.w,
                            height: 24.h,
                          ),
                        ),
                      ),
                      Gap(10.w),
                      Flexible(
                        flex: 4,
                        child: Text(
                          productDetails.product.shop.name,
                          style: AppTextStyle(context)
                              .bodyText
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Consumer(builder: (context, ref, _) {
                return Visibility(
                  visible: ref
                      .read(masterControllerProvider.notifier)
                      .materModel
                      .data
                      .isMultiVendor,
                  child: Flexible(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        context.nav.pushNamed(
                          Routes.getShopViewRouteName(
                              AppConstants.appServiceName),
                          arguments: productDetails.product.shop.id,
                        );
                      },
                      child: Text(
                        S.of(context).vistiStore,
                        style: AppTextStyle(context).bodyTextSmall.copyWith(
                              color: colors(context).primaryColor,
                              decoration: TextDecoration.underline,
                              decorationColor: colors(context).primaryColor,
                            ),
                      ),
                    ),
                  ),
                );
              })
            ],
          ),
          Gap(10.h),
          Divider(
            color: colors(context).accentColor,
          ),
          Gap(10.h),
          _buildShopInfoRow(
            icon: Assets.svg.clock,
            text: S.of(context).estdTime,
            value: productDetails.product.shop.estimatedDeliveryTime,
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildShopInfoRow(
      {required String icon,
      required String text,
      required String value,
      required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          child: Row(
            children: [
              SvgPicture.asset(icon),
              Gap(10.w),
              Text(
                text,
                style: AppTextStyle(context).bodyTextSmall,
              )
            ],
          ),
        ),
        Text(
          value,
          style: AppTextStyle(context).bodyTextSmall,
        )
      ],
    );
  }
}
