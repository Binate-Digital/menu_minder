import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../common/enums.dart';
import '../utils/asset_paths.dart';
import 'app_constants.dart';

class RoundedImage extends StatelessWidget {
  final String? image;
  final double? borderWidth;
  final Color? borderColor;
  final double? radius;
  final Color? backgroundColor;
  final ImageType? imageType;
  final double? imageHeight;
  final double? scale;
  const RoundedImage({
    Key? key,
    this.image,
    this.borderWidth,
    this.borderColor,
    this.scale,
    this.radius,
    this.backgroundColor,
    this.imageType = ImageType.TYPE_ASSET,
    this.imageHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imageType == ImageType.TYPE_ASSET
        ? CircleAvatar(
            backgroundColor: borderColor ?? AppColor.THEME_COLOR_SECONDARY,
            radius: radius ?? 50,
            child: Padding(
              padding: borderWidth == null
                  ? const EdgeInsets.all(1.0)
                  : EdgeInsets.all(borderWidth!),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(500),
                child: CircleAvatar(
                  backgroundColor: backgroundColor ?? AppColor.COLOR_RED1,
                  radius: radius != null ? radius! - 2 : 45,
                  child: Image.asset(
                    image ?? AssetPath.CAMERA,
                    color: image != null && image == AssetPath.CAMERA
                        ? Colors.black
                        : null,
                    fit: BoxFit.cover,
                    scale: scale != null
                        ? scale
                        : image != null && image == AssetPath.CAMERA
                            ? 3
                            : 4,
                  ),
                ),
              ),
            ),
          )
        : imageType == ImageType.TYPE_FILE
            ? CircleAvatar(
                backgroundColor: borderColor ?? AppColor.THEME_COLOR_SECONDARY,
                radius: radius ?? 50,
                child: Padding(
                  padding: borderWidth == null
                      ? const EdgeInsets.all(1.0)
                      : EdgeInsets.all(borderWidth!),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(500),
                    child: CircleAvatar(
                        backgroundColor: backgroundColor ?? AppColor.COLOR_RED1,
                        radius: radius != null ? radius! - 2 : 45,
                        child: Image.file(
                          File(image ?? ""),
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Container();
                          },
                        )),
                  ),
                ),
              )
            : CircleAvatar(
                backgroundColor:
                    backgroundColor ?? AppColor.THEME_COLOR_SECONDARY,
                radius: radius ?? 50,
                child: Padding(
                  padding: borderWidth == null
                      ? const EdgeInsets.all(1.0)
                      : EdgeInsets.all(borderWidth!),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(500),
                    child: CircleAvatar(
                        backgroundColor:
                            backgroundColor ?? AppColor.THEME_COLOR_PRIMARY1,
                        radius: radius != null ? radius! - 2 : 45,
                        child: image != null
                            ? Image.network(
                                dotenv.get('IMAGE_URL') + image!,
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                /*  loadingBuilder: (context, child, loadingProgress) =>
                              AppLoader.indicator(), */
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) {
                                  return Container();
                                },
                              )
                            : const SizedBox()),
                  ),
                ),
              );
  }
}
