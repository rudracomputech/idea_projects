import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';
import 'package:ready_ecommerce/models/eCommerce/category/category.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

class SubCategoriesBottomSheet extends ConsumerWidget {
  final Category category;
  final String? shopName;
  const SubCategoriesBottomSheet({
    Key? key,
    required this.category,
    this.shopName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDark =
        Theme.of(context).scaffoldBackgroundColor == EcommerceAppColor.black;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? EcommerceAppColor.white : EcommerceAppColor.black,
          ),
        ),
        title: Text(
          category.name,
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: GlobalFunction.getContainerColor(),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.r), topRight: Radius.circular(8.r)),
        ),
        child: ListView(
          children: [
            Text(
              'Sub Category',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color:
                    isDark ? EcommerceAppColor.white : EcommerceAppColor.black,
              ),
            ),
            SizedBox(height: 16.h),
            ListView.builder(
              itemBuilder: (context, index) {
                final SubCategory subCategory = category.subCategories[index];
                return _buildGadgetButton(
                  subCategory: subCategory,
                  context: context,
                );
              },
              itemCount: category.subCategories.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
            const SizedBox(height: 16),
            // _buildViewMoreButton(context: context),
          ],
        ),
      ),
    );
  }

  Widget _buildGadgetButton(
      {required SubCategory subCategory, BuildContext? context}) {
    bool isDark =
        Theme.of(context!).scaffoldBackgroundColor == EcommerceAppColor.black;
    return GestureDetector(
      onTap: () =>
          GlobalFunction.navigatorKey.currentContext!.nav.popAndPushNamed(
        Routes.getProductsViewRouteName(
          AppConstants.appServiceName,
        ),
        arguments: [
          category.id,
          category.name,
          null,
          subCategory.id,
          shopName,
          category.subCategories
        ],
      ),
      // icon: CachedNetworkImage(
      //   imageUrl: subCategory.thumbnail,
      //   width: 24.w,
      // ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 7.h),
        padding: EdgeInsets.only(left: 10.w),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: colors(context).buttonColor!,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 17),
          child: Text(
            subCategory.name,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: isDark ? EcommerceAppColor.white : EcommerceAppColor.black,
            ),
          ),
        ),
      ),
      // style: ElevatedButton.styleFrom(
      //   elevation: 0,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(8),
      //   ),
      //   side: BorderSide(
      //     color:
      //         colors(GlobalFunction.navigatorKey.currentContext).accentColor!,
      //   ),
      //   alignment: Alignment.centerLeft,
      //   textStyle:
      //       AppTextStyle(GlobalFunction.navigatorKey.currentContext!).bodyText,
      //   foregroundColor:
      //       colors(GlobalFunction.navigatorKey.currentContext!).bodyTextColor,
      // ),
    );
  }

  Widget _buildViewMoreButton({required BuildContext context}) {
    return OutlinedButton(
      onPressed: () => context.nav.popAndPushNamed(
        Routes.getProductsViewRouteName(
          AppConstants.appServiceName,
        ),
        arguments: [
          category.id,
          category.name,
          null,
          null,
          shopName,
          category.subCategories
        ],
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: GlobalFunction.getContainerColor(),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        side: BorderSide(color: EcommerceAppColor.primary, width: 1),
        minimumSize: Size(MediaQuery.of(context).size.width, 45.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'View all Products',
            style: AppTextStyle(context).bodyTextSmall.copyWith(
                color: colors(context).primaryColor,
                fontWeight: FontWeight.w600),
          ),
          Gap(3.w),
          SvgPicture.asset(
            Assets.svg.arrowRight,
            colorFilter: ColorFilter.mode(
              colors(context).primaryColor!,
              BlendMode.srcIn,
            ),
          )
        ],
      ),
    );
  }
}
