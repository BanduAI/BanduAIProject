import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SkillSwapScreen extends StatefulWidget {
  const SkillSwapScreen({super.key});

  @override
  State<SkillSwapScreen> createState() => _SkillSwapScreenState();
}

class _SkillSwapScreenState extends State<SkillSwapScreen> {
  final ScrollController _scrollController = ScrollController();
  String _selectedLanguage = 'en';

  // Mock AI-suggested match
  final Map<String, dynamic> _suggestedMatch = {
    'type': 'exchange',
    'yourSkill': 'English Teaching',
    'yourSkillHi': 'अंग्रेजी शिक्षा',
    'theirSkill': 'Python Programming',
    'theirSkillHi': 'पायथन प्रोग्रामिंग',
    'partnerName': 'Rohan Kumar',
    'partnerAvatar':
        'https://images.unsplash.com/photo-1668105617569-82a8ad941c87',
    'partnerSemanticLabel':
        'Young Indian man with glasses wearing casual blue shirt, friendly smile',
    'matchScore': 95,
    'description':
        'Perfect match! Rohan is looking for English conversation practice and can teach Python basics.',
    'descriptionHi':
        'बेहतरीन मैच! रोहन अंग्रेजी बातचीत का अभ्यास चाहते हैं और पायथन की बेसिक्स सिखा सकते हैं।',
    'distance': '0.3 km',
    'rating': 4.8,
    'skillLevel': 'Intermediate',
    'availability': 'Weekends',
  };

  // Mock available skills in neighborhood
  final List<Map<String, dynamic>> _availableSkills = [
    {
      'id': 1,
      'userName': 'Priya Sharma',
      'avatar':
          'https://images.unsplash.com/photo-1652396944757-ad27b62b33f6',
      'semanticLabel':
          'Young Indian woman with long dark hair wearing traditional outfit, warm smile',
      'skill': 'Cooking',
      'skillHi': 'खाना बनाना',
      'category': 'Life Skills',
      'categoryHi': 'जीवन कौशल',
      'level': 'Expert',
      'rating': 4.9,
      'distance': '0.2 km',
      'availability': 'Evenings',
      'description': 'Traditional Indian cuisine specialist',
      'descriptionHi': 'पारंपरिक भारतीय व्यंजन विशेषज्ञ',
    },
    {
      'id': 2,
      'userName': 'Amit Patel',
      'avatar':
          'https://images.unsplash.com/photo-1631894862790-b8bf1598eb85',
      'semanticLabel':
          'Middle-aged Indian man with beard wearing casual shirt, professional look',
      'skill': 'Guitar',
      'skillHi': 'गिटार',
      'category': 'Music',
      'categoryHi': 'संगीत',
      'level': 'Advanced',
      'rating': 4.7,
      'distance': '0.4 km',
      'availability': 'Weekends',
      'description': 'Classical and modern guitar techniques',
      'descriptionHi': 'शास्त्रीय और आधुनिक गिटार तकनीक',
    },
    {
      'id': 3,
      'userName': 'Dr. Sunita Devi',
      'avatar':
          'https://images.unsplash.com/photo-1632110287190-7b6807b7ad2e',
      'semanticLabel':
          'Elderly Indian woman with gray hair wearing saree, wise and kind expression',
      'skill': 'Yoga & Meditation',
      'skillHi': 'योग और ध्यान',
      'category': 'Health & Wellness',
      'categoryHi': 'स्वास्थ्य और कल्याण',
      'level': 'Master',
      'rating': 5.0,
      'distance': '0.1 km',
      'availability': 'Mornings',
      'description': '30+ years of yoga practice and teaching',
      'descriptionHi': '30+ वर्षों का योग अभ्यास और शिक्षण',
    },
    {
      'id': 4,
      'userName': 'Rahul Singh',
      'avatar':
          'https://images.unsplash.com/photo-1616064987986-e339fa40da32',
      'semanticLabel':
          'Young Indian man with short hair wearing hoodie, tech-savvy appearance',
      'skill': 'Computer Repair',
      'skillHi': 'कंप्यूटर मरम्मत',
      'category': 'Technical',
      'categoryHi': 'तकनीकी',
      'level': 'Expert',
      'rating': 4.6,
      'distance': '0.5 km',
      'availability': 'Flexible',
      'description': 'Hardware and software troubleshooting',
      'descriptionHi': 'हार्डवेयर और सॉफ्टवेयर समस्या निवारण',
    },
    {
      'id': 5,
      'userName': 'Kavita Joshi',
      'avatar':
          'https://images.unsplash.com/photo-1678536517689-f9d11edd22ec',
      'semanticLabel':
          'Middle-aged Indian woman with shoulder-length hair wearing modern attire, confident smile',
      'skill': 'Tailoring',
      'skillHi': 'दर्जी का काम',
      'category': 'Crafts',
      'categoryHi': 'शिल्प',
      'level': 'Expert',
      'rating': 4.8,
      'distance': '0.3 km',
      'availability': 'Afternoons',
      'description': 'Custom clothing and alterations',
      'descriptionHi': 'कस्टम कपड़े और परिवर्तन',
    },
  ];

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
          _selectedLanguage == 'hi' ? 'कौशल आदान-प्रदान' : 'Skill Swap',
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
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Suggested Match Card
            _buildSuggestedMatchCard(context),

            SizedBox(height: 4.h),

            // Available Skills Section
            Text(
              _selectedLanguage == 'hi'
                  ? 'आपके पड़ोस में उपलब्ध कौशल'
                  : 'Available Skills in Your Neighborhood',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),

            SizedBox(height: 2.h),

            // Skills List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _availableSkills.length,
              separatorBuilder: (context, index) => SizedBox(height: 2.h),
              itemBuilder: (context, index) {
                final skill = _availableSkills[index];
                return _buildSkillCard(context, skill);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.lightImpact();
          _showAddSkillDialog(context);
        },
        backgroundColor: colorScheme.primary,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          _selectedLanguage == 'hi' ? 'कौशल जोड़ें' : 'Add Skill',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildSuggestedMatchCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with AI badge
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                    SizedBox(width: 1.w),
                    Text(
                      _selectedLanguage == 'hi' ? 'AI सुझाव' : 'AI Suggested',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_suggestedMatch['matchScore']}% ${_selectedLanguage == 'hi' ? 'मैच' : 'Match'}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          Text(
            _selectedLanguage == 'hi' ? 'सुझावित मैच' : 'Suggested Match',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 2.h),

          // Match description
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _selectedLanguage == 'hi'
                                ? 'आप सिखाते हैं'
                                : 'You Teach',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            _selectedLanguage == 'hi'
                                ? _suggestedMatch['yourSkillHi'] as String
                                : _suggestedMatch['yourSkill'] as String,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child:
                          Icon(Icons.swap_horiz, color: Colors.white, size: 24),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _selectedLanguage == 'hi'
                                ? 'आप सीखते हैं'
                                : 'You Learn',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            _selectedLanguage == 'hi'
                                ? _suggestedMatch['theirSkillHi'] as String
                                : _suggestedMatch['theirSkill'] as String,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Partner info
          Row(
            children: [
              CircleAvatar(
                radius: 8.w,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: _suggestedMatch['partnerAvatar'] as String,
                    width: 16.w,
                    height: 16.w,
                    fit: BoxFit.cover,
                    semanticLabel:
                        _suggestedMatch['partnerSemanticLabel'] as String,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _suggestedMatch['partnerName'] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      _selectedLanguage == 'hi'
                          ? _suggestedMatch['descriptionHi'] as String
                          : _suggestedMatch['description'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _showMatchDetails(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(Icons.info_outline, color: Colors.white, size: 18),
                  label: Text(
                    _selectedLanguage == 'hi' ? 'विवरण' : 'Details',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _connectWithMatch(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(Icons.chat, color: colorScheme.primary, size: 18),
                  label: Text(
                    _selectedLanguage == 'hi' ? 'कनेक्ट करें' : 'Connect',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(BuildContext context, Map<String, dynamic> skill) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          _showSkillDetails(context, skill);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 6.w,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: skill['avatar'] as String,
                    width: 12.w,
                    height: 12.w,
                    fit: BoxFit.cover,
                    semanticLabel: skill['semanticLabel'] as String,
                  ),
                ),
              ),

              SizedBox(width: 4.w),

              // Skill info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            skill['userName'] as String,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            SizedBox(width: 1.w),
                            Text(
                              '${skill['rating']}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      _selectedLanguage == 'hi'
                          ? (skill['skillHi'] as String)
                          : (skill['skill'] as String),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      _selectedLanguage == 'hi'
                          ? (skill['descriptionHi'] as String)
                          : (skill['description'] as String),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 14,
                            color:
                                colorScheme.onSurface.withValues(alpha: 0.6)),
                        SizedBox(width: 1.w),
                        Text(
                          skill['distance'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(Icons.schedule,
                            size: 14,
                            color:
                                colorScheme.onSurface.withValues(alpha: 0.6)),
                        SizedBox(width: 1.w),
                        Text(
                          skill['availability'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: 2.w),

              Icon(
                Icons.arrow_forward_ios,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMatchDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_selectedLanguage == 'hi' ? 'मैच विवरण' : 'Match Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '${_selectedLanguage == 'hi' ? 'दूरी' : 'Distance'}: ${_suggestedMatch['distance']}'),
            Text(
                '${_selectedLanguage == 'hi' ? 'रेटिंग' : 'Rating'}: ${_suggestedMatch['rating']}/5.0'),
            Text(
                '${_selectedLanguage == 'hi' ? 'स्तर' : 'Level'}: ${_suggestedMatch['skillLevel']}'),
            Text(
                '${_selectedLanguage == 'hi' ? 'उपलब्धता' : 'Availability'}: ${_suggestedMatch['availability']}'),
          ],
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

  void _connectWithMatch(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_selectedLanguage == 'hi' ? 'कनेक्ट करें' : 'Connect'),
        content: Text(
          _selectedLanguage == 'hi'
              ? 'क्या आप ${_suggestedMatch['partnerName']} के साथ कौशल आदान-प्रदान शुरू करना चाहते हैं?'
              : 'Would you like to start skill exchange with ${_suggestedMatch['partnerName']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_selectedLanguage == 'hi' ? 'रद्द करें' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _selectedLanguage == 'hi'
                        ? 'कनेक्शन अनुरोध भेजा गया!'
                        : 'Connection request sent!',
                  ),
                ),
              );
            },
            child: Text(_selectedLanguage == 'hi' ? 'भेजें' : 'Send'),
          ),
        ],
      ),
    );
  }

  void _showSkillDetails(BuildContext context, Map<String, dynamic> skill) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Row(
                children: [
                  CircleAvatar(
                    radius: 8.w,
                    child: ClipOval(
                      child: CustomImageWidget(
                        imageUrl: skill['avatar'] as String,
                        width: 16.w,
                        height: 16.w,
                        fit: BoxFit.cover,
                        semanticLabel: skill['semanticLabel'] as String,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          skill['userName'] as String,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          _selectedLanguage == 'hi'
                              ? (skill['skillHi'] as String)
                              : (skill['skill'] as String),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                _selectedLanguage == 'hi'
                    ? (skill['descriptionHi'] as String)
                    : (skill['description'] as String),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDetailItem(
                    context,
                    Icons.star,
                    _selectedLanguage == 'hi' ? 'रेटिंग' : 'Rating',
                    '${skill['rating']}/5.0',
                  ),
                  _buildDetailItem(
                    context,
                    Icons.location_on,
                    _selectedLanguage == 'hi' ? 'दूरी' : 'Distance',
                    skill['distance'] as String,
                  ),
                  _buildDetailItem(
                    context,
                    Icons.schedule,
                    _selectedLanguage == 'hi' ? 'समय' : 'Time',
                    skill['availability'] as String,
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _selectedLanguage == 'hi'
                              ? 'संपर्क अनुरोध भेजा गया!'
                              : 'Contact request sent!',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  icon: Icon(Icons.chat, color: Colors.white),
                  label: Text(
                    _selectedLanguage == 'hi' ? 'संपर्क करें' : 'Contact',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(
      BuildContext context, IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
        SizedBox(height: 1.h),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  void _showAddSkillDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            _selectedLanguage == 'hi' ? 'नया कौशल जोड़ें' : 'Add New Skill'),
        content: Text(
          _selectedLanguage == 'hi'
              ? 'यह फ़ीचर जल्द ही आएगा। आप अपने कौशल जोड़ सकेंगे और दूसरों के साथ आदान-प्रदान कर सकेंगे।'
              : 'This feature is coming soon. You will be able to add your skills and exchange with others.',
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




