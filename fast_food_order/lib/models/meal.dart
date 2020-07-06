import 'dart:math';

import 'food_category.dart';
import 'package:uuid/uuid.dart';

class Meal {
  final String id;
  final String title;
  final String photo;
  final int AED;

  Meal(this.title, {this.photo, this.AED}): id = Uuid().v1();

  static List<Meal> getMeals(FoodCategory category) {
    var output = List<Meal>();
    var rand = Random();
    for (var i = 0; i < 20; i++) {
      output.add(Meal(category.title + ' #$i', photo: category.photo, AED: 5 + rand.nextInt(15)));
    }
    return output;
  }
}