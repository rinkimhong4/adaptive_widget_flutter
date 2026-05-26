import 'package:flutter/material.dart';

class Helper {
  Helper._();

  /// Bottom SnackBar
  static void showAppSnackBar({
    required BuildContext context,
    required String message,
    bool isError = false,
    Color? backgroundColor,
    Color? textColor,
    bool centerText = false,
    double? fontSize,
    FontWeight? fontWeight,
    VoidCallback? onPressed,
    bool? showAction = false,
    String actionLabel = "Undo",
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: fontSize ?? 14,
            fontWeight: fontWeight ?? FontWeight.normal,
          ),
          textAlign: centerText ? TextAlign.center : TextAlign.left,
        ),
        action: showAction == true
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed:
                    onPressed ??
                    () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
              )
            : null,
        duration: const Duration(seconds: 2),
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Top Notification
  static void showTopNotification({
    required BuildContext context,
    required String message,
    bool isError = false,
  }) {
    final overlay = Overlay.of(context);

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isError ? Colors.red : Colors.green,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.2)),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  isError ? Icons.error : Icons.check_circle,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}

/// Data model for tab configuration
class TabItem {
  final String title;
  final IconData icon;
  final String? label; // For accessibility

  const TabItem({required this.title, required this.icon, this.label});
}

/// Theme configuration for CustomTabBar
class CustomTabBarTheme {
  final Color backgroundColor;
  final Color indicatorColor;
  final Color selectedLabelColor;
  final Color unselectedLabelColor;
  final double borderRadius;
  final double padding;
  final double margin;
  final double iconSize;
  final TextStyle? labelStyle;
  final TextStyle? selectedLabelStyle;

  const CustomTabBarTheme({
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.indicatorColor = const Color(0xFF007AFF),
    this.selectedLabelColor = Colors.white,
    this.unselectedLabelColor = const Color(0xFF8E8E93),
    this.borderRadius = 12,
    this.padding = 6,
    this.margin = 16,
    this.iconSize = 24,
    this.labelStyle,
    this.selectedLabelStyle,
  });

  /// Create a theme from the app's color scheme
  factory CustomTabBarTheme.fromColorScheme(ColorScheme colorScheme) {
    return CustomTabBarTheme(
      backgroundColor: colorScheme.surfaceContainer,
      indicatorColor: colorScheme.primary,
      selectedLabelColor: colorScheme.onPrimary,
      unselectedLabelColor: colorScheme.onSurfaceVariant,
    );
  }
}

/// Reusable CustomTabBar widget with Material 3 support
class CustomTabBar extends StatefulWidget {
  final List<TabItem> tabs;
  final TabController? controller;
  final ValueChanged<int>? onTabChanged;
  final CustomTabBarTheme theme;
  final bool showIcons;
  final bool showLabels;
  final EdgeInsets? contentPadding;
  final EdgeInsets? containerMargin;

  CustomTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.onTabChanged,
    this.theme = const CustomTabBarTheme(),
    this.showIcons = true,
    this.showLabels = true,
    this.contentPadding,
    this.containerMargin,
  }) : assert(tabs.isNotEmpty, 'Tabs list cannot be empty'),
       assert(
         showIcons || showLabels,
         'At least one of showIcons or showLabels must be true',
       );

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with TickerProviderStateMixin {
  late TabController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController =
        widget.controller ??
        TabController(length: widget.tabs.length, vsync: this);

    _internalController.addListener(_onTabChanged);
  }

  @override
  void didUpdateWidget(CustomTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabs.length != widget.tabs.length) {
      _internalController.dispose();
      _internalController =
          widget.controller ??
          TabController(length: widget.tabs.length, vsync: this);
      _internalController.addListener(_onTabChanged);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  void _onTabChanged() {
    widget.onTabChanged?.call(_internalController.index);
  }

  @override
  Widget build(BuildContext context) {
    final padding =
        widget.contentPadding ?? EdgeInsets.all(widget.theme.padding);
    final margin =
        widget.containerMargin ??
        EdgeInsets.symmetric(
          horizontal: widget.theme.margin,
          vertical: widget.theme.margin / 2,
        );

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: widget.theme.backgroundColor,
        borderRadius: BorderRadius.circular(widget.theme.borderRadius),
      ),
      child: TabBar(
        controller: _internalController,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: widget.theme.indicatorColor,
          borderRadius: BorderRadius.circular(widget.theme.borderRadius - 2),
        ),
        labelColor: widget.theme.selectedLabelColor,
        unselectedLabelColor: widget.theme.unselectedLabelColor,
        labelStyle:
            widget.theme.selectedLabelStyle ??
            Theme.of(context).textTheme.labelMedium,
        unselectedLabelStyle:
            widget.theme.labelStyle ??
            Theme.of(context).textTheme.labelMedium?.copyWith(
              color: widget.theme.unselectedLabelColor,
            ),
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: widget.tabs.map((tab) => _buildTabItem(context, tab)).toList(),
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, TabItem tab) {
    if (widget.showIcons && widget.showLabels) {
      return Tab(
        icon: Icon(tab.icon, size: widget.theme.iconSize),
        text: tab.title,
      );
    } else if (widget.showIcons) {
      return Tab(
        icon: Icon(tab.icon, size: widget.theme.iconSize),
        iconMargin: const EdgeInsets.only(bottom: 0),
      );
    } else {
      return Tab(text: tab.title);
    }
  }
}

/// Extension for easier theme switching
extension CustomTabBarThemeExt on BuildContext {
  CustomTabBarTheme get customTabBarTheme {
    final colorScheme = Theme.of(this).colorScheme;
    return CustomTabBarTheme.fromColorScheme(colorScheme);
  }
}
