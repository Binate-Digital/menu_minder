import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/rating_with_reviews_widget.dart';
import 'package:menu_minder/providers/map_provider.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/asset_paths.dart';
import 'package:menu_minder/utils/constants.dart';
import 'package:menu_minder/utils/dummy.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/hotel_map_view/screens/hotel_map_screen.dart';
import 'package:menu_minder/view/map/screens/map_screen.dart';
import 'package:menu_minder/view/restraunt_info/data/restaurant_model.dart';
import 'package:menu_minder/view/restraunt_info/data/single_place_detail.dart';
import 'package:menu_minder/view/restraunt_menu/screens/restraunt_menu_screen.dart';
import 'package:provider/provider.dart';
import '../../../common/primary_button.dart';
import '../../restraunt_reviews/screens/reviews_screen.dart';
import '../widgets/review_widget.dart';

class RestrauntInfoScreen extends StatefulWidget {
  const RestrauntInfoScreen(
      {super.key, required this.restaurantResultData, required this.marker});
  final RestaurantResultData restaurantResultData;
  final Marker marker;

  @override
  State<RestrauntInfoScreen> createState() => _RestrauntInfoScreenState();
}

class _RestrauntInfoScreenState extends State<RestrauntInfoScreen> {
  Set<Marker> makr = {};

  String getGooglePlacesPhotoUrl(String photoReference) {
    // Replace YOUR_API_KEY with your actual Google API key

    String apiKey = Constants.MAP_KEY;
    final photo =
        "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoReference&key=$apiKey";
    return photo;
  }

  @override
  void initState() {
    print("PLACE ID ${widget.restaurantResultData.placeId}");
    makr.add(widget.marker);

    context.read<MapProvider>().mapController?.animateCamera(
        CameraUpdate.newLatLng(LatLng(
            widget.restaurantResultData.geometry!.location!.lat!,
            widget.restaurantResultData.geometry!.location!.lng!)));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<MapProvider>()
          .getPlaceDetails(context, widget.restaurantResultData.placeId!);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppStyles.appBar("Restaurant", () {
        AppNavigator.pop(context);
      }),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Consumer<MapProvider>(builder: (context, val, _) {
          print(widget.restaurantResultData.photos?.first.photoReference);

          if (val.placeLoadState == States.loading) {
            return const CustomLoadingBarWidget();
          } else if (val.placeLoadState == States.failure) {
            return const CustomText(
              text: 'No Details Found',
            );
          } else if (val.placeLoadState == States.success) {
            return val.placeDetail?.result != null
                ? SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image.asset(
                        //   AssetPath.FOOD2,
                        //   height: 280,
                        //   fit: BoxFit.cover,
                        // ),

                        val.placeDetail?.result?.photos != null &&
                                val.placeDetail!.result!.photos!.isNotEmpty
                            ? Stack(
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2.5,
                                      child: Image.network(
                                        getGooglePlacesPhotoUrl(
                                          val.placeDetail!.result!.photos!.first
                                              .photoReference!,
                                        ),
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                              child: Image.asset(AssetPath
                                                  .PHOTO_PLACE_HOLDER));
                                        },
                                      )),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        .12,
                                    decoration: BoxDecoration(
                                        color: AppColor.COLOR_BLACK
                                            .withOpacity(.3)),
                                  ),
                                ],
                              )
                            : Stack(
                                children: [
                                  Image.asset(
                                    AssetPath.PHOTO_PLACE_HOLDER,
                                    height: MediaQuery.of(context).size.height /
                                        2.5,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        .12,
                                    decoration: BoxDecoration(
                                        color: AppColor.COLOR_BLACK
                                            .withOpacity(.3)),
                                  ),
                                ],
                              ),
                        Padding(
                          padding: AppStyles.screenPadding(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppStyles.headingStyle(
                                  val.placeDetail?.result?.name ?? '',
                                  fontWeight: FontWeight.w500),
                              AppStyles.height4SizedBox(),
                              RatingWithReviewsWidget(
                                rating: widget.restaurantResultData.rating,
                                endText: " Reviews",
                                isIgnoreGesture: true,
                              ),
                              // AppStyles.height16SizedBox(),

                              val.placeDetail?.result?.openingHours != null
                                  ? Column(
                                      children: [
                                        val.placeDetail!.result!.openingHours!
                                                .openNow!
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8),
                                                child: AppStyles.contentStyle(
                                                  'Open Now',
                                                  color: AppColor
                                                      .THEME_COLOR_SECONDARY,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8),
                                                child: AppStyles.contentStyle(
                                                  'Closed Now',
                                                  color: AppColor
                                                      .THEME_COLOR_PRIMARY1,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ],
                                    )
                                  : SizedBox(),

                              AppStyles.height16SizedBox(),

                              // widget.restaurantResultData.openingHours!.openNow!
                              //     ? AppStyles.contentStyle("Open . ${val.placeDetail.result.currentOpeningHours.}")
                              //     : const SizedBox(),

                              ...List.generate(
                                  val.placeDetail?.result?.openingHours
                                          ?.weekdayText?.length ??
                                      0, (index) {
                                final day = val.placeDetail?.result
                                    ?.openingHours?.weekdayText?[index];

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 10,
                                        width: 10,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                AppColor.THEME_COLOR_SECONDARY),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      CustomText(
                                        text: day,
                                      ),
                                    ],
                                  ),
                                );
                              }),

                              // AppStyles.contentStyle(val.placeDetail.result.openingHours.weekdayText.toString() ?? ''),
                              AppStyles.height16SizedBox(),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 110,
                                    child: PrimaryButton(
                                        // textPadding: EdgeInsets.zero,
                                        // isPadded: false,
                                        text: "Direction",
                                        height: 40,
                                        imagePath: AssetPath.DIRECTION,
                                        onTap: () {
                                          AppNavigator.push(
                                              context,
                                              HotelMapScreen(
                                                placeDetail: val.placeDetail!,
                                              ));
                                        }),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  // SizedBox(
                                  //   width: 110,
                                  //   child: PrimaryButton(
                                  //     text: "Menu",
                                  //     onTap: () {
                                  //       AppNavigator.push(context,
                                  //           const RestrauntMenuScren());
                                  //     },
                                  //     height: 40,
                                  //   ),
                                  // ),
                                ],
                              ),
                              AppStyles.height16SizedBox(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                      AssetPath.ARROW_METER,
                                      // scale: 4,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                      child: AppStyles.contentStyle(
                                          val.placeDetail?.result
                                                  ?.formattedAddress ??
                                              '',
                                          color: AppColor.COLOR_GREY2))
                                ],
                              ),
                              AppStyles.height8SizedBox(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset(
                                      AssetPath.PHONE,
                                      color: AppColor.THEME_COLOR_PRIMARY1,
                                      scale: 4,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                      child: AppStyles.contentStyle(
                                          val.placeDetail?.result
                                                  ?.internationalPhoneNumber ??
                                              '',
                                          color: AppColor.COLOR_GREY2))
                                ],
                              ),
                              AppStyles.height16SizedBox(),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                    height: 120,
                                    child: MapScreen(
                                      markers: makr,
                                      inittialPosition: CameraPosition(
                                          zoom: 15,
                                          target: LatLng(
                                              widget.restaurantResultData
                                                  .geometry!.location!.lat!,
                                              widget.restaurantResultData
                                                  .geometry!.location!.lng!)),
                                      absorbPointer: false,
                                    )),
                              ),
                              AppStyles.height16SizedBox(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppStyles.headingStyle("Reviews",
                                      fontWeight: FontWeight.bold),
                                  val.placeDetail?.result?.reviews != null
                                      ? PrimaryButton(
                                          text: "View All",
                                          height: 40,
                                          onTap: () {
                                            AppNavigator.push(
                                                context,
                                                ReviewsScreen(
                                                  place: val.placeDetail!,
                                                ));
                                          },
                                        )
                                      : const CustomText(
                                          text: 'No Reviews Found',
                                        )
                                ],
                              ),
                              val.placeDetail?.result?.reviews != null
                                  ? Column(
                                      children: [
                                        ...List.generate(
                                            (val.placeDetail?.result?.reviews
                                                            ?.length ??
                                                        0) >
                                                    3
                                                ? 3
                                                : val.placeDetail!.result!
                                                    .reviews!.length,
                                            (index) => ReviewsWidget(
                                                reviews: val.placeDetail!
                                                    .result!.reviews![index]))
                                      ],
                                    )
                                  : SizedBox()
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : CustomText(
                    text: 'No Data Found',
                  );
          }

          return const SizedBox();
        }),
      ),
    );
  }
}
