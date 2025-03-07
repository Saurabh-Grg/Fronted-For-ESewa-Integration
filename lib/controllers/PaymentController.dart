// import 'dart:convert';
//
// import 'package:get/get.dart';
// import '../screens/PurchasedItemDetails.dart';
// import '../services/PaymentService.dart';
// import 'package:http/http.dart' as http;
//
// class PaymentController extends GetxController {
//   final PaymentService paymentService;
//   var isLoading = false.obs;
//   var paymentData = {}.obs; // Store payment response data
//   var purchasedItemData = {}.obs; // Store purchased item data
//
//   PaymentController({required this.paymentService});
//
//
//   Future<void> buyItem(int itemId, double totalPrice) async {
//     isLoading(true);
//     try {
//       final data = await paymentService.initializePayment(itemId, totalPrice);
//       print("Received Data: $data");  // Add this line to log the response
//       paymentData.value = data['payment']; // Store payment data
//       purchasedItemData.value = data['purchasedItemData']; // Store purchased item data
//       // Navigate to the purchased item details page
//       Get.to(() => PurchasedItemDetails());
//     } catch (e) {
//       // Handle error
//       print('Error initializing payment: $e');
//     } finally {
//       isLoading(false);
//     }
//   }
//
//
//   Future<void> initiateEsewaPayment(double amount, String transactionUuid, String signature) async {
//     // eSewa API endpoint
//     String url = "https://rc-epay.esewa.com.np/api/epay/main/v2/form";
//
//     print("🔹 Initiating eSewa Payment...");
//     print("🔹 Amount: $amount");
//     print("🔹 Transaction UUID: $transactionUuid");
//     print("🔹 Signature: $signature");
//
//     // Prepare the form data to send with the POST request
//     final Map<String, String> formData = {
//       'amount': amount.toString(),
//       'tax_amount': '0', // Adjust if needed
//       'total_amount': amount.toString(),
//       'transaction_uuid': transactionUuid,
//       'product_code': 'EPAYTEST', // Replace with your actual product code
//       'product_service_charge': '0',
//       'product_delivery_charge': '0',
//       'success_url': 'http://localhost:3000/complete-payment', // Update with actual success URL
//       'failure_url': 'https://developer.esewa.com.np/failure', // Update with actual failure URL
//       'signed_field_names': 'total_amount,transaction_uuid,product_code',
//       'signature': signature, // Signature should be generated before this step
//       'secret': '8gBm/:&EnhH.1/q', // Replace with your actual secret key (should not be hardcoded)
//     };
//
//     print("🔹 Form Data Sent:");
//     formData.forEach((key, value) => print("  - $key: $value"));
//
//     try {
//       // Send POST request
//       var response = await http.post(
//         Uri.parse(url),
//         headers: {
//           "Content-Type": "application/x-www-form-urlencoded", // Important!
//         },
//         body: formData, // Convert the map to x-www-form-urlencoded format
//       );
//
//       print("\n🔹 Response Details:");
//       print("🔹 Status Code: ${response.statusCode}");
//       print("🔹 Headers: ${response.headers}");
//       print("🔹 Body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         print("✅ Payment request sent successfully!");
//       } else {
//         print("❌ Error: Failed to send payment request.");
//       }
//     } catch (e) {
//       print("❌ Exception Occurred: $e");
//     }
//   }
// }


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/ItemScreen.dart';
import '../screens/PurchasedItemDetails.dart';
import '../services/PaymentService.dart';
import 'package:http/http.dart' as http;

class PaymentController extends GetxController {
  final PaymentService paymentService;
  var isLoading = false.obs;
  var paymentData = {}.obs; // Store payment response data
  var purchasedItemData = {}.obs; // Store purchased item data

  PaymentController({required this.paymentService});

  Future<void> buyItem(int itemId, double totalPrice) async {
    isLoading(true);
    try {
      final data = await paymentService.initializePayment(itemId, totalPrice);
      print("Received Data: $data");  // Add this line to log the response
      paymentData.value = data['payment']; // Store payment data
      purchasedItemData.value = data['purchasedItemData']; // Store purchased item data
      // Navigate to the purchased item details page
      Get.to(() => PurchasedItemDetails());
    } catch (e) {
      // Handle error
      print('Error initializing payment: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> initiateEsewaPayment(double amount, String transactionUuid, String signature) async {
    // eSewa API endpoint
    String url = "https://rc-epay.esewa.com.np/api/epay/main/v2/form";

    print("🔹 Initiating eSewa Payment...");
    print("🔹 Amount: $amount");
    print("🔹 Transaction UUID: $transactionUuid");
    print("🔹 Signature: $signature");

    // Convert numeric values to integers
    int totalAmount = amount.toInt();
    int taxAmount = 0;
    int serviceCharge = 0;
    int deliveryCharge = 0;

    // Prepare the form data to send with the POST request
    final Map<String, String> formData = {
      'amount': totalAmount.toString(),
      'tax_amount': taxAmount.toString(),
      'total_amount': totalAmount.toString(),
      'transaction_uuid': transactionUuid,
      'product_code': 'EPAYTEST', // Replace with your actual product code
      'product_service_charge': serviceCharge.toString(),
      'product_delivery_charge': deliveryCharge.toString(),
      'success_url': 'http://localhost:3000/complete-payment', // Update with actual success URL
      'failure_url': 'https://developer.esewa.com.np/failure', // Update with actual failure URL
      'signed_field_names': 'total_amount,transaction_uuid,product_code',
      'signature': signature, // Signature should be generated before this step
    };

    print("🔹 Form Data Sent:");
    formData.forEach((key, value) => print("  - $key: $value"));

    try {
      // Send POST request
      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: formData.map((key, value) => MapEntry(key, value.toString())), // Convert all values to strings
      );
      print("\n🔹 Response Details:");
      print("🔹 Status Code: ${response.statusCode}");
      print("🔹 Headers: ${response.headers}");
      print("🔹 Body: ${response.body}");

      if (response.statusCode == 302) {
        // Extract redirection URL
        String? redirectUrl = response.headers['location'];
        if (redirectUrl != null) {
          print("🔹 Redirecting to eSewa: $redirectUrl");
          await launchUrl(Uri.parse(redirectUrl)); // Open eSewa in a browser
        } else {
          print("❌ Error: No redirection URL found.");
        }
      } else {
        print("❌ Error: Unexpected response status.");
      }
    } catch (e) {
      print("❌ Exception Occurred: $e");
    }
  }

  // Future<void> completeEsewaPayment(String encodedData) async {
  //   isLoading(true);
  //   try {
  //     String url = "http://localhost:3000/complete-payment?data=$encodedData"; // Backend verification API
  //     print("🔹 Verifying eSewa Payment at: $url");
  //
  //     var response = await http.get(Uri.parse(url));
  //     var responseData = jsonDecode(response.body);
  //
  //     if (responseData['success']) {
  //       print("✅ Payment Verification Successful");
  //       Get.to(() => PurchasedItemDetails());
  //     } else {
  //       print("❌ Payment Verification Failed: ${responseData['message']}");
  //     }
  //   } catch (e) {
  //     print("❌ Error Completing Payment: $e");
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  Future<void> completeEsewaPayment(String encodedData) async {
    isLoading(true);
    try {
      String url = "http://localhost:3000/complete-payment?data=$encodedData"; // Backend verification API
      print("🔹 Verifying eSewa Payment at: $url");

      var response = await http.get(Uri.parse(url));
      print("🔹 Response Status Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      var responseData = jsonDecode(response.body);

      if (responseData['success']) {
        print("✅ Payment Verification Successful");

        // Debugging log for navigation
        print("🔹 Navigating back to ItemScreen...");

        // Show success message in Snackbar
        Get.snackbar(
          "Payment Successful",
          "Your payment has been verified successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );

        // Navigate back to the item screen
        Get.offAll(() => ItemScreen()); // Replace with your actual item screen

        // Confirm that navigation is triggered
        print("🔹 Navigation to ItemScreen triggered.");
      } else {
        print("❌ Payment Verification Failed: ${responseData['message']}");

        // Show failure message
        Get.snackbar(
          "Payment Failed",
          responseData['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      print("❌ Error Completing Payment: $e");

      // Show error message
      Get.snackbar(
        "Error",
        "An error occurred while verifying the payment.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading(false);
      print("🔹 isLoading set to false.");
    }
  }


}