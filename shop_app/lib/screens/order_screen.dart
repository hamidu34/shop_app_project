import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/provider/order.dart';
import '/widgets/app_drawer.dart';
import '/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future _ordersFuture;

  Future _obtainOrderFuture() {
    return Provider.of<Order>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrderFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (context, datasnapshot) {
          if (datasnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Consumer<Order>(
                builder: (context, orderData, child) => ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (context, i) => OrderItem(
                        order: orderData.orders[i],
                      ),
                    ));
          }
        },
      ),
      drawer: const AppDrawer(),
    );
  }
}
