import 'package:flutter/material.dart';

class Category {
  final String title;
  final IconData icon;

  Category({
    required this.title,
    required this.icon,
  });
}

List<Category> categoryList = [

  Category(
    title: "Phone",
    icon: Icons.phone_android,
  ),

  Category(
    title: "Laptop",
    icon: Icons.laptop,
  ),

  Category(
    title: "Camera",
    icon: Icons.camera_alt,
  ),

  Category(
    title: "Watch",
    icon: Icons.watch,
  ),

  Category(
    title: "Speaker",
    icon: Icons.headphones,
  ),

  Category(
    title: "Accessories",
    icon: Icons.cable,
  ),

];