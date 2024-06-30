import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expense_manager/common/toast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../ItemModel.dart';


class alert_dialog extends StatefulWidget {
  final DatabaseReference databaseReference;
  final String titleText;
  const alert_dialog({
    super.key,
    required this.titleText,
    required this.databaseReference,
  });

  @override
  State<alert_dialog> createState() => _alert_dialogState();
}

class _alert_dialogState extends State<alert_dialog> {
  final amountController = TextEditingController();
  final typeController = TextEditingController();
  final noteController = TextEditingController();
  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;
  List<ItemModel> item = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 5),
      child: SingleChildScrollView(
        child: AlertDialog(
          title: Text(
            widget.titleText,
            style: commonTextStyletitle(),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            //position
            mainAxisSize: MainAxisSize.min,
            // wrap content in flutter
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: commonTextStyle16(),
                cursorColor: Colors.black,
                decoration: commonInputDecoration("Enter Amount"),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: typeController,
                keyboardType: TextInputType.text,
                style: commonTextStyle16(),
                cursorColor: Colors.black,
                decoration: commonInputDecoration("Enter Type"),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: noteController,
                keyboardType: TextInputType.text,
                style: commonTextStyle16(),
                cursorColor: Colors.black,
                decoration: commonInputDecoration("Enter Note"),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize:
                          Size(MediaQuery.of(context).size.width / 4, 40)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: commonTextStyle18(),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: Size(MediaQuery.of(context).size.width / 4, 40)),
                  onPressed: () {

                    switch (_source.keys.toList()[0]) {
                      case ConnectivityResult.mobile:
                        // showToast(message: 'Mobile: Online');
                        if (amountController.text.isEmpty) {
                          showToast(message: "Please Enter Amount Fields");
                          return;
                        } else if (typeController.text.isEmpty) {
                          showToast(message: "Please Enter Type Fields");

                          return; //Don't proceed with adding data
                        } else if (noteController.text.isEmpty) {
                          showToast(message: "Please Enter Note Fields");
                          return; //Don't proceed with adding data
                        }
                        var now = DateTime.now();
                        final userDatabase =  widget.databaseReference.child(widget.databaseReference.push().key!);
                        final newUser = ItemModel(
                          amount: amountController.text.toString(),
                          type: typeController.text.toString(),
                          date: DateFormat.yMMMMd().format(now).toString(),
                          note: noteController.text.toString(),
                          id: widget.databaseReference.push().key!,
                        ).toJson();

                        userDatabase.set(newUser);
                        showToast(message: widget.titleText);
                        Navigator.of(context).pop();
                        amountController.clear();
                        typeController.clear();
                        noteController.clear();
                        FocusScope.of(context).unfocus();
                        break;
                      case ConnectivityResult.wifi:
                        // showToast(message: 'WiFi: Online');
                        if (amountController.text.isEmpty) {
                          showToast(message: "Please Enter Amount Fields");
                          return;
                        } else if (typeController.text.isEmpty) {
                          showToast(message: "Please Enter Type Fields");

                          return; //Don't proceed with adding data
                        } else if (noteController.text.isEmpty) {
                          showToast(message: "Please Enter Note Fields");
                          return; //Don't proceed with adding data
                        }
                        var now = DateTime.now();
                        final userDatabase =  widget.databaseReference.child(widget.databaseReference.push().key!);
                        final newUser = ItemModel(
                          amount: amountController.text.toString(),
                          type: typeController.text.toString(),
                          date: DateFormat.yMMMMd().format(now).toString(),
                          note: noteController.text.toString(),
                          id: widget.databaseReference.push().key!,
                        ).toJson();

                        userDatabase.set(newUser);

                        showToast(message: widget.titleText);
                        Navigator.of(context).pop();
                        amountController.clear();
                        typeController.clear();
                        noteController.clear();
                        FocusScope.of(context).unfocus();
                        break;
                      case ConnectivityResult.none:
                      default:
                      showToast(message: 'Please check your internet Connection : Offline');
                    }
                    FocusScope.of(context).unfocus();
                  },
                  child: Text("Save", style: commonTextStyle18()),
                ),
              ],
            )
          ],
          elevation: 24.0,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
  // @override
  // void dispose() {
  //   _connectivity.disposeStream();
  //   super.dispose();
  // }
}

TextStyle commonTextStyletitle() {
  return TextStyle(
      fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black);
}

TextStyle commonTextStyle18() {
  return TextStyle(
      color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500);
}

TextStyle commonTextStyle16() {
  return TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}

InputDecoration commonInputDecoration(hint) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(width: 2)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(width: 2, color: Colors.red)),
    disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(width: 2, color: Colors.grey)),
    // contentPadding: EdgeInsets.only(
    //     left: 15, bottom: 11, top: 11, right: 15),
    hintText: hint,
  );
}

class MyConnectivity {
  MyConnectivity._();

  static final _instance = MyConnectivity._();
  static MyConnectivity get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;

  void initialise() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});
  }

  void disposeStream() => _controller.close();
}

