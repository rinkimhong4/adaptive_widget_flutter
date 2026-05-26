import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.centerStart,
      clipBehavior: Clip.none,
      children: [
        // text pill
        Container(
          margin: const EdgeInsets.only(left: 40),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 28),
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.black),
            color: Colors.red,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text(
            "Iced Latte",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // circle icon
        Container(
          alignment: Alignment.center,
          height: 58,
          width: 58,
          decoration: BoxDecoration(
            color: Colors.amber,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.coffee, size: 24),
        ),
        // Positioned(
        //   right: -10,
        //   top: 0,
        //   child: Container(
        //     alignment: Alignment.center,
        //     height: 30,
        //     width: 30,
        //     decoration: BoxDecoration(
        //       color: Colors.blue,
        //       shape: BoxShape.circle,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
