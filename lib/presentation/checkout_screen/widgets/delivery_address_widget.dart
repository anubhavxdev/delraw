import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class DeliveryAddressWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddressSelected;

  const DeliveryAddressWidget({
    super.key,
    required this.onAddressSelected,
  });

  @override
  State<DeliveryAddressWidget> createState() => _DeliveryAddressWidgetState();
}

class _DeliveryAddressWidgetState extends State<DeliveryAddressWidget> {
  int _selectedAddressIndex = 0;
  bool _showAddNewForm = false;

  // Form controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Mock saved addresses
  final List<Map<String, dynamic>> _savedAddresses = [
    {
      "id": 1,
      "name": "Rajesh Kumar",
      "phone": "+91 98765 43210",
      "address": "123, Industrial Area, Phase-1",
      "city": "Ludhiana",
      "state": "Punjab",
      "pincode": "141003",
      "isDefault": true,
      "type": "Office"
    },
    {
      "id": 2,
      "name": "Priya Sharma",
      "phone": "+91 87654 32109",
      "address": "456, Model Town Extension",
      "city": "Ludhiana",
      "state": "Punjab",
      "pincode": "141002",
      "isDefault": false,
      "type": "Home"
    },
  ];

  @override
  void initState() {
    super.initState();
    // Set default address
    if (_savedAddresses.isNotEmpty) {
      widget.onAddressSelected(_savedAddresses[_selectedAddressIndex]);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _selectAddress(int index) {
    setState(() {
      _selectedAddressIndex = index;
      _showAddNewForm = false;
    });
    widget.onAddressSelected(_savedAddresses[index]);
  }

  void _showAddNewAddress() {
    setState(() {
      _showAddNewForm = true;
    });
  }

  void _cancelAddNew() {
    setState(() {
      _showAddNewForm = false;
    });
    _clearForm();
  }

  void _clearForm() {
    _nameController.clear();
    _phoneController.clear();
    _addressController.clear();
    _cityController.clear();
    _stateController.clear();
    _pincodeController.clear();
  }

  void _saveNewAddress() {
    if (_formKey.currentState?.validate() ?? false) {
      final newAddress = {
        "id": _savedAddresses.length + 1,
        "name": _nameController.text,
        "phone": _phoneController.text,
        "address": _addressController.text,
        "city": _cityController.text,
        "state": _stateController.text,
        "pincode": _pincodeController.text,
        "isDefault": false,
        "type": "Other"
      };

      setState(() {
        _savedAddresses.add(newAddress);
        _selectedAddressIndex = _savedAddresses.length - 1;
        _showAddNewForm = false;
      });

      widget.onAddressSelected(newAddress);
      _clearForm();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Address saved successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                  iconName: 'location_on',
                  color: colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Delivery Address',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
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

          // Content
          Padding(
            padding: EdgeInsets.all(4.w),
            child: _showAddNewForm ? _buildAddNewForm() : _buildAddressList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressList() {
    return Column(
      children: [
        // Saved Addresses
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _savedAddresses.length,
          separatorBuilder: (context, index) => SizedBox(height: 3.w),
          itemBuilder: (context, index) {
            return _buildAddressCard(index);
          },
        ),

        SizedBox(height: 4.w),

        // Add New Address Button
        OutlinedButton.icon(
          onPressed: _showAddNewAddress,
          icon: CustomIconWidget(
            iconName: 'add',
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          label: const Text('Add New Address'),
          style: OutlinedButton.styleFrom(
            minimumSize: Size(double.infinity, 6.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCard(int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final address = _savedAddresses[index];
    final isSelected = index == _selectedAddressIndex;

    return InkWell(
      onTap: () => _selectAddress(index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            // Radio Button
            Radio<int>(
              value: index,
              groupValue: _selectedAddressIndex,
              onChanged: (value) => _selectAddress(value!),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),

            SizedBox(width: 2.w),

            // Address Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address['name'] as String,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.w,
                        ),
                        decoration: BoxDecoration(
                          color: address['isDefault'] as bool
                              ? colorScheme.primary
                              : colorScheme.secondary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          address['type'] as String,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: address['isDefault'] as bool
                                ? colorScheme.onPrimary
                                : colorScheme.onSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.w),
                  Text(
                    address['phone'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: 1.w),
                  Text(
                    '${address['address']}, ${address['city']}, ${address['state']} - ${address['pincode']}',
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewForm() {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form Header
          Row(
            children: [
              Text(
                'Add New Address',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _cancelAddNew,
                child: const Text('Cancel'),
              ),
            ],
          ),

          SizedBox(height: 3.w),

          // Name Field
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name *',
              hintText: 'Enter your full name',
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),

          SizedBox(height: 3.w),

          // Phone Field
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number *',
              hintText: '+91 XXXXX XXXXX',
            ),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (value.length != 10) {
                return 'Please enter a valid 10-digit phone number';
              }
              return null;
            },
          ),

          SizedBox(height: 3.w),

          // Address Field
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Address *',
              hintText: 'House/Flat/Office No., Street, Area',
            ),
            maxLines: 2,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your address';
              }
              return null;
            },
          ),

          SizedBox(height: 3.w),

          // City and State Row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City *',
                    hintText: 'Ludhiana',
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter city';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(
                    labelText: 'State *',
                    hintText: 'Punjab',
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter state';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 3.w),

          // Pincode Field
          TextFormField(
            controller: _pincodeController,
            decoration: const InputDecoration(
              labelText: 'Pincode *',
              hintText: '141003',
            ),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter pincode';
              }
              if (value.length != 6) {
                return 'Please enter a valid 6-digit pincode';
              }
              return null;
            },
          ),

          SizedBox(height: 4.w),

          // Save Button
          ElevatedButton(
            onPressed: _saveNewAddress,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 6.h),
            ),
            child: const Text('Save Address'),
          ),
        ],
      ),
    );
  }
}
