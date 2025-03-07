import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart'; // for opening the eSewa payment page

import '../controllers/PaymentController.dart';

class PurchasedItemDetails extends StatelessWidget {
  // Reactive variable to store the selected payment method
  final RxString selectedPaymentMethod = 'esewa'.obs;

  @override
  Widget build(BuildContext context) {
    final PaymentController paymentController = Get.find();

    // Get the data passed from the controller
    final purchasedItemData = paymentController.purchasedItemData;
    final paymentData = paymentController.paymentData;

    // Null checks for values
    final paymentMethod = purchasedItemData['paymentMethod'] ?? 'N/A';
    final purchaseDate = purchasedItemData['purchaseDate'] ?? 'N/A';
    final totalPrice = purchasedItemData['totalPrice'] ?? 0.00;
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
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Displaying general information in a card
              Text('Payment Method: $paymentMethod'),
              Text('Purchase Date: $purchaseDate'),
              Text('Total Price: NPR $totalPrice'),
              SizedBox(height: 10),
              Text('Payment Signature: $signature'),
              Text('Signed Field Names: $signedFieldNames'),
              SizedBox(height: 10),
              Text('Purchased Item ID: $purchasedItemId'),
              Text('Status: ${purchasedItemData['status'] ?? 'N/A'}'),

              SizedBox(height: 80),

              // Radio Buttons for payment method selection
              Text(
                'Select Payment Method',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Column(
                children: [
                  RadioListTile<String>(
                    title: Row(
                      children: [
                        Image.asset("assets/images/img.png", width: 30, height: 30,),
                        SizedBox(width: 10),
                        Expanded(child: Text('eSewa', style: TextStyle(fontWeight: FontWeight.bold),)),
                      ],
                    ),
                    value: 'esewa',
                    groupValue: selectedPaymentMethod.value,
                    onChanged: (String? value) {
                      selectedPaymentMethod.value = value!;
                    },
                  ),
                  RadioListTile<String>(
                    title: Row(
                      children: [
                        Image.asset("assets/images/img1.png", width: 30, height: 30,),
                        SizedBox(width: 10),
                        Text('Khalti', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    value: 'khalti',
                    groupValue: selectedPaymentMethod.value,
                    onChanged: (String? value) {
                      selectedPaymentMethod.value = value!;
                      // Show snackbar for coming soon
                      if (value != 'esewa') {
                        Get.snackbar('Coming Soon', 'This payment method is coming soon!');
                      }
                    },
                  ),
                  RadioListTile<String>(
                    title: Row(
                      children: [
                        Image.asset("assets/images/img2.png", width: 30, height: 30,),
                        SizedBox(width: 10),
                        Text('Bank Transfer', style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    value: 'bank_transfer',
                    groupValue: selectedPaymentMethod.value,
                    onChanged: (String? value) {
                      selectedPaymentMethod.value = value!;
                      // Show snackbar for coming soon
                      if (value != 'esewa') {
                        Get.snackbar('Coming Soon', 'This payment method is coming soon!');
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Payment Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [Colors.green, Colors.greenAccent],
                  ),
                ),
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
                    'Pay with ${selectedPaymentMethod.value.toUpperCase()}',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
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
