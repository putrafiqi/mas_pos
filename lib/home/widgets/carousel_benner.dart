import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:mas_pos/common/common.dart';
import 'package:mas_pos/home/home.dart';

class CaroulselBenner extends StatelessWidget {
  const CaroulselBenner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(16),
        child: FlutterCarousel(
          items: [
            CarouseltemBanner(imageUrl: AssetString.carousel1),
            CarouseltemBanner(imageUrl: AssetString.carousel2),
            CarouseltemBanner(imageUrl: AssetString.carousel3),
          ],
          options: FlutterCarouselOptions(
            aspectRatio: 16 / 7,
            enlargeCenterPage: true,
            enlargeFactor: 0.01,
            enableInfiniteScroll: true,
            clipBehavior: Clip.hardEdge,
          ),
        ),
      ),
    );
  }
}
