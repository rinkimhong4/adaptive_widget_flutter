import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:adaptive_widgeet/fetch_api_express/models/product.dart';

class ProductFormScreen extends StatefulWidget {
  final ProductModel? existing;

  const ProductFormScreen({super.key, this.existing});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController descCtrl;
  late TextEditingController categoryCtrl;
  late TextEditingController colorCtrl;
  late TextEditingController imageCtrl;

  List<String> colors = [];
  List<String> images = [];

  final ImagePicker picker = ImagePicker();
  final Dio dio = Dio();

  bool isUploading = false;
  double progress = 0;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool get isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();

    final p = widget.existing;

    nameCtrl = TextEditingController(text: p?.name ?? '');
    priceCtrl = TextEditingController(text: p?.price?.toString() ?? '');
    descCtrl = TextEditingController(text: p?.description ?? '');
    categoryCtrl = TextEditingController(text: p?.categoryId?.toString() ?? '');
    colorCtrl = TextEditingController();
    imageCtrl = TextEditingController();

    if (p != null) {
      colors = (p.colorsList ?? []).map((e) => e.toString()).toList();
      images = (p.imagesList ?? []).map((e) => e.toString()).toList();
    }
  }

  // ---------------- UPLOAD IMAGE ----------------
  Future<String?> uploadImage(File file) async {
    try {
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path),
      });

      final response = await dio.post(
        "http://localhost:3000/upload",
        data: formData,
        onSendProgress: (sent, total) {
          setState(() {
            progress = sent / total;
          });
        },
      );

      return response.data["url"];
    } catch (e) {
      return null;
    }
  }

  // ---------------- PICK + UPLOAD ----------------
  Future<void> pickAndUpload() async {
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (file == null) return;

    setState(() {
      isUploading = true;
      progress = 0;
    });

    final url = await uploadImage(File(file.path));

    if (url != null) {
      setState(() {
        images.add(url);
      });
    }

    setState(() {
      isUploading = false;
      progress = 0;
    });
  }

  // ---------------- COLOR ----------------
  void _addColor(String color) {
    if (color.trim().isEmpty) return;
    setState(() {
      colors.add(color.trim());
      colorCtrl.clear();
    });
  }

  void _removeColor(int i) => setState(() => colors.removeAt(i));

  void _removeImage(int i) => setState(() => images.removeAt(i));

  void _submit() {
    if (!mounted) return;

    final state = _formKey.currentState;

    if (state == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Form not ready")));
      return;
    }

    if (!state.validate()) return;

    state.save();

    final product = ProductModel(
      productId: widget.existing?.productId,
      name: nameCtrl.text.trim(),
      price: double.tryParse(priceCtrl.text),
      description: descCtrl.text,
      categoryId: int.tryParse(categoryCtrl.text),
      colorsList: colors,
      imagesList: images,
    );

    print(product);

    Navigator.pop(context, product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit" : "Create Product")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // NAME
            TextFormField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Name"),
            ),

            const SizedBox(height: 10),

            // PRICE
            TextFormField(
              controller: priceCtrl,
              decoration: const InputDecoration(labelText: "Price"),
            ),

            const SizedBox(height: 10),

            // CATEGORY
            TextFormField(
              controller: categoryCtrl,
              decoration: const InputDecoration(labelText: "Category"),
            ),

            const SizedBox(height: 10),

            // DESCRIPTION
            TextFormField(
              controller: descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Description"),
            ),

            const SizedBox(height: 20),

            // COLORS
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: colorCtrl,
                    decoration: const InputDecoration(labelText: "Color"),
                  ),
                ),
                IconButton(
                  onPressed: () => _addColor(colorCtrl.text),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),

            Wrap(
              children: colors
                  .map(
                    (c) => Chip(
                      label: Text(c),
                      onDeleted: () => _removeColor(colors.indexOf(c)),
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 20),

            // IMAGE UPLOAD BUTTON
            ElevatedButton.icon(
              onPressed: pickAndUpload,
              icon: const Icon(Icons.upload),
              label: const Text("Upload Image"),
            ),

            // PROGRESS
            if (isUploading)
              Column(
                children: [
                  LinearProgressIndicator(value: progress),
                  Text("${(progress * 100).toStringAsFixed(0)}%"),
                ],
              ),

            const SizedBox(height: 10),

            // IMAGES
            Wrap(
              spacing: 8,
              children: images
                  .map(
                    (img) => Stack(
                      children: [
                        Image.network(
                          img,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _removeImage(images.indexOf(img)),
                            child: const Icon(Icons.close, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),

            const SizedBox(height: 20),

            // SUBMIT
            ElevatedButton(
              onPressed: _submit,
              child: Text(isEdit ? "Update" : "Create"),
            ),
          ],
        ),
      ),
    );
  }
}
