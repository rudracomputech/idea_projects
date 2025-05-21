import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomImage extends StatelessWidget {
  final double? width;
  final double? height;
  final String? imagePath;
  final bool? isAssetsImage;
  final double? borderRadius;
  const CustomImage(
      {super.key,
      this.height,
      this.imagePath,
      this.width,
      this.isAssetsImage,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imagePath!,
      imageBuilder: (context, imageProvider) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 0),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
