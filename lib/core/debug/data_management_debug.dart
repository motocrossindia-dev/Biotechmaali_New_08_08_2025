import 'package:flutter/material.dart';
import 'package:biotech_maali/core/services/data_manager.dart';

class DataManagementDebugWidget extends StatelessWidget {
  const DataManagementDebugWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Management Debug'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Debug Tools for Data Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await DataManager.logAllStoredData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Check console for stored data'),
                  ),
                );
              },
              child: const Text('Log All Stored Data'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final keys = await DataManager.getAllPreferenceKeys();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Stored Keys'),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: keys.map((key) => Text('• $key')).toList(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Show All Keys'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                bool isLoggedIn = await DataManager.isUserLoggedIn();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User logged in: $isLoggedIn'),
                  ),
                );
              },
              child: const Text('Check Login Status'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              onPressed: () async {
                bool result = await DataManager.clearCacheDirectory();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Cache cleared: $result'),
                    backgroundColor: result ? Colors.green : Colors.red,
                  ),
                );
              },
              child: const Text('Clear Cache Only'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear User Session'),
                    content: const Text(
                        'This will clear all user data but keep app settings. Continue?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          bool result = await DataManager.clearUserSession();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('User session cleared: $result'),
                              backgroundColor:
                                  result ? Colors.green : Colors.red,
                            ),
                          );
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Clear User Session'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear ALL Data'),
                    content: const Text(
                        'This will clear everything including app settings. Continue?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          bool result = await DataManager.clearAllAppData();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('All data cleared: $result'),
                              backgroundColor:
                                  result ? Colors.green : Colors.red,
                            ),
                          );
                        },
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Clear ALL App Data'),
            ),
          ],
        ),
      ),
    );
  }
}
