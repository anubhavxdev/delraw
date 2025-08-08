import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/activity_item_widget.dart';
import './widgets/dashboard_header_widget.dart';
import './widgets/metrics_card_widget.dart';
import './widgets/quick_action_card_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Mock user data
  final Map<String, dynamic> userData = {
    "name": "Rajesh Kumar",
    "role": "Manufacturer",
    "company": "Kumar Textiles Ltd.",
    "location": "Ludhiana, Punjab"
  };

  // Mock metrics data based on user role
  final List<Map<String, dynamic>> metricsData = [
    {
      "title": "Active Orders",
      "value": "24",
      "subtitle": "+3 from last week",
      "icon": "shopping_bag",
      "color": Color(0xFF1D3557),
    },
    {
      "title": "Pending Deliveries",
      "value": "8",
      "subtitle": "2 urgent deliveries",
      "icon": "local_shipping",
      "color": Color(0xFFE76F51),
    },
    {
      "title": "Inventory Alerts",
      "value": "12",
      "subtitle": "Low stock items",
      "icon": "warning",
      "color": Color(0xFFFFC107),
    },
    {
      "title": "Monthly Revenue",
      "value": "₹2.4L",
      "subtitle": "+15% from last month",
      "icon": "trending_up",
      "color": Color(0xFF28A745),
    },
  ];

  // Mock quick actions data
  final List<Map<String, dynamic>> quickActionsData = [
    {
      "title": "Browse Catalog",
      "description": "Explore raw materials and supplies",
      "icon": "inventory_2",
      "route": "/product-catalog-screen",
    },
    {
      "title": "Track Orders",
      "description": "Monitor your order status",
      "icon": "track_changes",
      "route": "/checkout-screen",
    },
    {
      "title": "Find Suppliers",
      "description": "Discover verified suppliers",
      "icon": "business",
      "route": "/product-catalog-screen",
    },
    {
      "title": "Manage Inventory",
      "description": "Update stock levels",
      "icon": "inventory",
      "route": "/shopping-cart-screen",
    },
  ];

  // Mock recent activity data
  final List<Map<String, dynamic>> recentActivityData = [
    {
      "title": "Order #DEL2024001 Shipped",
      "description": "Cotton yarn order dispatched from Ahmedabad",
      "timestamp": "2 hours ago",
      "icon": "local_shipping",
      "color": Color(0xFF28A745),
    },
    {
      "title": "New Supplier Request",
      "description": "Fabric Mills Co. wants to connect",
      "timestamp": "4 hours ago",
      "icon": "person_add",
      "color": Color(0xFF1D3557),
    },
    {
      "title": "Payment Received",
      "description": "₹45,000 payment for order #DEL2024002",
      "timestamp": "6 hours ago",
      "icon": "payment",
      "color": Color(0xFF28A745),
    },
    {
      "title": "Inventory Alert",
      "description": "Polyester buttons running low (50 units left)",
      "timestamp": "8 hours ago",
      "icon": "warning",
      "color": Color(0xFFFFC107),
    },
    {
      "title": "Quality Check Completed",
      "description": "Silk fabric batch passed quality inspection",
      "timestamp": "1 day ago",
      "icon": "verified",
      "color": Color(0xFF28A745),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: CustomScrollView(
          slivers: [
            // Sticky Header
            SliverToBoxAdapter(
              child: DashboardHeaderWidget(
                userName: userData["name"] as String,
                userRole: userData["role"] as String,
                onNotificationTap: _handleNotificationTap,
                onProfileTap: _handleProfileTap,
              ),
            ),

            // Main Content
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 3.h),

                    // Metrics Section
                    _buildSectionHeader('Overview', 'Your business metrics'),
                    SizedBox(height: 2.h),
                    _buildMetricsGrid(),

                    SizedBox(height: 4.h),

                    // Quick Actions Section
                    _buildSectionHeader(
                        'Quick Actions', 'Frequently used features'),
                    SizedBox(height: 2.h),
                    _buildQuickActionsGrid(),

                    SizedBox(height: 4.h),

                    // Recent Activity Section
                    _buildSectionHeader(
                        'Recent Activity', 'Latest platform interactions'),
                    SizedBox(height: 2.h),
                    _buildRecentActivityList(),

                    SizedBox(height: 10.h), // Bottom padding for FAB
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          subtitle,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 1.1,
      ),
      itemCount: metricsData.length,
      itemBuilder: (context, index) {
        final metric = metricsData[index];
        return MetricsCardWidget(
          title: metric["title"] as String,
          value: metric["value"] as String,
          subtitle: metric["subtitle"] as String,
          iconName: metric["icon"] as String,
          iconColor: metric["color"] as Color,
          onTap: () => _handleMetricTap(index),
        );
      },
    );
  }

  Widget _buildQuickActionsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3.w,
        mainAxisSpacing: 2.h,
        childAspectRatio: 0.9,
      ),
      itemCount: quickActionsData.length,
      itemBuilder: (context, index) {
        final action = quickActionsData[index];
        return QuickActionCardWidget(
          title: action["title"] as String,
          description: action["description"] as String,
          iconName: action["icon"] as String,
          onTap: () => _handleQuickActionTap(action["route"] as String),
        );
      },
    );
  }

  Widget _buildRecentActivityList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentActivityData.length,
      itemBuilder: (context, index) {
        final activity = recentActivityData[index];
        return ActivityItemWidget(
          title: activity["title"] as String,
          description: activity["description"] as String,
          timestamp: activity["timestamp"] as String,
          iconName: activity["icon"] as String,
          iconColor: activity["color"] as Color?,
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _handleNewOrderTap,
      backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
      elevation: 4.0,
      icon: CustomIconWidget(
        iconName: 'add_shopping_cart',
        color: AppTheme.lightTheme.colorScheme.onSecondary,
        size: 20,
      ),
      label: Text(
        'New Order',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    // Show refresh feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Dashboard updated successfully',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onInverseSurface,
            ),
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.inverseSurface,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleNotificationTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'You have 3 new notifications',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onInverseSurface,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _handleProfileTap() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Profile Menu',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('View Profile'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Settings'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'logout',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login-screen');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _handleMetricTap(int index) {
    final routes = [
      '/checkout-screen',
      '/checkout-screen',
      '/shopping-cart-screen',
      '/checkout-screen',
    ];

    if (index < routes.length) {
      Navigator.pushNamed(context, routes[index]);
    }
  }

  void _handleQuickActionTap(String route) {
    Navigator.pushNamed(context, route);
  }

  void _handleNewOrderTap() {
    Navigator.pushNamed(context, '/product-catalog-screen');
  }
}
