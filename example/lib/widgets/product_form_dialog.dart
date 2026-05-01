import 'package:example/models/product.dart';
import 'package:flutter/material.dart';

/// Reusable form dialog for creating or editing a Product.
/// Returns the new/edited Product on save, or null on cancel.
Future<Product?> showProductFormDialog(
  BuildContext context, {
  Product? existing,
}) {
  final isEdit = existing != null;
  final titleCtrl = TextEditingController(text: existing?.title ?? '');
  final priceCtrl = TextEditingController(
    text: existing?.price?.toString() ?? '',
  );
  final descCtrl = TextEditingController(text: existing?.description ?? '');
  final categoryCtrl = TextEditingController(text: existing?.category ?? '');
  final brandCtrl = TextEditingController(text: existing?.brand ?? '');
  final stockCtrl = TextEditingController(
    text: existing?.stock?.toString() ?? '',
  );
  final formKey = GlobalKey<FormState>();

  return showDialog<Product>(
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
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Title is required'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Price is required';
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
                controller: brandCtrl,
                decoration: const InputDecoration(labelText: 'Brand'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: stockCtrl,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  if (int.tryParse(v) == null) return 'Invalid number';
                  return null;
                },
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
            final result = Product(
              id: existing?.id,
              title: titleCtrl.text.trim(),
              price: double.parse(priceCtrl.text),
              description: descCtrl.text.trim().isEmpty
                  ? null
                  : descCtrl.text.trim(),
              category: categoryCtrl.text.trim().isEmpty
                  ? null
                  : categoryCtrl.text.trim(),
              brand: brandCtrl.text.trim().isEmpty
                  ? null
                  : brandCtrl.text.trim(),
              stock: stockCtrl.text.trim().isEmpty
                  ? null
                  : int.tryParse(stockCtrl.text),
              // Preserve other fields when editing so we don't lose data on update
              thumbnail: existing?.thumbnail,
              images: existing?.images,
              rating: existing?.rating,
              tags: existing?.tags,
              sku: existing?.sku,
            );
            Navigator.pop(ctx, result);
          },
          child: Text(isEdit ? 'Update' : 'Create'),
        ),
      ],
    ),
  );
}
