// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class PaymentService {
//   final String baseUrl = "http://localhost:3000"; // Change to your server's URL
//
//   // Initialize payment by calling the backend
//   Future<Map<String, dynamic>> initializePayment(
//       String itemId, double totalPrice) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/initialize-payment'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'itemId': itemId,
//           'totalPrice': totalPrice,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       } else {
//         throw Exception('Failed to initialize payment');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
//
//   // Complete payment verification
//   Future<Map<String, dynamic>> completePayment(String encodedData) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/complete-payment?data=$encodedData'),
//       );
//
//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       } else {
//         throw Exception('Payment verification failed');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  final String baseUrl;

  PaymentService({required this.baseUrl});

  Future<Map<String, dynamic>> initializePayment(int itemId, double totalPrice) async {
    final url = Uri.parse('$baseUrl/initialize-esewa');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'itemId': itemId,
        'totalPrice': totalPrice,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to initialize payment');
    }
  }
}
