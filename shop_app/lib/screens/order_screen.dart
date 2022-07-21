import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/provider/order.dart';
import '/widgets/app_drawer.dart';
import '/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (context, i) => OrderItem(
          order: orderData.orders[i],
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
