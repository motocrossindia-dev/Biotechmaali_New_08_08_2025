import '../../../../import.dart';

class GiftCardScreen extends StatelessWidget {
  const GiftCardScreen({super.key});

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
          title: 'My Gift Card',
          color: Colors.black,
          fontSize: 18,
        ),
      ),
      body: Column(
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
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: CommonTextWidget(
                            title: 'Share referral link via',
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        color: cButtonGreen,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24.0,
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            CommonTextWidget(
                              title: 'Share',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Container(
                //   width: double.infinity,
                //   padding: const EdgeInsets.symmetric(vertical: 16),
                //   decoration: BoxDecoration(
                //     border: Border.all(color: cButtonGreen),
                //     borderRadius: BorderRadius.circular(4),
                //   ),
                //   child: Center(
                //     child: Text(
                //       'Total Referrals: 0',
                //       style: TextStyle(
                //         color: cButtonGreen,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
