import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/cart_item_card.dart';
import './widgets/empty_cart_widget.dart';
import './widgets/order_summary_widget.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  bool _isLoading = false;

  // Mock cart data
  List<Map<String, dynamic>> _cartItems = [
    {
      "id": 1,
      "name": "Premium Cotton Yarn - 40s Count",
      "supplier": "Gujarat Textiles Ltd.",
      "price": 450.0,
      "quantity": 5,
      "image":
          "https://images.pexels.com/photos/6069112/pexels-photo-6069112.jpeg?auto=compress&cs=tinysrgb&w=800",
      "deliveryTime": "3-5 days",
      "category": "Yarn",
    },
    {
      "id": 2,
      "name": "Organic Cotton Fabric - 200 GSM",
      "supplier": "Mumbai Fabrics Co.",
      "price": 280.0,
      "quantity": 10,
      "image":
          "https://images.pexels.com/photos/6069113/pexels-photo-6069113.jpeg?auto=compress&cs=tinysrgb&w=800",
      "deliveryTime": "2-4 days",
      "category": "Fabric",
    },
    {
      "id": 3,
      "name": "Metal Buttons - Silver Finish",
      "supplier": "Delhi Button Works",
      "price": 15.0,
      "quantity": 100,
      "image":
          "https://images.pexels.com/photos/6069114/pexels-photo-6069114.jpeg?auto=compress&cs=tinysrgb&w=800",
      "deliveryTime": "1-3 days",
      "category": "Buttons",
    },
    {
      "id": 4,
      "name": "YKK Zippers - 12 inch Black",
      "supplier": "Zipper Solutions India",
      "price": 25.0,
      "quantity": 50,
      "image":
          "https://images.pexels.com/photos/6069115/pexels-photo-6069115.jpeg?auto=compress&cs=tinysrgb&w=800",
      "deliveryTime": "2-3 days",
      "category": "Zippers",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoadingState() : _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Shopping Cart${_cartItems.isNotEmpty ? ' (${_cartItems.length})' : ''}',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      centerTitle: false,
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      actions: [
        if (_cartItems.isNotEmpty)
          TextButton(
            onPressed: _showClearCartDialog,
            child: Text(
              'Clear',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildBody() {
    if (_cartItems.isEmpty) {
      return EmptyCartWidget(
        onContinueShopping: () {
          Navigator.pushNamed(context, '/product-catalog-screen');
        },
      );
    }

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshCart,
            child: ListView.builder(
              padding: EdgeInsets.only(top: 1.h, bottom: 2.h),
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return CartItemCard(
                  item: item,
                  onRemove: () => _removeItem(index),
                  onMoveToWishlist: () => _moveToWishlist(index),
                  onQuantityChanged: (newQuantity) =>
                      _updateQuantity(index, newQuantity),
                );
              },
            ),
          ),
        ),
        OrderSummaryWidget(
          subtotal: _calculateSubtotal(),
          shipping: _calculateShipping(),
          total: _calculateTotal(),
          isCheckoutEnabled: _cartItems.isNotEmpty,
          onProceedToCheckout: _proceedToCheckout,
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            'Updating cart...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
        ],
      ),
    );
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item removed from cart'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Implement undo functionality
          },
        ),
      ),
    );
  }

  void _moveToWishlist(int index) {
    final item = _cartItems[index];
    setState(() {
      _cartItems.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item["name"]} moved to wishlist'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            // Navigate to wishlist
          },
        ),
      ),
    );
  }

  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _cartItems[index]["quantity"] = newQuantity;
        _isLoading = false;
      });
    });
  }

  Future<void> _refreshCart() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cart updated successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text(
            'Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _clearCart();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cart cleared successfully'),
      ),
    );
  }

  double _calculateSubtotal() {
    return _cartItems.fold(0.0, (sum, item) {
      return sum + ((item["price"] as double) * (item["quantity"] as int));
    });
  }

  double _calculateShipping() {
    final subtotal = _calculateSubtotal();
    return subtotal > 2000 ? 0.0 : 100.0; // Free shipping above ₹2000
  }

  double _calculateTotal() {
    return _calculateSubtotal() + _calculateShipping();
  }

  void _proceedToCheckout() {
    if (_cartItems.isEmpty) return;

    Navigator.pushNamed(context, '/checkout-screen');
  }
}
