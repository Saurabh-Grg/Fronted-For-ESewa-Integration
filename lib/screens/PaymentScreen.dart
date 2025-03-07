// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../controllers/PaymentController.dart';
//
// class PaymentScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Get the PaymentController
//     final PaymentController controller = Get.put(PaymentController());
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("eSewa Payment"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Obx(() {
//           if (controller.isLoading.value) {
//             return Center(child: CircularProgressIndicator());
//           } else {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => controller.initializePayment("123", 300.0),
//                   child: Text("Initialize Payment"),
//                 ),
//                 SizedBox(height: 20),
//                 Text("Status: ${controller.paymentStatus.value}"),
//                 if (controller.paymentData.value != null)
//                   Text("Transaction ID: ${controller.paymentData.value!.transactionId}"),
//                 if (controller.paymentData.value != null)
//                   Text("Amount: ${controller.paymentData.value!.amount}"),
//               ],
//             );
//           }
//         }),
//       ),
//     );
//   }
// }
