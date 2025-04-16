import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
class CarrouselImg extends StatelessWidget {
  final List<String> imgList;

  const CarrouselImg({super.key, required this.imgList});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        scrollPhysics: const NeverScrollableScrollPhysics(),
        
      ),
      items: imgList.map((item) {
        return InteractiveViewer(
          panEnabled: true, // permite arrastrar
          boundaryMargin: EdgeInsets.all(20),
          minScale: 1.0,
          maxScale: 4.0,
          scaleEnabled: true,
          child: Image.asset(
            item,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          
          
          
        );
      }).toList(),
    );
  }
}

