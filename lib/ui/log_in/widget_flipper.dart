import 'package:budgetapp/blocs/log_in_sign_up_bloc_provider.dart';
import 'package:flutter/material.dart';
import 'dart:math' show pi;

class WidgetFlipper extends StatefulWidget {
  WidgetFlipper({
    Key key,
    this.frontWidget,
    this.backWidget,
  }) : super(key: key);

  final Widget frontWidget;
  final Widget backWidget;

  @override
  _WidgetFlipperState createState() => _WidgetFlipperState();
}

class _WidgetFlipperState extends State<WidgetFlipper>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> _frontRotation;
  Animation<double> _backRotation;
  bool isFrontVisible = true;
  LoginSignupBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = LoginSignupBlocProvider.of(context);
  }

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _frontRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: pi / 2)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
      ],
    ).animate(controller);

    _backRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: -pi / 2, end: 0.0)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 50.0,
        ),
      ],
    ).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedCard(
          animation: _backRotation,
          child: widget.backWidget,
        ),
        AnimatedCard(
          animation: _frontRotation,
          child: widget.frontWidget,
        ),
      ],
    );
  }

  // Widget _tapDetectionControls() {
  //   return Stack(
  //     fit: StackFit.expand,
  //     children: <Widget>[
  //       GestureDetector(
  //         onTap: _leftRotation,
  //         child: FractionallySizedBox(
  //           widthFactor: 0.5,
  //           heightFactor: 1.0,
  //           alignment: Alignment.topLeft,
  //           child: Container(
  //             color: Colors.transparent,
  //           ),
  //         ),
  //       ),
  //       GestureDetector(
  //         onTap: _rightRotation,
  //         child: FractionallySizedBox(
  //           widthFactor: 0.5,
  //           heightFactor: 1.0,
  //           alignment: Alignment.topRight,
  //           child: Container(
  //             color: Colors.transparent,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // void _leftRotation() {
  //   _toggleSide();
  // }

  // void _rightRotation() {
  //   _toggleSide();
  // }

  void toggleSide() {
    if (isFrontVisible) {
      controller.forward();
      isFrontVisible = false;
    } else {
      controller.reverse();
      isFrontVisible = true;
    }
  }
}

class AnimatedCard extends StatelessWidget {
  AnimatedCard({
    this.child,
    this.animation,
  });

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        var transform = Matrix4.identity();
        transform.setEntry(3, 2, 0.001);
        transform.rotateY(animation.value);
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        Navigator.popAndPushNamed(context, '/main');
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
