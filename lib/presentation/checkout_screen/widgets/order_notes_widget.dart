import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderNotesWidget extends StatefulWidget {
  final Function(String) onNotesChanged;

  const OrderNotesWidget({
    super.key,
    required this.onNotesChanged,
  });

  @override
  State<OrderNotesWidget> createState() => _OrderNotesWidgetState();
}

class _OrderNotesWidgetState extends State<OrderNotesWidget> {
  final TextEditingController _notesController = TextEditingController();
  final int _maxLength = 200;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _onNotesChanged(String value) {
    setState(() {}); // Update character counter
    widget.onNotesChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentLength = _notesController.text.length;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'note_add',
                  color: colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Notes',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Special delivery instructions (optional)',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color: colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
            indent: 4.w,
            endIndent: 4.w,
          ),

          // Notes Input
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Suggestions
                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.w,
                  children: [
                    _buildSuggestionChip('Call before delivery'),
                    _buildSuggestionChip('Leave at door'),
                    _buildSuggestionChip('Handle with care'),
                    _buildSuggestionChip('Urgent delivery'),
                  ],
                ),

                SizedBox(height: 3.w),

                // Text Field
                TextFormField(
                  controller: _notesController,
                  onChanged: _onNotesChanged,
                  maxLines: 4,
                  maxLength: _maxLength,
                  decoration: InputDecoration(
                    hintText:
                        'Add any special instructions for delivery...\n\nExample:\n• Call before delivery\n• Deliver between 10 AM - 6 PM\n• Handle fragile items carefully',
                    hintStyle: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      height: 1.4,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(3.w),
                    counterText: '', // Hide default counter
                  ),
                  textInputAction: TextInputAction.newline,
                ),

                SizedBox(height: 2.w),

                // Custom Character Counter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'info_outline',
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'These notes will be shared with the delivery team',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '$currentLength/$_maxLength',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: currentLength > _maxLength * 0.8
                            ? (currentLength >= _maxLength
                                ? colorScheme.error
                                : Colors.orange)
                            : colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: currentLength > _maxLength * 0.8
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String label) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        final currentText = _notesController.text;
        final newText = currentText.isEmpty ? label : '$currentText\n$label';

        if (newText.length <= _maxLength) {
          _notesController.text = newText;
          _notesController.selection = TextSelection.fromPosition(
            TextPosition(offset: newText.length),
          );
          _onNotesChanged(newText);
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.w),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'add',
              color: colorScheme.primary,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}