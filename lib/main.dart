import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_club_colors.dart';
import 'package:flutter_fight_club/fight_club_icons.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          textTheme:
              GoogleFonts.pressStart2pTextTheme(Theme.of(context).textTheme)),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static const maxLives = 5;
  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;

  BodyPart enemiesDefendingBodyPart = BodyPart.random();
  BodyPart enemiesAttackingBodyPart = BodyPart.random();

  int yourLives = maxLives;
  int enemiesLives = maxLives;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            FightersInfo(
                yourLivesCount: yourLives,
                enemiesLivesCount: enemiesLives,
                maxLivesCount: maxLives),
            Expanded(child: SizedBox()),
            SizedBox(height: 14),
            ControlsWidget(
              attackingBodyPart: attackingBodyPart,
              defendingBodyPart: defendingBodyPart,
              selectAttackingBodyPart: _selectAttackingBodyPart,
              selectDefendingBodyPart: _selectDefendingBodyPart,
            ),
            SizedBox(height: 14),
            GoButton(
              onTap: _onGoButtonClicked,
              color: _getGoButtonColor(),
              text: _isLifesFinished() ? "Start new game" : "Go",
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Color _getGoButtonColor() {
    if (_isGoButtonEnabled() || _isLifesFinished()) {
      return FightClubColors.blackButton;
    } else {
      return FightClubColors.greyButton;
    }
  }

  static TextStyle white() {
    return TextStyle(color: FightClubColors.whiteText);
  }

  static TextStyle black() {
    return TextStyle(color: FightClubColors.darkGreyText);
  }

  bool _isGoButtonEnabled() {
    return defendingBodyPart != null && attackingBodyPart != null;
  }

  bool _isLifesFinished() {
    return yourLives == 0 || enemiesLives == 0;
  }

  void _selectDefendingBodyPart(BodyPart value) {
    if (yourLives == 0 || enemiesLives == 0) {
      return;
    }
    setState(() {
      defendingBodyPart = value;
    });
  }

  void _selectAttackingBodyPart(BodyPart value) {
    if (yourLives == 0 || enemiesLives == 0) {
      return;
    }
    setState(() {
      attackingBodyPart = value;
    });
  }

  void _onGoButtonClicked() {
    setState(() {
      if (yourLives == 0 || enemiesLives == 0) {
        yourLives = maxLives;
        enemiesLives = maxLives;
      } else {
        if (defendingBodyPart != enemiesAttackingBodyPart) {
          yourLives--;
        }

        if (attackingBodyPart != enemiesDefendingBodyPart) {
          enemiesLives--;
        }

        defendingBodyPart = null;
        attackingBodyPart = null;
        enemiesDefendingBodyPart = BodyPart.random();
        enemiesAttackingBodyPart = BodyPart.random();
      }
    });
  }
}

class GoButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final String text;

  const GoButton(
      {Key? key, required this.onTap, required this.color, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: 40,
          child: ColoredBox(
            color: color,
            child: Center(
                child: Text(
              text.toUpperCase(),
              style: TextStyle(
                  color: FightClubColors.whiteText,
                  fontWeight: FontWeight.w900,
                  fontSize: 16),
            )),
          ),
        ),
      ),
    );
  }
}

class FightersInfo extends StatelessWidget {
  final maxLivesCount;
  final yourLivesCount;
  final enemiesLivesCount;

  const FightersInfo({
    Key? key,
    required this.maxLivesCount,
    required this.yourLivesCount,
    required this.enemiesLivesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          LivesWidget(
              overallLivesCount: maxLivesCount,
              currentLivesCount: yourLivesCount),
          Center(
            child: Column(
              children: [
                SizedBox(height: 16),
                Text("You",
                    style:
                        TextStyle(color: FightClubColors.darkGreyText)),
                SizedBox(height: 12),
                ColoredBox(
                    color: Colors.red, child: SizedBox(height: 92, width: 92)),
              ],
            ),
          ),
          ColoredBox(
              color: Colors.green, child: SizedBox(width: 44, height: 44)),
          Center(
            child: Column(
              children: [
                SizedBox(height: 16),
                Text("Enemy",
                    style:
                        TextStyle(color: FightClubColors.darkGreyText)),
                SizedBox(height: 12),
                ColoredBox(
                    color: Colors.blue, child: SizedBox(height: 92, width: 92)),
              ],
            ),
          ),
          LivesWidget(
              overallLivesCount: maxLivesCount,
              currentLivesCount: enemiesLivesCount),
        ],
      ),
    );
  }
}

class ControlsWidget extends StatelessWidget {
  const ControlsWidget(
      {Key? key,
      required this.defendingBodyPart,
      required this.attackingBodyPart,
      required this.selectDefendingBodyPart,
      required this.selectAttackingBodyPart})
      : super(key: key);

  final BodyPart? defendingBodyPart;
  final BodyPart? attackingBodyPart;
  final ValueSetter<BodyPart> selectDefendingBodyPart;
  final ValueSetter<BodyPart> selectAttackingBodyPart;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                  height: 40,
                  child: Center(
                      child: Text("DEFEND",
                          style: TextStyle(
                              color: FightClubColors.darkGreyText)))),
              BodyPartButton(
                bodyPart: BodyPart.head,
                selected: defendingBodyPart == BodyPart.head,
                bodyPartSetter: selectDefendingBodyPart,
              ),
              SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: defendingBodyPart == BodyPart.torso,
                bodyPartSetter: selectDefendingBodyPart,
              ),
              SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: defendingBodyPart == BodyPart.legs,
                bodyPartSetter: selectDefendingBodyPart,
              ),
            ],
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                  height: 40,
                  child: Center(
                      child: Text("ATTACK",
                          style: TextStyle(
                              color: FightClubColors.darkGreyText)))),
              BodyPartButton(
                bodyPart: BodyPart.head,
                selected: attackingBodyPart == BodyPart.head,
                bodyPartSetter: selectAttackingBodyPart,
              ),
              SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: attackingBodyPart == BodyPart.torso,
                bodyPartSetter: selectAttackingBodyPart,
              ),
              SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: attackingBodyPart == BodyPart.legs,
                bodyPartSetter: selectAttackingBodyPart,
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
      ],
    );
  }
}

class LivesWidget extends StatelessWidget {
  final int overallLivesCount;
  final int currentLivesCount;

  const LivesWidget(
      {Key? key,
      required this.overallLivesCount,
      required this.currentLivesCount})
      : assert(overallLivesCount >= 1),
        assert(currentLivesCount >= 0),
        assert(currentLivesCount <= overallLivesCount),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 35),
      Column(
        children: List.generate(overallLivesCount, (index) {
          if (index < currentLivesCount) {
            return Image.asset(FightClubIcons.heartFull, width: 18, height: 18);
          } else {
            return Image.asset(FightClubIcons.heartEmpty,
                width: 18, height: 18);
          }
        }),
      )
    ]);
  }
}

class BodyPart {
  final String name;

  const BodyPart._(this.name);

  static const head = BodyPart._("Head");
  static const torso = BodyPart._("Torso");
  static const legs = BodyPart._("Legs");

  @override
  String toString() {
    return 'BodyPart{name: $name}';
  }

  static const List<BodyPart> _values = [
    BodyPart.head,
    BodyPart.torso,
    BodyPart.legs
  ];

  static BodyPart random() {
    return _values[Random().nextInt(_values.length)];
  }
}

class BodyPartButton extends StatelessWidget {
  final BodyPart bodyPart;
  final bool selected;
  final ValueSetter<BodyPart> bodyPartSetter;

  const BodyPartButton(
      {Key? key,
      required this.bodyPart,
      required this.selected,
      required this.bodyPartSetter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => bodyPartSetter(bodyPart),
      child: SizedBox(
        height: 40,
        child: ColoredBox(
            color: selected
                ? FightClubColors.blueButton
                : FightClubColors.greyButton,
            child: Center(
                child: Text(
              bodyPart.name.toUpperCase(),
              style: selected
                  ? TextStyle(color: FightClubColors.whiteText)
                  : TextStyle(color: FightClubColors.darkGreyText),
            ))),
      ),
    );
  }
}

