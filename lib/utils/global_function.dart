import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_constants.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/models/eCommerce/order/order_model.dart';

class GlobalFunction {
  static void changeStatusBarTheme({required isDark}) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void showCustomSnackbar({
    required String message,
    required bool isSuccess,
  }) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      dismissDirection: DismissDirection.startToEnd,
      backgroundColor: isSuccess
          ? colors(navigatorKey.currentState!.context).primaryColor
          : colors(navigatorKey.currentState!.context).errorColor,
      content: Text(message),
    );
    ScaffoldMessenger.of(navigatorKey.currentState!.context)
        .showSnackBar(snackBar);
  }

  static Future<void> pickImageFromGallery({required WidgetRef ref}) async {
    final picker = ImagePicker();
    await picker.pickImage(source: ImageSource.gallery).then((imageFile) {
      if (imageFile != null) {
        ref.read(selectedUserProfileImage.notifier).state = imageFile;
      }
    });
  }

  static String errorText(
      {required String fieldName, required BuildContext context}) {
    return '$fieldName ${S.of(context).isRequired}';
  }

  static String? commonValidator({
    required String value,
    required String hintText,
    required BuildContext context,
  }) {
    if (value.isEmpty) {
      return errorText(fieldName: hintText, context: context);
    }
    return null;
  }

  static String? phoneValidator({
    required String value,
    required String hintText,
    required BuildContext context,
  }) {
    if (value.isEmpty) {
      return errorText(fieldName: hintText, context: context);
    } else if (value.length < 2 || value.length > 20) {
      return 'Please enter a valid $hintText with minimum 2 and maximum 20 characters';
    }
    return null;
  }
    static String? emailValidator({
    required String value,
    required String hintText,
    required BuildContext context,
  }) {
    if (value.isEmpty) {
      return errorText(fieldName: hintText, context: context);
    } 
    return null;
  }


  static String? passwordValidator({
    required String value,
    required String hintText,
    required BuildContext context,
  }) {
    if (value.isEmpty) {
      return errorText(fieldName: hintText, context: context);
    } else if (value.length < 6) {
      return 'Please enter a valid $hintText with at least 6 characters';
    }

    return null;
  }

  static Color getBackgroundColor({required BuildContext context}) {
    return Theme.of(context).scaffoldBackgroundColor == EcommerceAppColor.black
        ? EcommerceAppColor.black
        : EcommerceAppColor.white;
  }

  static Color getContainerColor() {
    bool isDark = Hive.box(AppConstants.appSettingsBox)
        .get(AppConstants.isDarkTheme, defaultValue: false);

    return isDark ? EcommerceAppColor.black : EcommerceAppColor.white;
  }

  static Widget getStatusWidget(
      {required BuildContext context, required String status}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: getStatusWidgetColor(context: context, status: status),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Center(
        child: Text(
          status.toUpperCase()[0] + status.substring(1),
          style: AppTextStyle(context)
              .bodyText
              .copyWith(fontSize: 12.sp, color: EcommerceAppColor.white),
        ),
      ),
    );
  }

  static String formatDeliveryAddress(
      {required BuildContext context, required Address address}) {
    return "${address.addressLine}, ${address.flatNo}, ${address.addressLine2}, ${address.area}-${address.postCode}";
  }

  static Color getStatusWidgetColor(
      {required BuildContext context, required String status}) {
    switch (status.toLowerCase()) {
      case 'pending':
        return EcommerceAppColor.gray;
      case 'confirm':
        return EcommerceAppColor.carrotOrange;
      case 'processing':
        return EcommerceAppColor.blue;
      case 'on the way':
        return EcommerceAppColor.primary;
      case 'delivered':
        return EcommerceAppColor.green;
      default:
        return EcommerceAppColor.red;
    }
  }

  static double getPrice(
      {required double currentPrice, required double discountPrice}) {
    return discountPrice > 0 ? discountPrice : currentPrice;
  }

  static String price(
      {required String currency,
      required String position,
      required String price}) {
    return position == 'prefix' ? '$currency$price' : '$price$currency';
  }
}
