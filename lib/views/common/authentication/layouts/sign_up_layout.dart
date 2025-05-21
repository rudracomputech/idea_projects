import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/components/ecommerce/app_logo.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_button.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_text_field.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/eCommerce/authentication/authentication_controller.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/models/eCommerce/authentication/sign_up.dart';
import 'package:ready_ecommerce/routes.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';
import 'package:ready_ecommerce/utils/global_function.dart';
import 'package:ready_ecommerce/views/common/authentication/components/country_model_bottom_sheet.dart';
import 'package:ready_ecommerce/views/common/authentication/layouts/confirm_otp_layout.dart';

class SignUpLayout extends StatefulWidget {
  const SignUpLayout({super.key});

  @override
  State<SignUpLayout> createState() => _SignUpLayoutState();
}

class _SignUpLayoutState extends State<SignUpLayout> {
  final List<TextEditingController> controllers = List.generate(
    5,
    (index) => TextEditingController(),
  );

  final List<FocusNode> fNodes = List.generate(5, (i) => FocusNode());

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  bool isChecked = false;

  @override
  void initState() {
    controllers[1].text = "Romania";
    super.initState();
  }

  @override
  void dispose() {
    for (var element in controllers) {
      element.dispose();
    }
    super.dispose();
  }

  String? countryCode = "40";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        bottomNavigationBar: SizedBox(
          height: 60.h,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).alreadyHaveAnAccount,
                  style: AppTextStyle(context).bodyText.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Gap(5.w),
                GestureDetector(
                  onTap: () => context.nav.pop(),
                  child: Text(
                    S.of(context).login,
                    style: AppTextStyle(context).bodyText.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors(context).primaryColor,
                        ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: FormBuilder(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeader(context),
                buildBody(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 60.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
        boxShadow: [
          BoxShadow(
            color: colors(context).accentColor ?? EcommerceAppColor.offWhite,
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(
              0,
              2,
            ),
          )
        ],
      ),
      child: const Center(
        child: AppLogo(
          isAnimation: true,
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w)
          .copyWith(bottom: 20.h, top: 40.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).signUp,
            style: AppTextStyle(context)
                .title
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Gap(20.h),
          Text(
            S.of(context).signUpToContinue,
            style: AppTextStyle(context).bodyText.copyWith(
                color: colors(context).bodyTextSmallColor,
                fontWeight: FontWeight.w500),
          ),
          Gap(20.h),
          CustomTextFormField(
            name: S.of(context).fullName,
            hintText: S.of(context).enFullName,
            textInputType: TextInputType.text,
            controller: controllers[0],
            focusNode: fNodes[0],
            textInputAction: TextInputAction.next,
            validator: (value) => GlobalFunction.commonValidator(
              value: value!,
              hintText: S.of(context).fullName,
              context: context,
            ),
          ),
          Gap(20.h),
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => CountryModelBottomSheet(
                      onChangeCountry: (country) {
                        setState(() {
                          countryCode = country['phone_code'];
                        });

                        return controllers[1].text = country['name'];
                      },
                    ),
                  );
                },
                child: CustomTextFormField(
                  name: 'Country',
                  hintText: 'Country',
                  textInputType: TextInputType.text,
                  controller: controllers[1],
                  focusNode: fNodes[1],
                  textInputAction: TextInputAction.next,
                  validator: (value) => GlobalFunction.commonValidator(
                    value: value!,
                    hintText: 'Country',
                    context: context,
                  ),
                  widget: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  readOnly: true,
                ),
              ),
            ],
          ),
          Gap(20.h),
          Stack(
            children: [
              Text(
                S.of(context).phoneNumber,
                style: AppTextStyle(context)
                    .bodyText
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(top: 30.w),
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border:
                              Border.all(color: colors(context).accentColor!),
                        ),
                        child: Center(
                          child: Text(
                            countryCode ?? '+00',
                            style: AppTextStyle(context).bodyText.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(10.w),
                  Flexible(
                    flex: 7,
                    child: CustomTextFormField(
                      name: '',
                      hintText: S.of(context).enterPhoneNumber,
                      textInputType: TextInputType.phone,
                      controller: controllers[2],
                      focusNode: fNodes[2],
                      textInputAction: TextInputAction.next,
                      validator: (value) => GlobalFunction.phoneValidator(
                        value: value!,
                        hintText: S.of(context).phoneNumber,
                        context: context,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Gap(20.h),
          // CustomTextFormField(
          //   name: 'Email Address',
          //   hintText: S.of(context).enterPhoneNumber,
          //   textInputType: TextInputType.phone,
          //   controller: controllers[3],
          //   focusNode: fNodes[3],
          //   textInputAction: TextInputAction.next,
          //   validator: (value) => GlobalFunction.emailValidator(
          //     value: value!,
          //     hintText: S.of(context).email,
          //     context: context,
          //   ),
          // ),
          Gap(20.h),
          Consumer(builder: (context, ref, _) {
            return CustomTextFormField(
              name: S.of(context).password,
              hintText: S.of(context).createNewPass,
              textInputType: TextInputType.text,
              focusNode: fNodes[4],
              controller: controllers[4],
              textInputAction: TextInputAction.done,
              obscureText: ref.watch(obscureText1),
              widget: IconButton(
                splashColor: Colors.transparent,
                onPressed: () {
                  ref.read(obscureText1.notifier).state =
                      !ref.read(obscureText1);
                },
                icon: Icon(
                  !ref.watch(obscureText1)
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: colors(context).hintTextColor,
                ),
              ),
              validator: (value) => GlobalFunction.passwordValidator(
                value: value!,
                hintText: S.of(context).password,
                context: context,
              ),
            );
          }),
          Gap(24.h),
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 28.w),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: S.of(context).byTapping,
                        style: AppTextStyle(context).bodyText.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                            ),
                      ),
                      TextSpan(
                        text: S.of(context).termAndCondition,
                        style: AppTextStyle(context).bodyText.copyWith(
                              fontWeight: FontWeight.w400,
                              color: colors(context).primaryColor,
                              fontSize: 14.sp,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context.nav
                              .pushNamed(Routes.termsAndConditionsView),
                      ),
                      TextSpan(
                        text: S.of(context).and,
                        style: AppTextStyle(context).bodyText.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                            ),
                      ),
                      TextSpan(
                        text: S.of(context).privacyPolicy,
                        style: AppTextStyle(context).bodyText.copyWith(
                              fontWeight: FontWeight.w400,
                              color: colors(context).primaryColor,
                              fontSize: 14.sp,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () =>
                              context.nav.pushNamed(Routes.privacyPolicyView),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: -14,
                top: -5,
                child: Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                      });
                    }),
              )
            ],
          ),
          Gap(30.h),
          Hero(
            tag: 'otp',
            child: Consumer(builder: (context, ref, _) {
              return ref.watch(authControllerProvider)
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                      buttonText: S.of(context).signUp,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (formKey.currentState!.validate()) {
                          final SingUp singUpInfo = SingUp(
                            name: controllers[0].text,
                            phone: controllers[2].text,
                            password: controllers[4].text,
                            country: controllers[1].text,
                            phoneCode: countryCode ?? '+91',
                            email: controllers[3].text,
                          );
                          if (isChecked) {
                            ref
                                .read(authControllerProvider.notifier)
                                .singUp(singUpInfo: singUpInfo)
                                .then((response) {
                              if (response.isSuccess) {
                                context.nav.pushNamed(
                                  Routes.confirmOTP,
                                  arguments: ConfirmOTPScreenArguments(
                                    phoneNumber: controllers[2].text,
                                    isPasswordRecover: false,
                                  ),
                                );
                              } else {
                                GlobalFunction.showCustomSnackbar(
                                  message:
                                      S.of(context).phoneNumberAlreadyRegister,
                                  isSuccess: false,
                                );
                              }
                            });
                          } else {
                            GlobalFunction.showCustomSnackbar(
                              message: S.of(context).pleaseAccept,
                              isSuccess: false,
                            );
                          }
                        }
                      },
                    );
            }),
          )
        ],
      ),
    );
  }
}
