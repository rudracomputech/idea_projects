import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/models/eCommerce/common/common_response.dart';
import 'package:ready_ecommerce/models/eCommerce/common/product_filter_model.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product_details.dart'
    as product_details;
import 'package:ready_ecommerce/services/eCommerce/product_service/product_service.dart';
import 'package:ready_ecommerce/utils/request_handler.dart';

final selectedColorPriceProvider = StateProvider<double>((ref) => 0);
final selectedSizePriceProvider = StateProvider<double>((ref) => 0);

final productControllerProvider =
    StateNotifierProvider<ProductController, bool>(
        (ref) => ProductController(ref));

class ProductController extends StateNotifier<bool> {
  final Ref ref;
  ProductController(this.ref) : super(false);

  int? _total;
  int? get total => _total;

  List<Product> _products = [];
  List<Product> get products => _products;

  List<Product> _favoriteProducts = [];
  List<Product> get favoriteProducts => _favoriteProducts;

  Future<void> getCategoryWiseProducts({
    required ProductFilterModel productFilterModel,
    required bool isPagination,
  }) async {
    try {
      state = true;
      final response = await ref
          .read(productServiceProvider)
          .getCategoryWiseProducts(productFilterModel: productFilterModel);
      _total = response.data['data']['total'];
      List<dynamic> productData = response.data['data']['products'];

      if (isPagination) {
   

        List<Product> productDataFromModel = [];
        productDataFromModel.addAll(
            productData.map((product) => Product.fromMap(product)).toList());
        for (var data in productDataFromModel) {
          if (data.quantity != 0) {
            _products.add(data);
          }
        }
      } else {


        List<Product> productDataFromModel = [];
        productDataFromModel.addAll(
            productData.map((product) => Product.fromMap(product)).toList());
        for (var data in productDataFromModel) {
          if (data.quantity != 0) {
            _products.add(data);
          }
        }
        // _products =
        //     productData.map((product) => Product.fromMap(product)).toList();
      }

      state = false;
    } catch (error) {
      debugPrint(error.toString());
      state = false;
    }
  }

  Future<CommonResponse> favoriteProductAddRemove({
    required int productId,
  }) async {
    try {
      final response = await ref
          .read(productServiceProvider)
          .favoriteProductAddRemove(productId: productId);
      return CommonResponse(isSuccess: true, message: response.data['message']);
    } catch (error) {
      debugPrint(error.toString());
      return CommonResponse(isSuccess: false, message: error.toString());
    }
  }

  Future<CommonResponse> getFavoriteProducts() async {
    try {
      state = true;
      final response =
          await ref.read(productServiceProvider).getFavoriteProducts();
      List<dynamic> favoriteProductsData = response.data['data']['products'];
      _favoriteProducts = favoriteProductsData
          .map((product) => Product.fromMap(product))
          .toList();
      state = false;
      return CommonResponse(isSuccess: true, message: response.data['message']);
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return CommonResponse(isSuccess: false, message: error.toString());
    }
  }
}

final productDetailsControllerProvider = StateNotifierProvider.family
    .autoDispose<ProductDetailsController,
        AsyncValue<product_details.ProductDetails>, int>((ref, productId) {
  final controller = ProductDetailsController(ref);
  controller.getProductDetails(productId: productId);
  return controller;
});

class ProductDetailsController
    extends StateNotifier<AsyncValue<product_details.ProductDetails>> {
  final Ref ref;
  ProductDetailsController(this.ref) : super(const AsyncLoading());

  Future<void> getProductDetails({required int productId}) async {
    try {
      final response = await ref
          .read(productServiceProvider)
          .getProductDetails(productId: productId);
      final productData = response.data['data'];
      state = AsyncData(product_details.ProductDetails.fromMap(productData));
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      state = AsyncError(
          error is DioException ? ApiInterceptors.handleError(error) : error,
          stackTrace);
      rethrow;
    }
  }
}
