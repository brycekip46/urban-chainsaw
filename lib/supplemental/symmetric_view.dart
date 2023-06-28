import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shrine/model/product.dart';
import 'package:shrine/supplemental/colors.dart';

class Symmetric_view extends StatefulWidget {
  final List<Product> products;
  const Symmetric_view({Key? key, required this.products}) : super(key: key);

  @override
  State<Symmetric_view> createState() => _Symmetric_viewState();
}

class _Symmetric_viewState extends State<Symmetric_view> {
  double screenWidth = 600;
  int crossAxisCount = 2;

  void calculateCrossAxisCount() {
    // Calculate the crossAxisCount based on the screen width increment

    if (screenWidth < 600) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = (screenWidth / 200).floor();
    }
    // Update the state to reflect the new crossAxisCount
  }

  List<InkWell> _buildCards(BuildContext context) {
    if (widget.products.isEmpty) {
      return const <InkWell>[];
    }
    final ThemeData theme = Theme.of(context);
    final NumberFormat format = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());
    return widget.products.map((product) {
      return InkWell(
        onTap: () {},
        hoverColor: kShrinePink400,
        focusColor: kShrineBrown900,
        child: Card(
          elevation: 10.0,
          clipBehavior: Clip.antiAlias,
          child: Column(
            // TODO: Center items on the card (103)
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 18 / 11,
                child: Image.asset(
                  product.assetName,
                  package: product.assetPackage,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // TODO: Handle overflowing labels (103)
                      Text(
                        product.name,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        format.format(product.price),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Calculate initial crossAxisCount based on the current screen width
      screenWidth = MediaQuery.of(context).size.width;
      calculateCrossAxisCount();
      setState(() {});
    });
    return LayoutBuilder(
      builder: (context, constraints) {
        screenWidth = constraints.maxWidth;
        calculateCrossAxisCount();

        return OrientationBuilder(builder: (context, constraints) {
          return GridView.count(
            crossAxisCount: crossAxisCount,
            padding: EdgeInsets.all(16),
            childAspectRatio: 8.0 / 9.0,
            children: _buildCards(context),
          );
        });
      },
    );
  }
}
