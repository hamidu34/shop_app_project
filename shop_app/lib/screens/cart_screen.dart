import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/order.dart';

import '../provider/cart.dart' show Cart;
import '../widgets/cart_items.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = '/cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(children: [
        Card(
          margin: const EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(children: [
              const Text('TOTAL'),
              const Spacer(),
              Chip(
                label: Text('\$${cart.totalAmount}'),
              ),
              TextButton(
                onPressed: (cart.totalAmount <= 0 || _isLoading)
                    ? null
                    : () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await Provider.of<Order>(context, listen: false)
                            .addOrder(
                          cart.items.values.toList(),
                          cart.totalAmount,
                        );
                        setState(() {
                          _isLoading = false;
                        });
                        cart.clear();
                      },
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        'ORDER NOW',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (context, i) => CartItems(
              id: cart.items.values.toList()[i].id,
              productId: cart.items.keys.toList()[i],
              title: cart.items.values.toList()[i].title,
              quantity: cart.items.values.toList()[i].quantity,
              price: cart.items.values.toList()[i].price,
            ),
          ),
        ),
      ]),
    );
  }
}
