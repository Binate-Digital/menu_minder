import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:menu_minder/utils/network_strings.dart';
import '../../../utils/asset_paths.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({
    super.key,
  });

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  // TODO: replace this test ad unit with your own ad unit.
  final adUnitId = Platform.isAndroid
      ? NetworkStrings.BANNER_ADD_ID_ANDROID_TEST
      : NetworkStrings.BANNER_ADD_ID_IOS_TEST;

  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.largeBanner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadAd();
    });
    super.initState();
  }

  List<String> images = [
    AssetPath.FOOD1,
    AssetPath.FOOD2,
  ];
  @override
  Widget build(BuildContext context) {
    return _bannerAd != null && _isLoaded
        ? Align(
            alignment: Alignment.center,
            child: SafeArea(
              child: SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
          )
        : const SizedBox();

    //     CarouselSlider(
    //   options: CarouselOptions(
    //       height: 150, enlargeCenterPage: false, autoPlay: true),
    //   items: images.map((imagesPath) {
    //     return Container(
    //       margin: const EdgeInsets.only(right: 10),
    //       child: Builder(
    //         builder: (BuildContext context) {
    //           return ClipRRect(
    //             borderRadius: BorderRadius.circular(10),
    //             child: Stack(
    //               children: [
    //                 Image.asset(
    //                   imagesPath,
    //                   fit: BoxFit.cover,
    //                   width: double.infinity,
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.all(12.0),
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     mainAxisSize: MainAxisSize.max,
    //                     children: [
    //                       AppStyles.headingStyle("Upto 20% OFF",
    //                           color: AppColor.COLOR_WHITE,
    //                           fontWeight: FontWeight.w700),
    //                       AppStyles.height20SizedBox(),
    //                       Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         mainAxisSize: MainAxisSize.min,
    //                         children: [
    //                           AppStyles.headingStyle("In - app ads",
    //                               color: AppColor.COLOR_WHITE),
    //                           AppStyles.height8SizedBox(),
    //                           SizedBox(
    //                             width: 200,
    //                             child: AppStyles.contentStyle(LOREMSMALL,
    //                                 // fontSize: 12,
    //                                 color: AppColor.COLOR_WHITE,
    //                                 maxLines: 2),
    //                           ),
    //                         ],
    //                       ),
    //                     ],
    //                   ),
    //                 )
    //               ],
    //             ),
    //           );
    //         },
    //       ),
    //     );
    //   }).toList(),
    // );
  }
}
