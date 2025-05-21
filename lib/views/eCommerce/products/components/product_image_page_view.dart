// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product_details.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/video_player_screen.dart';

class ProductImagePageView extends ConsumerStatefulWidget {
  final ProductDetails productDetails;
  const ProductImagePageView({
    super.key,
    required this.productDetails,
  });

  @override
  ConsumerState<ProductImagePageView> createState() =>
      _ProductImagePageViewState();
}

class _ProductImagePageViewState extends ConsumerState<ProductImagePageView> {
  List imageData = [];
  PageController pageController = PageController();
  @override
  void initState() {
    getImageData();
    // ignore: unused_result
    ref.refresh(currentPageController);
    pageController.addListener(() {
      int? newPage = pageController.page?.round();
      if (newPage != ref.read(currentPageController)) {
        setState(() {
          ref.read(currentPageController.notifier).state = newPage!;
        });
      }
    });
    super.initState();
  }

  getImageData() {
    if (widget.productDetails.product.thumbnails.isNotEmpty) {
      for (int i = 0;
          i < widget.productDetails.product.thumbnails.length;
          i++) {
        imageData.add({
          "isImage": true,
          "image": widget.productDetails.product.thumbnails[i].thumbnail
        });
      }
    }
    if (widget.productDetails.product.videos.isNotEmpty) {
      for (int i = 0; i < widget.productDetails.product.videos.length; i++) {
        imageData.add({
          "isImage": false,
          "image": widget.productDetails.product.videos[i].thumbnail,
          "video": widget.productDetails.product.videos[i].video
        });
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 460.h,
          width: MediaQuery.of(context).size.width,
          child: PageView.builder(
            controller: pageController,
            itemCount: imageData.length,
            itemBuilder: (context, index) {
              return (imageData[index]["isImage"] == true)
                  ? CachedNetworkImage(
                      imageUrl: imageData[index]["image"],
                      fit: BoxFit.fitHeight,
                    )
                  : Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerScreen(
                                  thumbnailImage: imageData[index]["image"],
                                  videoPath: imageData[index]["video"],
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 460.h,
                            width: MediaQuery.of(context).size.width,
                            child: CachedNetworkImage(
                              imageUrl: imageData[index]["image"],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        if (imageData[index]["isImage"] == false) ...[
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VideoPlayerScreen(
                                      thumbnailImage: imageData[index]["image"],
                                      videoPath: imageData[index]["video"],
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.grey[100],
                                size: 75.0,
                                semanticLabel: 'Play',
                              ),
                              //  Container(
                              //   height: 60,        
                              //   width: 60,
                              //   alignment: Alignment.center,
                              //   decoration: BoxDecoration(
                              //     shape: BoxShape.circle,
                              //     color: Colors.grey[800],
                              //   ),
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(left: 5),
                              //     child: FaIcon(
                              //       FontAwesomeIcons.play,
                              //       color: Colors.white,
                              //       size: 35,
                              //     ),
                              //   ),
                              // ),
                            ),
                          )
                        ]
                      ],
                    );
            },
          ),
        ),
        Positioned(
          bottom: 16.h,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: EcommerceAppColor.lightGray,
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(
                widget.productDetails.product.thumbnails.length +
                    widget.productDetails.product.videos.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color:
                        ref.read(currentPageController.notifier).state == index
                            ? colors(context).light
                            : colors(context).accentColor!.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30.sp),
                  ),
                  height: 8.h,
                  width: 8.w,
                ),
              ).toList(),
            ),
          ),
        )
      ],
    );
  }
}
