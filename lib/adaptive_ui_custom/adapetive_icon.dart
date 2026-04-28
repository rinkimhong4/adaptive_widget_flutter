import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveIcons {
  static Widget calendar(VoidCallback onTap) {
    return _build(
      onTap,
      cupertino: CupertinoIcons.calendar,
      material: Icons.calendar_today_outlined,
    );
  }

  static Widget attach(VoidCallback onTap) {
    return _build(
      onTap,
      cupertino: CupertinoIcons.paperclip,
      material: Icons.attach_file,
    );
  }

  static Widget search(VoidCallback onTap) {
    return _build(
      onTap,
      cupertino: CupertinoIcons.search,
      material: Icons.search,
    );
  }

  static Widget back(VoidCallback onTap) {
    return _build(
      onTap,
      cupertino: CupertinoIcons.back,
      material: Icons.arrow_back,
    );
  }

  static Widget more(VoidCallback onTap) {
    return _build(
      onTap,
      cupertino: CupertinoIcons.ellipsis_vertical,
      material: Icons.more_vert,
    );
  }

  static Widget _build(
    VoidCallback onTap, {
    required IconData cupertino,
    required IconData material,
  }) {
    if (Platform.isIOS) {
      return CupertinoButton(
        padding: const EdgeInsets.only(left: 0),
        onPressed: onTap,
        child: Icon(cupertino, size: 24),
      );
    }

    return IconButton(onPressed: onTap, icon: Icon(material));
  }
}
