import '../../../../import.dart';

class ProductRatingScreen extends StatelessWidget {
  final int productId;

  const ProductRatingScreen({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    // Set the product ID when the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductRatingProvider>(context, listen: false)
          .setProductId(productId);
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const CommonTextWidget(
          title: 'Product Ratings',
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Consumer<ProductRatingProvider>(
                builder: (context, provider, child) {
                  // Check for auth error and navigate to login if needed
                  if (provider.isAuthError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Your session has expired. Please log in again.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      // Navigate to login screen
                      // Navigator.of(context).pushAndRemoveUntil(
                      //   MaterialPageRoute(builder: (context) => LoginScreen()),
                      //   (route) => false,
                      // );
                    });
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CommonTextWidget(
                        title: 'Please give rating*',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              Icons.star,
                              size: 40,
                              color: index < provider.rating
                                  ? cButtonGreen
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              provider.setRating(index);
                            },
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        maxLength: 50,
                        maxLines: 2,
                        onChanged: provider.setReviewTitle,
                        decoration: InputDecoration(
                          labelStyle: GoogleFonts.poppins(),
                          hintStyle: GoogleFonts.poppins(),
                          labelText: 'Review Title*',
                          hintText: 'Max 50 Characters',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        maxLength: 300,
                        maxLines: 4,
                        onChanged: provider.setComment,
                        decoration: InputDecoration(
                          labelStyle: GoogleFonts.poppins(),
                          hintStyle: GoogleFonts.poppins(),
                          labelText: 'Comment*',
                          hintText: 'Max 300 Characters',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const CommonTextWidget(
                        title: 'Will you recommend this product*',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Radio<String>(
                            value: "Yes",
                            groupValue: provider.recommend,
                            activeColor: cButtonGreen,
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              provider.setRecommend(value);
                            },
                          ),
                          const CommonTextWidget(title: 'YES'),
                          const SizedBox(width: 20),
                          Radio<String>(
                            value: "No",
                            groupValue: provider.recommend,
                            activeColor: cButtonGreen,
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              provider.setRecommend(value);
                            },
                          ),
                          const CommonTextWidget(title: 'NO'),
                        ],
                      ),
                      if (provider.errorMessage.isNotEmpty &&
                          !provider.isAuthError)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            provider.errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      sizedBoxHeight70,
                      sizedBoxHeight70,
                      sizedBoxHeight70,
                    ],
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 60,
              color: cWhiteColor,
              child: Consumer<ProductRatingProvider>(
                  builder: (context, provider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 183,
                      height: 48,
                      child: CustomizableBorderColoredButton(
                          title: 'CANCEL',
                          event: () {
                            provider.resetForm();
                            Navigator.pop(context);
                          }),
                    ),
                    SizedBox(
                      width: 183,
                      height: 48,
                      child: provider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : CustomizableButton(
                              title: 'SUBMIT',
                              event: () async {
                                final result =
                                    await provider.submitRating(context);
                                if (result) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                          'Rating submitted successfully!'),
                                      backgroundColor: cButtonGreen,
                                    ),
                                  );
                                  provider.resetForm();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              },
                            ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
