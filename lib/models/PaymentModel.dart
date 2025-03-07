// class PaymentModel {
//   final String transactionId;
//   final double amount;
//   final String status;
//
//   PaymentModel({
//     required this.transactionId,
//     required this.amount,
//     required this.status,
//   });
//
//   // Method to create a PaymentModel from a JSON response
//   factory PaymentModel.fromJson(Map<String, dynamic> json) {
//     return PaymentModel(
//       transactionId: json['transactionId'],
//       amount: json['amount'],
//       status: json['status'],
//     );
//   }
//
//   // Convert PaymentModel to JSON for sending API requests
//   Map<String, dynamic> toJson() {
//     return {
//       'transactionId': transactionId,
//       'amount': amount,
//       'status': status,
//     };
//   }
// }
