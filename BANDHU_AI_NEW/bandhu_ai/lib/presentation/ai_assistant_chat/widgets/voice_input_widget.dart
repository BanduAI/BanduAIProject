import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceInputWidget extends StatefulWidget {
  final Function(String) onVoiceInput;
  final VoidCallback? onRecordingStart;
  final VoidCallback? onRecordingStop;

  const VoiceInputWidget({
    super.key,
    required this.onVoiceInput,
    this.onRecordingStart,
    this.onRecordingStop,
  });

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget>
    with TickerProviderStateMixin {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _isProcessing = false;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<bool> _requestMicrophonePermission() async {
    if (kIsWeb) return true;

    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> _startRecording() async {
    try {
      if (!await _requestMicrophonePermission()) {
        _showPermissionDialog();
        return;
      }

      if (await _audioRecorder.hasPermission()) {
        setState(() {
          _isRecording = true;
        });

        HapticFeedback.mediumImpact();
        widget.onRecordingStart?.call();

        _pulseController.repeat(reverse: true);
        _waveController.repeat(reverse: true);

        if (kIsWeb) {
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.wav),
            path: 'recording.wav',
          );
        } else {
          final dir = await getTemporaryDirectory();
          String path =
              '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
          await _audioRecorder.start(
            const RecordConfig(),
            path: path,
          );
        }
      }
    } catch (e) {
      _showErrorMessage('There was a problem starting the recording');
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _stopRecording() async {
    try {
      setState(() {
        _isRecording = false;
        _isProcessing = true;
      });

      _pulseController.stop();
      _waveController.stop();

      HapticFeedback.lightImpact();
      widget.onRecordingStop?.call();

      final path = await _audioRecorder.stop();

      if (path != null) {
        // Simulate speech-to-text processing
        await Future.delayed(Duration(seconds: 2));

        // Mock transcription - in real app, this would use speech recognition API
        final mockTranscriptions = [
          'Hello, I need emergency help',
          'Who is the doctor near me?',
          'Can you tell me about the nearest shops?',
          'I need to contact my family',
          'Whats the weather like today?',
        ];

        final randomTranscription = mockTranscriptions[
            DateTime.now().millisecond % mockTranscriptions.length];

        widget.onVoiceInput(randomTranscription);
      }
    } catch (e) {
      _showErrorMessage('There was a problem stopping the recording');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'microphone permission',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Text(
          'Microphone permission is required for voice input.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
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

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          if (_isRecording) _buildWaveformVisualization(),
          SizedBox(height: 2.h),
          GestureDetector(
            onTapDown: (_) => _startRecording(),
            onTapUp: (_) => _stopRecording(),
            onTapCancel: () => _stopRecording(),
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isRecording ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: _isRecording
                          ? AppTheme.emergencyLight
                          : _isProcessing
                              ? AppTheme.secondaryLight
                              : AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(10.w),
                      boxShadow: [
                        BoxShadow(
                          color: (_isRecording
                                  ? AppTheme.emergencyLight
                                  : AppTheme.primaryLight)
                              .withValues(alpha: 0.3),
                          blurRadius: _isRecording ? 20 : 10,
                          spreadRadius: _isRecording ? 5 : 2,
                        ),
                      ],
                    ),
                    child: _isProcessing
                        ? CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          )
                        : CustomIconWidget(
                            iconName: _isRecording ? 'stop' : 'mic',
                            color: Colors.white,
                            size: 8.w,
                          ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            _isProcessing
                ? 'Your voice is being understood...'
                : _isRecording
                    ? 'Speak... release finger to release'
                    : 'Press and hold to speak',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryLight,
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWaveformVisualization() {
    return AnimatedBuilder(
      animation: _waveAnimation,
      builder: (context, child) {
        return SizedBox(
          height: 8.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(5, (index) {
              final height =
                  (2 + (3 * _waveAnimation.value * (index % 2 == 0 ? 1 : 0.7)))
                      .h;
              return Container(
                width: 1.w,
                height: height,
                margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(0.5.w),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}




