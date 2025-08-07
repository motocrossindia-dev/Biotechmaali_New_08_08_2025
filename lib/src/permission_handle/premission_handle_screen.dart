import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/permission_handle/premission_handle_provider.dart';

class PermissionHandleScreen extends StatefulWidget {
  const PermissionHandleScreen({super.key});

  @override
  State<PermissionHandleScreen> createState() => _PermissionHandleScreenState();
}

class _PermissionHandleScreenState extends State<PermissionHandleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PermissionHandleProvider>().checkPermissions();
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

                        // Permission Cards
                        _buildPermissionCard(
                          title: 'Location Access',
                          subtitle:
                              'Required for delivery and store locator services',
                          isGranted: provider.locationPermission,
                          onRequest: provider.requestLocationPermission,
                          icon: Icons.location_on_outlined,
                        ),
                        const SizedBox(height: 16),

                        // _buildPermissionCard(
                        //   title: 'Storage Access',
                        //   subtitle:
                        //       'Required for saving images and files locally',
                        //   isGranted: provider.storagePermission,
                        //   onRequest: provider.requestStoragePermission,
                        //   icon: Icons.folder_outlined,
                        // ),
                        // const SizedBox(height: 16),

                        _buildPermissionCard(
                          title: 'Camera Access',
                          subtitle:
                              'Required for scanning QR codes and taking photos',
                          isGranted: provider.cameraPermission,
                          onRequest: provider.requestCameraPermission,
                          icon: Icons.camera_alt_outlined,
                        ),
                        const SizedBox(height: 16),

                        _buildPermissionCard(
                          title: 'Microphone Access',
                          subtitle: 'Required for voice search functionality',
                          isGranted: provider.microphonePermission,
                          onRequest: provider.requestMicrophonePermission,
                          icon: Icons.mic_outlined,
                        ),
                        // const SizedBox(height: 16),

                        // _buildPermissionCard(
                        //   title: 'Notification Access',
                        //   subtitle:
                        //       'Required for order updates and important alerts',
                        //   isGranted: provider.notificationPermission,
                        //   onRequest: provider.requestNotificationPermission,
                        //   icon: Icons.notifications_outlined,
                        // ),

                        const SizedBox(height: 20),

                        // Continue Button
                        _buildContinueButton(context, provider),
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
    int grantedCount = [
      provider.locationPermission,
      // provider.storagePermission,
      provider.cameraPermission,
      provider.microphonePermission,
      // provider.notificationPermission,
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
                '$grantedCount/3',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color:
                      grantedCount == 4 ? Colors.green : Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: grantedCount / 3,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              grantedCount == 3 ? Colors.green : Colors.blue,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(
            grantedCount == 3
                ? 'All permissions granted!'
                : '${3 - grantedCount} permissions remaining',
            style: TextStyle(
              fontSize: 14,
              color: grantedCount == 5 ? Colors.green : Colors.grey.shade600,
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
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isGranted ? Colors.green.shade200 : Colors.grey.shade200,
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
              color: isGranted ? Colors.green.shade100 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 24,
              color: isGranted ? Colors.green.shade700 : Colors.grey.shade600,
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
              ],
            ),
          ),
          const SizedBox(width: 16),
          _buildPermissionButton(isGranted, onRequest),
        ],
      ),
    );
  }

  Widget _buildPermissionButton(bool isGranted, Function() onRequest) {
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
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: provider.allPermissionsGranted
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
        onPressed: provider.allPermissionsGranted
            ? () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('permissionGranted', true);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BottomNavWidget(),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: provider.allPermissionsGranted
              ? Colors.blue
              : Colors.grey.shade300,
          foregroundColor: provider.allPermissionsGranted
              ? Colors.white
              : Colors.grey.shade500,
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
            if (provider.allPermissionsGranted) ...[
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
