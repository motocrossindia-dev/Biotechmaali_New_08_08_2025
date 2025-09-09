import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/src/module/account/refer_friend/refer_friend_provider.dart';
import 'package:biotech_maali/src/module/account/refer_friend/refer_friend_screen.dart';
import 'package:biotech_maali/src/widgets/login_prompt_dialog.dart';

import '../../../../import.dart';

class ReferFriendWidget extends StatelessWidget {
  const ReferFriendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: height * 0.32, // ~280px for 870px height
          width: width,
          child: Image.asset(
            'assets/png/images/home_screen_img_1.jpg',
            fit: BoxFit.fill,
          ),
        ),
        Container(
          height: height * 0.21, // ~184px for 870px height
          width: width,
          color: cReferFriendsHome,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04), // ~16px for 400px width
                child: const Center(
                  child: CommonTextWidget(
                    title: 'Refer & Earn with BiotechMaali Rewards',
                    // 'Join our Plant Parent Rewards Club',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04), // ~16px for 400px width
                child: const Center(
                  child: CommonTextWidget(
                    title:
                        // 'Every plant purchase is a gift that keeps on giving. '
                        // 'Earn coins and redeem them for exclusive discounts.',
                        'Share the green with your friends and grow your wallet!. '
                        'Earn real money or rewards every time someone you refer makes a purchase.',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: height * 0.044, // ~38px for 870px height
                    width: width * 0.41, // ~147px for 400px width
                    child: BorderColoredButton(
                      title: 'Learn More',
                      event: () async {
                        final settingsProvider =
                            context.read<SettingsProvider>();
                        bool isAuth = await settingsProvider
                            .checkAccessTokenValidity(context);

                        if (!isAuth) {
                          _showLoginDialog(context);
                          return;
                        }
                        showReferralPopup(
                            context,
                            context
                                .read<ReferFriendProvider>()
                                .referralCode
                                .text);
                      },
                      height: height * 0.044,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.044,
                    width: width * 0.41, // ~150px for 400px width
                    child: CommonButtonWidget(
                      title: 'Refer A Friend',
                      event: () async {
                        final settingsProvider =
                            context.read<SettingsProvider>();
                        bool isAuth = await settingsProvider
                            .checkAccessTokenValidity(context);

                        if (!isAuth) {
                          _showLoginDialog(context);
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReferFriendScreen(),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const LoginPromptDialog();
      },
    );
  }
}
