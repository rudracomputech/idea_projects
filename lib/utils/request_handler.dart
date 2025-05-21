import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/global_function.dart';

class ApiInterceptors {
  static void addInterceptors(Dio dio) {
    dio.options.connectTimeout = const Duration(seconds: 20);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Content-Type'] = 'application/json';
    _addLoggerInterceptor(dio);
    _addResponseHandlerInterceptor(dio);
  }

  static void _addLoggerInterceptor(Dio dio) {
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ));
  }

  static void _addResponseHandlerInterceptor(Dio dio) {
    dio.interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) {
        handler.next(response); // Forward the response
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          _handleUnauthorized();
        } else {
          handleError(error);
        }
        handler.reject(error); // Forward the error
      },
    ));
  }

  static String handleError(DioException exception) {
    String errorMessage;
    switch (exception.type) {
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Receive time out!';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = 'Send time out!';
        break;
      case DioExceptionType.badResponse:
        errorMessage =
            'Bad response! Error code: ${exception.response?.statusCode}';
        break;
      case DioExceptionType.badCertificate:
        errorMessage = 'Bad Certificate response!';
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request was cancelled!';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'Connection error! Please check your internet.';
        break;
      case DioExceptionType.unknown:
        errorMessage = 'An unknown error occurred';
        break;
      default:
        errorMessage = 'An unexpected error occurred';
    }
    GlobalFunction.showCustomSnackbar(
      message: errorMessage,
      isSuccess: false,
    );
    return errorMessage;
  }

  static void _handleUnauthorized() {
    GlobalFunction.showCustomSnackbar(
      message: 'Unauthorized',
      isSuccess: false,
    );
    Box authBox = Hive.box(AppConstants.authBox);
    authBox.delete(AppConstants.authToken);
    GlobalFunction.navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(Routes.login, (route) => false);
  }
}
