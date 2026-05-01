import 'package:adaptive_widgeet/adaptive_ui_custom/adapetive_icon.dart';
import 'package:adaptive_widgeet/api/controller/controller.dart';
import 'package:adaptive_widgeet/widgets/product_card1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreenAPI extends StatelessWidget {
  const HomeScreenAPI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text("Product Card IOS"),
        leading: AdaptiveIcons.back(() {}),
        actions: [
          Padding(
            padding: .directional(end: 0),
            child: Row(children: [AdaptiveIcons.more(() {})]),
          ),
        ],
      ),
      body: Consumer<Controller>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 120, left: 16, right: 16),
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ProductCard1(product: controller.products[index]),
              );
            },
          );
        },
      ),
    );
  }
}
