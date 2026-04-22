import 'package:biotech_maali/src/payment_and_order/change_address/widgets/address_tile_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'change_address_provider.dart';
import 'model/address_model.dart';

import '../../../import.dart';

class ChangeAddressScreen extends StatefulWidget {
  const ChangeAddressScreen({super.key});

  @override
  State<ChangeAddressScreen> createState() => _ChangeAddressScreenState();
}

class _ChangeAddressScreenState extends State<ChangeAddressScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch addresses when the screen is shown
    Provider.of<ChangeAddressProvider>(context, listen: false)
        .fetchAllAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF3B5226),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset(
          'assets/png/Gidan Logo.png',
          height: 35,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Consumer<ChangeAddressProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                // Premium Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                  decoration: const BoxDecoration(
                    color: Color(0xFF3B5226),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          children: [
                            const TextSpan(text: 'Shipping '),
                            TextSpan(
                              text: 'Address',
                              style: GoogleFonts.playfairDisplay(
                                fontStyle: FontStyle.italic,
                                color: const Color(0xFFA6C13C),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Select where you want your green companions to be delivered.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Add New Address Action
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddEditAddressScreen(
                                    isAddAddress: true,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B5226).withOpacity(0.05),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFF3B5226).withOpacity(0.1)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF3B5226),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    "Add New Address",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: const Color(0xFF1B3012),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 32),
                          
                          Text(
                            "SAVED ADDRESSES",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1B3012).withOpacity(0.5),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: provider.addresses.length,
                            itemBuilder: (context, index) {
                              AddressModel address = provider.addresses[index];
                              final isSelected = provider.selectedAddressIndex == index;
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF1B3012) : Colors.grey.shade200,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () => provider.setSelectedAddressIndex(index),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Radio<int>(
                                          value: index,
                                          groupValue: provider.selectedAddressIndex,
                                          activeColor: const Color(0xFF1B3012),
                                          onChanged: (value) {
                                            provider.setSelectedAddressIndex(value!);
                                          },
                                        ),
                                        Expanded(
                                          child: AddressTileWidget(
                                            address: address,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomSheet: Consumer<ChangeAddressProvider>(
        builder: (context, provider, child) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      'CANCEL',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (provider.selectedAddressIndex != null) {
                        int addressId = provider.addresses[provider.selectedAddressIndex!].id;
                        bool result = await provider.changeDeliveryAddress(addressId);
                        if (result) {
                          context.read<OrderSummaryProvider>().fetchAllAddress();
                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(msg: 'Error changing address');
                        }
                      } else {
                        Fluttertoast.showToast(msg: 'Please select an address');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B3012),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Text(
                      'DELIVER HERE',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
