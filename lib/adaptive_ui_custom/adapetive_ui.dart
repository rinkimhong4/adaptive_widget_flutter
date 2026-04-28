// adaptive_ui.dart
//
// A single-file adaptive UI kit for Flutter.
// Renders Cupertino on iOS, Material on Android (and other platforms).
//
// Usage:
//   import 'package:your_app/widgets/adaptive_ui.dart';
//
//   AdaptiveScaffold(
//     title: 'Home',
//     actions: [...],
//     body: ...,
//   );

import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ============================================================================
// PLATFORM HELPER
// ============================================================================

class AdaptivePlatform {
  AdaptivePlatform._();

  /// Returns true on iOS. Safe on web (returns false).
  static bool get isIOS {
    try {
      return Platform.isIOS;
    } catch (_) {
      return false; // web
    }
  }

  /// Use this inside widgets when you have a BuildContext — works on web too.
  static bool isCupertino(BuildContext context) {
    final platform = Theme.of(context).platform;
    return platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
  }
}

// ============================================================================
// ADAPTIVE ACTION (shared icon descriptor)
// ============================================================================

class AdaptiveAction {
  final IconData materialIcon;
  final IconData cupertinoIcon;
  final VoidCallback? onTap;
  final String? tooltip;

  const AdaptiveAction({
    required this.materialIcon,
    required this.cupertinoIcon,
    this.onTap,
    this.tooltip,
  });
}

// ============================================================================
// ADAPTIVE SCAFFOLD
// ============================================================================

class AdaptiveScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final VoidCallback? onBack;
  final bool showBack;
  final List<AdaptiveAction> actions;
  final Color? backgroundColor;
  final Color? appBarColor;
  final Color? foregroundColor;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool resizeToAvoidBottomInset;

  const AdaptiveScaffold({
    super.key,
    required this.title,
    required this.body,
    this.onBack,
    this.showBack = true,
    this.actions = const [],
    this.backgroundColor,
    this.appBarColor,
    this.foregroundColor,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    final isCupertino = AdaptivePlatform.isCupertino(context);

    if (isCupertino) {
      return CupertinoPageScaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: appBarColor,
          middle: Text(title, style: TextStyle(color: foregroundColor)),
          leading: showBack
              ? GestureDetector(
                  onTap: onBack ?? () => Navigator.of(context).maybePop(),
                  child: Icon(CupertinoIcons.back, color: foregroundColor),
                )
              : null,
          trailing: actions.isEmpty
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < actions.length; i++) ...[
                      if (i > 0) const SizedBox(width: 16),
                      GestureDetector(
                        onTap: actions[i].onTap,
                        child: Icon(
                          actions[i].cupertinoIcon,
                          size: 24,
                          color: foregroundColor,
                        ),
                      ),
                    ],
                  ],
                ),
        ),
        child: SafeArea(
          bottom: bottomNavigationBar == null,
          child: Stack(
            children: [
              body,
              if (floatingActionButton != null)
                Positioned(right: 16, bottom: 16, child: floatingActionButton!),
              if (bottomNavigationBar != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: bottomNavigationBar!,
                ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: AppBar(
        backgroundColor: appBarColor,
        foregroundColor: foregroundColor,
        title: Text(title),
        automaticallyImplyLeading: false,
        leading: showBack
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              )
            : null,
        actions: [
          for (final action in actions)
            IconButton(
              icon: Icon(action.materialIcon),
              tooltip: action.tooltip,
              onPressed: action.onTap,
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

// ============================================================================
// ADAPTIVE BUTTON
// ============================================================================

enum AdaptiveButtonStyle { filled, tinted, plain, destructive }

class AdaptiveButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final AdaptiveButtonStyle style;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final double? minSize;
  final Color? textColor;

  const AdaptiveButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.style = AdaptiveButtonStyle.filled,
    this.color,
    this.padding,
    this.minSize,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isCupertino = AdaptivePlatform.isCupertino(context);
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;
    // final foregroundColor = color ?? foregroundColor;

    Color autoForeground(Color bg) =>
        ThemeData.estimateBrightnessForColor(bg) == Brightness.dark
        ? Colors.white
        : Colors.black;

    if (isCupertino) {
      switch (style) {
        case AdaptiveButtonStyle.filled:
          return CupertinoButton(
            onPressed: onPressed,
            color: effectiveColor,
            padding: padding,
            minSize: minSize,
            child: DefaultTextStyle.merge(
              style: TextStyle(color: autoForeground(effectiveColor)),
              child: child,
            ),
          );
        case AdaptiveButtonStyle.destructive:
          return CupertinoButton(
            onPressed: onPressed,
            color: CupertinoColors.destructiveRed,
            padding: padding,
            minSize: minSize,
            child: child,
          );
        case AdaptiveButtonStyle.tinted:
          return CupertinoButton(
            onPressed: onPressed,
            color: effectiveColor.withValues(alpha: 0.15),
            padding: padding,
            minSize: minSize,
            child: DefaultTextStyle.merge(
              style: TextStyle(color: effectiveColor),
              child: child,
            ),
          );
        case AdaptiveButtonStyle.plain:
          return CupertinoButton(
            onPressed: onPressed,
            padding: padding,
            minSize: minSize,
            child: child,
          );
      }
    }

    switch (style) {
      case AdaptiveButtonStyle.filled:
        return FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: color,
            foregroundColor: color != null ? autoForeground(color!) : null,
            padding: padding,
          ),
          child: child,
        );
      case AdaptiveButtonStyle.destructive:
        return FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
            padding: padding,
          ),
          child: child,
        );
      case AdaptiveButtonStyle.tinted:
        return FilledButton.tonal(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: color?.withValues(alpha: 0.15),
            foregroundColor: color,
            padding: padding,
          ),
          child: child,
        );
      case AdaptiveButtonStyle.plain:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(foregroundColor: color, padding: padding),
          child: child,
        );
    }
  }
}

// ============================================================================
// ADAPTIVE DIALOGS
// ============================================================================

class AdaptiveDialog {
  AdaptiveDialog._();

  /// Simple alert with one OK button.
  static Future<void> alert(
    BuildContext context, {
    required String title,
    String? message,
    String okLabel = 'OK',
  }) {
    final isCupertino = AdaptivePlatform.isCupertino(context);
    if (isCupertino) {
      return showCupertinoDialog<void>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(title),
          content: message != null ? Text(message) : null,
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(okLabel),
            ),
          ],
        ),
      );
    }
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: message != null ? Text(message) : null,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(okLabel),
          ),
        ],
      ),
    );
  }

  /// Confirm dialog. Returns true on confirm, false/null on cancel.
  static Future<bool?> confirm(
    BuildContext context, {
    required String title,
    String? message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
  }) {
    final isCupertino = AdaptivePlatform.isCupertino(context);
    if (isCupertino) {
      return showCupertinoDialog<bool>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(title),
          content: message != null ? Text(message) : null,
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(cancelLabel),
            ),
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop(true),
              isDestructiveAction: isDestructive,
              isDefaultAction: !isDestructive,
              child: Text(confirmLabel),
            ),
          ],
        ),
      );
    }
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: message != null ? Text(message) : null,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: isDestructive
                ? TextButton.styleFrom(
                    foregroundColor: Theme.of(ctx).colorScheme.error,
                  )
                : null,
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// ADAPTIVE ACTION SHEET
// ============================================================================

class AdaptiveSheetAction {
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  final bool isDefault;

  const AdaptiveSheetAction({
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    this.isDefault = false,
  });
}

class AdaptiveActionSheet {
  AdaptiveActionSheet._();

  static Future<void> show(
    BuildContext context, {
    String? title,
    String? message,
    required List<AdaptiveSheetAction> actions,
    String cancelLabel = 'Cancel',
  }) {
    final isCupertino = AdaptivePlatform.isCupertino(context);

    if (isCupertino) {
      return showCupertinoModalPopup<void>(
        context: context,
        builder: (ctx) => CupertinoActionSheet(
          title: title != null ? Text(title) : null,
          message: message != null ? Text(message) : null,
          actions: actions
              .map(
                (a) => CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    a.onTap();
                  },
                  isDestructiveAction: a.isDestructive,
                  isDefaultAction: a.isDefault,
                  child: Text(a.label),
                ),
              )
              .toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(cancelLabel),
          ),
        ),
      );
    }

    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  child: Text(
                    title,
                    style: Theme.of(ctx).textTheme.titleMedium,
                  ),
                ),
              if (message != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(
                    message,
                    style: Theme.of(ctx).textTheme.bodySmall,
                  ),
                ),
              for (final a in actions)
                ListTile(
                  title: Text(
                    a.label,
                    style: TextStyle(
                      color: a.isDestructive
                          ? Theme.of(ctx).colorScheme.error
                          : null,
                      fontWeight: a.isDefault
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    a.onTap();
                  },
                ),
              const Divider(height: 0),
              ListTile(
                title: Text(cancelLabel, textAlign: TextAlign.center),
                onTap: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================================
// ADAPTIVE TEXT FIELD
// ============================================================================

class AdaptiveTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final String? label;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? prefix;
  final Widget? suffix;

  const AdaptiveTextField({
    super.key,
    this.controller,
    this.placeholder,
    this.label,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final isCupertino = AdaptivePlatform.isCupertino(context);

    if (isCupertino) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Text(label!, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
          ],
          CupertinoTextField(
            controller: controller,
            placeholder: placeholder,
            keyboardType: keyboardType,
            obscureText: obscureText,
            enabled: enabled,
            maxLength: maxLength,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            prefix: prefix,
            suffix: suffix,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: CupertinoColors.systemGrey4),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      );
    }

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: enabled,
      maxLength: maxLength,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        prefixIcon: prefix,
        suffixIcon: suffix,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

// ============================================================================
// ADAPTIVE SWITCH
// ============================================================================

class AdaptiveSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;

  const AdaptiveSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    if (AdaptivePlatform.isCupertino(context)) {
      return CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: activeColor,
      );
    }
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: activeColor,
    );
  }
}

// ============================================================================
// ADAPTIVE LOADING INDICATOR
// ============================================================================

class AdaptiveLoading extends StatelessWidget {
  final double? size;
  final Color? color;

  const AdaptiveLoading({super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    if (AdaptivePlatform.isCupertino(context)) {
      return CupertinoActivityIndicator(radius: (size ?? 20) / 2, color: color);
    }
    return SizedBox(
      width: size ?? 24,
      height: size ?? 24,
      child: CircularProgressIndicator(strokeWidth: 2.5, color: color),
    );
  }
}

// ============================================================================
// ADAPTIVE PULL-TO-REFRESH
// ============================================================================

class AdaptiveRefresh extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const AdaptiveRefresh({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (AdaptivePlatform.isCupertino(context)) {
      return CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: onRefresh),
          SliverFillRemaining(child: child),
        ],
      );
    }
    return RefreshIndicator(onRefresh: onRefresh, child: child);
  }
}

// ============================================================================
// CONTEXT EXTENSION (sugar)
// ============================================================================

extension AdaptiveContext on BuildContext {
  bool get isCupertino => AdaptivePlatform.isCupertino(this);

  Future<bool?> showAdaptiveConfirm({
    required String title,
    String? message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
  }) => AdaptiveDialog.confirm(
    this,
    title: title,
    message: message,
    confirmLabel: confirmLabel,
    cancelLabel: cancelLabel,
    isDestructive: isDestructive,
  );

  Future<void> showAdaptiveAlert({
    required String title,
    String? message,
    String okLabel = 'OK',
  }) => AdaptiveDialog.alert(
    this,
    title: title,
    message: message,
    okLabel: okLabel,
  );
}
