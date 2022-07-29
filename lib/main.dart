import 'package:article_mobile_app/model/category.model.dart';
import 'package:article_mobile_app/widgets/authenticated.dart';
import 'package:article_mobile_app/widgets/categoryDetails.dart';
import 'package:article_mobile_app/widgets/home.dart';
import 'package:article_mobile_app/widgets/homeController.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Article App',
      theme: ThemeData(
        primarySwatch: Colors.teal,

      ),
      home: const Authenticated() , //const HomeController(title: 'Article App'),//CategoryDetails(Category(name: "pomme")),//const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

