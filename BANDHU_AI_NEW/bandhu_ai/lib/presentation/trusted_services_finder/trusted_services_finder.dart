import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_filter_chips.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet.dart';
import './widgets/search_bar_widget.dart';
import './widgets/service_provider_card.dart';

class TrustedServicesFinder extends StatefulWidget {
  const TrustedServicesFinder({super.key});

  @override
  State<TrustedServicesFinder> createState() => _TrustedServicesFinderState();
}

class _TrustedServicesFinderState extends State<TrustedServicesFinder>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  String? _selectedCategory;
  Map<String, dynamic> _currentFilters = {};
  bool _isLoading = false;
  bool _isRefreshing = false;

  // Mock data for service providers
  final List<Map<String, dynamic>> _allProviders = [
    {
      "id": 1,
      "name": "Rajesh Kumar",
      "serviceType": "Plumber",
      "avatar": "https://images.unsplash.com/photo-1691671318357-370ca801ad5f",
      "avatarSemanticLabel":
          "Professional headshot of middle-aged Indian man with mustache wearing blue work shirt",
      "rating": 4.8,
      "reviewCount": 127,
      "distance": 0.8,
      "availability": "Available Now",
      "priceRange": "₹₹",
      "isVerified": true,
      "testimonials": [
        {
          "reviewerName": "Priya Sharma",
          "reviewerAvatar":
              "https://images.unsplash.com/photo-1729101143873-d80050bae219",
          "reviewerAvatarSemanticLabel":
              "Smiling Indian woman with long black hair wearing traditional red saree",
          "comment":
              "Fixed our kitchen sink perfectly. Very professional and affordable.",
        }
      ]
    },
    {
      "id": 2,
      "name": "Dr. Meera Patel",
      "serviceType": "Doctor",
      "avatar": "https://images.unsplash.com/photo-1663664971647-59de765183c1",
      "avatarSemanticLabel":
          "Professional photo of female doctor in white coat with stethoscope around neck",
      "rating": 4.9,
      "reviewCount": 203,
      "distance": 1.2,
      "availability": "Today",
      "priceRange": "₹₹₹",
      "isVerified": true,
      "testimonials": [
        {
          "reviewerName": "Amit Singh",
          "reviewerAvatar":
              "https://images.unsplash.com/photo-1666358086313-543412e1cdc2",
          "reviewerAvatarSemanticLabel":
              "Portrait of young Indian man with beard wearing casual blue shirt",
          "comment":
              "Excellent consultation. Very patient and thorough in examination.",
        }
      ]
    },
    {
      "id": 3,
      "name": "Suresh Electricals",
      "serviceType": "Electrician",
      "avatar": "https://images.unsplash.com/photo-1615560144206-dd4c2c9c18da",
      "avatarSemanticLabel":
          "Electrician in yellow hard hat working with electrical wires and tools",
      "rating": 4.6,
      "reviewCount": 89,
      "distance": 2.1,
      "availability": "This Week",
      "priceRange": "₹₹",
      "isVerified": true,
      "testimonials": [
        {
          "reviewerName": "Kavita Reddy",
          "reviewerAvatar":
              "https://images.unsplash.com/photo-1649140337818-5921f2a6af7d",
          "reviewerAvatarSemanticLabel":
              "Middle-aged Indian woman with short hair wearing green kurta",
          "comment":
              "Quick response for emergency repair. Fair pricing and quality work.",
        }
      ]
    },
    {
      "id": 4,
      "name": "Anita Tutoring",
      "serviceType": "Tutor",
      "avatar": "https://images.unsplash.com/photo-1672819030217-a1ad8307e629",
      "avatarSemanticLabel":
          "Young female teacher with glasses holding books in classroom setting",
      "rating": 4.7,
      "reviewCount": 156,
      "distance": 0.5,
      "availability": "Flexible",
      "priceRange": "₹₹",
      "isVerified": true,
      "testimonials": [
        {
          "reviewerName": "Ravi Gupta",
          "reviewerAvatar":
              "https://images.unsplash.com/photo-1688630218162-231bf1d8c1e1",
          "reviewerAvatarSemanticLabel":
              "Professional headshot of Indian man in formal white shirt and tie",
          "comment":
              "Helped my daughter improve her math grades significantly. Highly recommended.",
        }
      ]
    },
    {
      "id": 5,
      "name": "Clean Home Services",
      "serviceType": "Cleaner",
      "avatar": "https://images.unsplash.com/photo-1709182360963-af9a03d8dcbe",
      "avatarSemanticLabel":
          "Professional cleaning service worker in uniform with cleaning supplies",
      "rating": 4.5,
      "reviewCount": 78,
      "distance": 1.8,
      "availability": "Available Now",
      "priceRange": "₹",
      "isVerified": false,
      "testimonials": [
        {
          "reviewerName": "Deepa Nair",
          "reviewerAvatar":
              "https://images.unsplash.com/photo-1729101143873-d80050bae219",
          "reviewerAvatarSemanticLabel":
              "Smiling Indian woman with curly hair wearing casual white top",
          "comment":
              "Thorough cleaning service. They pay attention to every detail.",
        }
      ]
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {"name": "All", "icon": "apps"},
    {"name": "Plumber", "icon": "plumbing"},
    {"name": "Electrician", "icon": "electrical_services"},
    {"name": "Doctor", "icon": "medical_services"},
    {"name": "Tutor", "icon": "school"},
    {"name": "Cleaner", "icon": "cleaning_services"},
    {"name": "Carpenter", "icon": "construction"},
    {"name": "Mechanic", "icon": "build"},
  ];

  List<Map<String, dynamic>> _filteredProviders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, initialIndex: 3, vsync: this);
    _filteredProviders = List.from(_allProviders);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreProviders();
    }
  }

  void _loadMoreProviders() {
    // Simulate loading more providers
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            _buildTabBar(context),
            Expanded(
              child: _buildServicesTab(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            icon: CustomIconWidget(
              iconName: 'arrow_back_ios',
              color: colorScheme.onSurface,
              size: 24,
            ),
          ),
          Expanded(
            child: Text(
              'Trusted Services',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, '/ai-assistant-chat');
            },
            icon: CustomIconWidget(
              iconName: 'chat_bubble_outline',
              color: colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        onTap: (index) {
          HapticFeedback.lightImpact();
        },
        tabs: const [
          Tab(text: 'Home'),
          Tab(text: 'Neighbors'),
          Tab(text: 'Timeline'),
          Tab(text: 'Services'),
          Tab(text: 'Assistant'),
        ],
      ),
    );
  }

  Widget _buildServicesTab(BuildContext context) {
    return Column(
      children: [
        SearchBarWidget(
          controller: _searchController,
          hintText: 'Search for services...',
          onChanged: _onSearchChanged,
          onVoiceSearch: _onVoiceSearch,
          onFilterTap: _showFilterBottomSheet,
        ),
        CategoryFilterChips(
          categories: _categories,
          selectedCategory: _selectedCategory,
          onCategorySelected: _onCategorySelected,
        ),
        Expanded(
          child: _buildProvidersList(context),
        ),
      ],
    );
  }

  Widget _buildProvidersList(BuildContext context) {
    if (_filteredProviders.isEmpty) {
      return EmptyStateWidget(
        title: 'No Services Found',
        subtitle:
            'We couldn\'t find any service providers matching your criteria. Try adjusting your filters or suggest a new provider.',
        buttonText: 'Suggest a Service Provider',
        onButtonPressed: _showSuggestProviderDialog,
        illustrationUrl:
            'https://images.pexels.com/photos/5699456/pexels-photo-5699456.jpeg',
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(bottom: 2.h),
        itemCount: _filteredProviders.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _filteredProviders.length) {
            return _buildLoadingIndicator(context);
          }

          final provider = _filteredProviders[index];
          return ServiceProviderCard(
            provider: provider,
            onTap: () => _showProviderDetails(provider),
            onCall: () => _callProvider(provider),
            onMessage: () => _messageProvider(provider),
            onBookService: () => _bookService(provider),
            onAddToFavorites: () => _addToFavorites(provider),
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Center(
        child: CircularProgressIndicator(
          color: colorScheme.primary,
        ),
      ),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterProviders();
    });
  }

  void _onVoiceSearch() {
    HapticFeedback.mediumImpact();
    // Implement voice search functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice search activated. Say "Find plumber near me"'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category == 'All' ? null : category;
      _filterProviders();
    });
  }

  void _filterProviders() {
    setState(() {
      _filteredProviders = _allProviders.where((provider) {
        final matchesSearch = _searchQuery.isEmpty ||
            (provider['name'] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (provider['serviceType'] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());

        final matchesCategory = _selectedCategory == null ||
            (provider['serviceType'] as String) == _selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();

      _applySorting();
    });
  }

  void _applySorting() {
    final sortBy = _currentFilters['sortBy'] as String? ?? 'Nearest';

    switch (sortBy) {
      case 'Highest Rated':
        _filteredProviders
            .sort((a, b) => (b['rating'] as num).compareTo(a['rating'] as num));
        break;
      case 'Most Affordable':
        _filteredProviders.sort((a, b) => (a['priceRange'] as String)
            .length
            .compareTo((b['priceRange'] as String).length));
        break;
      case 'Recently Active':
        // Keep current order for recently active
        break;
      case 'Nearest':
      default:
        _filteredProviders.sort(
            (a, b) => (a['distance'] as num).compareTo(b['distance'] as num));
        break;
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        currentFilters: _currentFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _currentFilters = filters;
            _filterProviders();
          });
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
        _filteredProviders = List.from(_allProviders);
        _filterProviders();
      });
    }
  }

  void _showProviderDetails(Map<String, dynamic> provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildProviderDetailsSheet(provider),
    );
  }

  Widget _buildProviderDetailsSheet(Map<String, dynamic> provider) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
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
                    'Provider Details',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ServiceProviderCard(
                    provider: provider,
                    onCall: () => _callProvider(provider),
                    onMessage: () => _messageProvider(provider),
                    onBookService: () => _bookService(provider),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'About ${provider['name']}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Experienced ${provider['serviceType'].toString().toLowerCase()} with over 5 years of professional service in the community. Known for quality work and reliable service.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Reviews',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  // Add more review items here
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _callProvider(Map<String, dynamic> provider) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling ${provider['name']}...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _messageProvider(Map<String, dynamic> provider) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening chat with ${provider['name']}...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _bookService(Map<String, dynamic> provider) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking service with ${provider['name']}...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addToFavorites(Map<String, dynamic> provider) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${provider['name']} added to favorites'),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuggestProviderDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final TextEditingController nameController = TextEditingController();
    final TextEditingController serviceController = TextEditingController();
    final TextEditingController contactController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Suggest a Service Provider',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Provider Name',
                hintText: 'Enter provider name',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: serviceController,
              decoration: const InputDecoration(
                labelText: 'Service Type',
                hintText: 'e.g., Plumber, Electrician',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: contactController,
              decoration: const InputDecoration(
                labelText: 'Contact Information',
                hintText: 'Phone number or address',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Thank you! Your suggestion has been submitted for review.'),
                  backgroundColor: AppTheme.successLight,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}




