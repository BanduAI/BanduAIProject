import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final ValueChanged<Map<String, dynamic>>? onFiltersApplied;

  const FilterBottomSheet({
    super.key,
    required this.currentFilters,
    this.onFiltersApplied,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, dynamic> _filters;
  RangeValues _priceRange = const RangeValues(0, 5000);
  double _distanceRadius = 5.0;
  double _minRating = 0.0;
  String _sortBy = 'Nearest';
  List<String> _selectedAvailability = [];

  final List<String> _sortOptions = [
    'Nearest',
    'Highest Rated',
    'Most Affordable',
    'Recently Active',
  ];

  final List<String> _availabilityOptions = [
    'Available Now',
    'Today',
    'This Week',
    'Flexible',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    _initializeFilters();
  }

  void _initializeFilters() {
    _priceRange = RangeValues(
      (_filters['minPrice'] as num?)?.toDouble() ?? 0,
      (_filters['maxPrice'] as num?)?.toDouble() ?? 5000,
    );
    _distanceRadius = (_filters['distanceRadius'] as num?)?.toDouble() ?? 5.0;
    _minRating = (_filters['minRating'] as num?)?.toDouble() ?? 0.0;
    _sortBy = _filters['sortBy'] as String? ?? 'Nearest';
    _selectedAvailability = List<String>.from(_filters['availability'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceRangeSection(context),
                  SizedBox(height: 3.h),
                  _buildDistanceSection(context),
                  SizedBox(height: 3.h),
                  _buildRatingSection(context),
                  SizedBox(height: 3.h),
                  _buildAvailabilitySection(context),
                  SizedBox(height: 3.h),
                  _buildSortSection(context),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Filter Services',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            icon: CustomIconWidget(
              iconName: 'close',
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRangeSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 10000,
          divisions: 100,
          labels: RangeLabels(
            '₹${_priceRange.start.round()}',
            '₹${_priceRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₹${_priceRange.start.round()}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            Text(
              '₹${_priceRange.end.round()}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDistanceSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Distance Radius',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Slider(
          value: _distanceRadius,
          min: 1,
          max: 50,
          divisions: 49,
          label: '${_distanceRadius.round()} km',
          onChanged: (value) {
            setState(() {
              _distanceRadius = value;
            });
          },
        ),
        Text(
          'Within ${_distanceRadius.round()} km',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Minimum Rating',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: List.generate(5, (index) {
            final rating = index + 1;
            final isSelected = _minRating >= rating;

            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _minRating = rating.toDouble();
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 2.w),
                padding: EdgeInsets.all(2.w),
                child: CustomIconWidget(
                  iconName: isSelected ? 'star' : 'star_border',
                  color:
                      isSelected ? AppTheme.primaryLight : colorScheme.outline,
                  size: 24,
                ),
              ),
            );
          }),
        ),
        Text(
          _minRating > 0
              ? '${_minRating.round()} stars and above'
              : 'Any rating',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Availability',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _availabilityOptions.map((option) {
            final isSelected = _selectedAvailability.contains(option);

            return FilterChip(
              selected: isSelected,
              onSelected: (selected) {
                HapticFeedback.lightImpact();
                setState(() {
                  if (selected) {
                    _selectedAvailability.add(option);
                  } else {
                    _selectedAvailability.remove(option);
                  }
                });
              },
              label: Text(option),
              backgroundColor: colorScheme.surface,
              selectedColor: colorScheme.primary.withValues(alpha: 0.2),
              checkmarkColor: colorScheme.primary,
              side: BorderSide(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSortSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort By',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Column(
          children: _sortOptions.map((option) {
            return RadioListTile<String>(
              title: Text(
                option,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              value: option,
              groupValue: _sortBy,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                setState(() {
                  _sortBy = value!;
                });
              },
              activeColor: colorScheme.primary,
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                _resetFilters();
              },
              child: Text('Reset'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                _applyFilters();
              },
              child: Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _priceRange = const RangeValues(0, 5000);
      _distanceRadius = 5.0;
      _minRating = 0.0;
      _sortBy = 'Nearest';
      _selectedAvailability.clear();
    });
  }

  void _applyFilters() {
    final filters = {
      'minPrice': _priceRange.start,
      'maxPrice': _priceRange.end,
      'distanceRadius': _distanceRadius,
      'minRating': _minRating,
      'sortBy': _sortBy,
      'availability': _selectedAvailability,
    };

    widget.onFiltersApplied?.call(filters);
    Navigator.pop(context);
  }
}




