import 'package:biotech_maali/src/payment_and_order/change_address/model/address_model.dart';

import '../../../import.dart';

class AddEditAddressScreen extends StatefulWidget {
  final AddressModel? address;
  final bool? isFromAccount;
  final bool isAddAddress;
  const AddEditAddressScreen(
      {this.address,
      this.isFromAccount,
      required this.isAddAddress,
      super.key});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch addresses when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: CommonTextWidget(
          title: widget.isAddAddress ? 'Add Address' : 'Edit Address',
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Consumer<AddEditAddressProvider>(
            builder: (context, provider, child) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.isFromAccount != true
                            ? const Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      OrderTrackerTimeline(
                                          currentStatus: OrderStatus.address),
                                      sizedBoxHeight10,
                                    ],
                                  ),
                                ),
                              )
                            : sizedBoxHeight10,
                        Card(
                          color: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: provider.firstNameController,
                                  decoration: InputDecoration(
                                    hintText: 'First Name',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.blue),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your first name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: provider.lastNameController,
                                  decoration: InputDecoration(
                                    hintText: 'Last Name',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.blue),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your last name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: provider.addressController,
                                  decoration: InputDecoration(
                                    hintText: 'Address',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.blue),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your address';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: provider.cityController,
                                  decoration: InputDecoration(
                                    hintText: 'City',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.blue),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your city';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: provider.stateController,
                                  decoration: InputDecoration(
                                    hintText: 'State',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.blue),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your state';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: provider.pincodeController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 6,
                                  decoration: InputDecoration(
                                    hintText: 'Pincode',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.blue),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your pincode';
                                    }
                                    if (value.length != 6) {
                                      return 'Please enter a valid 6-digit pincode';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: provider.isHomeAddress,
                                          onChanged: (value) {
                                            provider.toggleIsHomeAddress();
                                          },
                                        ),
                                        const CommonTextWidget(
                                            title: 'Home (All day Delivery)'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                            value: !provider.isHomeAddress,
                                            onChanged: (value) {
                                              provider.toggleIsHomeAddress();
                                            }),
                                        const CommonTextWidget(
                                            title: 'Work (9am - 6pm)'),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        sizedBoxHeight20,
                        sizedBoxHeight20,
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 70,
                color: cWhiteColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 160,
                        height: 48,
                        child: CustomizableBorderColoredButton(
                            title: 'CANCEL', event: () {}),
                      ),
                      SizedBox(
                        width: 160,
                        height: 48,
                        child: provider.isLoading
                            ? const Center(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : CustomizableButton(
                                title: widget.isAddAddress
                                    ? 'ADD ADDRESS'
                                    : 'UPDATE',
                                event: () {
                                  if (_formKey.currentState!.validate()) {
                                    // Additional custom validations if needed
                                    if (provider
                                            .firstNameController.text.isEmpty ||
                                        provider
                                            .lastNameController.text.isEmpty ||
                                        provider
                                            .addressController.text.isEmpty ||
                                        provider.cityController.text.isEmpty ||
                                        provider.stateController.text.isEmpty ||
                                        provider
                                            .pincodeController.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please fill in all required fields')),
                                      );
                                      return;
                                    }

                                    // Validate pincode
                                    if (provider
                                            .pincodeController.text.length !=
                                        6) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please enter a valid 6-digit pincode')),
                                      );
                                      return;
                                    }

                                    // Add or update address
                                    if (widget.isAddAddress) {
                                      provider.addAddress(context);
                                    } else {
                                      provider.updateAddress(
                                          context, widget.address!.id);
                                    }

                                    // Show success message
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   SnackBar(
                                    //     content: Text(widget.isAddAddress
                                    //         ? 'Address Added Successfully'
                                    //         : 'Address Updated Successfully'),
                                    //   ),
                                    // );
                                  }
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
