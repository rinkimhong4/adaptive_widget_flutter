// ignore_for_file: must_be_immutable

import 'package:adaptive_widgeet/api/Model/Product.dart';
import 'package:adaptive_widgeet/helper/helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductCard1 extends StatelessWidget {
  ProductCard1({super.key, required this.product});
  Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: CachedNetworkImage(
              width: 100,
              height: 120,
              imageUrl: product.thumbnail ?? "Error",
              fit: BoxFit.cover,
              placeholder: (context, url) => const SizedBox(
                width: 92,
                height: 92,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, size: 40),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.title ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text(
                            product.stock.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.green[600],
                            ),
                          ),
                          Text(
                            product.rating.toString(),
                            style: TextStyle(
                              color: Colors.green[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  Helper.formatText4(product.description.toString()),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "\$${product.price}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.green[700],
                      ),
                    ),
                    Spacer(),
                    // add to cart or delete button
                    CupertinoButton.filled(
                      sizeStyle: CupertinoButtonSize.medium,
                      color: Colors.green[700],
                      onPressed: () {
                        print("Add to cart");
                      },
                      child: Icon(Icons.delete, color: Colors.white, size: 24),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
