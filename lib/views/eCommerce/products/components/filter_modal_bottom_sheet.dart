// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_ecommerce/components/ecommerce/custom_button.dart';
import 'package:ready_ecommerce/config/app_text_style.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/eCommerce/product/product_controller.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/generated/l10n.dart';
import 'package:ready_ecommerce/models/eCommerce/common/product_filter_model.dart';
import 'package:ready_ecommerce/models/master/master_model.dart';
import 'package:ready_ecommerce/utils/context_less_navigation.dart';

// ignore: must_be_immutable
class FilterModalBottomSheet extends ConsumerStatefulWidget {
  ProductFilterModel productFilterModel;
  MasterRes filetData;
  FilterModalBottomSheet({
    Key? key,
    required this.productFilterModel,
    required this.filetData,
  }) : super(key: key);

  @override
  ConsumerState<FilterModalBottomSheet> createState() =>
      _FilterModalBottomSheetState();
}

class _FilterModalBottomSheetState
    extends ConsumerState<FilterModalBottomSheet> {
  final EdgeInsets _edgeInsets =
      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h)
          .copyWith(bottom: 20.h);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _edgeInsets,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Gap(10.h),
          _buildCustomerReviewSection(),
          Gap(20.h),
          _buildSortSection(),
          Gap(20.h),
          _buildProductPriceSection(),
          Gap(30.h),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          S.of(context).filter,
          style: AppTextStyle(context).subTitle,
        ),
        IconButton(
          onPressed: () {
            _onPressClear();
            Navigator.pop(context);
            // context!.nav.pop();
          },
          icon: const Icon(Icons.close),
        )
      ],
    );
  }

  Widget _buildCustomerReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).size,
          style: AppTextStyle(context)
              .bodyText
              .copyWith(fontWeight: FontWeight.w600),
        ),
        Gap(8.h),
        _buildReviewChips(),
      ],
    );
  }

  Widget _buildReviewChips() {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 8.0,
      runSpacing: 8.0,
      children: List.generate(
        widget.filetData.data!.sizes!.length,
        (index) => Material(
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
          color: ref.watch(selectedSizeIndex) ==
                  widget.filetData.data!.sizes![index].id
              ? colors(context).primaryColor
              : Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8.r),
            onTap: () {
              ref.read(selectedSizeIndex.notifier).state =
                  widget.filetData.data!.sizes![index].id;
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
              width: 50.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: colors(context).accentColor!),
              ),
              alignment: Alignment.center,
              child: Text(
                "${widget.filetData.data!.sizes![index].name.toString()} KG",
                style: AppTextStyle(context).bodyText.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ref.watch(selectedSizeIndex) ==
                              widget.filetData.data!.sizes![index].id
                          ? colors(context).light
                          : null,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSortSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).season,
          style: AppTextStyle(context)
              .bodyText
              .copyWith(fontWeight: FontWeight.w600),
        ),
        Gap(10.h),
        _buildSortChips(),
      ],
    );
  }

  Widget _buildSortChips() {
    return Wrap(
      children: List.generate(
        widget.filetData.data!.seasons!.length,
        (index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: ChoiceChip(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: colors(context).accentColor!)),
            backgroundColor: colors(context).accentColor,
            disabledColor: colors(context).light,
            labelStyle: TextStyle(
              color: ref.watch(selectedSeasonIndex) ==
                      widget.filetData.data!.seasons![index].id
                  ? colors(context).light
                  : null,
            ),
            label: Text(
              widget.filetData.data!.seasons![index].name.toString(),
            ),
            selectedColor: colors(context).primaryColor,
            surfaceTintColor: colors(context).light,
            checkmarkColor: colors(context).light,
            selected: ref.watch(selectedSeasonIndex) ==
                widget.filetData.data!.seasons![index].id,
            onSelected: (bool selected) {
              ref.watch(selectedSeasonIndex.notifier).state =
                  widget.filetData.data!.seasons![index].id;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProductPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).quality,
          style: AppTextStyle(context)
              .bodyText
              .copyWith(fontWeight: FontWeight.w600),
        ),
        Gap(20.h),
        _buildPriceSlider(),
      ],
    );
  }

  Widget _buildPriceSlider() {
    return Wrap(
      children: List.generate(
        widget.filetData.data!.qualities!.length,
        (index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: ChoiceChip(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: colors(context).accentColor!)),
            backgroundColor: colors(context).accentColor,
            disabledColor: colors(context).light,
            labelStyle: TextStyle(
              color: ref.watch(selectedQuantityIndex) ==
                      widget.filetData.data!.qualities![index].id
                  ? colors(context).light
                  : null,
            ),
            label: Text(
              widget.filetData.data!.qualities![index].name.toString(),
            ),
            selectedColor: colors(context).primaryColor,
            surfaceTintColor: colors(context).light,
            checkmarkColor: colors(context).light,
            selected: ref.watch(selectedQuantityIndex) ==
                widget.filetData.data!.qualities![index].id,
            onSelected: (bool selected) {
              ref.watch(selectedQuantityIndex.notifier).state =
                  widget.filetData.data!.qualities![index].id;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: InkWell(
            borderRadius: BorderRadius.circular(50.r),
            onTap: () => _onPressClear(),
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  border: Border.all(color: colors(context).accentColor!)),
              child: Center(
                child: Text(
                  S.of(context).clear,
                  style: AppTextStyle(context).bodyText.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ),
          ),
        ),
        Gap(20.w),
        Flexible(
          flex: 1,
          child: Consumer(builder: (context, ref, _) {
            return CustomButton(
              buttonText: S.of(context).apply,
              onPressed: _onPressFilter,
            );
          }),
        ),
      ],
    );
  }

  void _onPressFilter() {
    ref.read(productControllerProvider.notifier).getCategoryWiseProducts(
          productFilterModel: widget.productFilterModel.copyWith(
            size: ref.read(selectedSizeIndex) != null
                ? ref.read(selectedSizeIndex)!.toInt()
                : null,
            qualities: ref.read(selectedQuantityIndex) != null
                ? ref.read(selectedQuantityIndex)!.toInt()
                : null,
            seasons: ref.read(selectedSeasonIndex) != null
                ? ref.read(selectedSeasonIndex)!.toInt()
                : null,
            minPrice: ref.read(selectedMinPrice).toInt(),
            maxPrice: ref.read(selectedMaxPrice).toInt(),
          ),
          isPagination: false,
        );
    context.nav.pop();
  }

  void _onPressClear() {
    ref.refresh(selectedReviewIndex.notifier).state;
    ref.refresh(selectedSeasonIndex.notifier).state;
    ref.refresh(selectedSizeIndex.notifier).state;
    ref.refresh(selectedMaxPrice.notifier).state;
    ref.refresh(selectedMinPrice.notifier).state;
    ref.refresh(selectedQuantityIndex.notifier).state;
  }
}
