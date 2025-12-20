import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FloatingVoiceButtonWidget extends StatefulWidget {
  const FloatingVoiceButtonWidget({super.key});

  @override
  State<FloatingVoiceButtonWidget> createState() =>
      _FloatingVoiceButtonWidgetState();
}

class _FloatingVoiceButtonWidgetState extends State<FloatingVoiceButtonWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onVoiceButtonPressed() async {
    HapticFeedback.heavyImpact();

    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      _scaleController.forward();
      _showVoiceDialog();
    } else {
      _scaleController.reverse();
    }
  }

  void _showVoiceDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _VoiceListeningDialog(
        onClose: () {
          setState(() {
            _isListening = false;
          });
          _scaleController.reverse();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Positioned(
      right: 4.w,
      bottom: 20.h,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseAnimation, _scaleAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 20 * _pulseAnimation.value,
                    spreadRadius: 5 * _pulseAnimation.value,
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: _onVoiceButtonPressed,
                backgroundColor:
                    _isListening ? colorScheme.error : colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 8,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isListening
                      ? CustomIconWidget(
                          key: const ValueKey('stop'),
                          iconName: 'stop',
                          color: Colors.white,
                          size: 28,
                        )
                      : CustomIconWidget(
                          key: const ValueKey('mic'),
                          iconName: 'mic',
                          color: Colors.white,
                          size: 28,
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _VoiceListeningDialog extends StatefulWidget {
  final VoidCallback onClose;

  const _VoiceListeningDialog({required this.onClose});

  @override
  State<_VoiceListeningDialog> createState() => _VoiceListeningDialogState();
}

class _VoiceListeningDialogState extends State<_VoiceListeningDialog>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _waveAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));

    _waveController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Voice Assistant',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                IconButton(
                  onPressed: widget.onClose,
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 24,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    border: Border.all(
                      color: colorScheme.primary
                          .withValues(alpha: _waveAnimation.value),
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'mic',
                      color: colorScheme.primary,
                      size: 32,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 3.h),
            Text(
              'Listening for "Bandhu, Help!"',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Speak clearly or tap the microphone button to activate emergency assistance',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onClose,
                    child: const Text('Cancel'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onClose();
                      Navigator.pushNamed(context, '/emergency-sos');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.error,
                    ),
                    child: const Text('Emergency'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
