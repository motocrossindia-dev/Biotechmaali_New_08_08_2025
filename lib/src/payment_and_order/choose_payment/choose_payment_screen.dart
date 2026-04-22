import 'package:biotech_maali/src/module/account/wallet/wallet_provider.dart';
import 'package:biotech_maali/src/payment_and_order/choose_payment/choose_payment_provider.dart';
import 'package:biotech_maali/src/payment_and_order/choose_payment/widgets/gst_update_popup.dart';
import 'package:biotech_maali/src/payment_and_order/order_summary/model/order_summary_response.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:biotech_maali/core/services/analytics_service.dart';
import 'package:biotech_maali/core/services/analytics_helper.dart';

import '../../../import.dart';

class PaymentScreen extends StatefulWidget {
  final OrderSummaryResponse orderSummaryResponse;
  const PaymentScreen({required this.orderSummaryResponse, super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _showCODMessage = false;

  static const Color _primaryGreen = Color(0xFF3B5226);
  static const Color _darkGreen = Color(0xFF1B3012);
  static const Color _bgColor = Color(0xFFF9FBF7);

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView(screenName: ScreenNames.choosePayment);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditProfileProvider>().fetchProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderDetails = widget.orderSummaryResponse;
    final selectedDeliveryOption =
        context.read<OrderSummaryProvider>().selectedDeliveryOption;

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: _darkGreen, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Payment',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _darkGreen,
              ),
            ),
            Text(
              'Choose your preferred method',
              style:
                  GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Order tracker
            Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: const OrderTrackerTimeline(
                  currentStatus: OrderStatus.payment),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Total Summary card
                    _buildCard(
                      icon: Icons.receipt_long_outlined,
                      title: 'Order Summary',
                      child: Consumer<OrderSummaryProvider>(
                        builder: (context, orderSummaryProvider, child) {
                          final orderData = orderSummaryProvider.orderData;
                          final order = orderData?.order;
                          final shippingInfo = orderData?.shippingInfo;

                          final isFreeShippingFromApi =
                              shippingInfo?.freeShipping ?? false;
                          final isPickUpStore =
                              selectedDeliveryOption == "Pick Up Store";
                          final isFreeDelivery =
                              isPickUpStore || isFreeShippingFromApi;

                          final actualShippingCharge =
                              shippingInfo?.shippingCharge ??
                                  order?.shippingCharge ??
                                  0.0;
                          final finalDisplayShippingCharge =
                              isFreeDelivery ? 0.0 : actualShippingCharge;

                          final productGst5 = order?.gstAmount5 ?? 0.0;
                          final productGst18 = order?.gstAmount18 ?? 0.0;
                          final totalProductGst = productGst5 + productGst18;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPriceRow(
                                'Price (${orderDetails.data.orderItems.length} items)',
                                '₹${orderDetails.data.order.taxableValue.toStringAsFixed(2)}',
                              ),
                              _buildPriceRow(
                                'Discount',
                                '-₹${orderDetails.data.order.totalDiscount.toStringAsFixed(2)}',
                                isGreen: orderDetails.data.order.totalDiscount > 0,
                              ),
                              if (orderDetails.data.order.couponDiscount > 0)
                                _buildCouponRow(
                                  orderData?.couponCode ?? 'Coupon Applied',
                                  '-₹${orderDetails.data.order.couponDiscount.toStringAsFixed(2)}',
                                ),
                              _buildPriceRow(
                                'Delivery Charges',
                                finalDisplayShippingCharge > 0
                                    ? '₹${finalDisplayShippingCharge.toStringAsFixed(2)}'
                                    : 'Free',
                                isGreen: finalDisplayShippingCharge == 0,
                              ),
                              Builder(builder: (context) {
                                final totalGst = orderDetails
                                    .data.order.gstSummary.values
                                    .fold<double>(0.0, (a, b) => a + b);
                                if (totalGst > 0) {
                                  return _buildPriceRow(
                                      'GST', '₹${totalGst.toStringAsFixed(2)}');
                                } else if (totalProductGst > 0) {
                                  return _buildPriceRow('GST',
                                      '₹${totalProductGst.toStringAsFixed(2)}');
                                }
                                return const SizedBox.shrink();
                              }),
                              Divider(
                                  height: 28, color: Colors.grey.shade100),
                              Builder(builder: (context) {
                                final shippingInGrandTotal =
                                    shippingInfo?.shippingCharge ??
                                        order?.shippingCharge ??
                                        0.0;
                                final calculatedTotal = isPickUpStore
                                    ? orderDetails.data.order.grandTotal -
                                        shippingInGrandTotal
                                    : orderDetails.data.order.grandTotal;

                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total Amount',
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: _darkGreen,
                                      ),
                                    ),
                                    Text(
                                      '₹${calculatedTotal.toStringAsFixed(2)}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: _primaryGreen,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              const SizedBox(height: 8),
                              // Savings banner
                              if ((orderDetails.data.order.totalDiscount +
                                      orderDetails.data.order.couponDiscount) >
                                  0)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.green.shade100),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.savings_outlined,
                                          size: 16, color: Colors.green),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'You save ₹${(orderDetails.data.order.totalDiscount + orderDetails.data.order.couponDiscount).toStringAsFixed(2)} on this order!',
                                          style: GoogleFonts.poppins(
                                            color: Colors.green.shade700,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Payment Options card
                    _buildCard(
                      icon: Icons.payment_outlined,
                      title: 'Payment Method',
                      child: Column(
                        children: [
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
                                        if (editProfileProvider
                                            .hasGstNumber()) {
                                          choosePaymentProvider
                                              .handleGstCheckbox(value!);
                                        } else {
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
                                  if (choosePaymentProvider.isGstCheckbox &&
                                      editProfileProvider.hasGstNumber())
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 48, top: 4, bottom: 8),
                                      child: Text(
                                        'GST: ${editProfileProvider.gstNumberCheckout.text}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),

                          Divider(height: 20, color: Colors.grey.shade100),

                          // Wallet
                          Consumer2<WalletProvider, ChoosePaymentProvider>(
                            builder: (context, walletProvider,
                                choosePaymentProvider, child) {
                              final grandTotal = widget
                                  .orderSummaryResponse.data.order.grandTotal;
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
                                              msg:
                                                  "Insufficient wallet balance",
                                              backgroundColor: Colors.red);
                                          return;
                                        }
                                        double actualWalletBalance =
                                            walletProvider.balance -
                                                widget.orderSummaryResponse
                                                    .data.order.grandTotal;
                                        context
                                            .read<ChoosePaymentProvider>()
                                            .handleWalletBalance(
                                                actualWalletBalance);
                                        context
                                            .read<ChoosePaymentProvider>()
                                            .handleWalletCheckbox(
                                                value!,
                                                walletProvider.balance);
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
                                                value!,
                                                walletProvider.balance);
                                      }
                                    },
                                  ),
                                  if (isWalletChecked)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 48, top: 4, bottom: 8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Payable Amount: ₹${payableAmount.toInt()}',
                                          style: GoogleFonts.poppins(
                                            color: Colors.green.shade700,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),

                          Divider(height: 20, color: Colors.grey.shade100),

                          // Online / COD
                          Consumer<ChoosePaymentProvider>(
                            builder: (context, choosePaymentProvider, child) {
                              return Column(
                                children: [
                                  _buildPaymentOption(
                                    'Razorpay Secure (UPI, Cards, Wallets, NetBanking)',
                                    '',
                                    showPaymentIcons: true,
                                    onChanged: (value) {
                                      choosePaymentProvider
                                          .handleOnlinePaymentOption(value!);
                                    },
                                    radioValue: choosePaymentProvider
                                        .isOnlineRadioButton,
                                    radioGroupValue: true,
                                  ),
                                  const SizedBox(height: 8),
                                  _buildPaymentOption(
                                    'Cash on Delivery / Pay on Delivery',
                                    '',
                                    onChanged: (value) {
                                      setState(() {
                                        _showCODMessage = true;
                                      });
                                      Future.delayed(
                                          const Duration(seconds: 2), () {
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
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            // Bottom Buttons
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: _primaryGreen),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'CANCEL',
                        style: GoogleFonts.poppins(
                          color: _primaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final isPickUpStore = context
                                .read<OrderSummaryProvider>()
                                .selectedDeliveryOption ==
                            "Pick Up Store";
                        context.read<ChoosePaymentProvider>().checkPaymentMethod(
                              widget.orderSummaryResponse,
                              context,
                              isPickUpStore: isPickUpStore,
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock_outline, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'PROCEED',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B5226).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: const Color(0xFF3B5226)),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1B3012),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount,
      {bool isGreen = false, String? originalPrice, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Row(
            children: [
              if (originalPrice != null) ...[
                Text(
                  originalPrice,
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4),
              ],
              Text(
                amount,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: isGreen ? Colors.green.shade700 : const Color(0xFF1B3012),
                  fontWeight:
                      isBold ? FontWeight.bold : FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCouponRow(String couponCode, String discountValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.local_offer, size: 14, color: Colors.green),
              const SizedBox(width: 6),
              Text(
                'Coupon ($couponCode)',
                style: GoogleFonts.poppins(
                    fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
          Text(
            discountValue,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.green.shade700,
            ),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isCheckbox)
            Transform.scale(
              scale: 1.1,
              child: Checkbox(
                value: isGstCheckbox
                    ? (gstCheckboxValue ?? false)
                    : context.watch<ChoosePaymentProvider>().isWalletCheckbox,
                onChanged: isGstCheckbox
                    ? onGstChanged
                    : (onWalletChanged != null)
                        ? onWalletChanged
                        : (value) {
                            if (value == true) {
                              double actualWalletBalance =
                                  double.parse(amount) -
                                      widget.orderSummaryResponse.data.order
                                          .grandTotal;
                              context
                                  .read<ChoosePaymentProvider>()
                                  .handleWalletBalance(actualWalletBalance);
                            } else if (value == false) {
                              double actualWalletBalance =
                                  double.parse(amount);
                              context
                                  .read<ChoosePaymentProvider>()
                                  .handleWalletBalance(actualWalletBalance);
                            }
                            context
                                .read<ChoosePaymentProvider>()
                                .handleWalletCheckbox(value!,
                                    context.read<WalletProvider>().balance);
                          },
                activeColor: const Color(0xFF3B5226),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
            )
          else
            Radio(
              value: radioValue,
              groupValue: radioGroupValue,
              onChanged: onChanged,
              activeColor: const Color(0xFF3B5226),
            ),
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
                          vertical: 8, horizontal: 12),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade100),
                      ),
                      child: Text(
                        message,
                        style: GoogleFonts.poppins(
                          color: Colors.red.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                else
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF1B3012),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (showPaymentIcons)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Image.asset("assets/png/payment_icon/upi.png",
                            height: 36, width: 36),
                        const SizedBox(width: 6),
                        Image.asset("assets/png/payment_icon/visa.png",
                            height: 38, width: 38),
                        const SizedBox(width: 6),
                        Image.asset(
                            "assets/png/payment_icon/master_card.png",
                            height: 36,
                            width: 36),
                        const SizedBox(width: 6),
                        Image.asset("assets/png/payment_icon/rupay.png",
                            height: 48, width: 48),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (amount.isNotEmpty && !isGstCheckbox)
            context.watch<ChoosePaymentProvider>().isWalletCheckbox
                ? Row(
                    children: [
                      Text(
                        '₹${widget.orderSummaryResponse.data.order.grandTotal.toInt()}',
                        style: GoogleFonts.poppins(
                            color: Colors.grey.shade500, fontSize: 12),
                      ),
                      Text(' - ',
                          style: GoogleFonts.poppins(
                              color: Colors.grey.shade500, fontSize: 12)),
                      Text(
                        '₹$amount',
                        style: GoogleFonts.poppins(
                            color: Colors.grey.shade500, fontSize: 12),
                      ),
                      Text(' = ',
                          style: GoogleFonts.poppins(
                              color: Colors.grey.shade500, fontSize: 12)),
                      Text(
                        '₹${(widget.orderSummaryResponse.data.order.grandTotal - double.parse(amount)).clamp(0.0, double.infinity).toInt()}',
                        style: GoogleFonts.poppins(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  )
                : Text(
                    '₹$amount',
                    style: GoogleFonts.poppins(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
        ],
      ),
    );
  }
}
