import 'package:example/models/test.dart';
import 'package:example/providers/test_provider.dart';
import 'package:example/widgets/test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TestProvider>().fetchAll();
    });
  }

  Future<void> _onAdd() async {
    final newProduct = await showProductFormDialog(context);
    if (newProduct == null || !mounted) return;

    final ok = await context.read<TestProvider>().create(newProduct);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product created (mock)')));
    }
  }

  Future<void> _onEdit(ProductD p) async {
    final edited = await showProductFormDialog(context, existing: p);
    if (edited == null || !mounted) return;

    final ok = await context.read<TestProvider>().update(p.id, edited);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product updated (mock)')));
    }
  }

  Future<void> _onDelete(ProductD p) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete?'),
        content: Text('Delete "${p.title ?? 'this product'}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;
    final ok = await context.read<TestProvider>().delete(p.id);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product deleted (mock)')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<TestProvider>().fetchAll(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAdd,
        child: const Icon(Icons.add),
      ),
      body: Consumer<TestProvider>(
        builder: (_, provider, __) {
          if (provider.isLoading && provider.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.hasError && provider.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      provider.errorMessage ?? 'Something went wrong',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => provider.fetchAll(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.isEmpty) {
            return const Center(child: Text('No products yet. Tap + to add.'));
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchAll(),
            child: Stack(
              children: [
                ListView.separated(
                  itemCount: provider.items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final p = provider.items[i];
                    return ListTile(
                      leading: p.image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                p.image!,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 56,
                                  height: 56,
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                            )
                          : Container(
                              width: 56,
                              height: 56,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.shopping_bag),
                            ),
                      title: Text(
                        p.title ?? '(no title)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${p.price?.toStringAsFixed(2) ?? '-'}'
                            '${p.category != null ? ' • ${p.category}' : ''}'
                            '${p.category != null ? ' • ${p.category}' : ''}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (p.rating != null)
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 14,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  p.rating.toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                if (p.price != null) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    'Stock: ${p.price}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ],
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _onEdit(p),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _onDelete(p),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (provider.isLoading)
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
