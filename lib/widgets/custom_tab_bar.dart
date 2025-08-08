import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tab item data for custom tab bar
class TabItem {
  final String label;
  final IconData? icon;
  final Widget? customWidget;

  const TabItem({
    required this.label,
    this.icon,
    this.customWidget,
  });
}

/// Custom Tab Bar for B2B apparel supply chain application
/// Provides professional tabbed navigation with clean aesthetics
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// List of tab items
  final List<TabItem> tabs;

  /// Tab controller
  final TabController? controller;

  /// Whether tabs are scrollable
  final bool isScrollable;

  /// Tab alignment for scrollable tabs
  final TabAlignment? tabAlignment;

  /// Background color override
  final Color? backgroundColor;

  /// Selected tab color override
  final Color? selectedColor;

  /// Unselected tab color override
  final Color? unselectedColor;

  /// Indicator color override
  final Color? indicatorColor;

  /// Custom indicator decoration
  final Decoration? indicator;

  /// Indicator size
  final TabBarIndicatorSize indicatorSize;

  /// Callback when tab is tapped
  final ValueChanged<int>? onTap;

  /// Whether to show divider below tabs
  final bool showDivider;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.tabAlignment,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.indicator,
    this.indicatorSize = TabBarIndicatorSize.label,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.scaffoldBackgroundColor,
        border: showDivider
            ? Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 0.5,
                ),
              )
            : null,
      ),
      child: TabBar(
        controller: controller,
        tabs: tabs.map((tab) => _buildTab(context, tab)).toList(),
        isScrollable: isScrollable,
        tabAlignment: tabAlignment,
        labelColor: selectedColor ?? colorScheme.primary,
        unselectedLabelColor:
            unselectedColor ?? colorScheme.onSurface.withValues(alpha: 0.6),
        indicatorColor: indicatorColor ?? colorScheme.primary,
        indicator: indicator,
        indicatorSize: indicatorSize,
        onTap: onTap,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 8),
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }

  /// Builds individual tab widget
  Widget _buildTab(BuildContext context, TabItem tabItem) {
    if (tabItem.customWidget != null) {
      return Tab(child: tabItem.customWidget);
    }

    if (tabItem.icon != null) {
      return Tab(
        icon: Icon(tabItem.icon, size: 20),
        text: tabItem.label,
        iconMargin: const EdgeInsets.only(bottom: 4),
      );
    }

    return Tab(
      text: tabItem.label,
      height: 48,
    );
  }

  /// Creates a tab bar for product categories
  static CustomTabBar productCategories({
    TabController? controller,
    ValueChanged<int>? onTap,
  }) {
    return CustomTabBar(
      controller: controller,
      onTap: onTap,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      tabs: const [
        TabItem(label: 'All Products'),
        TabItem(label: 'Fabrics'),
        TabItem(label: 'Trims'),
        TabItem(label: 'Accessories'),
        TabItem(label: 'Machinery'),
        TabItem(label: 'Raw Materials'),
      ],
    );
  }

  /// Creates a tab bar for order status
  static CustomTabBar orderStatus({
    TabController? controller,
    ValueChanged<int>? onTap,
  }) {
    return CustomTabBar(
      controller: controller,
      onTap: onTap,
      tabs: const [
        TabItem(
          label: 'Pending',
          icon: Icons.schedule,
        ),
        TabItem(
          label: 'Processing',
          icon: Icons.help_outline,
        ),
        TabItem(
          label: 'Shipped',
          icon: Icons.local_shipping,
        ),
        TabItem(
          label: 'Delivered',
          icon: Icons.check_circle,
        ),
      ],
    );
  }

  /// Creates a tab bar for supplier information
  static CustomTabBar supplierInfo({
    TabController? controller,
    ValueChanged<int>? onTap,
  }) {
    return CustomTabBar(
      controller: controller,
      onTap: onTap,
      tabs: const [
        TabItem(label: 'Overview'),
        TabItem(label: 'Products'),
        TabItem(label: 'Reviews'),
        TabItem(label: 'Contact'),
      ],
    );
  }

  /// Creates a scrollable tab bar with custom items
  static CustomTabBar scrollable({
    required List<TabItem> tabs,
    TabController? controller,
    ValueChanged<int>? onTap,
    Color? selectedColor,
    Color? unselectedColor,
    Color? indicatorColor,
  }) {
    return CustomTabBar(
      tabs: tabs,
      controller: controller,
      onTap: onTap,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      selectedColor: selectedColor,
      unselectedColor: unselectedColor,
      indicatorColor: indicatorColor,
    );
  }

  /// Creates a fixed tab bar with equal width tabs
  static CustomTabBar fixed({
    required List<TabItem> tabs,
    TabController? controller,
    ValueChanged<int>? onTap,
    Color? selectedColor,
    Color? unselectedColor,
    Color? indicatorColor,
  }) {
    return CustomTabBar(
      tabs: tabs,
      controller: controller,
      onTap: onTap,
      isScrollable: false,
      selectedColor: selectedColor,
      unselectedColor: unselectedColor,
      indicatorColor: indicatorColor,
    );
  }

  /// Creates a minimal tab bar without divider
  static CustomTabBar minimal({
    required List<TabItem> tabs,
    TabController? controller,
    ValueChanged<int>? onTap,
  }) {
    return CustomTabBar(
      tabs: tabs,
      controller: controller,
      onTap: onTap,
      showDivider: false,
      indicatorSize: TabBarIndicatorSize.tab,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
