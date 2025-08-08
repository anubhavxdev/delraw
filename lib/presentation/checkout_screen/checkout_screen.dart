import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/checkout_bottom_bar.dart';
import './widgets/delivery_address_widget.dart';
import './widgets/order_notes_widget.dart';
import './widgets/order_summary_widget.dart';
import './widgets/payment_method_widget.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final ScrollController _scrollController = ScrollController();

  // Order data
  Map<String, dynamic>? _selectedAddress;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.card;
  Map<String, dynamic>? _paymentData;
  String _orderNotes = '';
  bool _isProcessingOrder = false;

  // Mock cart data
  final List<Map<String, dynamic>> _cartItems = [
    {
      "id": 1,
      "name": "Premium Cotton Yarn",
      "image":
          "https://images.pexels.com/photos/6474471/pexels-photo-6474471.jpeg?auto=compress&cs=tinysrgb&w=800",
      "price": 450.0,
      "quantity": 2,
      "supplier": "Ludhiana Textiles Co."
    },
    {
      "id": 2,
      "name": "Silk Fabric Roll",
      "image":
          "https://images.pexels.com/photos/6474471/pexels-photo-6474471.jpeg?auto=compress&cs=tinysrgb&w=800",
      "price": 1200.0,
      "quantity": 1,
      "supplier": "Punjab Silk Mills"
    },
    {
      "id": 3,
      "name": "Metal Buttons Set",
      "image":
          "https://images.pexels.com/photos/6474471/pexels-photo-6474471.jpeg?auto=compress&cs=tinysrgb&w=800",
      "price": 85.0,
      "quantity": 5,
      "supplier": "Button Craft Industries"
    },
  ];

  // Price calculations
  double get _subtotal {
    return _cartItems.fold(0.0, (sum, item) {
      return sum + ((item['price'] as double) * (item['quantity'] as int));
    });
  }

  double get _shippingCost => _subtotal > 2000 ? 0.0 : 150.0;
  double get _tax => _subtotal * 0.18; // 18% GST
  double get _total => _subtotal + _shippingCost + _tax;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onAddressSelected(Map<String, dynamic> address) {
    setState(() {
      _selectedAddress = address;
    });
  }

  void _onPaymentMethodSelected(
      PaymentMethod method, Map<String, dynamic>? data) {
    setState(() {
      _selectedPaymentMethod = method;
      _paymentData = data;
    });
  }

  void _onNotesChanged(String notes) {
    setState(() {
      _orderNotes = notes;
    });
  }

  bool _validateOrder() {
    if (_selectedAddress == null) {
      _showErrorSnackBar('Please select a delivery address');
      return false;
    }

    if (_selectedPaymentMethod == PaymentMethod.card) {
      if (_paymentData == null ||
          (_paymentData!['cardNumber'] as String).isEmpty ||
          (_paymentData!['expiry'] as String).isEmpty ||
          (_paymentData!['cvv'] as String).isEmpty ||
          (_paymentData!['cardHolder'] as String).isEmpty) {
        _showErrorSnackBar('Please complete card details');
        return false;
      }
    }

    return true;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> _placeOrder() async {
    if (!_validateOrder()) return;

    setState(() {
      _isProcessingOrder = true;
    });

    try {
      // Simulate order processing
      await Future.delayed(const Duration(seconds: 3));

      // Show success dialog
      if (mounted) {
        _showOrderSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to place order. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingOrder = false;
        });
      }
    }
  }

  void _showOrderSuccessDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: EdgeInsets.all(6.w),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppTheme.successLight.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.successLight,
                size: 10.w,
              ),
            ),
            SizedBox(height: 4.w),
            Text(
              'Order Placed Successfully!',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.w),
            Text(
              'Your order #DLR${DateTime.now().millisecondsSinceEpoch.toString().substring(8)} has been placed successfully.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.w),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(
                          context, '/dashboard-screen');
                    },
                    child: const Text('Continue Shopping'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigate to order tracking (would be implemented)
                      Navigator.pushReplacementNamed(
                          context, '/dashboard-screen');
                    },
                    child: const Text('Track Order'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
            'You have unsaved changes. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (_selectedAddress != null || _orderNotes.isNotEmpty) {
            _showUnsavedChangesDialog();
          } else {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'Checkout',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: theme.scaffoldBackgroundColor,
          foregroundColor: colorScheme.onSurface,
          leading: IconButton(
            onPressed: () {
              if (_selectedAddress != null || _orderNotes.isNotEmpty) {
                _showUnsavedChangesDialog();
              } else {
                Navigator.of(context).pop();
              }
            },
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: colorScheme.onSurface,
              size: 24,
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 4.w),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'security',
                    color: colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Secure',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Progress Indicator
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
              child: Row(
                children: [
                  _buildProgressStep('Cart', true, true),
                  _buildProgressLine(true),
                  _buildProgressStep('Checkout', true, false),
                  _buildProgressLine(false),
                  _buildProgressStep('Payment', false, false),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 2.w),

                    // Order Summary
                    OrderSummaryWidget(
                      cartItems: _cartItems,
                      subtotal: _subtotal,
                      shippingCost: _shippingCost,
                      tax: _tax,
                      total: _total,
                    ),

                    SizedBox(height: 4.w),

                    // Delivery Address
                    DeliveryAddressWidget(
                      onAddressSelected: _onAddressSelected,
                    ),

                    SizedBox(height: 4.w),

                    // Payment Method
                    PaymentMethodWidget(
                      onPaymentMethodSelected: _onPaymentMethodSelected,
                    ),

                    SizedBox(height: 4.w),

                    // Order Notes
                    OrderNotesWidget(
                      onNotesChanged: _onNotesChanged,
                    ),

                    SizedBox(height: 20.h), // Space for bottom bar
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CheckoutBottomBar(
          total: _total,
          isLoading: _isProcessingOrder,
          onPlaceOrder: _placeOrder,
        ),
      ),
    );
  }

  Widget _buildProgressStep(String label, bool isCompleted, bool isActive) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: isCompleted
                ? colorScheme.primary
                : (isActive
                    ? colorScheme.primary.withValues(alpha: 0.2)
                    : colorScheme.outline.withValues(alpha: 0.3)),
            shape: BoxShape.circle,
            border: isActive && !isCompleted
                ? Border.all(color: colorScheme.primary, width: 2)
                : null,
          ),
          child: isCompleted
              ? CustomIconWidget(
                  iconName: 'check',
                  color: colorScheme.onPrimary,
                  size: 4.w,
                )
              : null,
        ),
        SizedBox(height: 1.w),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isCompleted || isActive
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight:
                isCompleted || isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isCompleted) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        height: 2,
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        decoration: BoxDecoration(
          color: isCompleted
              ? colorScheme.primary
              : colorScheme.outline.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}
