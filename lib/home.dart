import 'package:flutter/material.dart';
import 'package:shrine/model/product.dart';
import 'package:shrine/model/products_repository.dart';
import 'package:shrine/supplemental/symmetric_view.dart';

class HomePage extends StatelessWidget {
  final Category category;
  const HomePage({Key? key, this.category = Category.all}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Symmetric_view(
      products: ProductsRepository.loadProducts(category),
    );
  }
}
