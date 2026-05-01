import 'package:flutter/material.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBottomNavBar(
      selectedColor: Colors.blueAccent,
      items: const [
        NavBarItem(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore),
          label: 'Home',
          screen: Center(child: Text('Home')),
        ),
        NavBarItem(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search),
          label: 'Search',
          screen: Center(child: Text('Search')),
        ),
        NavBarItem(
          icon: Icon(Icons.bookmark_border),
          selectedIcon: Icon(Icons.bookmark),
          label: 'Saved',
          screen: Center(child: Text('Saved')),
        ),
        NavBarItem(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
          screen: Center(child: Text('Settings')),
        ),
      ],
    );
  }
}

class NavBarItem {
  final Widget icon;
  final Widget selectedIcon;
  final String label;
  final Widget screen;

  const NavBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.screen,
  });
}

class AppBottomNavBar extends StatefulWidget {
  final List<NavBarItem> items;

  final int initialIndex;
  final ValueChanged<int>? onIndexChanged;

  final Color? selectedColor;
  final Color? unselectedColor;
  final Color indicatorColor;
  final double iconSize;
  final double labelFontSize;
  final FontWeight selectedFontWeight;
  final FontWeight unselectedFontWeight;
  final double navBarHeight;
  final NavigationDestinationLabelBehavior labelBehavior;

  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;

  const AppBottomNavBar({
    super.key,
    required this.items,
    this.initialIndex = 0,
    this.onIndexChanged,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor = Colors.transparent,
    this.iconSize = 24,
    this.labelFontSize = 12,
    this.selectedFontWeight = FontWeight.w600,
    this.unselectedFontWeight = FontWeight.w400,
    this.navBarHeight = 60,
    this.labelBehavior = NavigationDestinationLabelBehavior.alwaysShow,
    this.appBar,
    this.floatingActionButton,
    this.backgroundColor,
  }) : assert(items.length >= 2, 'Provide at least 2 items');

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  late int _index = widget.initialIndex.clamp(0, widget.items.length - 1);

  @override
  void didUpdateWidget(covariant AppBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_index >= widget.items.length) {
      _index = widget.items.length - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = widget.selectedColor ?? theme.colorScheme.primary;
    final unselected = widget.unselectedColor ?? Colors.grey.shade500;

    return Scaffold(
      appBar: widget.appBar,
      backgroundColor: widget.backgroundColor,
      floatingActionButton: widget.floatingActionButton,
      body: IndexedStack(
        index: _index,
        children: widget.items.map((e) => e.screen).toList(),
      ),
      bottomNavigationBar: _buildNavBar(selected, unselected),
    );
  }

  Widget _buildNavBar(Color selected, Color unselected) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: widget.indicatorColor,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: widget.iconSize,
            color: isSelected ? selected : unselected,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: widget.labelFontSize,
            fontWeight: isSelected
                ? widget.selectedFontWeight
                : widget.unselectedFontWeight,
            color: isSelected ? selected : unselected,
          );
        }),
      ),
      child: NavigationBar(
        height: widget.navBarHeight,
        selectedIndex: _index,
        labelBehavior: widget.labelBehavior,
        onDestinationSelected: (index) {
          if (_index == index) return;
          setState(() => _index = index);
          widget.onIndexChanged?.call(index);
        },
        destinations: widget.items
            .map(
              (e) => NavigationDestination(
                icon: e.icon,
                selectedIcon: e.selectedIcon,
                label: e.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
