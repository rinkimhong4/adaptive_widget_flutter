import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF8B6F47);
  static const Color secondary = Color(0xFFD6B98C);
  static const Color background = Color(0xFFF8F5F2);
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int selectedCategoryIndex = 0;
  String searchQuery = '';
  int selectedSizeIndex = 0;

  List<String> coffeeSize = ["S", "M", "L"];
  final List<double> coffeePrices = [
    0.60, // S
    0.0, // M default
    0.75, // L
  ];

  final List<String> categories = [
    'All Coffees',
    'Espresso',
    'Cappuccino',
    'Latte',
    'Mocha',
    'Cold Brew',
    'Tea & More',
    'Pastries',
  ];

  // Add-ons with prices
  final List<Map<String, dynamic>> addOns = [
    {'name': 'Extra Shot', 'price': 0.70},
    {'name': 'Vanilla Syrup', 'price': 0.70},
    {'name': 'Caramel Drizzle', 'price': 0.70},
  ];

  final List<CoffeeItem> allItems = [
    CoffeeItem(
      name: 'Espresso',
      description: 'Strong & classic',
      price: 3.20,
      category: 'Espresso',
      imageUrl:
          "https://static.vecteezy.com/system/resources/thumbnails/023/438/448/small/espresso-coffee-cutout-free-png.png",
    ),
    CoffeeItem(
      name: 'Cappuccino',
      description: 'Creamy & smooth',
      price: 4.30,
      category: 'Cappuccino',
      imageUrl:
          'https://static.vecteezy.com/system/resources/previews/011/771/100/non_2x/cup-of-cappuccino-png.png',
    ),
    CoffeeItem(
      name: 'Latte',
      description: 'Smooth & velvety',
      price: 4.30,
      category: 'Latte',
      imageUrl:
          'https://static.vecteezy.com/system/resources/thumbnails/023/742/327/small/latte-coffee-isolated-illustration-ai-generative-free-png.png',
    ),
    CoffeeItem(
      name: 'Mocha',
      description: 'Rich & chocolatey',
      price: 4.60,
      category: 'Mocha',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGghVlm6g6nHVGEXSuOJPGTzO64Qt9goyv7Q&s',
    ),
    CoffeeItem(
      name: 'Cold Brew',
      description: 'Chilled & refreshing',
      price: 4.50,
      category: 'Cold Brew',
      imageUrl:
          "https://static.vecteezy.com/system/resources/thumbnails/023/438/448/small/espresso-coffee-cutout-free-png.png",
    ),
    CoffeeItem(
      name: 'Flat White',
      description: 'Bold & velvety',
      price: 4.20,
      category: 'Cappuccino',
      imageUrl:
          'https://static.vecteezy.com/system/resources/previews/011/771/100/non_2x/cup-of-cappuccino-png.png',
    ),
    CoffeeItem(
      name: 'Americano',
      description: 'Bold & smooth',
      price: 3.50,
      category: 'Espresso',
      imageUrl:
          'https://static.vecteezy.com/system/resources/thumbnails/023/742/327/small/latte-coffee-isolated-illustration-ai-generative-free-png.png',
    ),
    CoffeeItem(
      name: 'Macchiato',
      description: 'Espresso with milk',
      price: 3.80,
      category: 'Espresso',
      imageUrl:
          'https://static.vecteezy.com/system/resources/thumbnails/023/742/327/small/latte-coffee-isolated-illustration-ai-generative-free-png.png',
    ),
  ];

  List<CoffeeItem> getFilteredItems() {
    var filtered = allItems;

    if (selectedCategoryIndex > 0) {
      filtered = filtered
          .where((item) => item.category == categories[selectedCategoryIndex])
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (item) =>
                item.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                item.description.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }

    return filtered;
  }

  Widget _buildSidebar() {
    return Container(
      width: 95,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
      ),
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedCategoryIndex == index;
          return _CategoryTile(
            label: categories[index],
            isSelected: isSelected,
            onTap: () {
              setState(() => selectedCategoryIndex = index);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'Our Menu',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: CupertinoSearchTextField(
                onChanged: (value) => setState(() {
                  searchQuery = value;
                }),
                placeholder: 'Search',
                suffixIcon: Icon(Icons.tune, color: Colors.black, size: 24),
                suffixMode: OverlayVisibilityMode.always,
                onSuffixTap: () {
                  if (kDebugMode) {
                    print('Running in debug mode. Extra logging enabled.');
                  }
                },
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  _buildSidebar(),
                  Expanded(
                    child: getFilteredItems().isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.coffee_outlined,
                                  size: 64,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No items found',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            itemCount: getFilteredItems().length,
                            itemBuilder: (context, index) {
                              final item = getFilteredItems()[index];

                              return GestureDetector(
                                onTap: () => showModalBottomSheet(
                                  context: context,
                                  useSafeArea: true,
                                  showDragHandle: true,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (context) {
                                    int selectedSizeIndex = 1;
                                    int quantity = 1;
                                    // Track checked state for each add-on separately
                                    Map<int, bool> addOnChecked = {
                                      0: false,
                                      1: false,
                                      2: false,
                                    };

                                    return StatefulBuilder(
                                      builder: (context, setModalState) {
                                        double currentPrice =
                                            coffeePrices[selectedSizeIndex];

                                        // Calculate add-ons total
                                        double addOnsTotal = 0.0;
                                        addOnChecked.forEach((
                                          index,
                                          isChecked,
                                        ) {
                                          if (isChecked) {
                                            addOnsTotal +=
                                                addOns[index]['price'];
                                          }
                                        });

                                        double totalPrice =
                                            item.price +
                                            currentPrice +
                                            addOnsTotal;

                                        return ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                top: Radius.circular(20),
                                              ),
                                          child: Scaffold(
                                            backgroundColor: Colors.white,
                                            appBar: AppBar(
                                              backgroundColor: Colors.white,
                                              automaticallyImplyLeading: false,
                                              title: const Text(
                                                "Product Details",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              centerTitle: true,
                                              actions: [
                                                GestureDetector(
                                                  onTap: () =>
                                                      Navigator.pop(context),
                                                  child: const Icon(
                                                    CupertinoIcons.xmark,
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                              ],
                                            ),
                                            body: SingleChildScrollView(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 16,
                                                  right: 16,
                                                  top: 20,
                                                  bottom: 20,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // IMAGE
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      child: CachedNetworkImage(
                                                        imageUrl: item.imageUrl,
                                                        fit: BoxFit.cover,
                                                        height: 250,
                                                        width: double.infinity,
                                                        placeholder:
                                                            (
                                                              context,
                                                              url,
                                                            ) => const Center(
                                                              child:
                                                                  CircularProgressIndicator.adaptive(),
                                                            ),
                                                        errorWidget:
                                                            (
                                                              context,
                                                              url,
                                                              error,
                                                            ) => Container(
                                                              height: 250,
                                                              color: Colors
                                                                  .grey[200],
                                                              child: const Icon(
                                                                Icons
                                                                    .broken_image,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 16),

                                                    // Product name & price
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          item.name,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(
                                                          "\$${totalPrice.toStringAsFixed(2)}",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: AppColors
                                                                .primary,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      item.description,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),

                                                    // SIZE SECTION
                                                    Text(
                                                      "Size",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: List.generate(coffeeSize.length, (
                                                        sizeIndex,
                                                      ) {
                                                        final isSelected =
                                                            selectedSizeIndex ==
                                                            sizeIndex;

                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 8,
                                                              ),
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              setModalState(() {
                                                                selectedSizeIndex =
                                                                    sizeIndex;
                                                              });
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        20,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    isSelected
                                                                    ? AppColors
                                                                          .secondary
                                                                    : AppColors
                                                                          .secondary
                                                                          .withValues(
                                                                            alpha:
                                                                                0.3,
                                                                          ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      10,
                                                                    ),
                                                              ),
                                                              child: Text(
                                                                coffeeSize[sizeIndex],
                                                                style: TextStyle(
                                                                  color:
                                                                      isSelected
                                                                      ? Colors
                                                                            .white
                                                                      : Colors
                                                                            .black,
                                                                  fontWeight:
                                                                      isSelected
                                                                      ? FontWeight
                                                                            .w600
                                                                      : FontWeight
                                                                            .normal,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                    const SizedBox(height: 24),

                                                    // ADD-ONS SECTION
                                                    Text(
                                                      "Add-ons",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    ...List.generate(addOns.length, (
                                                      addOnIndex,
                                                    ) {
                                                      final addOn =
                                                          addOns[addOnIndex];
                                                      final isChecked =
                                                          addOnChecked[addOnIndex]!;

                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              bottom: 12,
                                                            ),
                                                        child: Row(
                                                          children: [
                                                            CupertinoCheckbox(
                                                              checkColor:
                                                                  CupertinoColors
                                                                      .white,
                                                              value: isChecked,
                                                              onChanged: (bool? value) {
                                                                setModalState(() {
                                                                  addOnChecked[addOnIndex] =
                                                                      value ??
                                                                      false;
                                                                });
                                                              },
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                addOn['name'],
                                                                style:
                                                                    TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                              ),
                                                            ),
                                                            Text(
                                                              "\$${addOn['price'].toStringAsFixed(2)}",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                                    const SizedBox(height: 24),

                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                                vertical: 5,
                                                              ),

                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              width: 1.5,
                                                              color: AppColors
                                                                  .background,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                            // color: AppColors
                                                            //     .background,
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              CupertinoButton(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                child: Icon(
                                                                  Icons.remove,
                                                                  size: 18,
                                                                ),
                                                                onPressed: () {
                                                                  if (quantity >
                                                                      1) {
                                                                    setModalState(
                                                                      () {
                                                                        quantity--;
                                                                      },
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                              SizedBox(
                                                                width: 30,
                                                                child: Center(
                                                                  child: Text(
                                                                    "$quantity",
                                                                    style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              CupertinoButton(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                child: Icon(
                                                                  Icons.add,
                                                                  size: 18,
                                                                ),
                                                                onPressed: () {
                                                                  setModalState(
                                                                    () {
                                                                      quantity++;
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        Expanded(
                                                          child: CupertinoButton.filled(
                                                            color: AppColors
                                                                .primary,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  .center,
                                                              spacing: 10,
                                                              children: [
                                                                Icon(
                                                                  CupertinoIcons
                                                                      .cart,
                                                                ),
                                                                Text(
                                                                  "Add to Cart",
                                                                ),
                                                              ],
                                                            ),
                                                            onPressed: () {
                                                              // TODO:
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                child: CoffeeItemCard(item: item),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          border: isSelected
              ? Border(left: BorderSide(color: AppColors.primary, width: 4))
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.primary : Colors.black,
            height: 1.4,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class CoffeeItemCard extends StatelessWidget {
  final CoffeeItem item;

  const CoffeeItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    Text(
                      "\$${item.price}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    imageUrl: item.imageUrl,

                    placeholder: (context, url) => Container(
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator.adaptive(),
                    ),

                    errorWidget: (context, url, error) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                // icon add can create to class
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 24),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CoffeeItem {
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;

  CoffeeItem({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
  });
}
