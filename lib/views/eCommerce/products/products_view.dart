import 'package:flutter/material.dart';
import 'package:ready_ecommerce/models/eCommerce/category/category.dart';
import 'package:ready_ecommerce/views/eCommerce/products/layouts/products_layout.dart';

class EcommerceProductsView extends StatelessWidget {
  final int? categoryId;
  final String categoryName;
  final String? sortType;
  final int? subCategoryId;
  final String? shopName;
  final List<SubCategory>? subCategories;
  const EcommerceProductsView({
    Key? key,
    required this.categoryId,
    required this.categoryName,
    required this.sortType,
    this.subCategoryId,
    this.shopName,
    this.subCategories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EcommerceProductsLayout(
      categoryId: categoryId,
      categoryName: categoryName,
      sortType: sortType,
      subCategoryId: subCategoryId,
      shopName: shopName,
      subCategories: subCategories,
    );
  }
}
