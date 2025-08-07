import '../../../../import.dart';

class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const CommonTextWidget(
          title: 'Track Order',
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizedBoxHeight30,
            // SVG Image
            SvgPicture.asset(
              'assets/svg/images/track_order_image.svg', // path to your SVG file
              height: 150,
            ),
            const SizedBox(height: 20),

            // Text Widget for Order ID/Tracking Number label
            CommonTextWidget(
              title: "Order ID/Tracking Number",
              color: cButtonGreen,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Input field for entering Order ID or Tracking Number
            TextFormField(
              decoration: InputDecoration(
                hintText: "Enter order ID or Tracking Number",
                hintStyle: TextStyle(color: Colors.grey[600]),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                      color: Colors.grey), // Default border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:  BorderSide(
                      color: cButtonGreen, width: 2.0), // Focused border color
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Track Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Track button action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: cButtonGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  "TRACK",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
