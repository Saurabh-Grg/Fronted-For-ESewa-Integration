import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/PaymentController.dart';
import '../models/ItemModel.dart';
// import 'PaymentPage.dart';

class ItemScreen extends StatelessWidget {
  // A sample list of items to display
  final List<ItemModel> items = [
    ItemModel(
      id: 1,
      name: 'Frontend developer needed',
      price: 100.0,
    ),
    ItemModel(
      id: 2,
      name: 'Need someone to do my C# coursework',
      price: 200.0,
    ),
    ItemModel(
      id: 3,
      name: 'API integrate gardini manche chaiyo',
      price: 300.0,
    ),
    ItemModel(
      id: 4,
      name: 'UI design gardeu na kasaile',
      price: 400.0,
    ),
    ItemModel(
      id: 5,
      name: 'Help me do the backend',
      price: 500.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final PaymentController paymentController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text('Ongoing/Accepted Jobs'),
      ),
      body: Column(
        children: [
          Expanded(  // ✅ Wrap GridView.builder with Expanded
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: items.length,
                itemBuilder: (ctx, index) {
                  final item = items[index];
                  return ItemCard(item: item, paymentController: paymentController);
                },
              ),
            ),
          ),
          SizedBox(height: 10), // Add spacing
        ],
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final ItemModel item;
  final PaymentController paymentController;

  ItemCard({required this.item, required this.paymentController});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10), // Adding padding to prevent items from touching the edges
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: Get.height * 0.025,),
            Text(
              item.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            // Item Price
            Text(
              'NPR ${item.price}',
              style: TextStyle(fontSize: 14, color: Colors.green),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            // Buy Button
            Obx(() {
              if (paymentController.isLoading.value) {
                return CircularProgressIndicator();
              } else {
                return ElevatedButton(
                  onPressed: () async {
                    await paymentController.buyItem(item.id, item.price);
                    // Handle the payment response as needed
                  },
                  child: Text('Pay now'),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
