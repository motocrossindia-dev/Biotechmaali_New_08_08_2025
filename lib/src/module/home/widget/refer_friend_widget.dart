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
    final isTablet = width > 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: isTablet ? height * 0.25 : height * 0.32,
          width: width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/png/images/home_screen_img_1.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: isTablet ? height * 0.18 : height * 0.21,
          width: width,
          color: cReferFriendsHome,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Center(
                  child: CommonTextWidget(
                    title: 'Refer & Earn with BiotechMaali Rewards',
                    fontSize: isTablet ? 24.0 : width * 0.05,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Center(
                  child: CommonTextWidget(
                    title:
                        'Share the green with your friends and grow your wallet!. '
                        'Earn real money or rewards every time someone you refer makes a purchase.',
                    fontSize: isTablet ? 16.0 : width * 0.035,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: isTablet ? height * 0.05 : height * 0.044,
                      width: isTablet ? width * 0.35 : width * 0.41,
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
                        height: isTablet ? height * 0.05 : height * 0.044,
                      ),
                    ),
                    SizedBox(width: width * 0.02),
                    SizedBox(
                      height: isTablet ? height * 0.05 : height * 0.044,
                      width: isTablet ? width * 0.35 : width * 0.41,
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
