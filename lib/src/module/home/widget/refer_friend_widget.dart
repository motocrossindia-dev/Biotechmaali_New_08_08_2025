import 'package:biotech_maali/core/settings_provider/settings_provider.dart';
import 'package:biotech_maali/src/module/account/refer_friend/refer_friend_provider.dart';
import 'package:biotech_maali/src/module/account/refer_friend/refer_friend_screen.dart';
import 'package:biotech_maali/src/module/home/home_provider.dart';
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

    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        final bannerContent = homeProvider.bannerContent;

        // If no banner content is available, show default
        final imageUrl = bannerContent?.image ?? '';
        final title =
            bannerContent?.title ?? 'Refer & Earn with BiotechMaali Rewards';
        final subtitle = bannerContent?.subtitle ??
            'Share the green with your friends and grow your wallet!. '
                'Earn real money or rewards every time someone you refer makes a purchase.';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: isTablet ? height * 0.25 : height * 0.32,
              width: width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/png/images/home_screen_img_1.jpg',
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/png/images/home_screen_img_1.jpg',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Container(
              width: width,
              color: cReferFriendsHome,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: height * 0.015,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  CommonTextWidget(
                    title: title,
                    fontSize: isTablet ? 24.0 : width * 0.05,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                  ),
                  // Only show subtitle if it's not empty
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: height * 0.01),
                    CommonTextWidget(
                      title: subtitle,
                      fontSize: isTablet ? 16.0 : width * 0.035,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                    ),
                  ],
                  SizedBox(height: height * 0.015),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: width * 0.01),
                          child: SizedBox(
                            height: isTablet ? height * 0.05 : height * 0.044,
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
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: width * 0.01),
                          child: SizedBox(
                            height: isTablet ? height * 0.05 : height * 0.044,
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
                                    builder: (context) =>
                                        const ReferFriendScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
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
