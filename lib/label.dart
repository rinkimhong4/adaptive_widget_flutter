import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math' as math;

// ============================================================================
// MODELS
// ============================================================================

class LabelElement {
  final String id;
  final String
  type; // text, picture, qrcode, barcode, icon, graph, border, line, time, scan, tabulation
  final Offset position;
  final Size size;
  final double rotation;
  String content; // text content or asset path

  LabelElement({
    required this.id,
    required this.type,
    required this.position,
    required this.size,
    this.rotation = 0,
    this.content = '',
  });

  LabelElement copyWith({
    Offset? position,
    Size? size,
    double? rotation,
    String? content,
  }) {
    return LabelElement(
      id: id,
      type: type,
      position: position ?? this.position,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'position': {'dx': position.dx, 'dy': position.dy},
    'size': {'width': size.width, 'height': size.height},
    'rotation': rotation,
    'content': content,
  };

  static LabelElement fromJson(Map<String, dynamic> json) {
    return LabelElement(
      id: json['id'],
      type: json['type'],
      position: Offset(json['position']['dx'], json['position']['dy']),
      size: Size(json['size']['width'], json['size']['height']),
      rotation: json['rotation'] ?? 0,
      content: json['content'] ?? '',
    );
  }
}

class LabelDesign {
  final String id;
  final String name;
  final Size canvasSize;
  final List<LabelElement> elements;
  final DateTime createdAt;
  final DateTime updatedAt;

  LabelDesign({
    required this.id,
    required this.name,
    required this.canvasSize,
    required this.elements,
    required this.createdAt,
    required this.updatedAt,
  });

  LabelDesign copyWith({List<LabelElement>? elements, DateTime? updatedAt}) {
    return LabelDesign(
      id: id,
      name: name,
      canvasSize: canvasSize,
      elements: elements ?? this.elements,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'canvasSize': {'width': canvasSize.width, 'height': canvasSize.height},
    'elements': elements.map((e) => e.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  static LabelDesign fromJson(Map<String, dynamic> json) {
    return LabelDesign(
      id: json['id'],
      name: json['name'],
      canvasSize: Size(
        json['canvasSize']['width'],
        json['canvasSize']['height'],
      ),
      elements: (json['elements'] as List)
          .map((e) => LabelElement.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

// ============================================================================
// PROVIDERS
// ============================================================================

final labelDesignProvider =
    StateNotifierProvider<LabelDesignNotifier, LabelDesign?>((ref) {
      return LabelDesignNotifier();
    });

class LabelDesignNotifier extends StateNotifier<LabelDesign?> {
  LabelDesignNotifier() : super(null);

  void createNew(String name, Size canvasSize) {
    final now = DateTime.now();
    state = LabelDesign(
      id: now.millisecondsSinceEpoch.toString(),
      name: name,
      canvasSize: canvasSize,
      elements: [],
      createdAt: now,
      updatedAt: now,
    );
  }

  void addElement(LabelElement element) {
    if (state == null) return;
    state = state!.copyWith(elements: [...state!.elements, element]);
  }

  void updateElement(String elementId, LabelElement element) {
    if (state == null) return;
    final updated = state!.elements
        .map((e) => e.id == elementId ? element : e)
        .toList();
    state = state!.copyWith(elements: updated);
  }

  void removeElement(String elementId) {
    if (state == null) return;
    final updated = state!.elements.where((e) => e.id != elementId).toList();
    state = state!.copyWith(elements: updated);
  }

  void clear() {
    if (state == null) return;
    state = state!.copyWith(elements: []);
  }
}

final selectedElementProvider = StateProvider<String?>((ref) => null);

final prefsProvider = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

// ============================================================================
// LABEL DESIGNER SCREEN
// ============================================================================

class LabelDesignerScreen extends ConsumerWidget {
  const LabelDesignerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = ref.watch(labelDesignProvider);
    final selectedId = ref.watch(selectedElementProvider);

    if (design == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Label Designer')),
        body: const _NewLabelDialog(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(design.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => ref.read(labelDesignProvider.notifier).state = null,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveDesign(context, ref, design),
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => _showPrintDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Canvas with rulers
          Expanded(
            child: _CanvasArea(design: design, selectedId: selectedId),
          ),
          // Control buttons
          _ControlButtonsBar(design: design),
          // Element tools
          _ElementToolsBar(design: design, selectedId: selectedId),
        ],
      ),
    );
  }

  void _saveDesign(
    BuildContext context,
    WidgetRef ref,
    LabelDesign design,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final designs = prefs.getStringList('label_designs') ?? [];
    final encoded = jsonEncode(design.toJson());
    final existing = designs.indexWhere((d) {
      final decoded = jsonDecode(d) as Map<String, dynamic>;
      return decoded['id'] == design.id;
    });

    if (existing >= 0) {
      designs[existing] = encoded;
    } else {
      designs.add(encoded);
    }

    await prefs.setStringList('label_designs', designs);
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Label saved successfully')));
    }
  }

  void _showPrintDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Print Label'),
        content: const Text('Print functionality would be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// CANVAS AREA
// ============================================================================

class _CanvasArea extends ConsumerWidget {
  final LabelDesign design;
  final String? selectedId;

  const _CanvasArea({required this.design, required this.selectedId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scale = 2.0; // pixels per unit

    return Container(
      color: Colors.grey[100],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              // Rulers
              SizedBox(
                width: design.canvasSize.width * scale + 60,
                height: design.canvasSize.height * scale + 60,
                child: _RulerBackground(
                  width: design.canvasSize.width,
                  height: design.canvasSize.height,
                  scale: scale,
                ),
              ),
              // Canvas
              Positioned(
                left: 40,
                top: 40,
                child: GestureDetector(
                  onTapDown: (details) {
                    ref.read(selectedElementProvider.notifier).state = null;
                  },
                  child: Container(
                    width: design.canvasSize.width * scale,
                    height: design.canvasSize.height * scale,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Stack(
                      children: [
                        // Elements
                        ...design.elements.map((element) {
                          return _ElementWidget(
                            element: element,
                            scale: scale,
                            isSelected: element.id == selectedId,
                            onSelect: () {
                              ref.read(selectedElementProvider.notifier).state =
                                  element.id;
                            },
                            onUpdate: (updated) {
                              ref
                                  .read(labelDesignProvider.notifier)
                                  .updateElement(element.id, updated);
                            },
                            onDelete: () {
                              ref
                                  .read(labelDesignProvider.notifier)
                                  .removeElement(element.id);
                              ref.read(selectedElementProvider.notifier).state =
                                  null;
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// RULER BACKGROUND
// ============================================================================

class _RulerBackground extends StatelessWidget {
  final double width;
  final double height;
  final double scale;

  const _RulerBackground({
    required this.width,
    required this.height,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RulerPainter(width: width, height: height, scale: scale),
      size: Size(width * scale + 60, height * scale + 60),
    );
  }
}

class _RulerPainter extends CustomPainter {
  final double width;
  final double height;
  final double scale;

  _RulerPainter({
    required this.width,
    required this.height,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const rulerWidth = 40.0;
    const tickColor = Colors.black54;
    const labelColor = Colors.black87;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Top ruler
    canvas.drawRect(
      Rect.fromLTWH(rulerWidth, 0, size.width - rulerWidth, rulerWidth),
      Paint()..color = Colors.grey[300]!,
    );

    for (int i = 0; i <= width.toInt(); i++) {
      final x = rulerWidth + i * scale;
      final isMajor = i % 10 == 0;
      final tickHeight = isMajor ? 12.0 : 6.0;

      canvas.drawLine(
        Offset(x, rulerWidth - tickHeight),
        Offset(x, rulerWidth),
        Paint()
          ..color = tickColor
          ..strokeWidth = 1,
      );

      if (isMajor && i > 0) {
        textPainter.text = TextSpan(
          text: i.toString(),
          style: const TextStyle(color: labelColor, fontSize: 9),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x - textPainter.width / 2, 15));
      }
    }

    // Left ruler
    canvas.drawRect(
      Rect.fromLTWH(0, rulerWidth, rulerWidth, size.height - rulerWidth),
      Paint()..color = Colors.grey[300]!,
    );

    for (int i = 0; i <= height.toInt(); i++) {
      final y = rulerWidth + i * scale;
      final isMajor = i % 10 == 0;
      final tickWidth = isMajor ? 12.0 : 6.0;

      canvas.drawLine(
        Offset(rulerWidth - tickWidth, y),
        Offset(rulerWidth, y),
        Paint()
          ..color = tickColor
          ..strokeWidth = 1,
      );

      if (isMajor && i > 0) {
        textPainter.text = TextSpan(
          text: i.toString(),
          style: const TextStyle(color: labelColor, fontSize: 9),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(5, y - textPainter.height / 2));
      }
    }
  }

  @override
  bool shouldRepaint(_RulerPainter oldDelegate) => false;
}

// ============================================================================
// ELEMENT WIDGET
// ============================================================================

class _ElementWidget extends ConsumerWidget {
  final LabelElement element;
  final double scale;
  final bool isSelected;
  final VoidCallback onSelect;
  final Function(LabelElement) onUpdate;
  final VoidCallback onDelete;

  const _ElementWidget({
    required this.element,
    required this.scale,
    required this.isSelected,
    required this.onSelect,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaledPos = element.position * scale;
    final scaledSize = element.size * scale;

    return Positioned(
      left: scaledPos.dx,
      top: scaledPos.dy,
      child: GestureDetector(
        onTapDown: (_) => onSelect(),
        onPanUpdate: (details) {
          if (!isSelected) return;
          onUpdate(
            element.copyWith(
              position: element.position + details.delta / scale,
            ),
          );
        },
        child: Transform.rotate(
          angle: element.rotation * math.pi / 180,
          child: Container(
            width: scaledSize.width,
            height: scaledSize.height,
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey,
                width: isSelected ? 2 : 1,
              ),
              color: Colors.white.withOpacity(0.8),
            ),
            child: Stack(
              children: [
                // Element content
                Center(child: _ElementContent(element: element)),
                // Resize handles (only if selected)
                if (isSelected) ..._buildResizeHandles(scaledSize),
                // Delete button
                if (isSelected)
                  Positioned(
                    top: -12,
                    right: -12,
                    child: GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildResizeHandles(Size scaledSize) {
    const handleSize = 20.0;
    final handleRadius = handleSize / 2;

    return [
      // Top-left
      _ResizeHandle(
        position: Offset(-handleRadius, -handleRadius),
        onDrag: (delta) {
          onUpdate(
            element.copyWith(
              position: element.position + delta / scale,
              // size: element.size - delta / scale,
            ),
          );
        },
      ),
      // Top-right
      _ResizeHandle(
        position: Offset(scaledSize.width - handleRadius, -handleRadius),
        onDrag: (delta) {
          onUpdate(
            element.copyWith(
              size: Size(
                element.size.width + delta.dx / scale,
                element.size.height - delta.dy / scale,
              ),
            ),
          );
        },
      ),
      // Bottom-left
      _ResizeHandle(
        position: Offset(-handleRadius, scaledSize.height - handleRadius),
        onDrag: (delta) {
          onUpdate(
            element.copyWith(
              position: element.position + Offset(delta.dx, 0) / scale,
              size: Size(
                element.size.width - delta.dx / scale,
                element.size.height + delta.dy / scale,
              ),
            ),
          );
        },
      ),
      // Bottom-right
      _ResizeHandle(
        position: Offset(
          scaledSize.width - handleRadius,
          scaledSize.height - handleRadius,
        ),
        onDrag: (delta) {
          onUpdate(element.copyWith(size: element.size + delta / scale));
        },
      ),
    ];
  }
}

class _ResizeHandle extends StatefulWidget {
  final Offset position;
  final Function(Offset) onDrag;

  const _ResizeHandle({required this.position, required this.onDrag});

  @override
  State<_ResizeHandle> createState() => _ResizeHandleState();
}

class _ResizeHandleState extends State<_ResizeHandle> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: GestureDetector(
        onPanUpdate: (details) => widget.onDrag(details.delta),
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(blurRadius: 4, color: Colors.black.withOpacity(0.2)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ElementContent extends StatelessWidget {
  final LabelElement element;

  const _ElementContent({required this.element});

  @override
  Widget build(BuildContext context) {
    switch (element.type) {
      case 'text':
        return Text(
          element.content.isEmpty ? 'Double click to edit' : element.content,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        );
      case 'barcode':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (_) => Container(
              height: 2,
              width: double.infinity,
              color: Colors.black,
            ),
          ),
        );
      case 'qrcode':
        return Container(
          color: Colors.black12,
          child: const Icon(Icons.qr_code_2, size: 24),
        );
      case 'picture':
        return const Icon(Icons.image, size: 32, color: Colors.grey);
      case 'icon':
        return const Icon(Icons.star, size: 32, color: Colors.orange);
      case 'graph':
        return const Icon(Icons.show_chart, size: 32, color: Colors.blue);
      case 'border':
        return Container(
          decoration: BoxDecoration(border: Border.all(width: 2)),
        );
      case 'line':
        return CustomPaint(painter: _LinePainter());
      case 'time':
        return const Icon(Icons.access_time, size: 24, color: Colors.grey);
      case 'scan':
        return const Icon(
          Icons.center_focus_strong,
          size: 24,
          color: Colors.grey,
        );
      case 'tabulation':
        return const Icon(Icons.dashboard, size: 24, color: Colors.grey);
      default:
        return const SizedBox();
    }
  }
}

class _LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      Paint()
        ..color = Colors.black
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_LinePainter oldDelegate) => false;
}

// ============================================================================
// CONTROL BUTTONS BAR
// ============================================================================

class _ControlButtonsBar extends ConsumerWidget {
  final LabelDesign design;

  const _ControlButtonsBar({required this.design});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedElementProvider);
    final selectedElement = selectedId != null
        ? design.elements.firstWhere(
            (e) => e.id == selectedId,
            orElse: () => LabelElement(
              id: '',
              type: '',
              position: Offset.zero,
              size: Size.zero,
            ),
          )
        : null;

    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          _ControlButton(
            icon: Icons.undo,
            label: 'Cancel',
            onPressed: () =>
                ref.read(labelDesignProvider.notifier).state = null,
          ),
          const SizedBox(width: 8),
          _ControlButton(
            icon: Icons.restore,
            label: 'Restore',
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          _ControlButton(
            icon: Icons.content_copy,
            label: 'Copy',
            onPressed: selectedId != null
                ? () {
                    if (selectedElement != null &&
                        selectedElement.id.isNotEmpty) {
                      final newElement = LabelElement(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        type: selectedElement.type,
                        position:
                            selectedElement.position + const Offset(20, 20),
                        size: selectedElement.size,
                        rotation: selectedElement.rotation,
                        content: selectedElement.content,
                      );
                      ref
                          .read(labelDesignProvider.notifier)
                          .addElement(newElement);
                    }
                  }
                : null,
          ),
          const SizedBox(width: 8),
          _ControlButton(
            icon: Icons.rotate_right,
            label: 'Rotate',
            onPressed: selectedId != null
                ? () {
                    if (selectedElement != null &&
                        selectedElement.id.isNotEmpty) {
                      ref
                          .read(labelDesignProvider.notifier)
                          .updateElement(
                            selectedElement.id,
                            selectedElement.copyWith(
                              rotation: (selectedElement.rotation + 15) % 360,
                            ),
                          );
                    }
                  }
                : null,
          ),
          const SizedBox(width: 8),
          _ControlButton(
            icon: Icons.align_horizontal_left,
            label: 'Left',
            onPressed: selectedId != null
                ? () {
                    if (selectedElement != null &&
                        selectedElement.id.isNotEmpty) {
                      ref
                          .read(labelDesignProvider.notifier)
                          .updateElement(
                            selectedElement.id,
                            selectedElement.copyWith(
                              position: Offset(0, selectedElement.position.dy),
                            ),
                          );
                    }
                  }
                : null,
          ),
          const SizedBox(width: 8),
          _ControlButton(
            icon: Icons.align_horizontal_right,
            label: 'Right',
            onPressed: selectedId != null
                ? () {
                    if (selectedElement != null &&
                        selectedElement.id.isNotEmpty) {
                      final maxX =
                          design.canvasSize.width - selectedElement.size.width;
                      ref
                          .read(labelDesignProvider.notifier)
                          .updateElement(
                            selectedElement.id,
                            selectedElement.copyWith(
                              position: Offset(
                                maxX,
                                selectedElement.position.dy,
                              ),
                            ),
                          );
                    }
                  }
                : null,
          ),
          const SizedBox(width: 8),
          _ControlButton(
            icon: Icons.align_horizontal_center,
            label: 'Center',
            onPressed: selectedId != null
                ? () {
                    if (selectedElement != null &&
                        selectedElement.id.isNotEmpty) {
                      final centerX =
                          (design.canvasSize.width -
                              selectedElement.size.width) /
                          2;
                      ref
                          .read(labelDesignProvider.notifier)
                          .updateElement(
                            selectedElement.id,
                            selectedElement.copyWith(
                              position: Offset(
                                centerX,
                                selectedElement.position.dy,
                              ),
                            ),
                          );
                    }
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon),
          color: Colors.white,
          iconSize: 20,
          onPressed: onPressed,
        ),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 9)),
      ],
    );
  }
}

// ============================================================================
// ELEMENT TOOLS BAR
// ============================================================================

class _ElementToolsBar extends ConsumerWidget {
  final LabelDesign design;
  final String? selectedId;

  const _ElementToolsBar({required this.design, required this.selectedId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(12),
      child: GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        shrinkWrap: true,
        children: [
          _ElementTool(
            icon: Icons.text_fields,
            label: 'Text',
            type: 'text',
            onAdd: (type) => _addElement(ref, type),
          ),
          _ElementTool(
            icon: Icons.image,
            label: 'Picture',
            type: 'picture',
            onAdd: (type) => _addElement(ref, type),
          ),
          _ElementTool(
            icon: Icons.show_chart,
            label: 'Graph',
            type: 'graph',
            onAdd: (type) => _addElement(ref, type),
          ),
          _ElementTool(
            icon: Icons.star_outline,
            label: 'Icon',
            type: 'icon',
            onAdd: (type) => _addElement(ref, type),
          ),
          _ElementTool(
            icon: Icons.rectangle_outlined,
            label: 'Border',
            type: 'border',
            onAdd: (type) => _addElement(ref, type),
          ),
          _ElementTool(
            icon: Icons.calculate,
            label: 'Bar code',
            type: 'barcode',
            onAdd: (type) => _addElement(ref, type),
          ),
          _ElementTool(
            icon: Icons.qr_code_2,
            label: 'QR code',
            type: 'qrcode',
            onAdd: (type) => _addElement(ref, type),
          ),
          _ElementTool(
            icon: Icons.minimize_outlined,
            label: 'Line',
            type: 'line',
            onAdd: (type) => _addElement(ref, type),
          ),
          _ElementTool(
            icon: Icons.access_time,
            label: 'Time',
            type: 'time',
            onAdd: (type) => _addElement(ref, type),
          ),
          _ElementTool(
            icon: Icons.center_focus_strong,
            label: 'Scan',
            type: 'scan',
            onAdd: (type) => _addElement(ref, type),
          ),
          _ElementTool(
            icon: Icons.dashboard,
            label: 'Tabulation',
            type: 'tabulation',
            onAdd: (type) => _addElement(ref, type),
          ),
        ],
      ),
    );
  }

  void _addElement(WidgetRef ref, String type) {
    final element = LabelElement(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      position: const Offset(10, 10),
      size: const Size(100, 50),
      content: type == 'text' ? 'New Text' : '',
    );
    ref.read(labelDesignProvider.notifier).addElement(element);
  }
}

class _ElementTool extends StatelessWidget {
  final IconData icon;
  final String label;
  final String type;
  final Function(String) onAdd;

  const _ElementTool({
    required this.icon,
    required this.label,
    required this.type,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onAdd(type),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Colors.grey[700]),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// NEW LABEL DIALOG
// ============================================================================

class _NewLabelDialog extends ConsumerWidget {
  const _NewLabelDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final widthController = TextEditingController(text: '57');
    final heightController = TextEditingController(text: '50');

    return Center(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Create New Label',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Label Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widthController,
                    decoration: const InputDecoration(
                      labelText: 'Width (mm)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: heightController,
                    decoration: const InputDecoration(
                      labelText: 'Height (mm)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.isEmpty
                    ? 'Untitled'
                    : nameController.text;
                final width = double.tryParse(widthController.text) ?? 57;
                final height = double.tryParse(heightController.text) ?? 50;

                ref
                    .read(labelDesignProvider.notifier)
                    .createNew(name, Size(width, height));
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                child: Text('Create'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// MAIN APP
// ============================================================================
