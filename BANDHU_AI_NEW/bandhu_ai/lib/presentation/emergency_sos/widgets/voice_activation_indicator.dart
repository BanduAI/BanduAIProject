import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceActivationIndicator extends StatefulWidget {
  final bool isListening;
  final VoidCallback onMicrophonePressed;
  final String voiceCommand;

  const VoiceActivationIndicator({
    super.key,
    required this.isListening,
    required this.onMicrophonePressed,
    this.voiceCommand = 'Bandhu, Help!',
  });

  @override
  State<VoiceActivationIndicator> createState() =>
      _VoiceActivationIndicatorState();
}

class _VoiceActivationIndicatorState extends State<VoiceActivationIndicator>
    with TickerProviderStateMixin {
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
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
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
  void didUpdateWidget(VoiceActivationIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening && !oldWidget.isListening) {
      _pulseController.repeat(reverse: true);
      _waveController.repeat(reverse: true);
    } else if (!widget.isListening && oldWidget.isListening) {
      _pulseController.stop();
      _waveController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Microphone button with animation
        GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            widget.onMicrophonePressed();
          },
          child: AnimatedBuilder(
            animation: widget.isListening
                ? _pulseAnimation
                : const AlwaysStoppedAnimation(1.0),
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isListening
                        ? AppTheme.emergencyLight
                        : colorScheme.surface,
                    border: Border.all(
                      color: widget.isListening
                          ? Colors.white
                          : colorScheme.outline.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: widget.isListening
                        ? [
                            BoxShadow(
                              color: AppTheme.emergencyLight
                                  .withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: widget.isListening ? 'mic' : 'mic_none',
                      color: widget.isListening
                          ? Colors.white
                          : colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 8.w,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 2.h),

        // Voice command text
        Text(
          widget.isListening ? 'Listening...' : 'Say "${widget.voiceCommand}"',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: widget.isListening
                ? AppTheme.emergencyLight
                : colorScheme.onSurface.withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 1.h),

        // Instruction text
        Text(
          widget.isListening
              ? 'Voice activation ready'
              : 'Tap microphone or use voice command',
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),

        // Sound wave visualization when listening
        if (widget.isListening) ...[
          SizedBox(height: 3.h),
          AnimatedBuilder(
            animation: _waveAnimation,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final delay = index * 0.2;
                  final animationValue = (_waveAnimation.value + delay) % 1.0;
                  final height = 1.h + (3.h * animationValue);

                  return Container(
                    width: 1.w,
                    height: height,
                    margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                    decoration: BoxDecoration(
                      color: AppTheme.emergencyLight.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(0.5.w),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ],
    );
  }
}




