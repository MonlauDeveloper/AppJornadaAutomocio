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
      ),
      items: imgList.map((item) {
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                insetPadding: EdgeInsets.zero, // Elimina el padding por defecto
                backgroundColor: Colors.transparent, // Fondo transparente
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.98, // 98% del ancho
                  height: MediaQuery.of(context).size.height * 0.9, // 90% del alto
                  decoration: BoxDecoration(
                    color: Colors.white, // Fondo negro para el visor
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      InteractiveViewer(
                        panEnabled: true,
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: Center(
                          child: Image.asset(
                            item,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.black),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          child: ClipRRect(
            child: Image.asset(
              item,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        );
      }).toList(),
    );
  }
}