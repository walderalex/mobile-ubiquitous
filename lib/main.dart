import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffD96C2A),
          brightness: Brightness.dark,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Accessible Home'),
        ),
        body: const Home(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  static HomeState of(BuildContext context) {
    return context.findAncestorStateOfType<HomeState>()!;
  }

  late String homeName;
  late List<String> availableHomes;
  late Map<String, List<Room>> rooms;

  @override
  void initState() {
    super.initState();
    homeName = 'Default';
    availableHomes = ["Default", "Birmingham", "London", "Bristol"];
    const d = [
      Room(name: 'Kitchen', things: [
        Thing(
          name: "Ceil. Lights",
          icon: Icons.light,
        ),
        Thing(
          name: "Blinds",
          icon: Icons.vertical_split_outlined,
        ),
        Thing(
          name: "Lamp",
          icon: Icons.lightbulb,
        ),
        Thing(
          name: "Window",
          icon: Icons.grid_view,
        ),
      ]),
      Room(name: 'Bedroom', things: [
        Thing(
          name: "Lights",
          icon: Icons.light,
        ),
        Thing(
          name: "Lamp 1",
          icon: Icons.lightbulb,
        ),
        Thing(
          name: "Lamp 2",
          icon: Icons.lightbulb_outline,
        ),
        Thing(
          name: "Window",
          icon: Icons.grid_view,
        ),
        Thing(
          name: "Blinds",
          icon: Icons.vertical_split,
        ),
      ]),
      Room(
        name: 'Lounge',
        things: [
          Thing(
            name: "Window",
            icon: Icons.grid_view,
          ),
          Thing(
            name: "Blinds",
            icon: Icons.vertical_split,
          ),
          Thing(
            icon: Icons.light_outlined,
            name: "Lights",
          ),
        ],
      ),
    ];
    rooms = {
      "Default": d,
      "Birmingham": d,
      "London": [],
      "Bristol": [],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          value: homeName,
          items: availableHomes
              .map(
                (e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ),
              )
              .toList(),
          onChanged: (home) {
            setState(() {
              homeName = home.toString();
            });
          },
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) => rooms[homeName]![index],
            itemCount: rooms[homeName]!.length,
          ),
        ),
      ],
    );
  }
}

class Room extends StatelessWidget {
  final String name;
  final List<Thing> things;

  static String? of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<Room>()?.name;

  const Room({
    Key? key,
    required this.name,
    required this.things,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: Text(name, style: Theme.of(context).textTheme.titleLarge),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => things[index],
            itemCount: things.length,
          ),
        ),
      ],
    );
  }
}

class Thing extends StatelessWidget {
  final String name;
  final IconData icon;
  const Thing({Key? key, required this.icon, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final room = Room.of(context);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox.square(
        dimension: 100,
        child: Material(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ThingControl(
                    name: name,
                    room: room ?? 'Accessible Home',
                  ),
                ),
              );
            },
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 50,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    name,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ThingControl extends StatefulWidget {
  final String name;
  final String room;
  const ThingControl({
    Key? key,
    required this.name,
    required this.room,
  }) : super(key: key);

  @override
  State<ThingControl> createState() => _ThingControlState();
}

class _ThingControlState extends State<ThingControl> {
  late int value;
  static const max = 100;

  @override
  void initState() {
    super.initState();
    value = Random().nextInt(max);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            height: 20,
          ),
          Slider(
            value: value.toDouble(),
            onChanged: (v) {
              setState(() {
                value = v.round();
              });
            },
            max: max.toDouble(),
            min: 0,
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: (() {
                  if (value == 0) {
                    return;
                  }
                  setState(
                    () {
                      value--;
                    },
                  );
                }),
                child: const Text('-'),
              ),
              const SizedBox(
                width: 20,
              ),
              OutlinedButton(
                child: const Text('+'),
                onPressed: () {
                  if (value == max) {
                    return;
                  }
                  setState(() {
                    value++;
                  });
                },
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            widget.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
