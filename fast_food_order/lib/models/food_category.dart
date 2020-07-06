import 'package:uuid/uuid.dart';

class FoodCategory {
  final String id;
  final String title;
  final String photo;

  FoodCategory(this.title, {this.photo}) : id = Uuid().v1();

  static var all = [
    FoodCategory("Breakfast", photo: "coffee_machine"),
    FoodCategory("Snack & Sides", photo: "fries"),
    FoodCategory("Desserts", photo: "cake"),
    FoodCategory("Beverages", photo: "drink"),
    FoodCategory("Burgers", photo: "burger"),
    FoodCategory("Salads", photo: "salads")
  ];
}

class ListItem<T> {
  bool isSelected = false; //Selection property to highlight or not
  T data; 
  ListItem(this.data); //Constructor to assign the data
}