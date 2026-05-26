import 'package:flutter/material.dart';
import 'package:pos_qr_table_ordering/main_page.dart';
import 'package:pos_qr_table_ordering/testing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Flutter Demo',

      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          brightness: Brightness.light,
          primary: Colors.white,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
        ),

        useMaterial3: true,
      ),

      // home: const MainPage(),
      // home: const Testing(),
      // ex1
      home: const BasicTabBarExample(),
      // ex2
      // home: const CustomThemeExample(),
      // ex3
      // home: const MaterialThemeExample(),
      //ex4
      // home: const IconOnlyTabsExample(),
    );
  }
}
