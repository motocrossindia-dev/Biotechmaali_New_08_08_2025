import 'dart:io';

import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/permission_handle/premission_handle_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandleScreen extends StatefulWidget {
  const PermissionHandleScreen({super.key});

  @override
  State<PermissionHandleScreen> createState() => _PermissionHandleScreenState();
}

class _PermissionHandleScreenState extends State<PermissionHandleScreen> {
  bool _showSkipOption = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<PermissionHandleProvider>().checkPermissions();
      _checkIfAllPermissionsDenied();
    });
  }

  Future<void> _checkIfAllPermissionsDenied() async {
    // Check if all permissions are permanently denied (excluding photos)
    bool allDenied = true;

    if (Platform.isIOS) {
      bool locationDenied =
          await Permission.locationWhenInUse.isPermanentlyDenied;
      bool cameraDenied = await Permission.camera.isPermanentlyDenied;
      bool microphoneDenied = await Permission.microphone.isPermanentlyDenied;

      allDenied = locationDenied && cameraDenied && microphoneDenied;
    } else {
      bool locationDenied = await Permission.location.isPermanentlyDenied;
      bool cameraDenied = await Permission.camera.isPermanentlyDenied;
      bool microphoneDenied = await Permission.microphone.isPermanentlyDenied;

      allDenied = locationDenied && cameraDenied && microphoneDenied;
    }

    setState(() {
      _showSkipOption = allDenied;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Consumer<PermissionHandleProvider>(
            builder: (context, provider, child) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(height: 10),
                        // Header Section
                        _buildHeader(context),
                        const SizedBox(height: 10),

                        // Progress Indicator
                        _buildProgressSection(provider),
                        const SizedBox(height: 16),

                        // Show warning if permissions are permanently denied
                        if (_showSkipOption) _buildWarningCard(),
                        if (_showSkipOption) const SizedBox(height: 16),

                        // Permission Cards (without photos)
                        _buildPermissionCard(
                          title: 'Location Access',
                          subtitle:
                              'Required for delivery and store locator services',
                          isGranted: provider.locationPermission,
                          onRequest: provider.requestLocationPermission,
                          icon: Icons.location_on_outlined,
                          isPermanentlyDenied: Platform.isIOS
                              ? Permission.locationWhenInUse.isPermanentlyDenied
                              : Permission.location.isPermanentlyDenied,
                        ),
                        const SizedBox(height: 16),

                        _buildPermissionCard(
                          title: 'Camera Access',
                          subtitle:
                              'Required for scanning QR codes and taking photos',
                          isGranted: provider.cameraPermission,
                          onRequest: provider.requestCameraPermission,
                          icon: Icons.camera_alt_outlined,
                          isPermanentlyDenied:
                              Permission.camera.isPermanentlyDenied,
                        ),
                        const SizedBox(height: 16),

                        _buildPermissionCard(
                          title: 'Microphone Access',
                          subtitle: 'Required for voice search functionality',
                          isGranted: provider.microphonePermission,
                          onRequest: provider.requestMicrophonePermission,
                          icon: Icons.mic_outlined,
                          isPermanentlyDenied:
                              Permission.microphone.isPermanentlyDenied,
                        ),

                        const SizedBox(height: 20),

                        // Continue Button
                        _buildContinueButton(context, provider),
                        const SizedBox(height: 20),

                        // Skip Button (only show if permissions are denied)
                        // if (_showSkipOption) ...[
                        //   const SizedBox(height: 16),
                        //   _buildSkipButton(context),
                        // ],

                        _buildSkipButton(context),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWarningCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange.shade600,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Permissions Previously Denied',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'To enable permissions, go to Settings > Biotech Maali > Permissions',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.security_outlined,
            size: 32,
            color: Colors.blue.shade700,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'App Permissions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'To provide you with the best experience, we need access to certain features on your device. All permissions are secure and used only for app functionality.',
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(PermissionHandleProvider provider) {
    // Only count 3 permissions: location, camera, microphone
    int totalPermissions = 3;
    int grantedCount = [
      provider.locationPermission,
      provider.cameraPermission,
      provider.microphonePermission,
    ].where((granted) => granted).length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              Text(
                '$grantedCount/$totalPermissions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: grantedCount == totalPermissions
                      ? Colors.green
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: grantedCount / totalPermissions,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              grantedCount == totalPermissions ? Colors.green : Colors.blue,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(
            grantedCount == totalPermissions
                ? 'All permissions granted!'
                : '${totalPermissions - grantedCount} permissions remaining',
            style: TextStyle(
              fontSize: 14,
              color: grantedCount == totalPermissions
                  ? Colors.green
                  : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionCard({
    required String title,
    required String subtitle,
    required bool isGranted,
    required Function() onRequest,
    required IconData icon,
    required Future<bool> isPermanentlyDenied,
  }) {
    return FutureBuilder<bool>(
      future: isPermanentlyDenied,
      builder: (context, snapshot) {
        bool permanentlyDenied = snapshot.data ?? false;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isGranted
                  ? Colors.green.shade200
                  : permanentlyDenied
                      ? Colors.red.shade200
                      : Colors.grey.shade200,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isGranted
                      ? Colors.green.shade100
                      : permanentlyDenied
                          ? Colors.red.shade100
                          : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: isGranted
                      ? Colors.green.shade700
                      : permanentlyDenied
                          ? Colors.red.shade600
                          : Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                    if (permanentlyDenied && !isGranted) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Enable in Settings',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _buildPermissionButton(isGranted, permanentlyDenied, onRequest),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPermissionButton(
      bool isGranted, bool permanentlyDenied, Function() onRequest) {
    if (isGranted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 16,
              color: Colors.green.shade700,
            ),
            const SizedBox(width: 6),
            Text(
              'Granted',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade700,
              ),
            ),
          ],
        ),
      );
    } else if (permanentlyDenied) {
      return ElevatedButton(
        onPressed: () =>
            context.read<PermissionHandleProvider>().openSettings(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: onRequest,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Grant',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }

  Widget _buildContinueButton(
      BuildContext context, PermissionHandleProvider provider) {
    // Check if core permissions are granted (excluding photos)
    bool corePermissionsGranted = provider.locationPermission &&
        provider.cameraPermission &&
        provider.microphonePermission;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: corePermissionsGranted
            ? [
                BoxShadow(
                  color: Colors.blue.shade200,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: corePermissionsGranted
            ? () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('permissionGranted', true);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BottomNavWidget(),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              corePermissionsGranted ? Colors.blue : Colors.grey.shade300,
          foregroundColor:
              corePermissionsGranted ? Colors.white : Colors.grey.shade500,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Continue to App',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (corePermissionsGranted) ...[
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: () async {
          // Show confirmation dialog
          bool? shouldSkip = await _showSkipConfirmationDialog();
          if (shouldSkip == true) {
            await context.read<PermissionHandleProvider>().skipPermissions();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavWidget(),
              ),
            );
          }
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade400),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.skip_next_outlined,
              size: 20,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              'Continue with Limited Features',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showSkipConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Continue with Limited Features?'),
        content: const Text(
            'Some app features may not work properly without these permissions. You can always enable them later in Settings.\n\nDo you want to continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
