import 'dart:developer';
import 'package:biotech_maali/src/other_modules/contact_us/model/cantact_us_model.dart';
import '../../../import.dart';

class ContactRepository {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> submitInquiry(ContactInquiry inquiry) async {
    try {
      log("Request URL: ${EndUrl.addContactUs}");
      final requestData = {
        "name": inquiry.name,
        "mobile": inquiry.contactNumber,
        "email": inquiry.email,
        "message": inquiry.message
      };
      log("Request Data: $requestData");

      final response = await _dio.post(
        EndUrl.addContactUs,
        data: requestData,
        options: Options(
          validateStatus: (status) => true,
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      log("Response Status Code: ${response.statusCode}");
      log("Response Data: ${response.data}");

      if (response.statusCode == 400) {
        return {
          'success': false,
          'message': response.data['message'],
          'errors': response.data['errors']
        };
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': 'Message sent successfully!'};
      }

      return {
        'success': false,
        'message': 'Something went wrong. Please try again.'
      };
    } catch (e) {
      log('Error: $e');
      return {'success': false, 'message': 'Failed to connect to server'};
    }
  }
}
