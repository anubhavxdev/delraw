import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation item data for bottom navigation
class BottomNavItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final String route;

  const BottomNavItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    required this.route,
  });
}

/// Custom Bottom Navigation Bar for B2B apparel supply chain application
/// Provides thumb-friendly navigation optimized for mobile-first workflows
class CustomBottomBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when item is tapped
  final ValueChanged<int>? onTap;

  /// Background color override
  final Color? backgroundColor;

  /// Selected item color override
  final Color? selectedItemColor;

  /// Unselected item color override
  final Color? unselectedItemColor;

  /// Whether to show elevation
  final bool showElevation;

  /// Navigation items (if null, uses default B2B items)
  final List<BottomNavItem>? items;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.showElevation = true,
    this.items,
  });

  /// Default navigation items for B2B supply chain workflow
  static const List<BottomNavItem> _defaultItems = [
    BottomNavItem(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      route: '/dashboard-screen',
    ),
    BottomNavItem(
      label: 'Catalog',
      icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2,
      route: '/product-catalog-screen',
    ),
    BottomNavItem(
      label: 'Cart',
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart,
      route: '/shopping-cart-screen',
    ),
    BottomNavItem(
      label: 'Orders',
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
      route: '/checkout-screen',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final navigationItems = items ?? _defaultItems;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.scaffoldBackgroundColor,
        boxShadow: showElevation
            ? [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  offset: const Offset(0, -2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ]
            : null,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 64, // Optimized height for thumb reach
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return _buildNavItem(
                context,
                item,
                isSelected,
                index,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Builds individual navigation item
  Widget _buildNavItem(
    BuildContext context,
    BottomNavItem item,
    bool isSelected,
    int index,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color itemColor = isSelected
        ? (selectedItemColor ?? colorScheme.primary)
        : (unselectedItemColor ?? colorScheme.onSurface.withValues(alpha: 0.6));

    return Expanded(
      child: InkWell(
        onTap: () => _handleTap(context, index, item.route),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with proper touch target
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                child: Icon(
                  isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                  size: 24,
                  color: itemColor,
                ),
              ),
              const SizedBox(height: 2),
              // Label
              Text(
                item.label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: itemColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handles navigation item tap
  void _handleTap(BuildContext context, int index, String route) {
    // Call the onTap callback if provided
    onTap?.call(index);

    // Navigate to the route if it's different from current
    if (index != currentIndex) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  /// Creates a bottom bar for main navigation
  static CustomBottomBar main({
    required int currentIndex,
    ValueChanged<int>? onTap,
  }) {
    return CustomBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      showElevation: true,
    );
  }

  /// Creates a bottom bar with custom items
  static CustomBottomBar custom({
    required int currentIndex,
    required List<BottomNavItem> items,
    ValueChanged<int>? onTap,
    Color? backgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
  }) {
    return CustomBottomBar(
      currentIndex: currentIndex,
      items: items,
      onTap: onTap,
      backgroundColor: backgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
    );
  }

  /// Creates a minimal bottom bar without elevation
  static CustomBottomBar minimal({
    required int currentIndex,
    ValueChanged<int>? onTap,
  }) {
    return CustomBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      showElevation: false,
    );
  }
}
