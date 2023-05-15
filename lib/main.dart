import 'package:flutter/material.dart';

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
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(213, 222, 240, 1),
      body: Column(
        children: [
          SizedBox(height: 55),
          Row(
            children: [
              SizedBox(width: 16),
              Expanded(
                  child: Center(
                child: PlayerHPWidget(name: "You"),
              )),
              SizedBox(width: 12),
              Expanded(
                  child: Center(
                child: PlayerHPWidget(name: "Enemy"),
              )),
              SizedBox(width: 16),
            ],
          ),
          Expanded(child: SizedBox()),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 40, child: Center(child: Text("DEFEND"))),
                    BodyPartButton(
                      bodyPart: BodyPart.head,
                      selected: defendingBodyPart == BodyPart.head,
                      bodyPartSetter: _selectDefendingBodyPart,
                    ),
                    SizedBox(height: 14),
                    BodyPartButton(
                      bodyPart: BodyPart.torso,
                      selected: defendingBodyPart == BodyPart.torso,
                      bodyPartSetter: _selectDefendingBodyPart,
                    ),
                    SizedBox(height: 14),
                    BodyPartButton(
                      bodyPart: BodyPart.legs,
                      selected: defendingBodyPart == BodyPart.legs,
                      bodyPartSetter: _selectDefendingBodyPart,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 40, child: Center(child: Text("ATTACK"))),
                    BodyPartButton(
                      bodyPart: BodyPart.head,
                      selected: attackingBodyPart == BodyPart.head,
                      bodyPartSetter: _selectAttackingBodyPart,
                    ),
                    SizedBox(height: 14),
                    BodyPartButton(
                      bodyPart: BodyPart.torso,
                      selected: attackingBodyPart == BodyPart.torso,
                      bodyPartSetter: _selectAttackingBodyPart,
                    ),
                    SizedBox(height: 14),
                    BodyPartButton(
                      bodyPart: BodyPart.legs,
                      selected: attackingBodyPart == BodyPart.legs,
                      bodyPartSetter: _selectAttackingBodyPart,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
            ],
          ),
          SizedBox(height: 14),
          Row(
            children: [
              SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ColoredBox(
                    color: _isGoButtonEnabled()
                        ? Colors.black87
                        : MyColors.BUTTON_GREY_COLOR,
                    child: GestureDetector(
                      onTap: () {
                        if (defendingBodyPart != null &&
                            attackingBodyPart != null) {
                          onGoClicked();
                        }
                      },
                      child: Center(
                          child: Text(
                        "GO".toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16),
                      )),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16)
            ],
          ),
          SizedBox(height: 14),
        ],
      ),
    );
  }

  bool _isGoButtonEnabled() {
    return defendingBodyPart != null && attackingBodyPart != null;
  }

  void _selectDefendingBodyPart(BodyPart value) {
    setState(() {
      defendingBodyPart = value;
    });
  }

  void _selectAttackingBodyPart(BodyPart value) {
    setState(() {
      attackingBodyPart = value;
    });
  }

  void onGoClicked() {
    setState(() {
      defendingBodyPart = null;
      attackingBodyPart = null;
    });
  }
}

class PlayerHPWidget extends StatelessWidget {
  final String name;

  const PlayerHPWidget({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(name),
        SizedBox(height: 11),
        Text("1"),
        Text("1"),
        Text("1"),
        Text("1"),
        Text("1"),
      ],
    );
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
                ? Color.fromRGBO(28, 121, 206, 1)
                : MyColors.BUTTON_GREY_COLOR,
            child: Center(
                child: Text(
              bodyPart.name.toUpperCase(),
              style:
                  TextStyle(color: selected ? Colors.white : Color(0xFF060D14)),
            ))),
      ),
    );
  }
}

class MyColors {
  static const Color BUTTON_GREY_COLOR = Color.fromRGBO(0, 0, 0, 0.38);
}
