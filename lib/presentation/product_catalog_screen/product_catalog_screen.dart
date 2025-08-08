import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_chip_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/product_card_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/sort_fab_widget.dart';

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _selectedCategory = 'All';
  String _searchQuery = '';
  String _currentSort = 'relevance';
  Map<String, dynamic> _activeFilters = {};
  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;

  List<Map<String, dynamic>> _allProducts = [];
  List<Map<String, dynamic>> _filteredProducts = [];

  final List<String> _categories = [
    'All',
    'Yarn',
    'Fabric',
    'Buttons',
    'Zippers'
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeData() {
    _allProducts = [
      {
        "id": 1,
        "name": "Premium Cotton Yarn",
        "category": "Yarn",
        "price": "₹850",
        "priceValue": 850.0,
        "supplier": "Ludhiana Textiles Ltd",
        "rating": 4.5,
        "image":
            "https://images.pexels.com/photos/6069112/pexels-photo-6069112.jpeg",
        "location": "Ludhiana",
        "material": "Cotton",
        "availability": "In Stock",
        "dateAdded": DateTime.now().subtract(const Duration(days: 2)),
      },
      {
        "id": 2,
        "name": "Silk Fabric Roll",
        "category": "Fabric",
        "price": "₹2,400",
        "priceValue": 2400.0,
        "supplier": "Delhi Silk House",
        "rating": 4.8,
        "image":
            "https://images.pexels.com/photos/6069113/pexels-photo-6069113.jpeg",
        "location": "Delhi",
        "material": "Silk",
        "availability": "In Stock",
        "dateAdded": DateTime.now().subtract(const Duration(days: 1)),
      },
      {
        "id": 3,
        "name": "Metal Buttons Set",
        "category": "Buttons",
        "price": "₹320",
        "priceValue": 320.0,
        "supplier": "Mumbai Button Co",
        "rating": 4.2,
        "image":
            "https://images.pexels.com/photos/6069114/pexels-photo-6069114.jpeg",
        "location": "Mumbai",
        "material": "Metal",
        "availability": "Pre-Order",
        "dateAdded": DateTime.now().subtract(const Duration(days: 3)),
      },
      {
        "id": 4,
        "name": "Heavy Duty Zippers",
        "category": "Zippers",
        "price": "₹180",
        "priceValue": 180.0,
        "supplier": "Bangalore Fasteners",
        "rating": 4.0,
        "image":
            "https://images.pexels.com/photos/6069115/pexels-photo-6069115.jpeg",
        "location": "Bangalore",
        "material": "Polyester",
        "availability": "In Stock",
        "dateAdded": DateTime.now().subtract(const Duration(days: 4)),
      },
      {
        "id": 5,
        "name": "Polyester Yarn Blend",
        "category": "Yarn",
        "price": "₹650",
        "priceValue": 650.0,
        "supplier": "Chennai Synthetics",
        "rating": 4.3,
        "image":
            "https://images.pexels.com/photos/6069116/pexels-photo-6069116.jpeg",
        "location": "Chennai",
        "material": "Polyester",
        "availability": "Custom Order",
        "dateAdded": DateTime.now().subtract(const Duration(days: 5)),
      },
      {
        "id": 6,
        "name": "Linen Fabric Premium",
        "category": "Fabric",
        "price": "₹1,800",
        "priceValue": 1800.0,
        "supplier": "Ludhiana Linen Mills",
        "rating": 4.6,
        "image":
            "https://images.pexels.com/photos/6069117/pexels-photo-6069117.jpeg",
        "location": "Ludhiana",
        "material": "Linen",
        "availability": "In Stock",
        "dateAdded": DateTime.now().subtract(const Duration(days: 6)),
      },
      {
        "id": 7,
        "name": "Wooden Buttons Eco",
        "category": "Buttons",
        "price": "₹450",
        "priceValue": 450.0,
        "supplier": "Delhi Eco Buttons",
        "rating": 4.4,
        "image":
            "https://images.pexels.com/photos/6069118/pexels-photo-6069118.jpeg",
        "location": "Delhi",
        "material": "Wood",
        "availability": "In Stock",
        "dateAdded": DateTime.now().subtract(const Duration(days: 7)),
      },
      {
        "id": 8,
        "name": "Invisible Zippers",
        "category": "Zippers",
        "price": "₹220",
        "priceValue": 220.0,
        "supplier": "Mumbai Zip Solutions",
        "rating": 4.1,
        "image":
            "https://images.pexels.com/photos/6069119/pexels-photo-6069119.jpeg",
        "location": "Mumbai",
        "material": "Nylon",
        "availability": "Pre-Order",
        "dateAdded": DateTime.now().subtract(const Duration(days: 8)),
      },
    ];

    _applyFiltersAndSort();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreProducts();
    }
  }

  void _loadMoreProducts() {
    if (!_isLoading && _hasMoreData) {
      setState(() {
        _isLoading = true;
      });

      // Simulate loading more products
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _currentPage++;
            // In a real app, you would load more products here
            if (_currentPage > 3) {
              _hasMoreData = false;
            }
          });
        }
      });
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _applyFiltersAndSort();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFiltersAndSort();
  }

  void _onFiltersApplied(Map<String, dynamic> filters) {
    setState(() {
      _activeFilters = filters;
    });
    _applyFiltersAndSort();
  }

  void _onSortSelected(String sortType) {
    setState(() {
      _currentSort = sortType;
    });
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    List<Map<String, dynamic>> filtered = List.from(_allProducts);

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((product) =>
              (product["category"] as String?) == _selectedCategory)
          .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        final name = (product["name"] as String?)?.toLowerCase() ?? '';
        final supplier = (product["supplier"] as String?)?.toLowerCase() ?? '';
        final category = (product["category"] as String?)?.toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();
        return name.contains(query) ||
            supplier.contains(query) ||
            category.contains(query);
      }).toList();
    }

    // Apply advanced filters
    if (_activeFilters.isNotEmpty) {
      if (_activeFilters['location'] != null &&
          _activeFilters['location'] != 'All') {
        filtered = filtered
            .where((product) =>
                (product["location"] as String?) == _activeFilters['location'])
            .toList();
      }

      if (_activeFilters['material'] != null &&
          _activeFilters['material'] != 'All') {
        filtered = filtered
            .where((product) =>
                (product["material"] as String?) == _activeFilters['material'])
            .toList();
      }

      if (_activeFilters['availability'] != null &&
          _activeFilters['availability'] != 'All') {
        filtered = filtered
            .where((product) =>
                (product["availability"] as String?) ==
                _activeFilters['availability'])
            .toList();
      }

      if (_activeFilters['priceMin'] != null &&
          _activeFilters['priceMax'] != null) {
        filtered = filtered.where((product) {
          final price = (product["priceValue"] as double?) ?? 0.0;
          return price >= (_activeFilters['priceMin'] as double) &&
              price <= (_activeFilters['priceMax'] as double);
        }).toList();
      }
    }

    // Apply sorting
    switch (_currentSort) {
      case 'price_low_high':
        filtered.sort((a, b) => ((a["priceValue"] as double?) ?? 0.0)
            .compareTo((b["priceValue"] as double?) ?? 0.0));
        break;
      case 'price_high_low':
        filtered.sort((a, b) => ((b["priceValue"] as double?) ?? 0.0)
            .compareTo((a["priceValue"] as double?) ?? 0.0));
        break;
      case 'rating':
        filtered.sort((a, b) => ((b["rating"] as double?) ?? 0.0)
            .compareTo((a["rating"] as double?) ?? 0.0));
        break;
      case 'newest':
        filtered.sort((a, b) =>
            ((b["dateAdded"] as DateTime?) ?? DateTime.now())
                .compareTo((a["dateAdded"] as DateTime?) ?? DateTime.now()));
        break;
      default: // relevance
        break;
    }

    setState(() {
      _filteredProducts = filtered;
    });
  }

  void _onVoiceSearch() {
    // Voice search implementation would go here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Voice search feature coming soon!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onProductTap(Map<String, dynamic> product) {
    // Navigate to product detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${product["name"] ?? "product"} details...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onAddToCart(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product["name"] ?? "Product"} added to cart!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: AppTheme.lightTheme.colorScheme.onTertiary,
          onPressed: () {
            Navigator.pushNamed(context, '/shopping-cart-screen');
          },
        ),
      ),
    );
  }

  void _onViewSupplier(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Viewing ${product["supplier"] ?? "supplier"} profile...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onShareProduct(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${product["name"] ?? "product"}...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Product Catalog',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/shopping-cart-screen');
            },
            icon: CustomIconWidget(
              iconName: 'shopping_cart',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _initializeData();
          await Future.delayed(const Duration(seconds: 1));
        },
        color: AppTheme.lightTheme.colorScheme.primary,
        child: Column(
          children: [
            // Search Bar
            SearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onFilterTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => FilterBottomSheetWidget(
                    onApplyFilters: _onFiltersApplied,
                  ),
                );
              },
              onVoiceSearch: _onVoiceSearch,
            ),

            // Category Chips
            Container(
              height: 6.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return CategoryChipWidget(
                    label: category,
                    isSelected: _selectedCategory == category,
                    onTap: () => _onCategorySelected(category),
                  );
                },
              ),
            ),

            // Products Grid
            Expanded(
              child: _filteredProducts.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(4.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 3.w,
                        mainAxisSpacing: 3.w,
                        childAspectRatio: 0.75,
                      ),
                      itemCount:
                          _filteredProducts.length + (_isLoading ? 2 : 0),
                      itemBuilder: (context, index) {
                        if (index >= _filteredProducts.length) {
                          return _buildLoadingCard();
                        }

                        final product = _filteredProducts[index];
                        return ProductCardWidget(
                          product: product,
                          onTap: () => _onProductTap(product),
                          onAddToCart: () => _onAddToCart(product),
                          onViewSupplier: () => _onViewSupplier(product),
                          onShare: () => _onShareProduct(product),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: SortFabWidget(
        onSortSelected: _onSortSelected,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.3),
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _searchQuery = '';
                _selectedCategory = 'All';
                _activeFilters = {};
              });
              _applyFiltersAndSort();
            },
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.1),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 2.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    height: 1.5.h,
                    width: 60.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
