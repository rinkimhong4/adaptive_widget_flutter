import 'package:example/api/config/api_service.dart';
import 'package:example/providers/category_provider.dart';
import 'package:example/providers/product_provider.dart';
import 'package:example/providers/student_provider.dart';
import 'package:example/providers/test_provider.dart';
import 'package:example/screens/product_screen.dart';
import 'package:example/screens/student_screen.dart';
import 'package:example/screens/test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
  // DummyJSON — no auth required.
  // For your real API, swap the baseUrl and pass an accessToken.
  // final apiURL = ApiService(baseUrl: 'https://dummyjson.com');
  // final apiURL = ApiService(baseUrl: 'https://fakestoreapi.com');
  // final apiURL = ApiService(baseUrl: 'http://localhost:3000/v1/api');
  final apiURL = ApiService(baseUrl: 'http://localhost:3000');

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>.value(value: apiURL),
        ChangeNotifierProvider(create: (_) => ProductProvider(apiURL)),
        ChangeNotifierProvider(create: (_) => CategoryProvider(apiURL)),
        ChangeNotifierProvider(create: (_) => TestProvider(apiURL)),
        ChangeNotifierProvider(create: (_) => StudentProvider(apiURL)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter CRUD + Provider',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      // home: const ProductScreen(),
      home: const Test(),
      // home: const StudentScreen(),
    );
  }
}
