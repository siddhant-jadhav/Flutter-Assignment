import 'package:flutter/material.dart';

/// Entry point to run this file directly via `flutter run lib/productlisting.dart`
void main() {
  runApp(const ProductListingApp());
}

// =============================================================================
// ENUMS & DATA MODEL
// =============================================================================

/// Categories available for filtering products
enum ProductCategory {
  all('All Items', Icons.grid_view_rounded),
  electronics('Electronics', Icons.laptop_mac_rounded),
  audio('Audio', Icons.headphones_rounded),
  wearables('Wearables', Icons.watch_rounded),
  footwear('Footwear', Icons.directions_run_rounded),
  accessories('Accessories', Icons.backpack_rounded);

  final String label;
  final IconData icon;

  const ProductCategory(this.label, this.icon);
}

/// Available sorting options
enum SortOption {
  featured('Featured', Icons.auto_awesome_rounded),
  priceLowHigh('Price: Low to High', Icons.arrow_upward_rounded),
  priceHighLow('Price: High to Low', Icons.arrow_downward_rounded),
  rating('Highest Rated', Icons.star_rounded),
  nameAZ('Name: A to Z', Icons.sort_by_alpha_rounded);

  final String label;
  final IconData icon;

  const SortOption(this.label, this.icon);
}

/// Strongly typed data model class representing an individual product
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewCount;
  final ProductCategory category;
  final IconData icon;
  final Color accentColor;
  final bool inStock;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.icon,
    required this.accentColor,
    this.inStock = true,
    this.isFavorite = false,
  });

  /// Calculates percentage discount if originalPrice > price
  int get discountPercentage {
    if (originalPrice <= price) return 0;
    return (((originalPrice - price) / originalPrice) * 100).round();
  }

  bool get hasDiscount => originalPrice > price;

  /// Creates a copy of the Product with optional field replacements
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    double? rating,
    int? reviewCount,
    ProductCategory? category,
    IconData? icon,
    Color? accentColor,
    bool? inStock,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      accentColor: accentColor ?? this.accentColor,
      inStock: inStock ?? this.inStock,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

// =============================================================================
// ROOT APPLICATION WIDGET
// =============================================================================

class ProductListingApp extends StatelessWidget {
  const ProductListingApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF4338CA), // Modern Indigo
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Product Catalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: baseScheme,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Slate 50
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF0F172A),
          centerTitle: false,
        ),
      ),
      home: const ProductListingScreen(),
    );
  }
}

// =============================================================================
// MAIN SCREEN (STATEFUL WIDGET WITH DYNAMIC LIST & FILTERING)
// =============================================================================

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  // Search text controller
  final TextEditingController _searchController = TextEditingController();

  // State variables driving the UI
  String _searchQuery = '';
  ProductCategory _selectedCategory = ProductCategory.all;
  SortOption _selectedSort = SortOption.featured;
  bool _showFavoritesOnly = false;
  double _maxPriceFilter = 2000.0;

  // Master product catalog managed in memory
  late final List<Product> _products;

  @override
  void initState() {
    super.initState();
    _products = _initializeMockCatalog();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Initial catalog with 12 diverse, realistic products across categories
  List<Product> _initializeMockCatalog() {
    return [
      Product(
        id: 'prod_1',
        name: 'Sony WH-1000XM5 Wireless Headphones',
        description: 'Industry-leading noise cancellation with two processors and 8 microphones. Up to 30h battery life.',
        price: 349.99,
        originalPrice: 399.99,
        rating: 4.8,
        reviewCount: 1240,
        category: ProductCategory.audio,
        icon: Icons.headphones_rounded,
        accentColor: const Color(0xFF0284C7),
        inStock: true,
      ),
      Product(
        id: 'prod_2',
        name: 'Apple Watch Series 9 GPS',
        description: 'Advanced health sensors, Double Tap gesture, brighter Always-On Retina display, and S9 SiP chip.',
        price: 399.00,
        originalPrice: 429.00,
        rating: 4.9,
        reviewCount: 2150,
        category: ProductCategory.wearables,
        icon: Icons.watch_rounded,
        accentColor: const Color(0xFFE11D48),
        inStock: true,
        isFavorite: true,
      ),
      Product(
        id: 'prod_3',
        name: 'Dell XPS 15 OLED InfinityEdge',
        description: '15.6-inch 3.5K OLED touch display, Intel Core i7 13th Gen, 32GB DDR5 RAM, 1TB NVMe SSD.',
        price: 1499.00,
        originalPrice: 1699.00,
        rating: 4.7,
        reviewCount: 820,
        category: ProductCategory.electronics,
        icon: Icons.laptop_chromebook_rounded,
        accentColor: const Color(0xFF4F46E5),
        inStock: true,
      ),
      Product(
        id: 'prod_4',
        name: 'Nike Air Max 270 Flyknit',
        description: 'Large volume Max Air heel unit delivers responsive cushioning with breathable sock-like fit.',
        price: 150.00,
        originalPrice: 180.00,
        rating: 4.6,
        reviewCount: 940,
        category: ProductCategory.footwear,
        icon: Icons.directions_run_rounded,
        accentColor: const Color(0xFFEA580C),
        inStock: true,
      ),
      Product(
        id: 'prod_5',
        name: 'Logitech MX Master 3S Mouse',
        description: 'Quiet clicks, 8K DPI any-surface tracking, MagSpeed electromagnetic scrolling, ergonomic design.',
        price: 99.99,
        originalPrice: 119.99,
        rating: 4.9,
        reviewCount: 3400,
        category: ProductCategory.electronics,
        icon: Icons.mouse_rounded,
        accentColor: const Color(0xFF0D9488),
        inStock: true,
        isFavorite: true,
      ),
      Product(
        id: 'prod_6',
        name: 'Bose SoundLink Flex Bluetooth Speaker',
        description: 'PositionIQ technology, waterproof and dustproof (IP67), engineered for deep clear sound anywhere.',
        price: 129.00,
        originalPrice: 149.00,
        rating: 4.7,
        reviewCount: 1530,
        category: ProductCategory.audio,
        icon: Icons.speaker_rounded,
        accentColor: const Color(0xFF2563EB),
        inStock: true,
      ),
      Product(
        id: 'prod_7',
        name: 'Peak Design Everyday Backpack 20L',
        description: 'Ultra-durable weatherproof 100% recycled nylon shell with customizable FlexFold dividers.',
        price: 279.95,
        originalPrice: 299.95,
        rating: 4.8,
        reviewCount: 670,
        category: ProductCategory.accessories,
        icon: Icons.backpack_rounded,
        accentColor: const Color(0xFF7C3AED),
        inStock: true,
      ),
      Product(
        id: 'prod_8',
        name: 'Samsung Galaxy Watch Ultra 47mm',
        description: 'Titanium cushion design, dual-frequency GPS, multi-day battery life, and 100m water resistance.',
        price: 649.99,
        originalPrice: 699.99,
        rating: 4.6,
        reviewCount: 410,
        category: ProductCategory.wearables,
        icon: Icons.watch_outlined,
        accentColor: const Color(0xFF059669),
        inStock: true,
      ),
      Product(
        id: 'prod_9',
        name: 'Adidas Ultraboost Light Running Shoes',
        description: 'Lightest Ultraboost ever made with 30% lighter BOOST material and Continental Rubber outsole.',
        price: 190.00,
        originalPrice: 210.00,
        rating: 4.7,
        reviewCount: 1180,
        category: ProductCategory.footwear,
        icon: Icons.run_circle_outlined,
        accentColor: const Color(0xFFD97706),
        inStock: false,
      ),
      Product(
        id: 'prod_10',
        name: 'Anker Prime 140W GaN Power Bank',
        description: '24,000mAh capacity, smart digital display, two USB-C ports providing up to 140W fast charge.',
        price: 109.99,
        originalPrice: 139.99,
        rating: 4.8,
        reviewCount: 1890,
        category: ProductCategory.accessories,
        icon: Icons.battery_charging_full_rounded,
        accentColor: const Color(0xFF16A34A),
        inStock: true,
      ),
      Product(
        id: 'prod_11',
        name: 'Keychron Q1 Pro Mechanical Keyboard',
        description: 'Full aluminum CNC body, hot-swappable QMK/VIA programmable, wireless Bluetooth and wired mode.',
        price: 199.00,
        originalPrice: 219.00,
        rating: 4.9,
        reviewCount: 760,
        category: ProductCategory.electronics,
        icon: Icons.keyboard_rounded,
        accentColor: const Color(0xFF9333EA),
        inStock: true,
      ),
      Product(
        id: 'prod_12',
        name: 'Shure SM7B Vocal Dynamic Studio Mic',
        description: 'Legendary broadcast vocal microphone with smooth, flat wide-range frequency response for studio speech.',
        price: 399.00,
        originalPrice: 449.00,
        rating: 4.9,
        reviewCount: 2890,
        category: ProductCategory.audio,
        icon: Icons.mic_external_on_rounded,
        accentColor: const Color(0xFF475569),
        inStock: true,
      ),
    ];
  }

  // ===========================================================================
  // COMPUTED FILTERED AND SORTED LIST
  // ===========================================================================

  /// Pure computation that returns filtered and sorted products based on current state
  List<Product> get _filteredProducts {
    final query = _searchQuery.trim().toLowerCase();

    final result = _products.where((product) {
      // 1. Category Filter
      if (_selectedCategory != ProductCategory.all &&
          product.category != _selectedCategory) {
        return false;
      }

      // 2. Favorites Filter
      if (_showFavoritesOnly && !product.isFavorite) {
        return false;
      }

      // 3. Price Filter
      if (product.price > _maxPriceFilter) {
        return false;
      }

      // 4. Search Filter (matches name, description, or category)
      if (query.isNotEmpty) {
        final matchesName = product.name.toLowerCase().contains(query);
        final matchesDesc = product.description.toLowerCase().contains(query);
        final matchesCategory =
            product.category.label.toLowerCase().contains(query);
        if (!matchesName && !matchesDesc && !matchesCategory) {
          return false;
        }
      }

      return true;
    }).toList();

    // Apply Sorting
    switch (_selectedSort) {
      case SortOption.priceLowHigh:
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighLow:
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.rating:
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.nameAZ:
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.featured:
        // Preserves catalog default ordering
        break;
    }

    return result;
  }

  int get _favoriteCount => _products.where((p) => p.isFavorite).length;

  // ===========================================================================
  // STATE MUTATION METHODS (UTILIZING setState)
  // ===========================================================================

  /// Triggered whenever search input text changes
  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  /// Clears the search text box and resets search state
  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  /// Triggered when the user taps a category filter chip
  void _onCategorySelected(ProductCategory category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  /// Triggered when the user selects a sort option
  void _onSortChanged(SortOption option) {
    setState(() {
      _selectedSort = option;
    });
  }

  /// Toggles the 'Favorites Only' view
  void _toggleFavoritesFilter() {
    setState(() {
      _showFavoritesOnly = !_showFavoritesOnly;
    });
  }

  /// Toggles favorite status on a product
  void _toggleFavoriteProduct(String productId) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      setState(() {
        _products[index].isFavorite = !_products[index].isFavorite;
      });

      final isFav = _products[index].isFavorite;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isFav ? Colors.redAccent : Colors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isFav
                      ? 'Added "${_products[index].name}" to favorites'
                      : 'Removed "${_products[index].name}" from favorites',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  /// Resets all filters to show full catalog
  void _resetAllFilters() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _selectedCategory = ProductCategory.all;
      _selectedSort = SortOption.featured;
      _showFavoritesOnly = false;
      _maxPriceFilter = 2000.0;
    });
  }

  /// Appends a newly created product dynamically to demonstrate real-time list growth
  void _addNewProduct(Product product) {
    setState(() {
      _products.insert(0, product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Product "${product.name}" added successfully!'),
        backgroundColor: const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Deletes a product with an undo option
  void _deleteProduct(Product product) {
    final removedIndex = _products.indexWhere((p) => p.id == product.id);
    if (removedIndex == -1) return;

    setState(() {
      _products.removeAt(removedIndex);
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed "${product.name}"'),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.amberAccent,
          onPressed: () {
            setState(() {
              _products.insert(removedIndex, product);
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ===========================================================================
  // BUILD METHOD & UI WIDGET TREE
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts;
    final hasActiveFilters = _searchQuery.isNotEmpty ||
        _selectedCategory != ProductCategory.all ||
        _showFavoritesOnly ||
        _selectedSort != SortOption.featured ||
        _maxPriceFilter < 2000.0;

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Search Bar & Filter Header
          _buildSearchAndFilterHeader(),

          // Category Chips Horizontal Carousel
          _buildCategoryFilterRow(),

          // Status & Sorting Indicator Bar
          _buildMetricsBar(filtered.length, hasActiveFilters),

          // Dynamic Product Listing using ListView.builder
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState()
                : _buildProductListView(filtered),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddProductBottomSheet,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Product',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF4338CA),
        foregroundColor: Colors.white,
      ),
    );
  }

  /// Top Navigation AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4338CA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: Color(0xFF4338CA),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PrimeCatalog',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Dynamic ListView.builder with setState',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Favorites quick-toggle button with badge
        IconButton(
          tooltip: _showFavoritesOnly ? 'Show all products' : 'Show favorites only',
          onPressed: _toggleFavoritesFilter,
          icon: Badge(
            isLabelVisible: _favoriteCount > 0,
            label: Text('$_favoriteCount'),
            backgroundColor: const Color(0xFFE11D48),
            child: Icon(
              _showFavoritesOnly
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: _showFavoritesOnly ? const Color(0xFFE11D48) : const Color(0xFF475569),
            ),
          ),
        ),
        // Sort Menu Button
        PopupMenuButton<SortOption>(
          tooltip: 'Sort Products',
          icon: const Icon(Icons.swap_vert_rounded, color: Color(0xFF475569)),
          initialValue: _selectedSort,
          onSelected: _onSortChanged,
          itemBuilder: (context) => SortOption.values.map((option) {
            return PopupMenuItem(
              value: option,
              child: Row(
                children: [
                  Icon(
                    option.icon,
                    size: 18,
                    color: _selectedSort == option
                        ? const Color(0xFF4338CA)
                        : const Color(0xFF64748B),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    option.label,
                    style: TextStyle(
                      fontWeight: _selectedSort == option
                          ? FontWeight.w700
                          : FontWeight.normal,
                      color: _selectedSort == option
                          ? const Color(0xFF4338CA)
                          : const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// Search Bar with instant feedback and clear trigger
  Widget _buildSearchAndFilterHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search products by name, description, category...',
          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B)),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  color: const Color(0xFF64748B),
                  onPressed: _clearSearch,
                )
              : null,
          filled: true,
          fillColor: const Color(0xFFF1F5F9),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF4338CA), width: 1.5),
          ),
        ),
      ),
    );
  }

  /// Horizontally scrollable Category Filter Chips
  Widget _buildCategoryFilterRow() {
    return Container(
      color: Colors.white,
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: ProductCategory.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = ProductCategory.values[index];
          final isSelected = _selectedCategory == category;

          // Count items matching this category
          final count = category == ProductCategory.all
              ? _products.length
              : _products.where((p) => p.category == category).length;

          return FilterChip(
            showCheckmark: false,
            avatar: Icon(
              category.icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
            ),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(category.label),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.25)
                        : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : const Color(0xFF475569),
                    ),
                  ),
                ),
              ],
            ),
            selected: isSelected,
            onSelected: (_) => _onCategorySelected(category),
            selectedColor: const Color(0xFF4338CA),
            backgroundColor: const Color(0xFFF8FAFC),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF334155),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 13,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? const Color(0xFF4338CA) : const Color(0xFFE2E8F0),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          );
        },
      ),
    );
  }

  /// Metrics & filter indicators bar
  Widget _buildMetricsBar(int count, bool hasActiveFilters) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Showing $count ${count == 1 ? "product" : "products"}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF334155),
            ),
          ),
          if (_showFavoritesOnly) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE4E6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_rounded, size: 12, color: Color(0xFFE11D48)),
                  SizedBox(width: 4),
                  Text(
                    'Favorites',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE11D48),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const Spacer(),
          if (hasActiveFilters)
            TextButton.icon(
              onPressed: _resetAllFilters,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: const Icon(Icons.refresh_rounded, size: 14, color: Color(0xFF4338CA)),
              label: const Text(
                'Reset Filters',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4338CA),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Dynamic list implementation utilizing ListView.builder
  Widget _buildProductListView(List<Product> products) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _ProductCard(
          key: ValueKey(product.id),
          product: product,
          onToggleFavorite: () => _toggleFavoriteProduct(product.id),
          onDelete: () => _deleteProduct(product),
          onAddToCart: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('"${product.name}" added to shopping cart!'),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
        );
      },
    );
  }

  /// Empty state illustration and action when filters produce no items
  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFEEF2FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 56,
                color: Color(0xFF4338CA),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Products Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No results match "$_searchQuery". Try refining your search query or adjusting your category filters.'
                  : 'No products match the selected criteria.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _resetAllFilters,
              icon: const Icon(Icons.filter_alt_off_rounded, size: 18),
              label: const Text('Reset All Filters'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4338CA),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Modal Bottom Sheet to dynamically add a new product into the list via setState
  void _openAddProductBottomSheet() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final priceController = TextEditingController();
    ProductCategory chosenCategory = ProductCategory.electronics;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                top: 24,
                left: 20,
                right: 20,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Add New Product',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Product Name
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Product Name',
                          hintText: 'e.g. Sony Wireless Earbuds',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Product name is required'
                                : null,
                      ),
                      const SizedBox(height: 14),
                      // Category Dropdown
                      DropdownButtonFormField<ProductCategory>(
                        value: chosenCategory,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: ProductCategory.values
                            .where((c) => c != ProductCategory.all)
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Row(
                                    children: [
                                      Icon(c.icon, size: 18, color: const Color(0xFF4338CA)),
                                      const SizedBox(width: 10),
                                      Text(c.label),
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() => chosenCategory = val);
                          }
                        },
                      ),
                      const SizedBox(height: 14),
                      // Price
                      TextFormField(
                        controller: priceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Price (\$USD)',
                          hintText: 'e.g. 199.99',
                          prefixText: '\$ ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Price is required';
                          }
                          final parsed = double.tryParse(value.trim());
                          if (parsed == null || parsed <= 0) {
                            return 'Enter a valid positive number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      // Description
                      TextFormField(
                        controller: descController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Brief highlight of features and specifications...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Description is required'
                                : null,
                      ),
                      const SizedBox(height: 20),
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final price = double.parse(priceController.text.trim());
                              final newProduct = Product(
                                id: 'prod_${DateTime.now().millisecondsSinceEpoch}',
                                name: nameController.text.trim(),
                                description: descController.text.trim(),
                                price: price,
                                originalPrice: price * 1.15,
                                rating: 5.0,
                                reviewCount: 1,
                                category: chosenCategory,
                                icon: chosenCategory.icon,
                                accentColor: const Color(0xFF4338CA),
                                inStock: true,
                              );
                              _addNewProduct(newProduct);
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(Icons.check_circle_rounded),
                          label: const Text(
                            'Add to Catalog',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4338CA),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// =============================================================================
// PRODUCT CARD COMPONENT (WIDGET RENDERING INSIDE ListView.builder)
// =============================================================================

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onToggleFavorite;
  final VoidCallback onDelete;
  final VoidCallback onAddToCart;

  const _ProductCard({
    super.key,
    required this.product,
    required this.onToggleFavorite,
    required this.onDelete,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row with Visual Icon, Title, Category Badge, and Favorite Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Icon in vibrant container
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: product.accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: product.accentColor.withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    product.icon,
                    color: product.accentColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                // Title and Category
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Tag & Stock Status
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              product.category.label.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF475569),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // In Stock / Out of Stock
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: product.inStock
                                  ? const Color(0xFFDCFCE7)
                                  : const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: product.inStock
                                        ? const Color(0xFF16A34A)
                                        : const Color(0xFFDC2626),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  product.inStock ? 'In Stock' : 'Out of Stock',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: product.inStock
                                        ? const Color(0xFF15803D)
                                        : const Color(0xFFB91C1C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Product Name
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Favorite Heart Button (Mutates state via callback)
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    product.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: product.isFavorite
                        ? const Color(0xFFE11D48)
                        : const Color(0xFF94A3B8),
                    size: 22,
                  ),
                  onPressed: onToggleFavorite,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Product Description Snippet
            Text(
              product.description,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
                height: 1.35,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            const Divider(color: Color(0xFFF1F5F9), height: 1),
            const SizedBox(height: 10),

            // Bottom row: Rating, Pricing, and Cart Button
            Row(
              children: [
                // Star Rating & Review Count
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, size: 15, color: Color(0xFFD97706)),
                      const SizedBox(width: 3),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '(${product.reviewCount})',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Spacer(),

                // Price Display
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        if (product.hasDiscount) ...[
                          const SizedBox(width: 6),
                          Text(
                            '\$${product.originalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (product.hasDiscount)
                      Text(
                        'Save ${product.discountPercentage}%',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),

                // Add to Cart Button
                ElevatedButton(
                  onPressed: product.inStock ? onAddToCart : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4338CA),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    minimumSize: const Size(0, 36),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shopping_cart_outlined, size: 15),
                      const SizedBox(width: 6),
                      Text(
                        product.inStock ? 'Add' : 'Out',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
