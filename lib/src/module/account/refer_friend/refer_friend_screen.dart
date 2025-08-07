import 'package:biotech_maali/src/module/account/refer_friend/refer_friend_provider.dart';
import 'package:biotech_maali/src/module/account/refer_friend/widgets/refer_friend_textformfield.dart';

import '../../../../import.dart';

class ReferFriendScreen extends StatefulWidget {
  const ReferFriendScreen({super.key});

  @override
  State<ReferFriendScreen> createState() => _ReferFriendScreenState();
}

class _ReferFriendScreenState extends State<ReferFriendScreen> {
  @override
  void initState() {
    context.read<ReferFriendProvider>().getReferralDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const CommonTextWidget(
          title: 'Refer A Friend',
          color: Colors.black,
          fontSize: 18,
        ),
      ),
      body: Consumer<ReferFriendProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(
                    height: 280,
                    width: double.infinity,
                    child: SvgPicture.asset(
                      'assets/svg/referral.svg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: ReferFriendTextformfield(
                                hint: "Enter referral code",
                                controller: provider.referralCode,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: provider.isLoading
                                ? null
                                : () => provider.shareReferralCode(),
                            child: Container(
                              color: cButtonGreen,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 24.0,
                              ),
                              child: Row(
                                children: [
                                  provider.isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.share,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                  const SizedBox(width: 8),
                                  const CommonTextWidget(
                                    title: 'Share',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: cButtonGreen),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          'Total Referrals: ${provider.totlaReferral ?? 0}',
                          style: TextStyle(
                            color: cButtonGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    if (provider.totalcoins != null && provider.totalcoins! > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: cBottomNav),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              'Total Coins Earned: ${provider.totalcoins}',
                              style: TextStyle(
                                color: cBottomNav,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
