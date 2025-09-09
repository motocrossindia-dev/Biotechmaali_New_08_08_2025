import 'import.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app lifecycle handler for data cleanup
  AppLifecycleHandler.initialize();

  runApp(const BiotechApp());
}
