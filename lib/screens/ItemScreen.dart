import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/PaymentController.dart';
import '../models/ItemModel.dart';

class ItemScreen extends StatelessWidget {
  // A sample list of items to display
  final List<ItemModel> items = [
    ItemModel(
      id: 1,
      name: 'Item 1',
      imageUrl: 'assets/images/item.jpeg',
      price: 100.0,
    ),
    ItemModel(
      id: 2,
      name: 'Item 2',
      imageUrl: 'assets/images/item.jpeg',
      price: 200.0,
    ),
    ItemModel(
      id: 3,
      name: 'Item 3',
      imageUrl: 'assets/images/item.jpeg',
      price: 300.0,
    ),
    ItemModel(
      id: 4,
      name: 'Item 4',
      imageUrl: 'assets/images/item.jpeg',
      price: 400.0,
    ),
    ItemModel(
      id: 5,
      name: 'Item 5',
      imageUrl: 'assets/images/item.jpeg',
      price: 500.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final PaymentController paymentController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text('Items for Sale'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
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
        // Removing the fixed height and let it fit based on the content
        padding: EdgeInsets.all(10), // Adding padding to prevent items from touching the edges
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Item Image
            Image.asset(
              item.imageUrl,
              width: 50,  // Adjusted width
              height: 50, // Adjusted height
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            // Item Name
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
                  child: Text('Buy'),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
