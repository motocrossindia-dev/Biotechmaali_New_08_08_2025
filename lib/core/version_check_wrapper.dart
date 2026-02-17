import 'package:flutter/material.dart';
import 'package:biotech_maali/core/config/pallet.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:biotech_maali/core/version_check_utils.dart';

class VersionCheckWrapper extends StatefulWidget {
  final Widget child;
  const VersionCheckWrapper({super.key, required this.child});

  @override
  State<VersionCheckWrapper> createState() => _VersionCheckWrapperState();
}

class _VersionCheckWrapperState extends State<VersionCheckWrapper>
    with WidgetsBindingObserver {
  bool _isDialogShowing = false;
  bool _hasCheckedVersion = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When app resumes and dialog was showing, check version again
    // This handles the case when user returns from store without updating
    if (state == AppLifecycleState.resumed && _isDialogShowing) {
      // Re-check version to see if user updated
      _recheckVersionAfterResume();
    }
  }

  Future<void> _recheckVersionAfterResume() async {
    final newVersion = NewVersionPlus(
      androidId: 'com.biotechmaali.app',
      iOSId: 'com.example.biotechMaali',
    );
    final status = await newVersion.getVersionStatus();
    if (status != null && !status.canUpdate) {
      // User has updated, close the dialog
      if (_isDialogShowing && mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        _isDialogShowing = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check version after MaterialApp is built
    if (!_hasCheckedVersion) {
      _hasCheckedVersion = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _checkVersion(context);
        }
      });
    }
    return widget.child;
  }

  Future<void> _checkVersion(BuildContext context) async {
    // Ensure we have a valid context with MaterialLocalizations
    try {
      final newVersion = NewVersionPlus(
        androidId: 'com.biotechmaali.app',
        iOSId: 'com.example.biotechMaali',
      );
      final status = await newVersion.getVersionStatus();
      if (status != null && status.canUpdate && mounted) {
        _showUpdateDialog(context, status);
      }
    } catch (e) {
      debugPrint('Version check error: $e');
    }
  }

  void _showUpdateDialog(BuildContext context, VersionStatus status) {
    if (_isDialogShowing) return; // Prevent duplicate dialogs

    _isDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Update icon with green color
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: cButtonGreen.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.system_update_rounded,
                            size: 60,
                            color: cButtonGreen,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Update Required',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: cButtonGreen,
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'A new version of the app is available!\n',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cButtonGreen.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Icon(Icons.app_settings_alt, color: cButtonGreen),
                              Text(
                                'Current: ${status.localVersion}',
                                style: TextStyle(
                                  color: cButtonGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Icon(Icons.new_releases, color: cButtonGreen),
                              Text(
                                'Latest: ${status.storeVersion}',
                                style: TextStyle(
                                  color: cButtonGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please update to continue.',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cButtonGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            onPressed: () {
                              // Launch store URL - dialog stays open
                              // User will return to app after updating
                              launchStoreUrl(status);
                            },
                            icon: const Icon(Icons.system_update_alt),
                            label: const Text(
                              'Update Now',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
            },
          ),
        ),
      ),
    ).then((_) {
      _isDialogShowing = false;
    });
  }
}
