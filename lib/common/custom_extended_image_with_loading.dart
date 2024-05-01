import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:menu_minder/utils/app_constants.dart';

class MyCustomExtendedImage extends StatelessWidget {
  final String imageUrl;

  const MyCustomExtendedImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      imageUrl,
      fit: BoxFit.cover,
      handleLoadingProgress: true,
      clearMemoryCacheIfFailed: true,
      clearMemoryCacheWhenDispose: false,
      cache: true,
      
      loadStateChanged: (ExtendedImageState state) {
        if (state.extendedImageLoadState == LoadState.loading) {
          final ImageChunkEvent? loadingProgress = state.loadingProgress;
          final double? progress = loadingProgress?.expectedTotalBytes != null
              ? loadingProgress!.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: SizedBox(
                    // width: 150.0,
                    child: CircularProgressIndicator(
                      value: progress,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColor.THEME_COLOR_PRIMARY1),
                      backgroundColor:
                          AppColor.THEME_COLOR_PRIMARY1.withOpacity(.2),
                    ),
                  ),
                ),

                // const SizedBox(
                //   height: 10.0,
                // ),
                // Text('${((progress ?? 0.0) * 100).toInt()}%'),
              ],
            ),
          );
        }
        return null;
      },
    );
  }
}
