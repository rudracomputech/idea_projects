import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/services/base/eCommerce/payment_provider_base.dart';
import 'package:ready_ecommerce/utils/api_client.dart';

class PaymentService implements PaymentProviderBase {
  final Ref ref;
  PaymentService(this.ref);
  @override
  Future<Response> orderPayment({
    required int orderId,
    required String paymentMethod,
  }) async {
    final response = await ref
        .read(apiClientProvider)
        .get('${AppConstants.ordePayment}/$orderId/$paymentMethod');
    return response;
  }
}

final paymentServiceProvider = Provider((ref) => PaymentService(ref));
