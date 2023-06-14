import 'package:flutter/material.dart';
import 'package:shrine/login.dart';
import 'package:shrine/model/product.dart';

class BackDrop extends StatefulWidget {
  final Category currentCategory;
  final Widget frontLayer;
  final Widget backLayer;
  final Widget frontTitle;
  final Widget backTitle;

  const BackDrop(
      {required this.backLayer,
      required this.backTitle,
      required this.frontLayer,
      required this.currentCategory,
      required this.frontTitle,
      Key? key})
      : super(key: key);

  @override
  State<BackDrop> createState() => _BackDropState();
}

class _BackDropState extends State<BackDrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey backdropKey = GlobalKey(debugLabel: 'Backdrop');
  late AnimationController _controller;

  @override
  void didUpdateWidget(covariant BackDrop oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.currentCategory != oldWidget.currentCategory) {
      _toggleBackDropLayerVisibility();
    } else if (!_fronttLayerVisible) {
      _controller.fling(velocity: flingVelocity);
    }
  }

  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(microseconds: 300),
      value: 1.0,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  bool get _fronttLayerVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackDropLayerVisibility() {
    _controller.fling(
        velocity: _fronttLayerVisible ? -flingVelocity : flingVelocity);
  }

  Widget buildStack(BuildContext context, BoxConstraints constaints) {
    const double layerTitleheight = 48;
    final Size layerSize = constaints.biggest;
    final double layerTop = layerSize.height - layerTitleheight;

    Animation<RelativeRect> layerAnimation = RelativeRectTween(
      begin:
          RelativeRect.fromLTRB(0.0, layerTop, 0, layerTop - layerSize.height),
      end: const RelativeRect.fromLTRB(0, 0, 0, 0),
    ).animate(_controller.view);

    return Stack(
      key: backdropKey,
      children: [
        ExcludeSemantics(
          child: widget.backLayer,
          excluding: _fronttLayerVisible,
        ),
        PositionedTransition(
          rect: layerAnimation,
          child: FrontLayer(
              onTap: _toggleBackDropLayerVisibility, child: widget.frontLayer),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      elevation: 0.0,
      titleSpacing: 0,
      title: _BackDropTitle(
          listenable: _controller.view,
          backTitle: widget.backTitle,
          onPress: _toggleBackDropLayerVisibility,
          frontTitle: widget.frontTitle),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => const LoginPage())));
          },
          icon: Icon(
            Icons.search,
            semanticLabel: 'login',
          ),
        ),
        IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => LoginPage())));
            },
            icon: Icon(Icons.tune))
      ],
    );
    return Scaffold(
        appBar: appBar,
        body: LayoutBuilder(
          builder: buildStack,
        ));
  }
}

class FrontLayer extends StatelessWidget {
  FrontLayer({Key? key, required this.child, this.onTap}) : super(key: key);
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 16.0,
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(46))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            height: 40,
            alignment: AlignmentDirectional.centerStart,
          ),
        ),
        Expanded(child: child)
      ]),
    );
  }
}

const double flingVelocity = 2.0;

class _BackDropTitle extends AnimatedWidget {
  final void Function() onPress;
  final Widget frontTitle;
  final Widget backTitle;

  const _BackDropTitle({
    Key? key,
    required Animation<double> listenable,
    required this.backTitle,
    required this.onPress,
    required this.frontTitle,
  })  : _listenable = listenable,
        super(key: key, listenable: listenable);
  final Animation<double> _listenable;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final Animation<double> animation = _listenable;

    return DefaultTextStyle(
        style: Theme.of(context).textTheme.titleLarge!,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        child: Row(
          children: [
            SizedBox(
              width: 72.0,
              child: IconButton(
                  padding: EdgeInsets.only(right: 8),
                  onPressed: this.onPress,
                  icon: Stack(
                    children: [
                      Opacity(
                        opacity: animation.value,
                        child: ImageIcon(AssetImage('assets/slanted_menu.png')),
                      )
                    ],
                  )),
            ),
            Stack(
              children: [
                Opacity(
                  opacity: CurvedAnimation(
                    parent: ReverseAnimation(animation),
                    curve: Interval(0.5, 1),
                  ).value,
                  child: FractionalTranslation(
                    translation: Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(0.5, 0.0),
                    ).evaluate(animation),
                    child: backTitle,
                  ),
                ),
                Opacity(
                  opacity: CurvedAnimation(
                    parent: animation,
                    curve: Interval(0.5, 1.0),
                  ).value,
                  child: FractionalTranslation(
                    translation: Tween<Offset>(
                            begin: Offset(-0.25, 0.0), end: Offset.zero)
                        .evaluate(animation),
                    child: frontTitle,
                  ),
                )
              ],
            )
          ],
        ));
  }
}
