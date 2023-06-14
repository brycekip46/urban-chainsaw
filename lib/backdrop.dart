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

  Widget _buildStack(BoxConstraints constraints, BuildContext context) {
    const double layerTitleHeight = 48;
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
            excluding: _frontLayerVisible, child: widget.backLayer),
        PositionedTransition(
          rect: layerAnimation,
          child: FrontLayer(child: widget.frontLayer),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      elevation: 0.0,
      titleSpacing: 0.0,
      leading: Icon(Icons.menu),
      title: Text("SHRINE"),
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
    return Scaffold(
      appBar: appBar,
      body: _buildStack(),
    );
  }
}

class FrontLayer extends StatelessWidget {
  const FrontLayer({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 16.0,
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(46), topRight: Radius.circular(46))),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [Expanded(child: child)]),
    );
  }
}

const double flingVelocity = 2.0;
