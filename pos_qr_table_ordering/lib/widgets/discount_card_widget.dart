import 'package:flutter/material.dart';

class DiscountCardWidget extends StatelessWidget {
  const DiscountCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.amber.shade700,
            Colors.red.shade500,
            Colors.red.shade700,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// left side
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "15",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'inter',
                  ),
                ),
                const SizedBox(width: 6),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "%",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    SizedBox(
                      width: 180,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        "ក្នុងឱកាសបុណ្យចូលឆ្នាំថ្មីប្រពៃណីជាតិខ្មែរ",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            /// right icon
            Container(
              height: 55,
              width: 55,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: Colors.white),
              ),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.discount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
