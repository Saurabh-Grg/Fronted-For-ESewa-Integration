import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart'; // for opening the eSewa payment page

import '../controllers/PaymentController.dart';

class PurchasedItemDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PaymentController paymentController = Get.find();

    // Get the data passed from the controller
    final purchasedItemData = paymentController.purchasedItemData;
    final paymentData = paymentController.paymentData;

    // Null checks for values
    final paymentMethod = purchasedItemData['paymentMethod'] ?? 'N/A';
    final purchaseDate = purchasedItemData['purchaseDate'] ?? 'N/A';
    final totalPrice = purchasedItemData['totalPrice'] ?? 0;
    final signature = paymentData['signature'] ?? '';
    final signedFieldNames = paymentData['signed_field_names'] ?? '';
    final purchasedItemId = purchasedItemData['purchasedItemId'] ?? '';

    // If signature is still null or empty, you can handle it more gracefully here.
    if (signature.isEmpty) {
      print("Warning: Signature is empty!");
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Purchased Item Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment Method: $paymentMethod'),
            Text('Purchase Date: $purchaseDate'),
            Text('Total Price: NPR $totalPrice'),
            SizedBox(height: 10),
            Text('Payment Signature: $signature'),
            Text('Signed Field Names: $signedFieldNames'),
            SizedBox(height: 10),
            Text('Purchased Item ID: $purchasedItemId'),
            Text('Status: ${purchasedItemData['status'] ?? 'N/A'}'),
            Container(
              color: Colors.green,
              child: TextButton(
                onPressed: () {
                  // Get the necessary details (like amount, transaction UUID, and signature)
                  double amount = purchasedItemData['totalPrice']?.toDouble() ?? 0.0;  // Null check and default value
                  String transactionUuid = purchasedItemData['purchasedItemId'] ?? '';  // Null check
                  String signature = paymentData['signature'] ?? '';  // Null check

                  // Make sure no field is null before proceeding
                  if (amount == 0.0 || transactionUuid.isEmpty || signature.isEmpty) {
                    // Handle the error case where the values are missing
                    print('Error: Missing data for payment');
                    return;
                  }

                  // Call the function to initiate payment
                  paymentController.initiateEsewaPayment(amount, transactionUuid, signature);
                },
                child: Text(
                  'Pay with eSewa',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch $url");
    }
  }
}
