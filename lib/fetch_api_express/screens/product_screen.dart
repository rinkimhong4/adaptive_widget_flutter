import 'package:adaptive_widgeet/fetch_api_express/models/product.dart';
import 'package:adaptive_widgeet/fetch_api_express/providers/product_provider.dart';
import 'package:adaptive_widgeet/fetch_api_express/widgets/product_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchAll();
    });
  }

  Future<void> _onAdd() async {
    final newProduct = await Navigator.push<ProductModel>(
      context,
      MaterialPageRoute(builder: (_) => const ProductFormScreen()),
    );

    if (newProduct == null || !mounted) return;

    final ok = await context.read<ProductProvider>().create(newProduct);

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchAll();
    });

    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product created (mock)')));
    }
  }

  Future<void> _onEdit(ProductModel p) async {
    final edited = await Navigator.push<ProductModel>(
      context,
      MaterialPageRoute(builder: (_) => ProductFormScreen(existing: p)),
    );

    if (edited == null || !mounted) return;

    final ok = await context.read<ProductProvider>().update(
      p.productId,
      edited,
    );

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchAll();
    });

    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product updated (mock)')));
    }
  }

  Future<void> _onDelete(ProductModel p) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete?'),
        content: Text('Delete "${p.name ?? 'this product'}"?'),
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
    final ok = await context.read<ProductProvider>().delete(p.productId);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product deleted (mock)')));
    }
  }

  double _getAverageRating(List<Review>? reviews) {
    if (reviews == null || reviews.isEmpty) return 0;
    final sum = reviews.fold<int>(0, (s, r) => s + (r.rating ?? 0));
    return sum / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F0F0F)
          : const Color(0xFFFAFAFA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Products',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ProductProvider>().fetchAll(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAdd,
        child: const Icon(Icons.add),
      ),
      body: Consumer<ProductProvider>(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final p = provider.items[i];
                    final avgRating = _getAverageRating(p.reviews);
                    final images = (p.imagesList ?? [])
                        .map((i) => i.toString())
                        .toList();
                    final colors = (p.colorsList ?? [])
                        .map((c) => c.toString())
                        .toList();

                    return Card(
                      elevation: 0,
                      color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Theme.of(context).dividerColor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// IMAGE CAROUSEL
                            if (images.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  height: 180,
                                  child: PageView.builder(
                                    itemCount: images.length,
                                    itemBuilder: (_, idx) {
                                      return Image.network(
                                        images[idx],
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: Colors.grey.shade200,
                                          child: const Icon(
                                            Icons.image_not_supported,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            else
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade200,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 48,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 12),

                            /// PRODUCT NAME & PRICE
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.name ?? '(no title)',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${p.price?.toStringAsFixed(2) ?? '-'}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),

                                /// RATING
                                if (p.reviews != null && p.reviews!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            ...List.generate(
                                              5,
                                              (j) => Icon(
                                                Icons.star,
                                                size: 16,
                                                color: j < avgRating.toInt()
                                                    ? Colors.amber
                                                    : Colors.grey.shade300,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${avgRating.toStringAsFixed(1)} (${p.reviews!.length})',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),

                            /// COLORS
                            if (colors.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: colors
                                    .map(
                                      (color) => Chip(
                                        label: Text(color),
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(fontSize: 11),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        backgroundColor: Theme.of(
                                          context,
                                        ).primaryColor.withAlpha(25),
                                        side: BorderSide(
                                          color: Theme.of(
                                            context,
                                          ).primaryColor.withAlpha(80),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],

                            /// DESCRIPTION
                            if (p.description != null &&
                                p.description.toString().isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Text(
                                p.description.toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.color
                                          ?.withAlpha(180),
                                    ),
                              ),
                            ],

                            const SizedBox(height: 12),

                            /// ACTION BUTTONS
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _onEdit(p),
                                  splashRadius: 20,
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _onDelete(p),
                                  splashRadius: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
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
