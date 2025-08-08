import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderSummaryWidget extends StatelessWidget {
  final double subtotal;
  final double shipping;
  final double total;
  final bool isCheckoutEnabled;
  final VoidCallback onProceedToCheckout;

  const OrderSummaryWidget({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.total,
    required this.isCheckoutEnabled,
    required this.onProceedToCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSummaryRow(
                'Subtotal',
                '₹${subtotal.toStringAsFixed(2)}',
                theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 1.h),
              _buildSummaryRow(
                'Estimated Shipping',
                shipping > 0 ? '₹${shipping.toStringAsFixed(2)}' : 'FREE',
                theme.textTheme.bodyMedium?.copyWith(
                  color: shipping > 0
                      ? theme.colorScheme.onSurface
                      : AppTheme.lightTheme.colorScheme.tertiary,
                  fontWeight:
                      shipping > 0 ? FontWeight.normal : FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Divider(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                thickness: 1,
              ),
              SizedBox(height: 1.h),
              _buildSummaryRow(
                'Total',
                '₹${total.toStringAsFixed(2)}',
                theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              SizedBox(height: 2.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isCheckoutEnabled ? onProceedToCheckout : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: isCheckoutEnabled
                        ? AppTheme.lightTheme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Proceed to Checkout',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: 'arrow_forward',
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              _buildSecurityBadge(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, TextStyle? style) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }

  Widget _buildSecurityBadge(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomIconWidget(
          iconName: 'security',
          color: AppTheme.lightTheme.colorScheme.tertiary,
          size: 16,
        ),
        SizedBox(width: 1.w),
        Text(
          'Secure Checkout',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.tertiary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
