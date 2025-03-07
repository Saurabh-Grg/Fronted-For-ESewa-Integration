// import 'package:esewa_flutter/screens/ItemScreen.dart';
// import 'package:esewa_flutter/screens/PaymentScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'eSewa Payment',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ItemScreen(),
//     );
//   }
// }

import 'package:esewa_flutter/screens/ItemScreen.dart';
import 'package:esewa_flutter/services/PaymentService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/PaymentController.dart';

void main() {
  final paymentService = PaymentService(baseUrl: 'http://localhost:3000');
  final paymentController = PaymentController(paymentService: paymentService);
  runApp(MyApp(paymentController: paymentController));
}

class MyApp extends StatelessWidget {
  final PaymentController paymentController;

  MyApp({required this.paymentController});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      initialBinding: BindingsBuilder(() {
        Get.put(paymentController);
      }),
      home: ItemScreen(),
    );
  }
}