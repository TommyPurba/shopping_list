import 'package:flutter/material.dart';


//enum ini dipakai agari bisa di pakai di data/catagories untuk seperti Categories.vegetables

enum Categories{
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other
}

class Category {
  const Category(
    this.title, this.color
  );

  final String title;
  final Color color;
}

