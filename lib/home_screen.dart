import 'dart:io';

import 'package:adaptive_widgeet/adaptive_ui_custom/adapetive_icon.dart';
import 'package:adaptive_widgeet/widgets/product_card1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isIOS = Platform.isIOS;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text("Product Card IOS"),
        leading: AdaptiveIcons.back(() {}),
        actions: [
          Padding(
            padding: .directional(end: 0),
            child: Row(
              children: [
                // AdaptiveIcons.calendar(() {}),
                // AdaptiveIcons.attach(() {}),
                AdaptiveIcons.more(() {}),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 120.0, left: 16, right: 16),
        child: Column(
          spacing: 10,
          children: List.generate(3, (index) => ProductCard1()),
        ),
        // Column(
        //   spacing: 10,
        //   children: List.generate(3, (index) => ProductCard1()),
        // ),
      ),
    );
  }
}
