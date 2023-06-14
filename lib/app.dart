import 'package:flutter/material.dart';
import 'package:shrine/model/product.dart';

import 'home.dart';
import 'login.dart';
import 'package:shrine/backdrop.dart';
import 'package:shrine/supplemental/colors.dart';
import 'package:shrine/supplemental/cut_corners_border.dart';
import 'package:shrine/menu_page.dart';

// TODO: Convert ShrineApp to stateful widget (104)
class ShrineApp extends StatefulWidget {
  const ShrineApp({Key? key}) : super(key: key);

  @override
  State<ShrineApp> createState() => _ShrineAppState();
}

class _ShrineAppState extends State<ShrineApp> {
  Category currentCat = Category.all;

  void onCategoryTap(Category category) {
    setState(() {
      currentCat = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shrine',
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext context) => const LoginPage(),
        '/': (BuildContext context) => BackDrop(
            backLayer: MenuPage(
                currentCategory: currentCat, onCategoryTap: onCategoryTap),
            backTitle: Text('MENU'),
            frontLayer: HomePage(
              cat: currentCat,
            ),
            currentCategory: Category.all,
            frontTitle: Text('SHRINE')),
      },
      theme: shrineTheme,
    );
  }
}

final ThemeData shrineTheme = _buildTheme();
ThemeData _buildTheme() {
  final ThemeData base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: kShrineBrown900,
              backgroundColor: kShrinePink100,
              elevation: 8.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ))),
      inputDecorationTheme: const InputDecorationTheme(
          border: CutCornersBorder(),
          focusedBorder: CutCornersBorder(
            borderSide: BorderSide(width: 2.0, color: kShrineBrown900),
          ),
          floatingLabelStyle: TextStyle(color: kShrineBrown900)),
      colorScheme: base.colorScheme.copyWith(
        primary: kShrinePink100,
        onPrimary: kShrineBrown900,
        secondary: kShrineBrown900,
        error: kShrineError,
      ));
}

TextTheme buildShrineTextTheme(TextTheme base) {
  return base
      .copyWith(
        headlineSmall:
            base.headlineSmall!.copyWith(fontWeight: FontWeight.w500),
        titleLarge: base.titleLarge!.copyWith(fontSize: 18),
        bodySmall: base.bodySmall!.copyWith(fontWeight: FontWeight.w400),
        bodyLarge:
            base.bodyLarge!.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
      )
      .apply(
          fontFamily: 'Rubik',
          displayColor: kShrineBrown900,
          bodyColor: kShrineBrown900);
}
