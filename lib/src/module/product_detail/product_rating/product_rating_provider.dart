import 'package:biotech_maali/import.dart';
import 'package:biotech_maali/src/module/product_detail/product_rating/product_rating_repository.dart';

class ProductRatingProvider extends ChangeNotifier {
  final ProductRatingRepository _repository = ProductRatingRepository();

  int _productId = 0;
  int get productId => _productId;

  int _rating = 0;
  int get rating => _rating;

  String _recommend = 'Yes';
  String get recommend => _recommend;

  String _reviewTitle = '';
  String get reviewTitle => _reviewTitle;

  String _comment = '';
  String get comment => _comment;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isAuthError = false;
  bool get isAuthError => _isAuthError;

  void setProductId(int id) {
    _productId = id;
    notifyListeners();
  }

  void setRating(int index) {
    _rating = index + 1;
    notifyListeners();
  }

  void setRecommend(String value) {
    _recommend = value;
    notifyListeners();
  }

  void setReviewTitle(String title) {
    _reviewTitle = title;
    notifyListeners();
  }

  void setComment(String text) {
    _comment = text;
    notifyListeners();
  }

  Future<bool> submitRating(BuildContext context) async {
    // Validate form
    if (_rating == 0) {
      _errorMessage = 'Please provide a rating';
      notifyListeners();
      return false;
    }

    if (_reviewTitle.isEmpty) {
      _errorMessage = 'Please provide a review title';
      notifyListeners();
      return false;
    }

    if (_comment.isEmpty) {
      _errorMessage = 'Please provide a comment';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = '';
    _isAuthError = false;
    notifyListeners();

    try {
      final result = await _repository.submitProductRating(
        productId: _productId,
        rating: _rating.toDouble(),
        reviewTitle: _reviewTitle,
        productReview: _comment,
        recommend: _recommend == 'Yes',
      );

      _isLoading = false;

      if (result) {
        context.read<ProductDetailsProvider>().fetchProductDetails(productId);
      }

      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to submit rating: $e';
      notifyListeners();
      return false;
    }
  }

  void resetForm() {
    _rating = 0;
    _recommend = 'Yes';
    _reviewTitle = '';
    _comment = '';
    _errorMessage = '';
    _isAuthError = false;
    notifyListeners();
  }
}
