import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageNetwork;

  // ignore: use_key_in_widget_constructors
  ProductItem(
    this.id,
    this.title,
    this.imageNetwork,
  );

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: GridTileBar(
        backgroundColor: Colors.black87,
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          padding: const EdgeInsets.all(0),
          onPressed: () {},
          icon: const Icon(
            Icons.favorite_rounded,
          ),
        ),
        trailing: IconButton(
          padding: const EdgeInsets.all(0),
          onPressed: () {},
          icon: const Icon(
            Icons.shopping_cart_rounded,
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: {id, title},
          );
        },
        child: Image.network(
          imageNetwork,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
