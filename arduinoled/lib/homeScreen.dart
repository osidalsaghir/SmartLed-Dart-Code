import 'package:flutter/material.dart';
import 'fireBase.dart' as Fobj;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  FirebaseDatabase database = new FirebaseDatabase();
  Fobj.FireBaseOrg fireB = new Fobj.FireBaseOrg();
  Color c = Color.fromRGBO(0, 0, 0, 1.0);
  List<double> rgb = new List<double>();
  List<Color> mood = new List<Color>();
  bool moodORstatic = false;
  int indexNav = 0;
  bool ledOnOFF = false;
  var dataColor;
  bool downloadend = true;
  bool errorView = false;
  bool isitMood = false;
  @override
  void initState() {
    rgb.insert(0, 0);
    rgb.insert(1, 0);
    rgb.insert(2, 0);
    getColors();
    getStaticOrMoode();
    super.initState();
  }

  Future<void> getStaticOrMoode() async {
    setState(() {
      downloadend = true;
    });
    isitMood = await fireB.getMoodOrStatic();
    setState(() {
      downloadend = false;
    });
  }

  Future<void> getColors() async {
    setState(() {
      downloadend = true;
    });

    ledOnOFF = await fireB.turnedOnOrOff();

    if (!ledOnOFF) {
      setState(() {
        c = Color.fromRGBO(0, 0, 0, 1.0);
      });
    } else {
      dataColor = await fireB.getColors();
      rgb.clear();
      setState(() {
        rgb.insert(0, dataColor.value["Blue"].toDouble());
        rgb.insert(1, dataColor.value["Red"].toDouble());
        rgb.insert(2, dataColor.value["Green"].toDouble());
        c = Color.fromRGBO(rgb.elementAt(1).toInt(), rgb.elementAt(2).toInt(),
            rgb.elementAt(0).toInt(), 1.0);
      });
    }

    setState(() {
      downloadend = false;
    });
  }

  Future<void> turnOnOff() async {
    setState(() {
      downloadend = true;
    });
    fireB.setTurnOnOff(ledOnOFF);
    await getColors();
    setState(() {
      downloadend = false;
    });
  }

  void colorsValuse(List<double> rgb) {
    setState(() {
      c = Color.fromRGBO(rgb.elementAt(1).toInt(), rgb.elementAt(2).toInt(),
          rgb.elementAt(0).toInt(), 1.0);
    });
    fireB.setColorValues(rgb);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: home(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showMyDialog();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
        ));
  }

  Widget home(context) {
    final spinkit = SpinKitSquareCircle(
      color: Colors.blue,
      size: 50.0,
      controller: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 1200)),
    );
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Costumize your color",
                style: TextStyle(fontSize: 25, color: Colors.grey[600]),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              AnimatedContainer(
                width: width - 20,
                height: 200,
                decoration: BoxDecoration(
                  color: c,
                  borderRadius: BorderRadius.circular(30),
                ),
                duration: Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isitMood
                          ? Text(
                              "Mood is on",
                              style: TextStyle(fontSize: 25),
                            )
                          : Text(
                              "Static color is on",
                              style: TextStyle(fontSize: 25),
                            ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      Text(
                        "RGB(${rgb.elementAt(1)},${rgb.elementAt(2)},${rgb.elementAt(0)})",
                        style: TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                ),
              ),
              Slider(
                  value: rgb.elementAt(0),
                  activeColor: Colors.blue,
                  min: 0,
                  max: 255,
                  divisions: 255,
                  label: rgb.elementAt(0).toString(),
                  onChanged: (double value) {
                    setState(() {
                      if (!ledOnOFF) value = 0;
                      rgb.removeAt(0);
                      rgb.insert(0, value);
                      if (ledOnOFF) {
                        colorsValuse(rgb);
                      }
                    });
                  }),
              Slider(
                  activeColor: Colors.red,
                  value: rgb.elementAt(1),
                  min: 0,
                  max: 255,
                  divisions: 255,
                  label: rgb.elementAt(1).toString(),
                  onChanged: (double value) {
                    setState(() {
                      if (!ledOnOFF) value = 0;
                      rgb.removeAt(1);
                      rgb.insert(1, value);
                      if (ledOnOFF) {
                        colorsValuse(rgb);
                      }
                    });
                  }),
              Slider(
                  activeColor: Colors.green,
                  value: rgb.elementAt(2),
                  min: 0,
                  max: 255,
                  divisions: 255,
                  label: rgb.elementAt(2).toString(),
                  onChanged: (double value) {
                    setState(() {
                      if (!ledOnOFF) value = 0;
                      rgb.removeAt(2);
                      rgb.insert(2, value);
                      if (ledOnOFF) {
                        colorsValuse(rgb);
                      }
                    });
                  }),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              AnimatedContainer(
                width: 80,
                height: 50,
                decoration: BoxDecoration(
                  color: !ledOnOFF ? c : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                duration: Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: Center(
                  child: FlatButton(
                    child: !ledOnOFF
                        ? Text(
                            "OFF",
                            style: TextStyle(color: Colors.white),
                          )
                        : Text("OFF"),
                    onPressed: () {
                      setState(() {
                        rgb.clear();
                        rgb.insert(0, 0);
                        rgb.insert(1, 0);
                        rgb.insert(2, 0);
                        c = Color.fromRGBO(0, 0, 0, 1.0);
                        ledOnOFF = false;
                        turnOnOff();
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              AnimatedContainer(
                width: 80,
                height: 50,
                decoration: BoxDecoration(
                  color: ledOnOFF ? c : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                duration: Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: Center(
                  child: FlatButton(
                    child: Text("ON"),
                    onPressed: () {
                      setState(() {
                        c = Color.fromRGBO(
                            rgb.elementAt(1).toInt(),
                            rgb.elementAt(2).toInt(),
                            rgb.elementAt(0).toInt(),
                            1.0);
                        ledOnOFF = true;
                        turnOnOff();
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              AnimatedContainer(
                width: isitMood ? 110 : 130,
                height: 50,
                decoration: BoxDecoration(
                  color: ledOnOFF ? c : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                duration: Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: Center(
                  child: FlatButton(
                    child: isitMood
                        ? Text(
                            "mood",
                            style: TextStyle(fontSize: 15),
                          )
                        : Text(
                            "static color",
                            style: TextStyle(fontSize: 15),
                          ),
                    onPressed: () {
                      setState(() {
                        if (ledOnOFF) {
                          isitMood = !isitMood;
                          fireB.setMoodOrStatic(isitMood);
                        }
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
            ],
          ),
        ),
        downloadend
            ? Container(
                width: width,
                height: height,
                color: Colors.black54,
                child: spinkit)
            : SizedBox(),
      ],
    );
  }

  Future<void> _showMyDialog() async {
    String name = "";
    String error = "Please enter a name for color to be saved.";
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose a name for this color'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                errorView
                    ? Text(error, style: TextStyle(color: Colors.red))
                    : Text(""),
                Text("Enter a name for your color"),
                TextField(
                  onChanged: (value) => name = value,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    errorView = false;
                  });
                }),
            TextButton(
              child: Text('Approve'),
              onPressed: () {
                if (name.isEmpty) {
                  setState(() {
                    errorView = true;
                  });
                  Navigator.of(context).pop();
                  _showMyDialog();
                } else {
                  fireB.setAndSaveColors(name, rgb);
                  Navigator.of(context).pop();
                  setState(() {
                    errorView = false;
                  });
                }

                //fireB.setAndSaveColors(rgb);
              },
            ),
          ],
        );
      },
    );
  }
}
