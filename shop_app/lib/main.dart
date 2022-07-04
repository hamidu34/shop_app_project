import 'package:flutter/material.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Shop',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(
          secondary: Colors.orange,
        ),
      ),
      home: ProductOverviewScreen(),
      routes: {
        ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
      },
    );
  }
}
