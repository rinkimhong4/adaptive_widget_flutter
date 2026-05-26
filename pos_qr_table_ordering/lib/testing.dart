// import 'package:flutter/material.dart';
// import 'package:pos_qr_table_ordering/config/function.dart';

// class Testing extends StatefulWidget {
//   const Testing({super.key});

//   @override
//   State<Testing> createState() => _TestingState();
// }

// class _TestingState extends State<Testing> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(title: Text("Test Func")),
//         body: Column(
//           children: [
//             CustomTabBar(
//               tabs: const [
//                 TabItem(icon: Icons.home, title: "Home"),
//                 TabItem(icon: Icons.favorite, title: "Favorite"),
//                 TabItem(icon: Icons.person, title: "Profile"),
//               ],
//             ),
//             Expanded(
//               child: TabBarView(
//                 children: [
//                   Column(
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           Helper.showAppSnackBar(
//                             context: context,
//                             textColor: Colors.white,
//                             message: "Order success",
//                             // centerText: true,
//                             fontSize: 18,
//                             backgroundColor: Colors.black54,
//                             fontWeight: FontWeight.bold,
//                             // showAction: true,
//                             // actionLabel: "Retry!",
//                             // onPressed: () {
//                             //   print("object");
//                             // },
//                           );
//                         },
//                         child: const Text(
//                           "Bottom Success",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       ),

//                       ElevatedButton(
//                         onPressed: () {
//                           Helper.showTopNotification(
//                             context: context,
//                             message: "Something went wrong",
//                             isError: true,
//                           );
//                         },
//                         child: const Text(
//                           "Top Error",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Center(child: Text("Favorite Page")),
//                   Center(child: Text("Profile Page")),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';

// class Testing extends StatefulWidget {
//   const Testing({super.key});

//   @override
//   State<Testing> createState() => _TestingState();
// }

// class _TestingState extends State<Testing> {
//   int selectedValue = -1;

//   double valueTextSize = 14;
//   double valueTextSize1 = 14;
//   double valueTextSize2 = 14;
//   double valueTextSize3 = 14;

//   void increaseValueSize() {
//     setState(() {
//       if (selectedValue == 0) {
//         valueTextSize++;
//       } else if (selectedValue == 1) {
//         valueTextSize1++;
//       } else if (selectedValue == 2) {
//         valueTextSize2++;
//       } else if (selectedValue == 3) {
//         valueTextSize3++;
//       }
//     });
//   }

//   void decreaseValueSize() {
//     setState(() {
//       if (selectedValue == 0 && valueTextSize > 1) {
//         valueTextSize--;
//       } else if (selectedValue == 1 && valueTextSize1 > 1) {
//         valueTextSize1--;
//       } else if (selectedValue == 2 && valueTextSize2 > 1) {
//         valueTextSize2--;
//       } else if (selectedValue == 3 && valueTextSize3 > 1) {
//         valueTextSize3--;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("data")),
//       body: Center(
//         child: Column(
//           spacing: 14,
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             _infoRow(
//               title: "Address 1",
//               value: "Takeo",
//               fontSize: valueTextSize,
//               isSelected: selectedValue == 0,
//               onTap: () {
//                 setState(() {
//                   selectedValue = 0;
//                 });
//               },
//             ),

//             _infoRow(
//               title: "Address 2",
//               value: "Phnom Penh",
//               fontSize: valueTextSize1,
//               isSelected: selectedValue == 1,
//               onTap: () {
//                 setState(() {
//                   selectedValue = 1;
//                 });
//               },
//             ),

//             _infoRow(
//               title: "Address 3",
//               value: "Kampot",
//               fontSize: valueTextSize2,
//               isSelected: selectedValue == 2,
//               onTap: () {
//                 setState(() {
//                   selectedValue = 2;
//                 });
//               },
//             ),

//             _infoRow(
//               title: "Address 4",
//               value: "Siem Reap",
//               fontSize: valueTextSize3,
//               isSelected: selectedValue == 3,
//               onTap: () {
//                 setState(() {
//                   selectedValue = 3;
//                 });
//               },
//             ),

//             Row(
//               spacing: 10,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 OutlinedButton(
//                   onPressed: increaseValueSize,
//                   child: const Icon(Icons.add, color: Colors.black),
//                 ),

//                 _buildTextSize(),

//                 OutlinedButton(
//                   onPressed: decreaseValueSize,
//                   child: const Icon(Icons.remove, color: Colors.black),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _infoRow({
//     required String title,
//     required String value,
//     required VoidCallback onTap,
//     required double fontSize,
//     required bool isSelected,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.amber : Colors.grey.shade200,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           children: [
//             Text(title),

//             Text(
//               value,
//               style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextSize() {
//     String text = "";

//     if (selectedValue == 0) {
//       text = valueTextSize.toString();
//     } else if (selectedValue == 1) {
//       text = valueTextSize1.toString();
//     } else if (selectedValue == 2) {
//       text = valueTextSize2.toString();
//     } else if (selectedValue == 3) {
//       text = valueTextSize3.toString();
//     } else {
//       text = "No item selected";
//     }

//     return Text(
//       text,
//       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:pos_qr_table_ordering/config/function.dart';
// import 'custom_tab_bar.dart';

/// EXAMPLE 1: Basic usage with TabController
class BasicTabBarExample extends StatefulWidget {
  const BasicTabBarExample({super.key});

  @override
  State<BasicTabBarExample> createState() => _BasicTabBarExampleState();
}

class _BasicTabBarExampleState extends State<BasicTabBarExample>
    with TickerProviderStateMixin {
  late TabController _tabController;

  static const List<TabItem> _tabs = [
    TabItem(title: 'Home', icon: Icons.home, label: 'Home tab'),
    TabItem(title: 'Search', icon: Icons.search, label: 'Search tab'),
    TabItem(title: 'Profile', icon: Icons.person, label: 'Profile tab'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Basic TabBar Example")),
      body: Column(
        children: [
          CustomTabBar(
            tabs: _tabs,
            controller: _tabController,
            onTabChanged: (index) {
              debugPrint('Tab changed to: $index');
            },
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Center(child: Text('Home Page')),
                Center(child: Text('Search Page')),
                Center(child: Text('Profile Page')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// EXAMPLE 2: Custom theme
class CustomThemeExample extends StatefulWidget {
  const CustomThemeExample({super.key});

  @override
  State<CustomThemeExample> createState() => _CustomThemeExampleState();
}

class _CustomThemeExampleState extends State<CustomThemeExample>
    with TickerProviderStateMixin {
  late TabController _tabController;

  static const List<TabItem> _tabs = [
    TabItem(title: 'All', icon: Icons.apps),
    TabItem(title: 'Favorites', icon: Icons.favorite),
    TabItem(title: 'Archive', icon: Icons.archive),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Custom theme matching your brand colors
    final customTheme = CustomTabBarTheme(
      backgroundColor: const Color(0xFFF9F9F9),
      indicatorColor: const Color(0xFF445A4B), // Your deep green
      selectedLabelColor: Colors.white,
      unselectedLabelColor: const Color(0xFF8E8E93),
      borderRadius: 16,
      padding: 8,
      margin: 20,
      iconSize: 26,
      selectedLabelStyle: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Custom Theme Tabs")),
      body: Column(
        children: [
          CustomTabBar(
            tabs: _tabs,
            controller: _tabController,
            theme: customTheme,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Center(child: Text('All items')),
                Center(child: Text('Favorites')),
                Center(child: Text('Archive')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// EXAMPLE 3: Using theme from ColorScheme
class MaterialThemeExample extends StatefulWidget {
  const MaterialThemeExample({super.key});

  @override
  State<MaterialThemeExample> createState() => _MaterialThemeExampleState();
}

class _MaterialThemeExampleState extends State<MaterialThemeExample>
    with TickerProviderStateMixin {
  late TabController _tabController;

  static const List<TabItem> _tabs = [
    TabItem(title: 'Tab 1', icon: Icons.star),
    TabItem(title: 'Tab 2', icon: Icons.settings),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Material Theme Tabs")),
      body: Column(
        children: [
          // Automatically adapts to Material 3 ColorScheme
          CustomTabBar(
            tabs: _tabs,
            controller: _tabController,
            theme: CustomTabBarTheme.fromColorScheme(
              Theme.of(context).colorScheme,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Center(child: Text('Tab 1 Content')),
                Center(child: Text('Tab 2 Content')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// EXAMPLE 4: Icons only (for compact layouts)
class IconOnlyTabsExample extends StatefulWidget {
  const IconOnlyTabsExample({super.key});

  @override
  State<IconOnlyTabsExample> createState() => _IconOnlyTabsExampleState();
}

class _IconOnlyTabsExampleState extends State<IconOnlyTabsExample>
    with TickerProviderStateMixin {
  late TabController _tabController;

  static const List<TabItem> _tabs = [
    TabItem(title: 'Home', icon: Icons.home),
    TabItem(title: 'Explore', icon: Icons.explore),
    TabItem(title: 'Messages', icon: Icons.message),
    TabItem(title: 'Notifications', icon: Icons.notifications),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Icon Only Tabs")),
      body: Column(
        children: [
          CustomTabBar(
            tabs: _tabs,
            controller: _tabController,
            showLabels: false, // Icons only
            theme: CustomTabBarTheme(
              borderRadius: 10,
              padding: 4,
              margin: 8,
              iconSize: 28,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Center(child: Text('Home')),
                Center(child: Text('Explore')),
                Center(child: Text('Messages')),
                Center(child: Text('Notifications')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
