import 'package:arduinoled/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'MoodFormate.dart';
import 'fireBase.dart' as Fobj;
import 'ColorsFormate.dart';

class MoodScreen extends StatefulWidget {
  @override
  _MoodScreenState createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> with TickerProviderStateMixin {
  AnimationController _controller;

  List<MoodFormate> moodsNames = new List<MoodFormate>();
  List<ColorsFormate> colorsFormate = new List<ColorsFormate>();
  Fobj.FireBaseOrg fireB = new Fobj.FireBaseOrg();
  final key = GlobalKey<AnimatedListState>();
  final key2 = GlobalKey<AnimatedListState>();
  List<double> rgb = new List<double>();
  bool downloadSavedColor = true;
  @override
  void initState() {
    moodsNames = [
      MoodFormate(name: "Happy", colors: [200, 10, 90, 60, 45, 70, 90, 60, 20]),
      MoodFormate(
          name: "Sad", colors: [100, 150, 90, 250, 20, 70, 90, 60, 200]),
      MoodFormate(
          name: "Romantic", colors: [44, 150, 90, 250, 10, 70, 90, 60, 50]),
      MoodFormate(
          name: "Work", colors: [170, 20, 90, 250, 200, 70, 90, 60, 50]),
      MoodFormate(name: "Calm", colors: [20, 6, 90, 250, 20, 70, 40, 60, 100]),
      MoodFormate(
          name: "Relax", colors: [10, 150, 20, 250, 200, 40, 20, 60, 207]),
      MoodFormate(name: "Sleep", colors: [30, 6, 90, 20, 100, 70, 5, 60, 22]),
      MoodFormate(
          name: "Morning", colors: [200, 13, 90, 250, 2, 70, 90, 20, 22]),
      MoodFormate(
          name: "Evning", colors: [60, 40, 200, 120, 10, 70, 90, 60, 23]),
    ];
    getColors();
    super.initState();

    print(colorsFormate.length);
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return moods(context);
  }

  Future<void> getColors() async {
    colorsFormate.clear();
    var dataColor = await fireB.getSaveColors();
    try {
      var KEYS = dataColor.value.keys;
      var Data = dataColor.value;
      setState(() {
        for (var key in KEYS) {
          colorsFormate.add(ColorsFormate(
            key: key.toString(),
            name: Data[key]["Name"],
            blue: Data[key]["Blue"],
            red: Data[key]["Red"],
            green: Data[key]["Green"],
          ));
        }
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloadSavedColor = false;
    });
  }

  Widget moods(BuildContext context) {
    final spinkit = SpinKitSquareCircle(
      color: Colors.blue,
      size: 50.0,
      controller: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 1200)),
    );
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 25),
          ),
          Center(
            child: Text("Choose Your Mood",
                style: TextStyle(fontSize: 25, color: Colors.grey[600])),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Container(
            width: width,
            height: height / 3,
            color: Colors.white,
            child: AnimatedList(
                key: key,
                scrollDirection: Axis.horizontal,
                initialItemCount: moodsNames.length,
                itemBuilder: (context, index, animation) {
                  return FlatButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      width: 200,
                      height: height / 3.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                            image: AssetImage("photos\\mood.jpg"),
                            fit: BoxFit.fill,
                            colorFilter: ColorFilter.mode(
                                Colors.black87, BlendMode.hardLight)),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.9),
                            spreadRadius: 5,
                            blurRadius: 5,
                            offset: Offset(0, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          moodsNames[index].name,
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        fireB.setMoodOn(
                            moodsNames[index].name, moodsNames[index].colors);
                      });
                    },
                  );
                }),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Center(
            child: Text("Saved Colors",
                style: TextStyle(fontSize: 25, color: Colors.grey[600])),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Container(
            width: width,
            height: height / 3,
            color: Colors.white,
            child: downloadSavedColor
                ? Container(
                    width: width,
                    height: height,
                    color: Colors.white24,
                    child: spinkit)
                : AnimatedList(
                    key: key2,
                    scrollDirection: Axis.horizontal,
                    initialItemCount: colorsFormate.length,
                    itemBuilder: (context, index, animation) {
                      return FlatButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          width: 200,
                          height: height / 3.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                                image: AssetImage("photos\\mood.jpg"),
                                fit: BoxFit.fill,
                                colorFilter: ColorFilter.mode(
                                    Colors.black87, BlendMode.hardLight)),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.9),
                                spreadRadius: 5,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 5), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              colorsFormate[index].name.toString(),
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            ),
                          ),
                        ),
                        onPressed: () {
                          rgb.clear();
                          rgb.insert(0, colorsFormate[index].blue.toDouble());
                          rgb.insert(1, colorsFormate[index].red.toDouble());
                          rgb.insert(2, colorsFormate[index].green.toDouble());
                          fireB.setColorValues(rgb);
                        },
                        onLongPress: () {
                          _showMyDialog(index);
                        },
                      );
                    }),
          ),
        ],
      ),
    );
  }

  Future<void> _showMyDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want to delete the saved color ? '),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: Text('Approve'),
              onPressed: () {
                fireB.deleteSaveColors(colorsFormate[index].key);
                setState(() {
                  getColors();
                  downloadSavedColor = true;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
