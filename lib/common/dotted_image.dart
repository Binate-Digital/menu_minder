import 'package:dotted_border/dotted_border.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../utils/app_constants.dart';
import '../utils/asset_paths.dart';

class DottedImage extends StatelessWidget {
  DottedImage({
    super.key,
    this.color,
    this.radius = 20,
    this.netWorkUrl,
    this.fullUrl,
  });

  double? radius;
  Color? color;
  final String? netWorkUrl;
  final String? fullUrl;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: color ?? AppColor.THEME_COLOR_SECONDARY,
      borderType: BorderType.Circle,
      radius: const Radius.circular(200),
      dashPattern: const [4, 4],
      strokeWidth: 2,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: fullUrl != null
            ? NetworkImage(fullUrl!)
            : netWorkUrl != null && netWorkUrl != ""
                ? ExtendedNetworkImageProvider(
                    dotenv.get('IMAGE_URL') + netWorkUrl!,
                  ) as ImageProvider
                : null,
        backgroundColor: color ?? AppColor.THEME_COLOR_SECONDARY,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: fullUrl != null || netWorkUrl != null && netWorkUrl != ""
              ? const SizedBox()
              : Image.asset(AssetPath.PROFILE),
        ),
      ),
    );
  }
}
