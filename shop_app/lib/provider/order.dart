import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class OrderItems {
  final String id;
  final double amount;
  final List<CartItems> products;
  final DateTime dateTime;
  OrderItems({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItems> _orders = [];

  List<OrderItems> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    var url = Uri.https(
        'shopapptesting-6b893-default-rtdb.firebaseio.com', '/orders.json');
    final response = await http.get(url);
    final List<OrderItems> loadedOrder = [];
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
    if (extractedData.isEmpty) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrder.add(OrderItems(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItems(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price']))
              .toList()));
    });
    _orders = loadedOrder.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItems> cartProduct, double total) async {
    var url = Uri.https(
        'shopapptesting-6b893-default-rtdb.firebaseio.com', '/orders.json');
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: jsonEncode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProduct
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity,
                  })
              .toList()
        }));
    _orders.insert(
      0,
      OrderItems(
        id: jsonDecode(response.body)['name'],
        amount: total,
        products: cartProduct,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}
