import 'package:flutter/material.dart';
import 'package:shrine/model/product.dart';
import 'package:shrine/supplemental/colors.dart';

class CategoryMenuPage extends StatelessWidget {
  final Category currentCategory;
  final ValueChanged<Category> onCategoryTap;
  final List<Category> _categories = Category.values;

  CategoryMenuPage(
      {Key? key, required this.currentCategory, required this.onCategoryTap})
      : super(key: key);

  Widget buildCategory(Category category, BuildContext context) {
    final categoryString =
        category.toString().replaceAll("Category.", '').toUpperCase();
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () => onCategoryTap(category),
      child: category == currentCategory
          ? Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                Text(
                  categoryString,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 14,
                ),
                Container(
                  width: 70,
                  height: 2.0,
                  color: kShrinePink400,
                )
              ],
            )
          : Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                categoryString,
                style: theme.textTheme.bodyLarge!
                    .copyWith(color: kShrineBrown900.withAlpha(153)),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: EdgeInsets.only(top: 40),
          color: kShrinePink100,
          child: ListView(
              children: _categories
                  .map((Category c) => buildCategory(c, context))
                  .toList())),
    );
  }
}
