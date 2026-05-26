import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductDetailWidget extends StatefulWidget {
  const ProductDetailWidget({super.key});

  @override
  State<ProductDetailWidget> createState() => _ProductDetailWidgetState();
}

class _ProductDetailWidgetState extends State<ProductDetailWidget> {
  // size data
  int selectedIndex = 0;
  final List<Map<String, dynamic>> sizes = [
    {"label": "Small", "iconSize": 24.0, "price": 2.9},
    {"label": "Medium", "iconSize": 32.0, "price": 3.9},
    {"label": "Large", "iconSize": 40.0, "price": 4.9},
    {"label": "Custom", "iconSize": 50.0, "price": 5.9},
  ];
  // counter data
  int _counter = 1;
  bool _isAddIconPressed = false;
  bool _isRemoveIconPressed = false;

  void _decrementCounter() {
    setState(() {
      if (_counter > 1) {
        _counter--;
        _isAddIconPressed = false;
        _isRemoveIconPressed = true;
      }
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      _isAddIconPressed = true;
      _isRemoveIconPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          // statusBarColor: Colors.red,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        backgroundColor: Colors.transparent,
        title: Text("Coffee"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.blue[500],
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  top: -40,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Image.network(
                    height: 300,
                    width: double.infinity,
                    "https://www.nicepng.com/png/full/106-1060376_starbucks-iced-coffee-png-vector-library-pumpkin-spice.png",
                  ),
                ),
              ],
            ),

            // const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 30.0,
                horizontal: 20,
              ),
              child: Column(
                mainAxisAlignment: .start,
                crossAxisAlignment: .start,
                children: [
                  // coffee name + price
                  Row(
                    spacing: 10,
                    mainAxisAlignment: .spaceBetween,
                    crossAxisAlignment: .start,
                    children: [
                      Expanded(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          "Coffee name",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        "\$${(sizes[selectedIndex]["price"] * _counter).toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  // size
                  Text(
                    "Size",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(sizes.length, (index) {
                          final isSelected = selectedIndex == index;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Column(
                                mainAxisAlignment: .center,
                                crossAxisAlignment: .center,
                                children: [
                                  Container(
                                    height: 65,
                                    width: 65,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.blue.withValues(alpha: 0.2),
                                    ),
                                    child: Icon(
                                      Icons.coffee,
                                      size: sizes[index]["iconSize"],
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    sizes[index]["label"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: .spaceAround,
          children: [
            // counter
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: _decrementCounter,
                  child: Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isRemoveIconPressed
                          ? Colors.blue
                          : Colors.blue.withValues(alpha: 0.5),
                    ),
                    child: const Icon(
                      Icons.remove,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  _counter.toString(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _incrementCounter,
                  child: Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: _isAddIconPressed
                          ? Colors.blue
                          : Colors.blue.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, size: 24, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(width: 20),

            Expanded(
              child: CupertinoButton.filled(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10),
                child: Text(
                  "Place Order",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onPressed: () {
                  print("object");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final double? radius;
  final Color? color;
  const PrimaryContainer({
    super.key,
    this.radius,
    this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 30),
      ),
      child: child,
    );
  }
}
