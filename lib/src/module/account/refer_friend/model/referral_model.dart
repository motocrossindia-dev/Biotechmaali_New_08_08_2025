class ReferralModel {
  int totalCoins;
  String referralCode;
  int totalReferrals;

  ReferralModel({required this.totalCoins, required this.referralCode, required this.totalReferrals});

  factory ReferralModel.fromJson(Map<String, dynamic> json) {
    return ReferralModel(
      totalCoins: json['total_coins'],
      referralCode: json['referral_code'],
      totalReferrals: json['total_referrals'],
    );
  }

  @override
  String toString() {
    return 'ReferralData{totalCoins: $totalCoins, referralCode: $referralCode, totalReferrals: $totalReferrals}';
  }
}