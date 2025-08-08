import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SortFabWidget extends StatelessWidget {
  final Function(String) onSortSelected;

  const SortFabWidget({
    super.key,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showSortOptions(context),
      backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
      child: CustomIconWidget(
        iconName: 'sort',
        color: AppTheme.lightTheme.colorScheme.onSecondary,
        size: 24,
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
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
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Sort Products',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 3.h),
            _buildSortOption(
              context,
              'Relevance',
              'trending_up',
              'relevance',
            ),
            _buildSortOption(
              context,
              'Price: Low to High',
              'arrow_upward',
              'price_low_high',
            ),
            _buildSortOption(
              context,
              'Price: High to Low',
              'arrow_downward',
              'price_high_low',
            ),
            _buildSortOption(
              context,
              'Rating',
              'star',
              'rating',
            ),
            _buildSortOption(
              context,
              'Newest First',
              'schedule',
              'newest',
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    String title,
    String iconName,
    String sortType,
  ) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onSortSelected(sortType);
      },
    );
  }
}
