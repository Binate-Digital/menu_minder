import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/primary_button.dart';
import 'package:menu_minder/providers/core_provider.dart';
import 'package:menu_minder/services/location_service.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/view/map/screens/map_screen.dart';
import 'package:menu_minder/view/restraunt_info/screens/restraunt_screen.dart';
import 'package:provider/provider.dart';

import '../../../providers/map_provider.dart';
import '../../../utils/styles.dart';

class NearbyRestrauntScreen extends StatefulWidget {
  const NearbyRestrauntScreen({super.key, this.showDoneButtom = false});
  final bool showDoneButtom;

  @override
  State<NearbyRestrauntScreen> createState() => _NearbyRestrauntScreenState();
}

class _NearbyRestrauntScreenState extends State<NearbyRestrauntScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      handlePermissions();
    });
    super.initState();
  }

  handlePermissions() async {
    // final permission = await LocationService().handleLocationPermission();
    context.read<MapProvider>().updateLocationState(LocationState.loading);
    await LocationService().getCurrentPosition().then((value) {
      if (value != null) {
        context.read<MapProvider>().updateLocationState(LocationState.enabled);
        context.read<MapProvider>().getNearbyRestaurants(
            context,
            LocationService().currentPosition!.latitude,
            LocationService().currentPosition!.longitude);
      } else {
        context.read<MapProvider>().updateLocationState(LocationState.disabled);
      }
    });
  }

  MapProvider? _coreProvider;

  @override
  Widget build(BuildContext context) {
    _coreProvider = context.watch<MapProvider>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppStyles.pinkAppBar(context, "Nearby Restaurant",
          trailing: widget.showDoneButtom
              ? Padding(
                  padding: const EdgeInsets.only(top: 8, right: 10),
                  child: GestureDetector(
                    onTap: () {
                      AppNavigator.popWithData(context,
                          _coreProvider?.currentSelectedRestaurant?.name);
                    },
                    child: Row(
                      children: const [
                        CustomText(
                          text: 'Done',
                          fontColor: AppColor.BG_COLOR,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox()),
      body: Consumer<MapProvider>(builder: (context, val, _) {
        if (val.getLocationState == LocationState.loading) {
          return Center(child: CustomLoadingBarWidget());
        } else {
          return val.getLocationState == LocationState.enabled
              ? Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    MapScreen(
                      markers: val.markers,
                    ),
                    val.currentSelectedRestaurant != null
                        ? InkWell(
                            onTap: () async {
                              final icon = await getBytesFromAsset(
                                  'assets/icons/location_marker.png', 64);
                              // ignore: use_build_context_synchronously
                              AppNavigator.push(
                                  context,
                                  RestrauntInfoScreen(
                                    marker: Marker(
                                        icon: BitmapDescriptor.fromBytes(icon),
                                        // icon: getBytesFromAsset(path, width),
                                        markerId: MarkerId(val
                                            .currentSelectedRestaurant!.name!),
                                        position: LatLng(
                                          val.currentSelectedRestaurant!
                                              .geometry!.location!.lat!,
                                          val.currentSelectedRestaurant!
                                              .geometry!.location!.lng!,
                                        ),
                                        infoWindow: InfoWindow(
                                          title: val
                                              .currentSelectedRestaurant?.name,
                                        )),
                                    restaurantResultData:
                                        val.currentSelectedRestaurant!,
                                  ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColor.COLOR_WHITE,
                                  borderRadius: BorderRadius.circular(10)),
                              margin: const EdgeInsets.fromLTRB(
                                  AppDimen.SCREEN_PADDING,
                                  0,
                                  AppDimen.SCREEN_PADDING,
                                  100),
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              height: 130,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      val.restaurants.first.icon!,
                                      width: 110,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppStyles.height4SizedBox(),
                                        AppStyles.subHeadingStyle(val
                                                .currentSelectedRestaurant
                                                ?.name ??
                                            ''),
                                        // AppStyles.height4SizedBox(),
                                        AppStyles.height4SizedBox(),

                                        // Row(
                                        //   children: [
                                        //     Image.asset(
                                        //       AssetPath.ARROW_METER,
                                        //       scale: 4,
                                        //     ),
                                        //     AppStyles.contentStyle("240m",
                                        //         color: AppColor.THEME_COLOR_PRIMARY1)
                                        //   ],
                                        // ),
                                        // AppStyles.height4SizedBox(),

                                        // const RatingWithReviewsWidget(
                                        //   rating: 12,
                                        //   endText: " Reviews",
                                        // ),
                                        AppStyles.height4SizedBox(),

                                        Expanded(
                                            child: AppStyles.contentStyle(
                                                val.currentSelectedRestaurant
                                                        ?.vicinity ??
                                                    '',
                                                maxLines: 2,
                                                color: AppColor.COLOR_GREY2))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : const SizedBox()
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: CustomText(
                        text:
                            'Error Getting Location Info.\n  please check loaction settings',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 100,
                      child: PrimaryButton(
                          text: 'Retry',
                          onTap: () async {
                            final enabled = await LocationService()
                                .handleLocationPermission();

                            if (enabled) {
                              context
                                  .read<MapProvider>()
                                  .updateLocationState(LocationState.enabled);

                              Future.delayed(Duration(milliseconds: 70), () {
                                context
                                    .read<MapProvider>()
                                    .getNearbyRestaurants(
                                        context,
                                        LocationService()
                                            .currentPosition!
                                            .latitude,
                                        LocationService()
                                            .currentPosition!
                                            .longitude);
                              });
                            } else {
                              context
                                  .read<MapProvider>()
                                  .updateLocationState(LocationState.disabled);
                            }
                          }),
                    ),
                  ],
                );
        }
      }),
    );
  }
}
