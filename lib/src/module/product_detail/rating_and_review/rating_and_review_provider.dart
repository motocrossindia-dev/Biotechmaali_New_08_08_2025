import 'package:biotech_maali/src/module/product_detail/product_details/model/product_details_model.dart';
import 'package:flutter/material.dart';

class RatingAndReviewProvider extends ChangeNotifier {
  ProductData? productData;
  bool showReviews = false;
  double averageRating = 0.0;
  Map<int, int> ratingDistribution = {};

  RatingAndReviewProvider({this.productData}) {
    if (productData?.productRating != null) {
      averageRating = productData!.productRating!.avgRating;
      _initializeRatingDistribution();
    }
  }

  void _initializeRatingDistribution() {
    // Initialize with zeros first
    for (int i = 1; i <= 5; i++) {
      ratingDistribution[i] = 0;
    }
    
    // Fill in actual values from stars_given
    for (var starRating in productData!.productRating!.starsGiven) {
      ratingDistribution[starRating.roundedRating.toInt()] = starRating.count;
    }
  }

  void setShowReviews() {
    showReviews = !showReviews;
    notifyListeners();
  }

  int get totalRatings => productData?.productRating?.numRatings ?? 0;
  
  List<ProductReview> get reviews => productData?.productReviews ?? [];
}