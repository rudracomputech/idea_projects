import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_cart.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_search_field.dart';
import 'package:ready_ecommerce/components/ecommerce/product_not_found.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/eCommerce/product/product_controller.dart';
import 'package:ready_ecommerce/gen/assets.gen.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/models/eCommerce/category/category.dart';
import 'package:ready_ecommerce/models/eCommerce/common/product_filter_model.dart';
import 'package:ready_ecommerce/models/master/master_model.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/views/eCommerce/home/components/product_card.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/filter_modal_bottom_sheet.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/list_product_card.dart';

class EcommerceProductsLayout extends ConsumerStatefulWidget {
  final int? categoryId;
  final String? sortType;
  final String categoryName;
  final int? subCategoryId;
  final String? shopName;
  final List<SubCategory>? subCategories;
  final int? qualityID;
  final int? seasonID;

  const EcommerceProductsLayout({
    Key? key,
    required this.categoryId,
    required this.categoryName,
    required this.sortType,
    this.subCategoryId,
    this.shopName,
    this.subCategories,
    this.qualityID,
    this.seasonID,
  }) : super(key: key);

  @override
  ConsumerState<EcommerceProductsLayout> createState() =>
      _EcommerceProductsLayoutState();
}

class _EcommerceProductsLayoutState
    extends ConsumerState<EcommerceProductsLayout> {
  MasterRes? filterData;
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  bool isHeaderVisible = true;
  bool isList = false;
  int page = 1;
  int perPage = 20;
  List<FilterCategory> filterCategoryList = [
    FilterCategory(id: 0, name: 'All')
  ];
  @override
  void initState() {
    getFilterData();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(productControllerProvider.notifier).products.clear();
      _setSelectedCategory(id: widget.subCategoryId ?? 0);
      _fetchProducts(isPagination: false);
      _setSubCotegory(subCategories: widget.subCategories ?? []);
    });

    scrollController.addListener(_scrollListener);
  }

  getFilterData() async {
    var response = await Dio().get("${AppConstants.baseUrl}/master");
    if (response.statusCode == 200) {
      MasterRes masterRes = MasterRes.fromJson(response.data);
      filterData = masterRes;
    }
  }

  void _scrollListener() {
    if (scrollController.position.userScrollDirection ==
            ScrollDirection.reverse &&
        isHeaderVisible) {
      setState(() => isHeaderVisible = false);
    } else if (scrollController.position.userScrollDirection ==
            ScrollDirection.forward &&
        !isHeaderVisible) {
      setState(() => isHeaderVisible = true);
    }

    if (scrollController.offset >= scrollController.position.maxScrollExtent) {
      _fetchMoreProducts();
    }
  }

  void _fetchProducts({required bool isPagination}) {
    ref.read(productControllerProvider.notifier).getCategoryWiseProducts(
          productFilterModel: ProductFilterModel(
            categoryId: widget.categoryId,
            page: page,
            perPage: perPage,
            seasons: widget.seasonID,
            qualities: widget.qualityID,
            search: searchController.text,
            sortType: widget.sortType,
            subCategoryId: ref.watch(selectedCategory) != 0
                ? ref.watch(selectedCategory)
                : null,
          ),
          isPagination: isPagination,
        );
  }

  void _fetchMoreProducts() {
    final productNotifier = ref.read(productControllerProvider.notifier);
    if (productNotifier.products.length < productNotifier.total! &&
        !ref.watch(productControllerProvider)) {
      page++;
      _fetchProducts(isPagination: true);
    }
  }

  void _setSubCotegory({required List<SubCategory> subCategories}) {
    for (SubCategory category in subCategories) {
      filterCategoryList.add(
        FilterCategory(id: category.id, name: category.name),
      );
    }
  }

  void _setSelectedCategory({required int id}) {
    ref.read(selectedCategory.notifier).state = id;
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor ==
              const Color.fromARGB(255, 1, 1, 2)
          ? colors(context).dark
          : colors(context).accentColor,
      body: Column(
        children: [
          _buildHeaderWidget(context),
          _buildProductsWidget(context),
        ],
      ),
    );
  }

  Widget _buildHeaderWidget(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: GlobalFunction.getContainerColor(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h)
          .copyWith(top: !isHeaderVisible ? 35.h : 50.h),
      child: Column(
        children: [
          if (isHeaderVisible) ...[
            _buildHeaderRow(context),
            Gap(20.h),
          ],
          _buildFilterRow(context),
          Gap(8.h),
          Visibility(
              visible: widget.sortType == null,
              child: Divider(
                  color: colors(context).accentColor, height: 2, thickness: 2)),
          Visibility(
              visible:
                  widget.sortType == null && widget.subCategories!.isNotEmpty,
              child: _buildFilterListWidget()),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLeftRow(context),
        _buildRightRow(context),
      ],
    );
  }

  Widget _buildLeftRow(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => context.nav.pop(context),
            icon: Icon(Icons.arrow_back, size: 26.sp),
          ),
          Gap(16.w),
          Expanded(
            child: Text(
              widget.shopName ?? widget.categoryName,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle(context).subTitle,
            ),
          ),
          Gap(4.w),
        ],
      ),
    );
  }

  Widget _buildRightRow(BuildContext context) {
    return Row(
      children: [
        CustomCartWidget(context: context),
        Gap(16.w),
        GestureDetector(
          onTap: () => _showFilterModal(context),
          child: SvgPicture.asset(Assets.svg.filter, width: 46.sp),
        ),
      ],
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: GlobalFunction.getContainerColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      context: context,
      builder: (_) => FilterModalBottomSheet(
        filetData: filterData!,
        productFilterModel: ProductFilterModel(
          page: 1,
          perPage: 20,
          categoryId: widget.categoryId,
        ),
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 5,
          fit: FlexFit.tight,
          child: CustomSearchField(
            name: 'searchProduct',
            hintText: S.of(context).searchProduct,
            textInputType: TextInputType.text,
            controller: searchController,
            onChanged: (value) {
              page = 1;
              _fetchProducts(isPagination: false);
            },
            widget: Container(
              margin: EdgeInsets.all(10.sp),
              child: SvgPicture.asset(Assets.svg.searchHome),
            ),
          ),
        ),
        // Gap(20.w),
        // GestureDetector(
        //   onTap: () => setState(() => isList = !isList),
        //   child: SvgPicture.asset(isList ? Assets.svg.grid : Assets.svg.list,
        //       width: 26.w),
        // ),
      ],
    );
  }

  Widget _buildFilterListWidget() {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      height: 35.h,
      color: GlobalFunction.getContainerColor(),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filterCategoryList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (searchController.text.isNotEmpty) {
                searchController.clear();
              }
              page = 1;
              if (ref.read(selectedCategory) != filterCategoryList[index].id) {
                _setSelectedCategory(id: filterCategoryList[index].id ?? 0);
                _fetchProducts(isPagination: false);
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                    color: ref.watch(selectedCategory) ==
                            filterCategoryList[index].id
                        ? colors(context).primaryColor!
                        : colors(context).accentColor!),
              ),
              child: Center(
                child: Text(
                    index == 0
                        ? S.of(context).all
                        : filterCategoryList[index].name,
                    style: AppTextStyle(context).bodyTextSmall),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsWidget(BuildContext context) {
    final productController = ref.watch(productControllerProvider.notifier);
    final products = productController.products;

    if (ref.watch(productControllerProvider) && products.isEmpty) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    if (products.isEmpty) {
      return const ProductNotFoundWidget();
    }

    return Flexible(
      flex: 5,
      child: isList
          ? _buildListProductsWidget(context)
          : _buildGridProductsWidget(context),
    );
  }

  Widget _buildListProductsWidget(BuildContext context) {
    final products = ref.watch(productControllerProvider.notifier).products;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      child: AnimationLimiter(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          controller: scrollController,
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: ListProductCard(
                    product: product,
                    onTap: () => context.nav.pushNamed(
                      Routes.getProductDetailsRouteName(
                          AppConstants.appServiceName),
                      arguments: product.id,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGridProductsWidget(BuildContext context) {
    final products = ref.watch(productControllerProvider.notifier).products;

    return AnimationLimiter(
      child: GridView.builder(
        controller: scrollController,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 0.53,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return AnimationConfiguration.staggeredGrid(
            duration: const Duration(milliseconds: 375),
            position: index,
            columnCount: 2,
            child: ScaleAnimation(
              child: ProductCard(
                product: product,
                onTap: () => context.nav.pushNamed(
                  Routes.getProductDetailsRouteName(
                      AppConstants.appServiceName),
                  arguments: product.id,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  final selectedCategory = StateProvider<int>((value) => 0);
}

class FilterCategory {
  final int? id;
  final String name;

  FilterCategory({this.id, required this.name});
}
