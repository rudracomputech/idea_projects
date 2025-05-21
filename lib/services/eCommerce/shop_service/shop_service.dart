import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/models/eCommerce/common/product_filter_model.dart';
import 'package:ready_ecommerce/services/base/eCommerce/shop_provider_base.dart';
import 'package:ready_ecommerce/utils/api_client.dart';

class ShopService implements ShopProviderBase {
  final Ref ref;
  ShopService(this.ref);
  @override
  Future<Response> getShops({required int page, required int perPage}) async {
    final Map<String, dynamic> queryParams = {};
    queryParams['page'] = page;
    queryParams['per_page'] = perPage;
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstants.getShops, query: queryParams);
    return response;
  }

  @override
  Future<Response> getShopDetails({required int shopId}) async {
    final response = await ref
        .read(apiClientProvider)
        .get("${AppConstants.getShops}/$shopId");
    return response;
  }

  @override
  Future<Response> getProducts(
      {required ProductFilterModel productFilterModel}) async {
    final response = await ref.read(apiClientProvider).get(
      AppConstants.getProducts,
      query: {
        "page": productFilterModel.page,
        "per_page": productFilterModel.perPage,
        "search": productFilterModel.search,
        "shop_id": productFilterModel.shopId,
      },
    );
    return response;
  }

  @override
  Future<Response> getShopCategories({required int shopId}) async {
    final Map<String, dynamic> query = {};
    query['shop_id'] = shopId;
    final response = await ref
        .watch(apiClientProvider)
        .get(AppConstants.getShopCategiries, query: query);
    return response;
  }

  @override
  Future<Response> getShopReviews(
      {required ProductFilterModel productFilterModel}) async {
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstants.getReviews, query: productFilterModel.toMap());
    return response;
  }
}

final shopServiceProvider = Provider((ref) => ShopService(ref));
