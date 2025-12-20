import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmergencyNotesWidget extends StatefulWidget {
  final List<Map<String, dynamic>> notes;
  final Function(String) onAddNote;

  const EmergencyNotesWidget({
    super.key,
    required this.notes,
    required this.onAddNote,
  });

  @override
  State<EmergencyNotesWidget> createState() => _EmergencyNotesWidgetState();
}

class _EmergencyNotesWidgetState extends State<EmergencyNotesWidget> {
  final TextEditingController _noteController = TextEditingController();
  bool _isRecording = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'note_add',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Emergency Notes',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Add update for family members...',
                    border: InputBorder.none,
                    hintStyle:
                        AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                    ),
                  ),
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            _isRecording ? _stopRecording : _startRecording,
                        icon: CustomIconWidget(
                          iconName: _isRecording ? 'stop' : 'mic',
                          color: Colors.white,
                          size: 4.w,
                        ),
                        label: Text(
                          _isRecording ? 'Stop Recording' : 'Voice Note',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isRecording
                              ? AppTheme.lightTheme.colorScheme.error
                              : AppTheme.lightTheme.colorScheme.secondary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    ElevatedButton(
                      onPressed: _addNote,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.5.h),
                      ),
                      child: CustomIconWidget(
                        iconName: 'send',
                        color: Colors.white,
                        size: 4.w,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (widget.notes.isNotEmpty) ...[
            SizedBox(height: 3.h),
            Text(
              'Recent Updates',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            ...widget.notes.take(3).map((note) => _buildNoteItem(note)),
          ],
        ],
      ),
    );
  }

  Widget _buildNoteItem(Map<String, dynamic> note) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: note['type'] == 'voice' ? 'mic' : 'note',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  note['content'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            _formatTime(note['timestamp'] as DateTime),
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
    });
    HapticFeedback.lightImpact();
    // Simulate voice recording
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isRecording) {
        _stopRecording();
      }
    });
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });
    HapticFeedback.lightImpact();
    _noteController.text =
        'Voice note recorded - Everything is under control, helpers are here.';
  }

  void _addNote() {
    if (_noteController.text.trim().isNotEmpty) {
      widget.onAddNote(_noteController.text.trim());
      _noteController.clear();
      HapticFeedback.lightImpact();
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
