import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:math';

class SKCarousel extends CarouselSlider {
  final CarouselControllerImpl _carouselController;

  SKCarousel({@required items, @required options, carouselController, Key key})
      : _carouselController = carouselController ?? CarouselController(),
        super(
            key: key,
            items: items,
            options: options,
            carouselController: carouselController);

  @override
  CarouselSliderState createState() => SKCarouselState(_carouselController);
}

class SKCarouselState extends CarouselSliderState {
  SKCarouselState(CarouselControllerImpl carouselController)
      : super(carouselController);

  @override
  Widget getEnlargeWrapper(Widget child,
      {double width, double height, double scale}) {
    final double adjusted = max(scale, 0.9);
    return Opacity(
      opacity: adjusted,
      child: Transform.scale(
          scale: adjusted,
          alignment: Alignment.bottomCenter,
          child: Container(child: child, width: width, height: height)),
    );
  }
}