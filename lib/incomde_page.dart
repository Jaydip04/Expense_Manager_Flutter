import 'package:expense_manager/common/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ItemModel.dart';
import 'SideMenuBar.dart';
import 'common/alert_dialog.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}
class _IncomePageState extends State<IncomePage> {
  final mIncomeDatabase = FirebaseDatabase.instance.ref("IncomeData").child(FirebaseAuth.instance.currentUser!.uid);

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int _currentIndex = 0;
  List<ItemModel> item = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawerEnableOpenDragGesture: true,
      key: _drawerKey,
      drawer: const SideMenu(),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (_currentIndex == 0) {
            showCupertinoDialog(
                context: context,
                // barrierDismissible: false,
                builder: (context) => alert_dialog(titleText: "Add Income",databaseReference: mIncomeDatabase,));
          } else if (_currentIndex == 1) {
            showCupertinoDialog(
                context: context,
                // barrierDismissible: false,
                builder: (context) => AlertDialog(
              title: Text("Clear all Income?",
                style: commonTextStyletitle(),
              ),
              content: Text("Are you sure!",style: commonTextStyle16(),),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: commonElevatedButton(),
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
                      style: commonElevatedButton(),
                      onPressed: () {
                        mIncomeDatabase.remove().then((onValue){
                          showToast(message: "Clear all Income");
                        }).catchError((onError){
                          showToast(message: "some error occured");
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text("Clear", style: commonTextStyle18()),
                    ),
                  ],
                )
              ],
              elevation: 24.0,
              backgroundColor: Colors.white,
            ),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
            ),
            label: 'Add Income',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.clear_all),
            label: 'Clear All Income',
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // margin: EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width,
                height: 55,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    // borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 1,
                        // blurRadius: 3,
                      )
                    ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              _drawerKey.currentState!.openDrawer();
                            },
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.white,
                            )),
                        const SizedBox(
                          width: 16,
                        ),
                        const SizedBox(
                          height: 55,
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Income",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: FirebaseAnimatedList(
                  query: mIncomeDatabase,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                      return Card(
                        color: Colors.black,
                        child: ListTile(
                          title: Text(snapshot.child("type").value.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                          subtitle: Text(snapshot.child("note").value.toString(),style: TextStyle(color: Colors.white,fontWeight:FontWeight.w500,fontSize: 14),),
                          leading: Text(snapshot.child("date").value.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                          trailing: Text(snapshot.child("amount").value.toString(),style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 18),),
                        ),
                      );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
  ButtonStyle commonElevatedButton() {
    return ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: Size(MediaQuery.of(context).size.width / 4, 40));
  }
}