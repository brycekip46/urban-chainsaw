import 'package:flutter/material.dart';
import 'package:shrine/login.dart';
import 'package:shrine/model/product.dart';

class BackDrop extends StatefulWidget {
  final Category currentCategory;
  final Widget frontLayer;
  final Widget backLayer;
  final Widget frontTitle;
  final Widget backTitle;

  BackDrop({
    required this.backLayer,
    required this.backTitle,
    required this.currentCategory,
    required this.frontLayer,
    required this.frontTitle,
    Key? key,
  }) : super(key: key);

  @override
  State<BackDrop> createState() => _BackDropState();
}

class _BackDropState extends State<BackDrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backDropKey = GlobalKey(debugLabel: 'Backdrop');
  late AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      value: 1.0,
      duration: const Duration(microseconds: 400),
    );
  }

  @override
  void didUpdateWidget(BackDrop oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.currentCategory != oldWidget.currentCategory) {
      _toggleBackdropVisibility();
    } else if (!_frontLayerVisible) {
      _controller.fling(velocity: flingVelocity);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  bool get _frontLayerVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropVisibility() {
    _controller.fling(
        velocity: _frontLayerVisible ? -flingVelocity : flingVelocity);
  }

  Widget buildStack(BuildContext context, BoxConstraints constraints) {
    const double layerTitleHeight = 20;
    final Size layerSize = constraints.biggest;
    final double layerTop = layerSize.height - layerTitleHeight;

    Animation<RelativeRect> layerAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(0.0, layerTop, 0, layerSize.height),
      end: RelativeRect.fromLTRB(0, 0, 0, 0),
    ).animate(_controller.view);

    return Stack(
      key: _backDropKey,
      children: [
        ExcludeSemantics(
          excluding: _frontLayerVisible,
          child: widget.backLayer,
        ),
        PositionedTransition(
          rect: layerAnimation,
          child: FrontLayer(
            child: widget.frontLayer,
            onTap: _toggleBackdropVisibility,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      elevation: 0.0,
      titleSpacing: 0.0,
      title: BackDropTitle(
        backtitle: widget.backTitle,
        listenable: _controller.view,
        onPress: _toggleBackdropVisibility,
        frontTitle: widget.frontTitle,
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
          icon: Icon(
            Icons.search,
            semanticLabel: "Log in",
          ),
        ),
        IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            icon: Icon(
              Icons.tune,
              semanticLabel: "Login",
            ))
      ],
    );
    return Scaffold(appBar: appBar, body: LayoutBuilder(builder: buildStack));
  }
}

class FrontLayer extends StatelessWidget {
  final VoidCallback? onTap;
  const FrontLayer({Key? key, this.onTap, required this.child})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 16.0,
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(46), topRight: Radius.circular(46))),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

class BackDropTitle extends AnimatedWidget {
  final void Function() onPress;
  final Widget frontTitle;
  final Widget backtitle;

  const BackDropTitle({
    Key? key,
    required this.backtitle,
    required this.frontTitle,
    required this.onPress,
    required Animation<double> listenable,
  })  : _listenable = listenable,
        super(key: key, listenable: listenable);

  final Animation<double> _listenable;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = _listenable;
    // TODO: implement build
    return DefaultTextStyle(
        style: Theme.of(context).textTheme.titleLarge!,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        child: Row(
          children: [
            SizedBox(
              width: 72,
              child: IconButton(
                padding: const EdgeInsets.only(right: 10),
                onPressed: this.onPress,
                icon: Stack(children: [
                  Opacity(
                    opacity: animation.value,
                    child:
                        const ImageIcon(AssetImage('assets/slanted_menu.png')),
                  ),
                  FractionalTranslation(
                    translation: Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(1.0, 0.0),
                    ).evaluate(animation),
                    child: const ImageIcon(AssetImage('assets/diamond.png')),
                  )
                ]),
              ),
            ),
            Stack(
              children: [
                Opacity(
                  opacity: CurvedAnimation(
                          parent: ReverseAnimation(animation),
                          curve: Interval(0.5, 1.0))
                      .value,
                  child: FractionalTranslation(
                    translation:
                        Tween<Offset>(begin: Offset.zero, end: Offset(0.5, 0.0))
                            .evaluate(animation),
                    child: backtitle,
                  ),
                ),
                Opacity(
                  opacity: CurvedAnimation(
                          parent: animation, curve: Interval(0.5, 1))
                      .value,
                  child: FractionalTranslation(
                    translation: Tween<Offset>(
                      begin: Offset(-0.25, 0.0),
                      end: Offset.zero,
                    ).evaluate(animation),
                    child: frontTitle,
                  ),
                )
              ],
            )
          ],
        ));
  }
}
