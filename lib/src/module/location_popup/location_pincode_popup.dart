import 'package:biotech_maali/src/module/location_popup/location_pincode_provider.dart';
import 'package:biotech_maali/src/payment_and_order/change_address/model/address_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shimmer/shimmer.dart';

import '../../../import.dart';

class LocationPincodePopup extends StatefulWidget {
  final List<AddressModel> savedAddresses;

  const LocationPincodePopup({
    super.key,
    this.savedAddresses = const [],
  });

  @override
  State<LocationPincodePopup> createState() => _LocationPincodePopupState();
}

class _LocationPincodePopupState extends State<LocationPincodePopup> {
  // final TextEditingController _landmarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final popupProvider = context.read<LocationPincodeProvider>();

    popupProvider.checkUserLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Consumer<LocationPincodeProvider>(
            builder: (context, provider, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Close button

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SvgPicture.asset("assets/svg/location_popup_image.svg"),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'For a seamless shopping!',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Conditional Login Button
                  if (!provider.isLogin)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF89B449),
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MobileNumberScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Pincode Checking Section
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: provider.pincodeController,
                          decoration: const InputDecoration(
                            labelText: 'Change Pincode',
                            hintText: 'Check Delivery Info',
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 45,
                        width: MediaQuery.of(context).size.width *
                            0.25, // Responsive width
                        child: ElevatedButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString("user_pincode",
                                provider.pincodeController.text);
                            await context
                                .read<HomeProvider>()
                                .getLocationPincode();
                            Fluttertoast.showToast(
                                msg: "Location updated successfully",
                                backgroundColor: cButtonGreen);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                              side: BorderSide(color: cBottomNav, width: 1),
                            ),
                            backgroundColor: Colors.white,
                            foregroundColor: cBottomNav,
                          ),
                          child: const Text('Change'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Get Your Location Button
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: provider.isLoading
                        ? null
                        : () {
                            provider.getCurrentLocation(context);
                          },
                    child: provider.isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Get Your Location'),
                  ),

                  const SizedBox(height: 20),

                  // Saved Addresses Section
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget buildShimmerEffect() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 20,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    ),
  );
}
