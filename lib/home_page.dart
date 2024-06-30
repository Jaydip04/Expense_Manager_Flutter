import 'dart:async';
import 'dart:io';

import 'package:expense_manager/SideMenuBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '';

import 'common/alert_dialog.dart';
import 'common/toast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final mIncomeDatabase = FirebaseDatabase.instance.ref("IncomeData").child(FirebaseAuth.instance.currentUser!.uid);
  final mExpenseDatabase = FirebaseDatabase.instance.ref("ExpenseData").child(FirebaseAuth.instance.currentUser!.uid);
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int _currentIndex = 0;
  final amountController = TextEditingController();
  final typeController = TextEditingController();
  final noteController = TextEditingController();
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
                builder: (context) => alert_dialog(titleText: "Add Expense",databaseReference: mExpenseDatabase,));
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
            icon: Icon(Icons.remove),
            label: 'Add Expense',
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
                    ]),
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
                                "Expense Manager",
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
              SizedBox(height: 10,),
              Center(child: Text("Income",style: TextStyle(color: Colors.green,fontSize: 28,fontWeight: FontWeight.bold),)),
              SizedBox(height: 10,),
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
              SizedBox(height: 10,),
              Center(child: Text("Expense",style: TextStyle(color: Colors.red,fontSize: 28,fontWeight: FontWeight.bold),)),
              SizedBox(height: 10,),
              Expanded(
                child: FirebaseAnimatedList(
                  query: mExpenseDatabase,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    return Card(
                      color: Colors.black,
                      child: ListTile(
                        title: Text(snapshot.child("type").value.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                        subtitle: Text(snapshot.child("note").value.toString(),style: TextStyle(color: Colors.white,fontWeight:FontWeight.w500,fontSize: 14),),
                        leading: Text(snapshot.child("date").value.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                        trailing: Text(snapshot.child("amount").value.toString(),style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18),),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
