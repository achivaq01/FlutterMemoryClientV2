import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_memory_client/show_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stroke_text/stroke_text.dart';

class LayoutConnecting extends StatefulWidget {
  const LayoutConnecting({Key? key}) : super(key: key);

  @override
  LayoutConnectingState createState() => LayoutConnectingState();
}

class LayoutConnectingState extends State<LayoutConnecting> with TickerProviderStateMixin {
  static const Color backgroundGradientStartColor =
      Color.fromARGB(255, 247, 174, 248);
  static const Color backgroundGradientEndColor =
      Color.fromARGB(255, 144, 221, 247);
  static const Duration animationDuration = Duration(seconds: 10);

  late double width;
  late double height;
  late AnimationController _animationController;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );
    _topAlignmentAnimation = TweenSequence<Alignment>(
      [
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
          ),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.bottomRight,
            end: Alignment.bottomLeft,
          ),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.bottomLeft,
            end: Alignment.topLeft,
          ),
          weight: 1,
        ),
      ],
    ).animate(_animationController);
    _bottomAlignmentAnimation = TweenSequence<Alignment>(
      [
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.bottomRight,
            end: Alignment.bottomLeft,
          ),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.bottomLeft,
            end: Alignment.topLeft,
          ),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
          ),
          weight: 1,
        ),
      ],
    ).animate(_animationController);

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose the AnimationController when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    ShowFlutterToast singletonToast = ShowFlutterToast.instance;
    singletonToast.setContext(context);

    return Material(
      child: CupertinoPageScaffold(
        backgroundColor: Colors.transparent,
        child: Center(
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, _) => Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: const [
                        backgroundGradientStartColor,
                        backgroundGradientEndColor
                      ],
                      begin: _topAlignmentAnimation.value,
                      end: _bottomAlignmentAnimation.value,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: StrokeText(
                        text: 'Connecting!',
                        textColor: Colors.white,
                        textStyle: GoogleFonts.concertOne(
                          fontWeight: FontWeight.bold,
                          fontSize: 25
                        ),
                        strokeWidth: 10,
                        strokeColor: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: LoadingAnimationWidget.waveDots(
                        color: Colors.black,
                        size: 60,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );


  }
}
