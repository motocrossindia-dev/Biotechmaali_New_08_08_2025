import 'package:biotech_maali/src/other_modules/our_store/model/our_store_model.dart';
import 'package:biotech_maali/src/other_modules/our_store/our_store_repository.dart';
import '../../../import.dart';

class OurStoreProvider with ChangeNotifier {
  final OurStoresRepository ourStoresRepository = OurStoresRepository();

  List<OurStoreModel> _stores = [];
  bool _isLoading = false;
  String? _error;

  List<OurStoreModel> get stores => _stores;
  bool get isLoading => _isLoading;
  String? get error => _error;

  OurStoreProvider() {
    loadStores();
  }

  Future<void> loadStores() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _stores = await ourStoresRepository.getOurStoreModels();
    } catch (e) {
      _error = 'Failed to load stores: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
