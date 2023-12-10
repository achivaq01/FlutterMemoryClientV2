import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stroke_text/stroke_text.dart';

import 'app_data.dart';

class LayoutMain extends StatefulWidget {
  const LayoutMain({Key? key}) : super(key: key);

  @override
  LayoutMainState createState() => LayoutMainState();
}

class LayoutMainState extends State<LayoutMain>
    with SingleTickerProviderStateMixin {
  static const Duration animationDuration = Duration(seconds: 10);
  static const double textStrokeWidth = 5.0;
  static const double titleStrokeWidth = 20;
  static const EdgeInsets textFieldPadding = EdgeInsets.all(8.0);
  static const double textFieldWidth = 200.0;
  static const double textFontSize = 20;
  static const double titleFontSize = 100;
  static const Color backgroundGradientStartColor =
      Color.fromARGB(255, 247, 174, 248);
  static const Color backgroundGradientEndColor =
      Color.fromARGB(255, 144, 221, 247);

  late AnimationController _animationController;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;
  late double width;

  final _ipController = TextEditingController();
  final _portController = TextEditingController();
  final _nameController = TextEditingController();

  Widget _buildTextFormField(
      String defaultValue,
      TextEditingController controller,
      ) {
    controller.text = defaultValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: CupertinoTextField(controller: controller),
        ),
      ],
    );
  }

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
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    width = MediaQuery.of(context).size.width;

    return Material(
      child: CupertinoPageScaffold(
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
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
              Column(
                children: <Widget>[
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(50),
                        child: Stack(
                          children: [
                            StrokeText(
                              text: 'Memory!',
                              textColor: Colors.white,
                              textStyle: GoogleFonts.concertOne(
                                textStyle: const TextStyle(
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              strokeWidth: titleStrokeWidth,
                              strokeColor: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  StrokeText(
                    text: "Player Name",
                    textStyle: GoogleFonts.concertOne(
                      textStyle: const TextStyle(
                        fontSize: textFontSize,
                        color: Colors.white,
                      ),
                    ),
                    strokeColor: Colors.black,
                    strokeWidth: textStrokeWidth,
                  ),
                  Padding(
                    padding: textFieldPadding,
                    child: SizedBox(
                      width: textFieldWidth,
                      child: _buildTextFormField('SuperCoolPlayer', _nameController),
                    ),
                  ),
                  StrokeText(
                    text: "IP",
                    textStyle: GoogleFonts.concertOne(
                      textStyle: const TextStyle(
                        fontSize: textFontSize,
                        color: Colors.white,
                      ),
                    ),
                    strokeColor: Colors.black,
                    strokeWidth: textStrokeWidth,
                  ),
                  Padding(
                    padding: textFieldPadding,
                    child: SizedBox(
                      width: textFieldWidth,
                      child: _buildTextFormField(appData.ip, _ipController),
                    ),
                  ),
                  StrokeText(
                    text: "Port",
                    textStyle: GoogleFonts.concertOne(
                      textStyle: const TextStyle(
                        fontSize: textFontSize,
                        color: Colors.white,
                      ),
                    ),
                    strokeColor: Colors.black,
                    strokeWidth: textStrokeWidth,
                  ),
                  Padding(
                    padding: textFieldPadding,
                    child: SizedBox(
                      width: textFieldWidth,
                      child: _buildTextFormField(appData.port, _portController),
                    ),
                  ),
                  const Padding(
                    padding: textFieldPadding,
                  ),
                  Padding(
                    padding: textFieldPadding,
                    child: SizedBox(
                      width: textFieldWidth,
                      child: CupertinoButton(
                        color: Colors.white,
                        onPressed: () {
                          appData.ip = _ipController.value.text;
                          appData.port = _portController.value.text;
                          appData.name = _nameController.value.text;
                          _animationController.dispose();
                          appData.connectToServer();
                        },
                        child: StrokeText(
                          text: 'Connect',
                          textStyle: GoogleFonts.concertOne(
                            fontSize: textFontSize,
                          ),
                          strokeColor: Colors.black,
                          strokeWidth: textStrokeWidth,
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
