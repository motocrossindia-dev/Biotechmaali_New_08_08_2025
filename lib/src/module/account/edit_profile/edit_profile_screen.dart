import 'package:biotech_maali/src/module/account/edit_profile/edit_profile_shimmer.dart';

import '../../../../../import.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  final bool? isPlaceOrder;
  const EditProfileScreen({this.isPlaceOrder, super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditProfileProvider>().fetchProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final editProfileProvider = context.watch<EditProfileProvider>();

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const CommonTextWidget(
          title: 'User Profile',
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        actions: [
          IconButton(
            icon: Icon(
              editProfileProvider.isEditing ? Icons.close : Icons.edit,
              size: 30,
            ),
            onPressed: () {
              editProfileProvider.toggleEditMode();
            },
          ),
        ],
      ),
      body: editProfileProvider.isLoading
          ? const Center(child: EditProfileShimmer())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: const Border(
                        bottom: BorderSide(style: BorderStyle.none),
                      ),
                      color: cWhiteColor,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            EditProfileTextForm(
                              controller: editProfileProvider.firstName,
                              hintText:
                                  editProfileProvider.firstName.text.isEmpty
                                      ? 'First Name'
                                      : editProfileProvider.firstName.text,
                              labelText: 'First Name',
                              readOnly: !editProfileProvider.isEditing,
                            ),
                            sizedBoxHeight20,
                            EditProfileTextForm(
                              controller: editProfileProvider.lastName,
                              hintText:
                                  editProfileProvider.lastName.text.isEmpty
                                      ? 'Last Name'
                                      : editProfileProvider.lastName.text,
                              labelText: 'Last Name',
                              readOnly: !editProfileProvider.isEditing,
                            ),
                            sizedBoxHeight20,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonTextWidget(
                                  title: "Your Gender*",
                                  fontSize: 12,
                                  color: cBorderGrey,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    RadioOptionWidget(
                                      label: 'Male',
                                      value: 'Male',
                                      groupValue:
                                          editProfileProvider.selectedGender,
                                      onChanged: editProfileProvider.isEditing
                                          ? (value) {
                                              editProfileProvider
                                                  .selectGender(value!);
                                            }
                                          : null,
                                    ),
                                    RadioOptionWidget(
                                      label: 'Female',
                                      value: 'Female',
                                      groupValue:
                                          editProfileProvider.selectedGender,
                                      onChanged: editProfileProvider.isEditing
                                          ? (value) {
                                              editProfileProvider
                                                  .selectGender(value!);
                                            }
                                          : null,
                                    ),
                                    RadioOptionWidget(
                                      label: 'Others',
                                      value: 'Others',
                                      groupValue:
                                          editProfileProvider.selectedGender,
                                      onChanged: editProfileProvider.isEditing
                                          ? (value) {
                                              editProfileProvider
                                                  .selectGender(value!);
                                            }
                                          : null,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            sizedBoxHeight20,
                            EditProfileTextForm(
                              controller: editProfileProvider.emailAddress,
                              hintText:
                                  editProfileProvider.emailAddress.text.isEmpty
                                      ? 'Email Address'
                                      : editProfileProvider.emailAddress.text,
                              labelText: 'Email Address',
                              keyboardType: TextInputType.emailAddress,
                              readOnly: !editProfileProvider.isEditing,
                            ),
                            sizedBoxHeight20,
                            EditProfileTextForm(
                              controller: editProfileProvider.mobileNumber,
                              hintText:
                                  editProfileProvider.mobileNumber.text.isEmpty
                                      ? 'Mobile Number'
                                      : editProfileProvider.mobileNumber.text,
                              labelText: 'Mobile Number',
                              keyboardType: TextInputType.phone,
                              readOnly: true,
                            ),
                            sizedBoxHeight20,
                            EditProfileTextForm(
                              controller: editProfileProvider.dateOfBirth,
                              hintText:
                                  editProfileProvider.dateOfBirth.text.isEmpty
                                      ? 'Date of Birth'
                                      : editProfileProvider.dateOfBirth.text,
                              labelText: 'Date of Birth',
                              onTap: editProfileProvider.isEditing
                                  ? () async {
                                      final DateTime? picked =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: editProfileProvider
                                                .dateOfBirth.text.isNotEmpty
                                            ? DateTime.parse(editProfileProvider
                                                .dateOfBirth.text)
                                            : DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now(),
                                      );
                                      if (picked != null) {
                                        editProfileProvider.dateOfBirth.text =
                                            DateFormat('yyyy-MM-dd')
                                                .format(picked);
                                      }
                                    }
                                  : null,
                              readOnly: !editProfileProvider.isEditing,
                            ),
                            sizedBoxHeight20,
                            EditProfileTextForm(
                              controller: editProfileProvider.gstNumber,
                              hintText:
                                  editProfileProvider.gstNumber.text.isEmpty
                                      ? 'GST Number'
                                      : editProfileProvider.gstNumber.text,
                              labelText: 'GST Number',
                              keyboardType: TextInputType.text,
                              readOnly: !editProfileProvider.isEditing,
                              maxLength: 15,
                            ),
                            if (editProfileProvider.isEditing) ...[
                              sizedBoxHeight20,
                              CommonButtonWidget(
                                title: 'SAVE',
                                event: () async {
                                  final success =
                                      await editProfileProvider.updateProfile(
                                          widget.isPlaceOrder, context);
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Profile Updated Successfully')),
                                    );
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Profile Update Failed')),
                                    );
                                  }
                                },
                              )
                            ]
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: MaterialButton(
                        color: cScaffoldBackground,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DeleteAccountScreen(),
                            ),
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        child: CommonTextWidget(
                          title: 'DELETE ACCOUNT',
                          fontWeight: FontWeight.w500,
                          color: cButtonRed,
                          fontSize: 18,
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
