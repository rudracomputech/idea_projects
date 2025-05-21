import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/models/eCommerce/flash_sales_list_model/running_flash_sale.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product.dart';
import 'package:ready_ecommerce/services/eCommerce/flash_sales/flash_sales_service.dart';

final flashSalesListControllerProvider =
    StateNotifierProvider<FlashSalesListController, bool>((ref) {
  return FlashSalesListController(ref);
});

class FlashSalesListController extends StateNotifier<bool> {
  final Ref ref;
  FlashSalesListController(this.ref) : super(false) {
    getFlashSalesList();
  }
  RunningFlashSale? runningFlashSale;
  Future<void> getFlashSalesList() async {
    try {
      state = true;
      final response =
          await ref.read(flashSalesServiceProvider).getFlashSalesList();
      final data = response.data['data']["running_flash_sale"];
      if (data != null) {
        runningFlashSale = RunningFlashSale.fromMap(data);
      } else {
        runningFlashSale = null;
      }

      state = false;
    } catch (e, stk) {
      state = false;
      debugPrint(e.toString());
      debugPrint(stk.toString());
    }
  }
}

final flashSaleDetailsControllerProvider =
    StateNotifierProvider<FlashSalesDetailsController, bool>((ref) {
  return FlashSalesDetailsController(ref);
});

class FlashSalesDetailsController extends StateNotifier<bool> {
  final Ref ref;
  FlashSalesDetailsController(this.ref) : super(false);
  List<Product> _products = [];
  List<Product> get products => _products;

  Future<void> getFlashSalesDetails({required int id}) async {
    try {
      state = true;
      final response =
          await ref.read(flashSalesServiceProvider).getFlashSalesDetail(id: id);
      final List<dynamic> data = response.data['data']["products"];
      List<dynamic> productData = response.data['data']['products'];
      List<Product> productDataFromModel = [];
      productDataFromModel.addAll(
          productData.map((product) => Product.fromMap(product)).toList());
      for (var data in productDataFromModel) {
        if (data.quantity != 0) {
          _products.add(data);
        }
      }
      state = false;
    } catch (e, stk) {
      state = false;
      debugPrint(e.toString());
      debugPrint(stk.toString());
    }
  }
}
