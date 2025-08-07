import '../../../../import.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  // final _feedbackController = TextEditingController();
  // bool _termsAndConditionsChecked = false;
  // bool _giftCardBalanceChecked = false;
  // bool _pastOrdersChecked = false;

  // @override
  // void dispose() {
  //   _feedbackController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final deleteAccountProvider = context.read<DeleteAccountProvider>();
    final deleteAccountProviderWatch = context.watch<DeleteAccountProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const CommonTextWidget(
          title: 'Delete Account',
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWarningContainer(),
              const SizedBox(height: 20),
              _buildTermsAndConditionsCheckbox(
                  deleteAccountProvider, deleteAccountProviderWatch),
              const SizedBox(height: 8),
              _buildGiftCardBalanceCheckbox(
                  deleteAccountProvider, deleteAccountProviderWatch),
              const SizedBox(height: 8),
              _buildPastOrdersCheckbox(
                  deleteAccountProvider, deleteAccountProviderWatch),
              const SizedBox(height: 20),
              _buildFeedbackTextField(deleteAccountProvider),
              const SizedBox(height: 20),
              _buildDeleteAccountButton(deleteAccountProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarningContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cLightPink,
        border: Border.all(color: cDarkerRed),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonTextWidget(
            title: 'Deleting account is a permanent action',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 8),
          CommonTextWidget(
            title:
                'Please be advised that the deletion of your account is a permanent action. Once your account is deleted, you will lose all data, including order history, and it cannot be restored under any circumstances.',
            textAlign: TextAlign.justify,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditionsCheckbox(
      DeleteAccountProvider provider, DeleteAccountProvider providerWatch) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      title: const CommonTextWidget(
        title: 'I have read and agreed to the Terms and Conditions.',
        fontSize: 13,
        textAlign: TextAlign.justify,
      ),
      value: providerWatch.termsAndConditionsChecked,
      onChanged: (bool? value) {
        if (value == null) {
          return;
        }
        provider.setTermsAndConditionsChecked(value);
      },
    );
  }

  Widget _buildGiftCardBalanceCheckbox(
      DeleteAccountProvider provider, DeleteAccountProvider providerWatch) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      title: const CommonTextWidget(
        title:
            'I acknowledge that I do not have any Gift Card or SuperCoin balance in my account, or I am willing to forfeit any such balance available in my account.',
        fontSize: 13,
        textAlign: TextAlign.justify,
      ),
      value: providerWatch.giftCardBalanceChecked,
      onChanged: (bool? value) {
        if (value == null) {
          return;
        }
        provider.setGiftCardBalanceChecked(value);
      },
    );
  }

  Widget _buildPastOrdersCheckbox(
      DeleteAccountProvider provider, DeleteAccountProvider providerWatch) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      title: const CommonTextWidget(
        title:
            'I acknowledge that I will not be able to return / replace or seek any service regarding any past orders & transactions.',
        fontSize: 14,
        textAlign: TextAlign.justify,
      ),
      value: providerWatch.pastOrdersChecked,
      onChanged: (bool? value) {
        if (value == null) {
          return;
        }
        provider.setPastOrdersChecked(value);
      },
    );
  }

  Widget _buildFeedbackTextField(DeleteAccountProvider provider) {
    return TextField(
      controller: provider.feedBackController,
      decoration: InputDecoration(
        hintStyle: GoogleFonts.poppins(fontSize: 12, color: textGreyColor),
        hintText: 'Your Feedback Will Help Us Improve',
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      maxLines: 4,
    );
  }

  Widget _buildDeleteAccountButton(DeleteAccountProvider provider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _areTermsAndConditionsAccepted(provider)
            ? _showDeleteConfirmationDialog
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red, // Button color
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'DELETE ACCOUNT',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  bool _areTermsAndConditionsAccepted(DeleteAccountProvider provider) {
    return provider.termsAndConditionsChecked &&
        provider.giftCardBalanceChecked &&
        provider.pastOrdersChecked;
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const CommonTextWidget(
            title: "Are you sure?",
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.justify,
          ),
          content: const CommonTextWidget(
            title:
                "Do you really want to delete your account? This action cannot be undone.",
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.justify,
          ),
          actions: [
            TextButton(
              child: const CommonTextWidget(
                title: "Cancel",
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.justify,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const CommonTextWidget(
                title: "Delete",
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.justify,
              ),
              onPressed: () {
                // Place your delete account code here
                context.read<BottomNavProvider>().updateIndex(0);
                Navigator.of(context).pop(); // Close the dialog
                _showSuccessPopup();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        Future.delayed(const Duration(seconds: 3), () {
          if (dialogContext.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavWidget()),
              (Route<dynamic> route) => false,
            );
          }
        });

        return const SuccessPopupDelete();
      },
    );
  }
}
