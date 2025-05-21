import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/eCommerce/shop/shop_controller.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/models/eCommerce/common/product_filter_model.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product_details.dart'
    as product_details;
import 'package:ready_ecommerce/models/eCommerce/shop/shop_review.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/product_size_picker.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/review_card.dart';

class ProductDetailsAndReview extends ConsumerStatefulWidget {
  final product_details.ProductDetails productDetails;
  const ProductDetailsAndReview({Key? key, required this.productDetails})
      : super(key: key);

  @override
  ProductDetailsAndReviewState createState() => ProductDetailsAndReviewState();
}

class ProductDetailsAndReviewState
    extends ConsumerState<ProductDetailsAndReview> {
  final ScrollController reviewScrollController = ScrollController();
  int isProduct = 0;
  int page = 1;
  int perPage = 20;
  int? totalReview;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(shopControllerProvider.notifier)
          .getReviews(
            productFilterModel: ProductFilterModel(
              productId: widget.productDetails.product.id,
              page: page,
              perPage: perPage,
            ),
            isPagination: false,
          )
          .whenComplete(() {
        setState(() {
          totalReview = ref.read(shopControllerProvider.notifier).totalReviews;
        });
      });
    });

    super.initState();
  }

  void productScrollListener() {
    if (reviewScrollController.offset >=
        reviewScrollController.position.maxScrollExtent) {
      if (ref.watch(shopControllerProvider.notifier).review.length <
              ref.watch(shopControllerProvider.notifier).totalReviews! &&
          ref.watch(shopControllerProvider) == false) {
        page++;
        ref.read(shopControllerProvider.notifier).getReviews(
              isPagination: true,
              productFilterModel: ProductFilterModel(
                productId: widget.productDetails.product.id,
                page: page,
                perPage: perPage,
              ),
            );
      }
    }
  }

  @override
  void dispose() {
    reviewScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          _buildProductInfoRow(),
          Gap(10.h),
          Divider(
            color: colors(context).accentColor,
          ),
          Gap(30.h),
          tabBarWidgetView(),
          Visibility(
            visible: widget.productDetails.product.productSizeList.isNotEmpty,
            child: ProductSizePicker(productDetails: widget.productDetails),
          ),
          Gap(10.h),
        ],
      ),
    );
  }

  Widget _buildProductInfoRow() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: colors(context).accentColor,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: InkWell(
              onTap: () {
                setState(() {
                  isProduct = 0;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  color: isProduct == 0
                      ? GlobalFunction.getContainerColor()
                      : colors(context).accentColor,
                  boxShadow: [
                    if (isProduct == 0)
                      const BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.10),
                        offset: Offset(0, 0),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                  ],
                ),
                height: 50.h,
                child: Center(
                  child: Text(
                    S.of(context).productInfo,
                    textAlign: TextAlign.center,
                    style: isProduct == 0
                        ? AppTextStyle(context).bodyText
                        : AppTextStyle(context).bodyTextSmall,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: InkWell(
              onTap: () {
                setState(() {
                  isProduct = 1;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  color: isProduct == 1
                      ? GlobalFunction.getContainerColor()
                      : colors(context).accentColor,
                  boxShadow: [
                    if (isProduct == 1)
                      const BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.10),
                        offset: Offset(0, 0),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                  ],
                ),
                height: 50.h,
                child: Center(
                  child: Text(
                    S.of(context).shipping,
                    textAlign: TextAlign.center,
                    style: isProduct == 1
                        ? AppTextStyle(context).bodyText
                        : AppTextStyle(context).bodyTextSmall,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: InkWell(
              onTap: () {
                setState(() {
                  isProduct = 2;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  color: isProduct == 2
                      ? GlobalFunction.getContainerColor()
                      : colors(context).accentColor,
                  boxShadow: [
                    if (isProduct == 2)
                      const BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.10),
                        offset: Offset(0, 0),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                  ],
                ),
                height: 50.h,
                child: Center(
                  child: Text(
                    S.of(context).shopInfo,
                    textAlign: TextAlign.center,
                    style: isProduct == 2
                        ? AppTextStyle(context).bodyText
                        : AppTextStyle(context).bodyTextSmall,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget tabBarWidgetView() {
    if (isProduct == 0) {
      return productInfo();
    } else if (isProduct == 1) {
      return _buildShippingInfoWidget();
    } else {
      return _buildShopInfoWidget();
    }
  }

  Widget productInfo() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            commonText(
                title: S.of(context).quality,
                data: widget.productDetails.product.quality ?? ""),
            const SizedBox(
              height: 15,
            ),
            commonText(
                title: S.of(context).season,
                data: widget.productDetails.product.season ?? ""),
            const SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .35,
                    child: Text(
                      S.of(context).description,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * .53,
                      child: Html(
                        data: widget.productDetails.product.description,
                      ))
                ],
              ),
            ),
            // Html(
            //   data: widget.productDetails.product.description,
            // )
          ],
        ),
      ),
    );
  }

  Widget commonText({String? title, String? data}) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .35,
          child: Text(
            "${title!}:",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * .53,
          child: Text(
            data ?? "",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildShippingInfoWidget() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            commonText(
              title: S.of(context).estimatedTime,
              data: widget.productDetails.product.shop.estimatedDeliveryTime,
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: colors(context).accentColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "2 - 5 KG",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "25 RON",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopInfoWidget() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0),
        child: Column(
          children: [
            Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: CachedNetworkImage(
                    imageUrl: widget.productDetails.product.shop.logo,
                    width: 70.w,
                    height: 70.h,
                    fit: BoxFit.cover,
                  ),
                ),
                Gap(10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productDetails.product.shop.name,
                      style: AppTextStyle(context)
                          .bodyText
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Gap(5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.star,
                          size: 20,
                          color: EcommerceAppColor.carrotOrange,
                        ),
                        Gap(4.w),
                        Text(
                          "${widget.productDetails.product.shop.rating}/5.0",
                          style: AppTextStyle(context)
                              .bodyText
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewListWidget() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      child: ref.watch(shopControllerProvider)
          ? SizedBox(
              height: 300.h,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SizedBox(
              height:
                  ref.watch(shopControllerProvider.notifier).review.isNotEmpty
                      ? 400.h
                      : null,
              child: ListView.builder(
                controller: reviewScrollController,
                shrinkWrap: true,
                itemCount:
                    ref.watch(shopControllerProvider.notifier).review.length,
                itemBuilder: ((context, index) {
                  final Review review =
                      ref.watch(shopControllerProvider.notifier).review[index];
                  return ReviewCard(review: review);
                }),
              ),
            ),
    );
  }

  // void _toggleTab() {
  //   setState(() {
  //     isProduct = !isProduct;
  //   });
  // }
}
