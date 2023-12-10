import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_memory_client/show_toast.dart';
import 'package:flutter_memory_client/widget_memory_painter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:stroke_text/stroke_text.dart';
import 'dart:math';

import 'app_data.dart';

class LayoutGame extends StatefulWidget {
  const LayoutGame({Key? key}) : super(key: key);

  @override
  LayoutGameState createState() => LayoutGameState();
}

class LayoutGameState extends State<LayoutGame> with TickerProviderStateMixin {
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
    _animationController
        .dispose(); // Dispose the AnimationController when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    double smallerDimension = (width < height ? width : height) * 0.8;

    AppData appData = Provider.of<AppData>(context);
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
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SafeArea(
                      child: Center(
                        child: Stack(
                          children: [
                            CupertinoPageScaffold(
                              backgroundColor: Colors.transparent,
                              child: Container(
                                width: smallerDimension,
                                height: smallerDimension,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTapUp: (TapUpDetails details) {
                                Size size = context.size!;

                                double cellDimension = smallerDimension / (4);
                                double offsetX =
                                    (smallerDimension - (cellDimension * (4))) /
                                        2;
                                double offsetY =
                                    (smallerDimension - (cellDimension * 4)) /
                                        2;

                                final double tappedX =
                                    details.localPosition.dx - offsetX;
                                final double tappedY =
                                    details.localPosition.dy - offsetY;

                                final int col =
                                    ((tappedX / cellDimension)).floor();
                                final int row =
                                    ((tappedY / cellDimension)).floor();

                                appData.sendMessage("change status", "column", col.toString(), "row", row.toString());

                                print("x: " + row.toString());
                                print("y: " + col.toString());
                              },
                              child: SizedBox(
                                width: smallerDimension,
                                height: smallerDimension,
                                child: CustomPaint(
                                  painter: WidgetMemoryPainter(appData),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CupertinoButton(
                          color: Colors.white,
                          onPressed: () {
                            appData.disconnectFromServer();
                          },
                          child: StrokeText(
                            text: 'Disconnect!',
                            textColor: Colors.white,
                            textStyle: GoogleFonts.concertOne(
                                fontWeight: FontWeight.bold, fontSize: 20),
                            strokeColor: Colors.black,
                            strokeWidth: 10,
                          )),
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
