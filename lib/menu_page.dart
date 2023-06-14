import 'package:flutter/material.dart';
import 'package:shrine/supplemental/colors.dart';
import 'package:shrine/model/product.dart';

class MenuPage extends StatelessWidget {
  const MenuPage(
      {Key? key, required this.currentCategory, required this.onCategoryTap})
      : super(key: key);

  final Category currentCategory;
  final ValueChanged<Category> onCategoryTap;
  final List<Category> categories = Category.values;
  Widget buildCategory(Category category, BuildContext context) {
    final categoryString =
        category.toString().replaceAll('Category.', '').toUpperCase();
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
        onTap: () {
          onCategoryTap(category);
        },
        child: category == currentCategory
            ? Column(
                children: [
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    categoryString,
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
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
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  categoryString,
                  style: theme.textTheme.bodyLarge!
                      .copyWith(color: kShrineBrown900.withAlpha(153)),
                  textAlign: TextAlign.center,
                ),
              ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(top: 40.0),
        color: kShrinePink100,
        child: ListView(
          children: categories
              .map((Category cat) => buildCategory(cat, context))
              .toList(),
        ),
      ),
    );
  }
}
