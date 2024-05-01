import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CustomCarouselSlider extends StatelessWidget {
  final List<String> imageUrls;
  final Function(int index)? onPageChanged;

  const CustomCarouselSlider(
      {super.key, required this.imageUrls, this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 16 / 9, // Adjust the aspect ratio as needed
        viewportFraction: 1.0,
        height: MediaQuery.of(context).size.height / 3.2,
        onPageChanged: (index, reason) {
          onPageChanged?.call(index);
        },

        autoPlay: false,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: false,
      ),
      items: imageUrls.map((imageUrl) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              // margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: ExtendedNetworkImageProvider(
                      imageUrl.startsWith('http')
                          ? imageUrl
                          : dotenv.get('IMAGE_URL') + imageUrl,
                      cache: true),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
