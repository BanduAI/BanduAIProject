import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/app_export.dart';
import './widgets/countdown_timer.dart';
import './widgets/emergency_contacts_list.dart';
import './widgets/emergency_type_selector.dart';
import './widgets/location_sharing_toggle.dart';
import './widgets/network_status_indicator.dart';
import './widgets/sos_button.dart';
import './widgets/voice_activation_indicator.dart';

class EmergencySos extends StatefulWidget {
  const EmergencySos({super.key});

  @override
  State<EmergencySos> createState() => _EmergencySosState();
}

class _EmergencySosState extends State<EmergencySos>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<Color?> _backgroundAnimation;

  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isListening = false;
  bool _showCountdown = false;
  bool _showTypeSelector = false;
  bool _locationSharingEnabled = true;
  final bool _isNetworkConnected = true;
  String _selectedEmergencyType = '';

  final List<Map<String, dynamic>> _emergencyContacts = [
    {
      "id": 1,
      "name": "Priya Sharma",
      "relationship": "Family",
      "phone": "+91 98765 43210",
      "avatar": null,
      "isVerified": true,
    },
    {
      "id": 2,
      "name": "Dr. Rajesh Kumar",
      "relationship": "Doctor",
      "phone": "+91 98765 43211",
      "avatar": null,
      "isVerified": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _requestPermissions();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _backgroundAnimation = ColorTween(
      begin: AppTheme.lightTheme.scaffoldBackgroundColor,
      end: AppTheme.emergencyLight,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
  }

  /* ---------------- PERMISSIONS ---------------- */

  Future<void> _requestPermissions() async {
    final mic = await Permission.microphone.request();
    await Permission.locationWhenInUse.request();

    if (mic.isGranted) {
      _startVoiceListening();
    }
  }

  /* ---------------- VOICE RECORDING ---------------- */

  Future<void> _startVoiceListening() async {
    try {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/emergency.wav';

      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.wav),
        path: path,
      );

      setState(() {
        _isListening = true;
      });
    } catch (_) {
      setState(() {
        _isListening = false;
      });
    }
  }

  Future<void> _stopVoiceListening() async {
    if (_isListening) {
      await _audioRecorder.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  void _onMicrophonePressed() {
    HapticFeedback.lightImpact();
    _isListening ? _stopVoiceListening() : _startVoiceListening();
  }

  /* ---------------- SOS FLOW ---------------- */

  void _onSosButtonPressed() {
    HapticFeedback.heavyImpact();
    _activateEmergency();
  }

  void _activateEmergency() {
    _stopVoiceListening();
    setState(() {
      _showCountdown = true;
    });
    _backgroundController.forward();
  }

  void _onCountdownComplete() {
    setState(() {
      _showCountdown = false;
      _showTypeSelector = true;
    });
  }

  void _onCountdownCancel() {
    setState(() {
      _showCountdown = false;
    });
    _backgroundController.reverse();
    _startVoiceListening();
  }

  void _onEmergencyTypeSelected(String type) {
    _selectedEmergencyType = type;
    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/neighbor-response-tracking',
      );
    }
  }

  void _onTypeSelectorCancel() {
    setState(() {
      _showTypeSelector = false;
    });
    _backgroundController.reverse();
    _startVoiceListening();
  }

  /* ---------------- UI HELPERS ---------------- */

  void _onLocationToggle(bool enabled) {
    setState(() {
      _locationSharingEnabled = enabled;
    });
  }

  void _onContactCall(Map<String, dynamic> contact) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling ${contact['name']}...'),
        backgroundColor: AppTheme.emergencyLight,
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_showCountdown || _showTypeSelector) {
      return false;
    }
    return true;
  }

  @override
  void deactivate() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.deactivate();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  /* ---------------- UI ---------------- */

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, _) {
          return Scaffold(
            backgroundColor: _backgroundAnimation.value,
            body: Stack(
              children: [
                if (!_showCountdown) _buildMainContent(),
                if (_showCountdown)
                  CountdownTimer(
                    onCountdownComplete: _onCountdownComplete,
                    onCancel: _onCountdownCancel,
                  ),
                if (_showTypeSelector)
                  Positioned.fill(
                    child: EmergencyTypeSelector(
                      onTypeSelected: _onEmergencyTypeSelected,
                      onCancel: _onTypeSelectorCancel,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 4.h),
            NetworkStatusIndicator(
              isConnected: _isNetworkConnected,
              connectionType: '4G',
              signalStrength: 3,
            ),
            SizedBox(height: 4.h),
            SosButton(
              onPressed: _onSosButtonPressed,
              isActive: true,
            ),
            SizedBox(height: 4.h),
            VoiceActivationIndicator(
              isListening: _isListening,
              onMicrophonePressed: _onMicrophonePressed,
            ),
            SizedBox(height: 4.h),
            LocationSharingToggle(
              isEnabled: _locationSharingEnabled,
              onToggle: _onLocationToggle,
              currentAddress: 'Dwarka, New Delhi',
              gpsAccuracy: 'Accurate to 5m',
            ),
            SizedBox(height: 4.h),
            EmergencyContactsList(
              contacts: _emergencyContacts,
              onContactCall: _onContactCall,
            ),
          ],
        ),
      ),
    );
  }
}
