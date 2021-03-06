import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/provider/cart.dart';
import '/provider/product.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (context, value, child) => IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                product.toggleFavStatus();
              },
              icon: Icon(
                product.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
              ),
            ),
          ),
          trailing: IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              cart.addItem(
                product.id,
                product.title,
                product.price,
              );
            },
            icon: const Icon(
              Icons.shopping_cart_rounded,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/product-detail',
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
