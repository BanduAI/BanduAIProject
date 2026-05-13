import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatInputWidget extends StatefulWidget {
  final Function(String) onSendMessage;
  final Function(XFile) onImageSelected;
  final Function(PlatformFile) onFileSelected;
  final bool isEnabled;

  const ChatInputWidget({
    super.key,
    required this.onSendMessage,
    required this.onImageSelected,
    required this.onFileSelected,
    this.isEnabled = true,
  });

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _textController.text.trim().isNotEmpty;
    });
  }

  void _sendMessage() {
    if (_hasText && widget.isEnabled) {
      final message = _textController.text.trim();
      widget.onSendMessage(message);
      _textController.clear();
      HapticFeedback.lightImpact();
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        widget.onImageSelected(image);
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      _showErrorMessage('There was a problem selecting a photo');
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );

      if (result != null && result.files.isNotEmpty) {
        widget.onFileSelected(result.files.first);
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      _showErrorMessage('There was a problem selecting the file');
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAttachmentBottomSheet(),
    );
  }

  Widget _buildAttachmentBottomSheet() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6.w),
          topRight: Radius.circular(6.w),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 1.h,
            decoration: BoxDecoration(
              color: AppTheme.textSecondaryLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(0.5.h),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Select Attachments',
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAttachmentOption(
                'photo',
                'photo_camera',
                AppTheme.primaryLight,
                _pickImage,
              ),
              _buildAttachmentOption(
                'file',
                'attach_file',
                AppTheme.secondaryLight,
                _pickFile,
              ),
            ],
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildAttachmentOption(
    String label,
    String iconName,
    Color color,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      borderRadius: BorderRadius.circular(4.w),
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Container(
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.w),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 6.w,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.emergencyLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.borderLight.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Attachment button
            IconButton(
              onPressed: widget.isEnabled ? _showAttachmentOptions : null,
              icon: CustomIconWidget(
                iconName: 'attach_file',
                color: widget.isEnabled
                    ? AppTheme.textSecondaryLight
                    : AppTheme.textSecondaryLight.withValues(alpha: 0.5),
                size: 6.w,
              ),
              padding: EdgeInsets.all(2.w),
              constraints: BoxConstraints(
                minWidth: 10.w,
                minHeight: 10.w,
              ),
            ),
            SizedBox(width: 2.w),
            // Text input field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(6.w),
                  border: Border.all(
                    color: AppTheme.borderLight,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  enabled: widget.isEnabled,
                  maxLines: 4,
                  minLines: 1,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: InputDecoration(
                    hintText: 'Write your Message here...',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryLight.withValues(alpha: 0.7),
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 2.w),
            // Send button
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              child: IconButton(
                onPressed: (_hasText && widget.isEnabled) ? _sendMessage : null,
                icon: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: (_hasText && widget.isEnabled)
                        ? AppTheme.primaryLight
                        : AppTheme.textSecondaryLight.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(5.w),
                  ),
                  child: CustomIconWidget(
                    iconName: 'send',
                    color: Colors.white,
                    size: 5.w,
                  ),
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(
                  minWidth: 10.w,
                  minHeight: 10.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




