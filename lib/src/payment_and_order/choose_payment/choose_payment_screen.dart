import 'package:biotech_maali/src/module/account/wallet/wallet_provider.dart';
import 'package:biotech_maali/src/payment_and_order/choose_payment/choose_payment_provider.dart';
import 'package:biotech_maali/src/payment_and_order/choose_payment/widgets/gst_update_popup.dart';
import 'package:biotech_maali/src/payment_and_order/order_summary/model/order_summary_response.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../import.dart';

class PaymentScreen extends StatefulWidget {
  final OrderSummaryResponse orderSummaryResponse;
  const PaymentScreen({required this.orderSummaryResponse, super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _showCODMessage = false;

  @override
  void initState() {
    super.initState();
    // Initialize EditProfileProvider to fetch GST data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditProfileProvider>().fetchProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderDetails = widget.orderSummaryResponse;
    final shippingCharge = context
            .read<OrderSummaryProvider>()
            .orderData
            ?.shippingInfo
            ?.shippingCharge ??
        0.00;
    // orderDetails.data.shippingInfo?.shippingCharge ?? 0.0;

    // Get the selected delivery option from OrderSummaryProvider
    final selectedDeliveryOption =
        context.read<OrderSummaryProvider>().selectedDeliveryOption;
    // If Pick Up Store is selected, shipping charge should be 0
    final displayShippingCharge =
        selectedDeliveryOption == "Pick Up Store" ? 0.0 : shippingCharge;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  const Text(
                    'Select Payment Method',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const OrderTrackerTimeline(currentStatus: OrderStatus.payment),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Price Details
                      _buildPriceRow(
                          'Price (${orderDetails.data.orderItems.length} items)',
                          '₹${orderDetails.data.order.totalPrice.toInt()}'),
                      _buildPriceRow('Discount',
                          '-₹${orderDetails.data.order.totalDiscount.toInt()}',
                          isGreen: true),
                      _buildPriceRow('Coupon Discount',
                          '-₹${orderDetails.data.order.couponDiscount.toInt()}',
                          isGreen: true),
                      _buildPriceRow(
                        'Delivery Charges',
                        displayShippingCharge > 0
                            ? '₹${displayShippingCharge.toInt()}'
                            : 'Free',
                        isGreen: displayShippingCharge == 0,
                      ),
                      // _buildPriceRow('Secured Packaging Fee', ''),

                      const Divider(height: 32),

                      // Total
                      _buildPriceRow(
                        'Total Amount',
                        '₹${orderDetails.data.order.grandTotal.toInt()}',
                        isBold: true,
                      ),

                      // Savings
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'You will save ₹${(orderDetails.data.order.totalDiscount + orderDetails.data.order.couponDiscount).toInt()} on this order',
                          style: TextStyle(
                            color: Colors.green[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // Payment Options
                      const SizedBox(height: 20),

                      // GST Checkbox
                      Consumer2<ChoosePaymentProvider, EditProfileProvider>(
                        builder: (context, choosePaymentProvider,
                            editProfileProvider, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPaymentOption(
                                'Add GST Number',
                                '',
                                isCheckbox: true,
                                isGstCheckbox: true,
                                onGstChanged: (value) {
                                  if (value == true) {
                                    // Check if GST number exists
                                    if (editProfileProvider.hasGstNumber()) {
                                      choosePaymentProvider
                                          .handleGstCheckbox(value!);
                                    } else {
                                      // Show popup to update GST
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const GstUpdatePopup();
                                        },
                                      );
                                    }
                                  } else {
                                    choosePaymentProvider
                                        .handleGstCheckbox(value!);
                                  }
                                },
                                gstCheckboxValue:
                                    choosePaymentProvider.isGstCheckbox,
                              ),
                              // Show GST number when checkbox is checked
                              if (choosePaymentProvider.isGstCheckbox &&
                                  editProfileProvider.hasGstNumber())
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 40, top: 4),
                                  child: Text(
                                    'GST: ${editProfileProvider.gstNumberCheckout.text}',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),

                      Consumer2<WalletProvider, ChoosePaymentProvider>(
                        builder: (context, walletProvider,
                            choosePaymentProvider, child) {
                          // Calculate payable amount after wallet deduction
                          final grandTotal =
                              widget.orderSummaryResponse.data.order.grandTotal;
                          final walletBalance = walletProvider.balance;
                          final isWalletChecked =
                              choosePaymentProvider.isWalletCheckbox;
                          final payableAmount = isWalletChecked
                              ? (grandTotal - walletBalance)
                                  .clamp(0.0, double.infinity)
                              : grandTotal;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPaymentOption(
                                'Use Wallet',
                                walletProvider.balance.toInt().toString(),
                                isCheckbox: true,
                                onWalletChanged: (value) {
                                  if (value == true) {
                                    if (walletProvider.balance == 0.0) {
                                      Fluttertoast.showToast(
                                          msg: "Insufficient wallet balance",
                                          backgroundColor: Colors.red);
                                      return;
                                    }

                                    // Calculate wallet balance after deduction for display
                                    double actualWalletBalance =
                                        walletProvider.balance -
                                            widget.orderSummaryResponse.data
                                                .order.grandTotal;
                                    context
                                        .read<ChoosePaymentProvider>()
                                        .handleWalletBalance(
                                            actualWalletBalance);
                                    context
                                        .read<ChoosePaymentProvider>()
                                        .handleWalletCheckbox(
                                            value!, walletProvider.balance);
                                  } else {
                                    double actualWalletBalance =
                                        walletProvider.balance;
                                    context
                                        .read<ChoosePaymentProvider>()
                                        .handleWalletBalance(
                                            actualWalletBalance);
                                    context
                                        .read<ChoosePaymentProvider>()
                                        .handleWalletCheckbox(
                                            value!, walletProvider.balance);
                                  }
                                },
                              ),
                              // Show payable amount when wallet is checked
                              if (isWalletChecked)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 40, top: 4, bottom: 8),
                                  child: Text(
                                    'Payable Amount: ₹${payableAmount.toInt()}',
                                    style: TextStyle(
                                      color: Colors.green[700],
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      Consumer<ChoosePaymentProvider>(
                        builder: (context, choosePaymentProvider, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPaymentOption(
                                'Razorpay Secure (UPI, Cards, Wallets, NetBanking)',
                                '',
                                showPaymentIcons: true,
                                onChanged: (value) {
                                  choosePaymentProvider
                                      .handleOnlinePaymentOption(value!);
                                },
                                radioValue:
                                    choosePaymentProvider.isOnlineRadioButton,
                                radioGroupValue: true,
                              ),
                              _buildPaymentOption(
                                'Cash on Delivery/Pay on Delivery',
                                '',
                                onChanged: (value) {
                                  // choosePaymentProvider
                                  //     .handleCashOnDeliveryPayment(value!);

                                  setState(() {
                                    _showCODMessage = true;
                                  });

                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    if (mounted) {
                                      setState(() {
                                        _showCODMessage = false;
                                      });
                                    }
                                  });
                                },
                                radioValue:
                                    !choosePaymentProvider.isOnlineRadioButton,
                                radioGroupValue: true,
                                message: _showCODMessage
                                    ? 'Cash on Delivery is not available to this area'
                                    : null,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Buttons
            Container(
              width: double.infinity,
              height: 60,
              color: cWhiteColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 160,
                    height: 48,
                    child: CustomizableBorderColoredButton(
                      title: 'CANCEL',
                      event: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    height: 48,
                    child: CustomizableButton(
                      title: 'PROCEED',
                      event: () async {
                        context
                            .read<ChoosePaymentProvider>()
                            .checkPaymentMethod(
                                widget.orderSummaryResponse, context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount,
      {bool isGreen = false, String? originalPrice, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Row(
            children: [
              if (originalPrice != null)
                Text(
                  originalPrice,
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
              const SizedBox(width: 4),
              Text(
                amount,
                style: TextStyle(
                  color: isGreen ? Colors.green[600] : null,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    String label,
    String amount, {
    bool isCheckbox = false,
    bool isGstCheckbox = false,
    bool showPaymentIcons = false,
    Function(bool?)? onChanged,
    Function(bool?)? onGstChanged,
    Function(bool?)? onWalletChanged,
    bool radioValue = false,
    bool radioGroupValue = false,
    bool? gstCheckboxValue,
    String? message,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (isCheckbox)
            Checkbox(
              value: isGstCheckbox
                  ? (gstCheckboxValue ?? false)
                  : context.watch<ChoosePaymentProvider>().isWalletCheckbox,
              onChanged: isGstCheckbox
                  ? onGstChanged
                  : (onWalletChanged != null)
                      ? onWalletChanged
                      : (value) {
                          if (value == true) {
                            double actualWalletBalance = double.parse(amount) -
                                widget
                                    .orderSummaryResponse.data.order.grandTotal;

                            context
                                .read<ChoosePaymentProvider>()
                                .handleWalletBalance(actualWalletBalance);
                          } else if (value == false) {
                            double actualWalletBalance = double.parse(amount);

                            context
                                .read<ChoosePaymentProvider>()
                                .handleWalletBalance(actualWalletBalance);
                          }
                          context
                              .read<ChoosePaymentProvider>()
                              .handleWalletCheckbox(value!,
                                  context.read<WalletProvider>().balance);
                        },
            )
          else
            Radio(
                value: radioValue,
                groupValue: radioGroupValue,
                onChanged: onChanged),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message != null)
                  AnimatedOpacity(
                    opacity: message.isNotEmpty ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        message,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                else
                  Text(label),
                if (showPaymentIcons)
                  Row(
                    children: [
                      // Payment method icons would go here
                      // You'll need to add actual payment method icons
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/png/payment_icon/upi.png",
                              height: 40,
                              width: 40,
                            ),
                            const SizedBox(width: 8),
                            Image.asset(
                              "assets/png/payment_icon/visa.png",
                              height: 44,
                              width: 44,
                            ),
                            const SizedBox(width: 8),
                            Image.asset(
                              "assets/png/payment_icon/master_card.png",
                              height: 40,
                              width: 40,
                            ),
                            const SizedBox(width: 8),
                            Image.asset(
                              "assets/png/payment_icon/rupay.png",
                              height: 54,
                              width: 54,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (amount.isNotEmpty && !isGstCheckbox)
            context.watch<ChoosePaymentProvider>().isWalletCheckbox
                ? Row(
                    children: [
                      Text(
                        "₹${widget.orderSummaryResponse.data.order.grandTotal.toInt()}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        " - ",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "₹${amount}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        " = ",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "₹${(widget.orderSummaryResponse.data.order.grandTotal - double.parse(amount)).clamp(0.0, double.infinity).toInt()}",
                        style: TextStyle(
                          color: Colors.green[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Text(
                    "₹$amount",
                    style: TextStyle(
                      color: Colors.green[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
        ],
      ),
    );
  }
}
