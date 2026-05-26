import 'package:flutter/material.dart';

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          color: Colors.grey[50],
          child: SizedBox(
            height: 220,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 70, left: 14),
              child: Column(
                crossAxisAlignment: .start,
                spacing: 4,
                children: [
                  Text(
                    "Coffee Name",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    spacing: 4,
                    children: [
                      Text(
                        "\$9.5",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\$1.5",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              print("add to order list");
            },
            child: Container(
              alignment: Alignment.center,
              height: 40,
              width: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                ),
                color: Colors.red[600],
              ),
              child: Icon(Icons.add, size: 24, color: Colors.white),
            ),
          ),
        ),
        Positioned(
          top: -50,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              height: 110,
              width: 110,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Icon(
                Icons.coffee_rounded,
                size: 42,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
