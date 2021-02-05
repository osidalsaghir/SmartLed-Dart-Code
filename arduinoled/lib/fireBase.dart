import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FireBaseOrg {
  List<double> rgb = new List<double>();
  FirebaseDatabase database = new FirebaseDatabase();
  FireBaseOrg();

  Future<DataSnapshot> getColors() async {
    var dataColor;

    await database.reference().child('rgb').once().then((value) {
      dataColor = value;
    });

    return dataColor;
  }

  Future<void> setColorValues(List<double> rgb) async {
    database.reference().child('rgb').set(<String, int>{
      "Blue": rgb.elementAt(0).toInt(),
      "Red": rgb.elementAt(1).toInt(),
      "Green": rgb.elementAt(2).toInt()
    }).then((value) => print(rgb.toString() + "\n"));
  }

  Future<bool> turnedOnOrOff() async {
    bool ledOnOFF;
    await database.reference().child('ON\OFF').once().then((value) {
      value.value["isITOn"] == 1 ? ledOnOFF = true : ledOnOFF = false;
    });
    return ledOnOFF;
  }

  void setTurnOnOff(ledOnOFF) {
    int onoff;
    ledOnOFF ? onoff = 1 : onoff = 0;
    database
        .reference()
        .child('ON\OFF')
        .set(<String, int>{"isITOn": onoff}).then((value) => print(ledOnOFF));
  }

  Future<void> setAndSaveColors(String name, List<double> rgb) async {
    database.reference().child('rgbSaved').push().set({
      "Name": name,
      "Blue": rgb.elementAt(0).toInt(),
      "Red": rgb.elementAt(1).toInt(),
      "Green": rgb.elementAt(2).toInt()
    });
  }

  Future<DataSnapshot> getSaveColors() async {
    var dataColor;

    await database.reference().child('rgbSaved').once().then((value) {
      dataColor = value;
    });

    return dataColor;
  }

  Future<void> deleteSaveColors(String key) async {
    try {
      await database.reference().child("rgbSaved").child(key).remove();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> getMoodOrStatic() async {
    bool isMoode;

    await database.reference().child('moodORstatic').once().then((value) {
      isMoode = value.value["isItMood"];
    });

    return isMoode;
  }

  Future<void> setMoodOrStatic(moodOrstatic) async {
    database.reference().child('moodORstatic').set({
      "isItMood": moodOrstatic,
    });
  }

  Future<void> setMoodOn(String name, List<double> rgb) async {
    database.reference().child('moodOn').set({
      "red1": rgb.elementAt(0),
      "green1": rgb.elementAt(1),
      "blue1": rgb.elementAt(2),
      "red2": rgb.elementAt(3),
      "green2": rgb.elementAt(4),
      "blue2": rgb.elementAt(5),
      "red3": rgb.elementAt(6),
      "green3": rgb.elementAt(7),
      "blue3": rgb.elementAt(8),
    });
  }


}
