import 'package:flutter/material.dart';

class Helper {
  Helper._();

  static String formatText2(String text, {int wordsPerLine = 1}) {
    // length word
    final words = text.split(' ');
    final buffer = StringBuffer();
    for (int i = 0; i < words.length; i++) {
      buffer.write(words[i]);
      if ((i + 1) % wordsPerLine == 0 && i != words.length - 1) {
        buffer.write('\n');
      } else {
        buffer.write(' ');
      }
    }
    return buffer.toString().trim();
  }

  static Future<T?> showAppBottomSheet<T>({
    required BuildContext context,
    required WidgetBuilder builder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: builder,
    );
  }
}
