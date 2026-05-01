import 'package:example/models/test.dart';
import 'package:flutter/material.dart';

Future<ProductD?> showProductFormDialog(
  BuildContext context, {
  ProductD? existing,
}) {
  final isEdit = existing != null;

  final titleCtrl = TextEditingController(text: existing?.title ?? '');
  final priceCtrl = TextEditingController(
    text: existing?.price?.toString() ?? '',
  );
  final descCtrl = TextEditingController(text: existing?.description ?? '');
  final categoryCtrl = TextEditingController(text: existing?.category ?? '');
  final imageCtrl = TextEditingController(text: existing?.image ?? '');

  final formKey = GlobalKey<FormState>();

  return showDialog<ProductD>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(isEdit ? 'Edit Product' : 'Add Product'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (double.tryParse(v) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: categoryCtrl,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: imageCtrl,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) return;

            final result = ProductD(
              id: existing?.id,
              title: titleCtrl.text.trim(),
              price: double.parse(priceCtrl.text),
              description: descCtrl.text.trim().isEmpty
                  ? null
                  : descCtrl.text.trim(),
              category: categoryCtrl.text.trim().isEmpty
                  ? null
                  : categoryCtrl.text.trim(),
              image: imageCtrl.text.trim().isEmpty
                  ? null
                  : imageCtrl.text.trim(),

              // preserve rating when editing
              rating: existing?.rating,
            );

            Navigator.pop(ctx, result);
          },
          child: Text(isEdit ? 'Update' : 'Create'),
        ),
      ],
    ),
  );
}
