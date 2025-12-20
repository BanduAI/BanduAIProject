import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class CommunityMemoryScreen extends StatefulWidget {
  const CommunityMemoryScreen({super.key});

  @override
  State<CommunityMemoryScreen> createState() => _CommunityMemoryScreenState();
}

class _CommunityMemoryScreenState extends State<CommunityMemoryScreen> {
  final ScrollController _scrollController = ScrollController();
  String _selectedLanguage = 'en';
  String _selectedCategory = 'all';

  // Mock data for past solutions
  final List<Map<String, dynamic>> _pastSolutions = [
    {
      'id': 1,
      'title': 'Monsoon Waterlogging - Mar 2023',
      'titleHi': 'मानसूनी जलभराव - मार्च 2023',
      'successRate': '95%',
      'solution':
          'Hired Tanker Services from AquaHelp for quick water drainage. Coordinated with 15 families.',
      'solutionHi':
          'त्वरित जल निकासी के लिए एक्वाहेल्प से टैंकर सेवाएं किराए पर लीं। 15 परिवारों के साथ समन्वय किया।',
      'category': 'infrastructure',
      'date': 'Mar 15, 2023',
      'families': 15,
      'cost': '₹12,000',
      'contact': 'AquaHelp Services',
      'phone': '+91 98765 43210',
      'image': 'https://images.unsplash.com/photo-1718295039542-fdecaa122a02',
      'semanticLabel':
          'Flooded street with standing water during monsoon season, showing waterlogging problem',
    },
    {
      'id': 2,
      'title': 'Power Outage Solution - Jan 2023',
      'titleHi': 'बिजली कटौती समाधान - जनवरी 2023',
      'successRate': '88%',
      'solution':
          'Community generator rental and battery backup system installation for common areas.',
      'solutionHi':
          'सामुदायिक जनरेटर किराया और सामान्य क्षेत्रों के लिए बैटरी बैकअप सिस्टम स्थापना।',
      'category': 'utilities',
      'date': 'Jan 10, 2023',
      'families': 25,
      'cost': '₹8,500',
      'contact': 'PowerGen Solutions',
      'phone': '+91 87654 32109',
      'image': 'https://images.unsplash.com/photo-1677750021685-439d326b5c22',
      'semanticLabel':
          'Electrical generator setup providing backup power during outage, community solution',
    },
    {
      'id': 3,
      'title': 'Waste Management Crisis - Nov 2022',
      'titleHi': 'अपशिष्ट प्रबंधन संकट - नवंबर 2022',
      'successRate': '92%',
      'solution':
          'Organized community composting and recycling program with local NGO partnership.',
      'solutionHi':
          'स्थानीय एनजीओ साझेदारी के साथ सामुदायिक कंपोस्टिंग और रीसाइक्लिंग कार्यक्रम आयोजित किया।',
      'category': 'environment',
      'date': 'Nov 20, 2022',
      'families': 30,
      'cost': '₹5,000',
      'contact': 'GreenEarth NGO',
      'phone': '+91 76543 21098',
      'image': 'https://images.unsplash.com/photo-1503421960785-09113df4b1c1',
      'semanticLabel':
          'Community waste segregation and composting setup showing environmental solution',
    },
    {
      'id': 4,
      'title': 'Security Concerns - Sep 2022',
      'titleHi': 'सुरक्षा चिंताएं - सितंबर 2022',
      'successRate': '96%',
      'solution':
          'Installed CCTV cameras and organized neighborhood watch program with 24x7 monitoring.',
      'solutionHi':
          '24x7 निगरानी के साथ सीसीटीवी कैमरे स्थापित किए और पड़ोसी निगरानी कार्यक्रम आयोजित किया।',
      'category': 'safety',
      'date': 'Sep 5, 2022',
      'families': 40,
      'cost': '₹35,000',
      'contact': 'SecureHome Tech',
      'phone': '+91 65432 10987',
      'image': 'https://images.unsplash.com/photo-1731963135911-0cba31abaa7a',
      'semanticLabel':
          'CCTV security camera installation providing community safety and monitoring',
    },
  ];

  final List<Map<String, String>> _categories = [
    {'id': 'all', 'name': 'All', 'nameHi': 'सभी'},
    {
      'id': 'infrastructure',
      'name': 'Infrastructure',
      'nameHi': 'बुनियादी ढांचा'
    },
    {'id': 'utilities', 'name': 'Utilities', 'nameHi': 'उपयोगिताएं'},
    {'id': 'environment', 'name': 'Environment', 'nameHi': 'पर्यावरण'},
    {'id': 'safety', 'name': 'Safety', 'nameHi': 'सुरक्षा'},
  ];

  List<Map<String, dynamic>> get filteredSolutions {
    if (_selectedCategory == 'all') {
      return _pastSolutions;
    }
    return _pastSolutions
        .where((solution) => solution['category'] == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          _selectedLanguage == 'hi' ? 'समुदायिक स्मृति' : 'Community Memory',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.language, color: colorScheme.onSurface),
            onSelected: (language) {
              setState(() {
                _selectedLanguage = language;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'en', child: Text('English')),
              PopupMenuItem(value: 'hi', child: Text('हिंदी')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 7.h,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category['id'];

                return Container(
                  margin: EdgeInsets.only(right: 2.w),
                  child: FilterChip(
                    label: Text(
                      _selectedLanguage == 'hi'
                          ? category['nameHi']!
                          : category['name']!,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color:
                            isSelected ? Colors.white : colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category['id']!;
                      });
                    },
                    selectedColor: colorScheme.primary,
                    backgroundColor: colorScheme.surface,
                    side: BorderSide(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                );
              },
            ),
          ),

          // Solutions Feed
          Expanded(
            child: filteredSolutions.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(4.w),
                    itemCount: filteredSolutions.length,
                    itemBuilder: (context, index) {
                      final solution = filteredSolutions[index];
                      return _buildSolutionCard(context, solution);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.lightImpact();
          _showAddSolutionDialog(context);
        },
        backgroundColor: colorScheme.primary,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          _selectedLanguage == 'hi' ? 'समाधान जोड़ें' : 'Add Solution',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildSolutionCard(
      BuildContext context, Map<String, dynamic> solution) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Header
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: SizedBox(
                height: 20.h,
                width: double.infinity,
                child: CustomImageWidget(
                  imageUrl: solution['image'] as String,
                  fit: BoxFit.cover,
                  semanticLabel: solution['semanticLabel'] as String,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Success Rate
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedLanguage == 'hi'
                              ? (solution['titleHi'] as String)
                              : (solution['title'] as String),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          solution['successRate'] as String,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Solution Summary
                  Text(
                    _selectedLanguage == 'hi'
                        ? (solution['solutionHi'] as String)
                        : (solution['solution'] as String),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 3.h),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        context,
                        Icons.people,
                        '${solution['families']} ${_selectedLanguage == 'hi' ? 'परिवार' : 'Families'}',
                      ),
                      _buildStatItem(
                        context,
                        Icons.currency_rupee,
                        solution['cost'] as String,
                      ),
                      _buildStatItem(
                        context,
                        Icons.calendar_today,
                        solution['date'] as String,
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _showContactDetails(context, solution);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _selectedLanguage == 'hi'
                            ? 'संपर्क और लागत देखें'
                            : 'View Contact & Cost',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Icon(icon, color: colorScheme.primary, size: 24),
        SizedBox(height: 1.h),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.memory,
              size: 20.w,
              color: colorScheme.primary.withValues(alpha: 0.5),
            ),
            SizedBox(height: 3.h),
            Text(
              _selectedLanguage == 'hi'
                  ? 'इस श्रेणी में कोई समाधान नहीं मिला'
                  : 'No solutions found in this category',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              _selectedLanguage == 'hi'
                  ? 'पहला समाधान जोड़ने के लिए + बटन दबाएं'
                  : 'Press + button to add the first solution',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showContactDetails(
      BuildContext context, Map<String, dynamic> solution) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              SizedBox(height: 3.h),

              Text(
                _selectedLanguage == 'hi' ? 'समाधान विवरण' : 'Solution Details',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),

              SizedBox(height: 3.h),

              _buildDetailRow(
                  context, 'Service Provider', solution['contact'] as String),
              _buildDetailRow(context, 'Phone', solution['phone'] as String),
              _buildDetailRow(
                  context, 'Total Cost', solution['cost'] as String),
              _buildDetailRow(context, 'Families Involved',
                  '${solution['families']} families'),
              _buildDetailRow(
                  context, 'Success Rate', solution['successRate'] as String),
              _buildDetailRow(
                  context, 'Date Completed', solution['date'] as String),

              SizedBox(height: 4.h),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // Copy phone number
                        Clipboard.setData(
                            ClipboardData(text: solution['phone'] as String));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_selectedLanguage == 'hi'
                                ? 'फोन नंबर कॉपी किया गया'
                                : 'Phone number copied'),
                            backgroundColor: colorScheme.primary,
                          ),
                        );
                      },
                      icon: Icon(Icons.copy),
                      label: Text(_selectedLanguage == 'hi'
                          ? 'नंबर कॉपी करें'
                          : 'Copy Number'),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // Simulate call
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${_selectedLanguage == 'hi' ? 'कॉल कर रहे हैं' : 'Calling'} ${solution['contact']}'),
                            backgroundColor: colorScheme.primary,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary),
                      icon: Icon(Icons.call, color: Colors.white),
                      label: Text(
                        _selectedLanguage == 'hi' ? 'कॉल करें' : 'Call Now',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddSolutionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_selectedLanguage == 'hi'
            ? 'नया समाधान जोड़ें'
            : 'Add New Solution'),
        content: Text(
          _selectedLanguage == 'hi'
              ? 'यह फ़ीचर जल्द ही आएगा। समुदाय अपने समाधान साझा कर सकेगा।'
              : 'This feature is coming soon. Community will be able to share their solutions.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_selectedLanguage == 'hi' ? 'ठीक है' : 'OK'),
          ),
        ],
      ),
    );
  }
}
