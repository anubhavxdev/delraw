import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget for B2B apparel supply chain application
/// Provides professional, clean header with navigation and actions
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title to display in the app bar
  final String title;

  /// Whether to show the back button (automatically determined if not specified)
  final bool? showBackButton;

  /// Custom leading widget (overrides back button)
  final Widget? leading;

  /// List of action widgets to display on the right
  final List<Widget>? actions;

  /// Whether to show elevation shadow
  final bool showElevation;

  /// Background color override
  final Color? backgroundColor;

  /// Text color override
  final Color? foregroundColor;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom bottom widget (like TabBar)
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton,
    this.leading,
    this.actions,
    this.showElevation = false,
    this.backgroundColor,
    this.foregroundColor,
    this.centerTitle = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine if we should show back button
    final bool shouldShowBack =
        showBackButton ?? (Navigator.of(context).canPop() && leading == null);

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? colorScheme.onSurface,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: showElevation ? 2.0 : 0,
      shadowColor: showElevation ? colorScheme.shadow : Colors.transparent,
      surfaceTintColor: Colors.transparent,

      // Leading widget configuration
      leading: leading ?? (shouldShowBack ? _buildBackButton(context) : null),
      automaticallyImplyLeading: shouldShowBack && leading == null,

      // Actions configuration
      actions: actions != null
          ? [
              ...actions!,
              const SizedBox(width: 8), // Padding from edge
            ]
          : null,

      // Bottom widget (for tabs, etc.)
      bottom: bottom,

      // Icon theme
      iconTheme: IconThemeData(
        color: foregroundColor ?? colorScheme.onSurface,
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: foregroundColor ?? colorScheme.onSurface,
        size: 24,
      ),
    );
  }

  /// Builds a custom back button with proper touch target
  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.arrow_back),
      tooltip: 'Back',
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints(
        minWidth: 44,
        minHeight: 44,
      ),
    );
  }

  /// Creates an app bar for the dashboard screen
  static CustomAppBar dashboard({
    VoidCallback? onNotificationTap,
    VoidCallback? onProfileTap,
  }) {
    return CustomAppBar(
      title: 'Supply Chain Hub',
      showBackButton: false,
      centerTitle: false,
      actions: [
        Builder(
          builder: (context) => IconButton(
            onPressed: () {
              onNotificationTap?.call();
              // Navigate to notifications if needed
            },
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notifications',
            constraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),
          ),
        ),
        Builder(
          builder: (context) => IconButton(
            onPressed: () {
              onProfileTap?.call();
              // Navigate to profile or show menu
            },
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Profile',
            constraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),
          ),
        ),
      ],
    );
  }

  /// Creates an app bar for product catalog screen
  static CustomAppBar productCatalog({
    VoidCallback? onSearchTap,
    VoidCallback? onFilterTap,
  }) {
    return CustomAppBar(
      title: 'Product Catalog',
      actions: [
        Builder(
          builder: (context) => IconButton(
            onPressed: () {
              onSearchTap?.call();
              // Implement search functionality
            },
            icon: const Icon(Icons.search),
            tooltip: 'Search Products',
            constraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),
          ),
        ),
        Builder(
          builder: (context) => IconButton(
            onPressed: () {
              onFilterTap?.call();
              // Show filter bottom sheet
            },
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter Products',
            constraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),
          ),
        ),
      ],
    );
  }

  /// Creates an app bar for shopping cart screen
  static CustomAppBar shoppingCart({
    int itemCount = 0,
  }) {
    return CustomAppBar(
      title: 'Shopping Cart${itemCount > 0 ? ' ($itemCount)' : ''}',
      actions: [
        Builder(
          builder: (context) => TextButton(
            onPressed: itemCount > 0
                ? () {
                    // Clear cart functionality
                  }
                : null,
            child: Text(
              'Clear',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Creates an app bar for checkout screen
  static CustomAppBar checkout() {
    return const CustomAppBar(
      title: 'Checkout',
      showElevation: true,
    );
  }

  /// Creates an app bar with search functionality
  static CustomAppBar withSearch({
    required String title,
    required VoidCallback onSearchTap,
    List<Widget>? additionalActions,
  }) {
    return CustomAppBar(
      title: title,
      actions: [
        Builder(
          builder: (context) => IconButton(
            onPressed: onSearchTap,
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            constraints: const BoxConstraints(
              minWidth: 44,
              minHeight: 44,
            ),
          ),
        ),
        if (additionalActions != null) ...additionalActions,
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}
