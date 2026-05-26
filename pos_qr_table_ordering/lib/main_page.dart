import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_qr_table_ordering/pages/order_lists_page.dart';
import 'package:pos_qr_table_ordering/pages/pos_qr_order_home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final bool _isIOS = Platform.isIOS;
  final List<Widget> _pages = [
    const PosQrOrderHomePage(),
    const OrderListsPage(),
  ];

  List<Map<String, dynamic>> get navItems => [
    {
      "icon": _isIOS ? CupertinoIcons.house : Icons.home_outlined,
      "activeIcon": _isIOS ? CupertinoIcons.house_fill : Icons.home_rounded,
      "label": "Home",
    },
    {
      "icon": _isIOS ? CupertinoIcons.square_list : Icons.receipt_long_outlined,
      "activeIcon": _isIOS
          ? CupertinoIcons.square_list_fill
          : Icons.receipt_long_rounded,
      "label": "Orders",
    },
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF000000),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        switchInCurve: Curves.easeOutExpo,
        switchOutCurve: Curves.easeInExpo,
        child: _pages[_selectedIndex],
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 60, right: 60, bottom: 28),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              height: 84,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: List.generate(navItems.length, (index) {
                  final bool isSelected = _selectedIndex == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _onTap(index),
                      behavior: HitTestBehavior.translucent,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutExpo,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.18)
                                : Colors.transparent,
                          ),
                        ),

                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Soft Glow
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 400),

                              opacity: isSelected ? 1 : 0,

                              child: Container(
                                width: 55,
                                height: 55,

                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TweenAnimationBuilder<double>(
                                  tween: Tween<double>(
                                    begin: 0.95,
                                    end: isSelected ? 1.18 : 1,
                                  ),

                                  duration: const Duration(milliseconds: 500),

                                  curve: Curves.easeOutBack,

                                  builder: (context, scale, child) {
                                    return Transform.scale(
                                      scale: scale,

                                      child: AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),

                                        transitionBuilder: (child, animation) {
                                          return ScaleTransition(
                                            scale: animation,
                                            child: FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            ),
                                          );
                                        },

                                        child: Icon(
                                          isSelected
                                              ? navItems[index]["activeIcon"]
                                              : navItems[index]["icon"],

                                          key: ValueKey(isSelected),

                                          size: 27,

                                          color: isSelected
                                              ? Colors.white
                                              : Colors.white54,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 5),
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 350),

                                  curve: Curves.easeOut,

                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white54,
                                    letterSpacing: 0.2,
                                  ),

                                  child: Text(
                                    navItems[index]["label"],
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
