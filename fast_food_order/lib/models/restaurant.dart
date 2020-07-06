
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final double rating;
  final int priceRange;
  final String logo;
  final String photo;
  final int orderTimeMin;
  final int orderTimeMax;
  final Color color;

  Restaurant(
      this.name,
      {
      @required this.description,
      @required this.logo,
      @required this.photo,
      @required this.orderTimeMin,
      @required this.orderTimeMax,
      @required this.color,
      @required double rating,
      @required int priceRange})
      : id = Uuid().v1(),
        rating = rating.clamp(0, 5),
        priceRange = priceRange.clamp(0, 5);

  static var all = [
    Restaurant("McDonald's", description: "Burgers, American", logo: "mcdonalds_logo", photo: "mcdonalds", orderTimeMin: 10, orderTimeMax: 15, color: Colors.red, priceRange: 3, rating: 4.8),
    Restaurant("Starbucks", description: "Coffee, Beverages", logo: "starbucks_logo", photo: "starbucks", orderTimeMin: 10, orderTimeMax: 15, color: Color(0xFF186442), rating: 4.6, priceRange: 3),
    Restaurant("Burger King", description: "Burgers, American", logo: "burgerking_logo", photo: "burgerking", orderTimeMin: 10, orderTimeMax: 15, color: Color(0xFF0E52A6), rating: 4.8, priceRange: 3),
    Restaurant("Pizza Hut", description: "Pizza, American", logo: "pizzahut_logo", photo: "pizza", orderTimeMin: 15, orderTimeMax: 30, color: Color(0xFFF3AF22), rating: 4.7, priceRange: 3),
    Restaurant("Costa Coffee", description: "Coffee, Beverages", logo: "costacoffee_logo", photo: "coffee", orderTimeMin: 5, orderTimeMax: 10, color: Color(0xFF86001E), rating: 4.6, priceRange: 3)
  ];
}

extension TextFormat on Restaurant {
  String priceRangeString() {
    return List<String>.filled(priceRange, '\$').join();
  }

  String orderTimeString() {
    if (orderTimeMax <= orderTimeMin) {
      return '$orderTimeMin mins';
    }
    return '$orderTimeMin - $orderTimeMax mins';
  }
}