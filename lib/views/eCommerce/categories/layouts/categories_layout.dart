import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_search_field.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/controllers/eCommerce/category/category_controller.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/views/eCommerce/categories/components/sub_categories_bottom_sheet.dart';
import 'package:ready_ecommerce/views/eCommerce/home/components/category_card.dart';
import 'package:ready_ecommerce/views/eCommerce/products/layouts/product_details_layout.dart';

class EcommerceCategoriesLayout extends ConsumerWidget {
  const EcommerceCategoriesLayout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController categorySearchController = TextEditingController();
    int columnCount = 4;
    bool isDark =
        Theme.of(context).scaffoldBackgroundColor == EcommerceAppColor.black;
    return LoadingWrapperWidget(
      isLoading: ref.watch(subCategoryControllerProvider),
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('All Categories'),
        //   toolbarHeight: 80.h,
        // ),
        backgroundColor:
            isDark ? EcommerceAppColor.black : EcommerceAppColor.white,
        body: Consumer(
          builder: (context, ref, _) {
            final asyncValue = ref.watch(categoryControllerProvider);
            return asyncValue.when(
              data: (categoryList) => AnimationLimiter(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.refresh(categoryControllerProvider).value;
                  },
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                            ),
                            child: GestureDetector(
                                onTap: () {
                                  context.nav.pushNamedAndRemoveUntil(
                                    Routes.getCoreRouteName(
                                        AppConstants.appServiceName),
                                    (route) => false,
                                  );
                                },
                                child: Icon(Icons.arrow_back_ios)),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .86,
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: 10.w,
                              ),
                              child: CustomSearchField(
                                name: 'product_search',
                                hintText: S.of(context).searchProduct,
                                textInputType: TextInputType.text,
                                controller: categorySearchController,
                                widget: Container(
                                  margin: EdgeInsets.all(10.sp),
                                  child:
                                      SvgPicture.asset(Assets.svg.searchHome),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      // Container(
                      //   margin: EdgeInsets.symmetric(
                      //     horizontal: 10.w,
                      //   ),
                      //   height: 45,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(10.r),
                      //     border: Border.all(
                      //       width: 1,
                      //       color: isDark
                      //           ? EcommerceAppColor.white
                      //           : EcommerceAppColor.black,
                      //     ),
                      //   ),
                      //   alignment: Alignment.center,
                      //   width: MediaQuery.of(context).size.width,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Text(
                      //         'Filtrele Mele',
                      //         style: TextStyle(
                      //           fontSize: 17,
                      //           fontWeight: FontWeight.w500,
                      //           color: isDark
                      //               ? EcommerceAppColor.white
                      //               : EcommerceAppColor.black,
                      //         ),
                      //       ),
                      //       const SizedBox(
                      //         width: 10,
                      //       ),
                      //       Icon(
                      //         Icons.arrow_forward,
                      //         size: 15,
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 20.h,
                      // ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 10.h),
                        child: Text(
                          S.of(context).allCategories,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? EcommerceAppColor.white
                                : EcommerceAppColor.black,
                          ),
                        ),
                      ),
                      ListView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 0.h),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: categoryList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            columnCount: columnCount,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: CategoryCard(
                                    category: categoryList[index],
                                    // TODO need to work here
                                    onTap: () {
                                      if (categoryList[index]
                                          .subCategories
                                          .isNotEmpty) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SubCategoriesBottomSheet(
                                              category: categoryList[index],
                                            ),
                                          ),
                                        );
                                        // showModalBottomSheet(
                                        //   context: context,
                                        //   builder: (context) =>
                                        //       SubCategoriesBottomSheet(
                                        //     category: categoryList[index],
                                        //   ),
                                        // );
                                      } else {
                                        GlobalFunction
                                            .navigatorKey.currentContext!.nav
                                            .pushNamed(
                                          Routes.getProductsViewRouteName(
                                            AppConstants.appServiceName,
                                          ),
                                          arguments: [
                                            categoryList[index].id,
                                            categoryList[index].name,
                                            null,
                                            null,
                                            null,
                                            categoryList[index].subCategories,
                                          ],
                                        );
                                      }
                                    }),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              error: (error, stackTrace) => Center(
                child: Text(
                  error.toString(),
                ),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}
