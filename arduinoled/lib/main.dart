import 'package:arduinoled/homeScreen.dart';
import 'package:arduinoled/settingScreen.dart';
import 'package:flutter/material.dart';
import 'moodScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int indexNav = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> wid = new List<Widget>();
    wid.addAll({HomeScreen(), MoodScreen(), SettingScreen()});
    return Scaffold(
      backgroundColor: Colors.white,
      body: wid.elementAt(indexNav),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood),
            label: 'moods',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        currentIndex: indexNav,
        selectedItemColor: Colors.black,
        onTap: (value) {
          setState(() {
            indexNav = value;
          });
        },
      ),
    );
  }
}
