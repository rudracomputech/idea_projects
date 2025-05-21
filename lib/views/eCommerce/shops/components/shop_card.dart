import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/models/eCommerce/shop/shop.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

class ShopCard extends StatelessWidget {
  final Shop shop;

  const ShopCard({
    Key? key,
    required this.shop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Material(
        child: InkWell(
          onTap: () {
            context.nav.pushNamed(
              Routes.getShopViewRouteName(AppConstants.appServiceName),
              arguments: shop.id,
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShopLogo(),
                Gap(16.w),
                _buildShopInfo(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShopLogo() {
    return Flexible(
      flex: 1,
      child: Container(
        height: 60.h,
        width: 60.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
              color: colors(GlobalFunction.navigatorKey.currentContext)
                  .accentColor!),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(
              shop.logo,
              errorListener: (error) => debugPrint(error.toString()),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShopInfo(BuildContext context) {
    return Flexible(
      flex: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 5,
                child: Text(
                  shop.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle(context).subTitle,
                ),
              ),
              Flexible(
                flex: 1,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14.sp,
                  color: EcommerceAppColor.lightGray,
                ),
              )
            ],
          ),
          Gap(10.h),
          _buildShopDetails(context),
        ],
      ),
    );
  }

  Widget _buildShopDetails(BuildContext context) {
    final int itemCount = shop.totalProducts;

    return Row(
      children: [
        Text(
          '$itemCount+ ${S.of(context).items}',
          style: AppTextStyle(context).bodyTextSmall,
        ),
        Gap(16.w),
        Container(
          margin: const EdgeInsets.only(top: 3),
          height: 12.h,
          width: 2,
          color: EcommerceAppColor.lightGray,
        ),
        Gap(16.w),
        Text(
          '${shop.totalCategories}+ ${S.of(context).categories}',
          style: AppTextStyle(context).bodyTextSmall,
        ),
      ],
    );
  }
}
