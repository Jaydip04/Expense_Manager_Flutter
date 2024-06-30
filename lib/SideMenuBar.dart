import 'package:expense_manager/authentication/login_page.dart';
import 'package:expense_manager/expense_page.dart';
import 'package:expense_manager/home_page.dart';
import 'package:expense_manager/incomde_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'common/toast.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final mIncomeDatabase = FirebaseDatabase.instance.ref("IncomeData").child(FirebaseAuth.instance.currentUser!.uid);
  final mExpenseDatabase = FirebaseDatabase.instance.ref("ExpenseData").child(FirebaseAuth.instance.currentUser!.uid);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 48,
                child: Center(
                  child: Text("Expense Manager",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25)),
                ),
              ),
              const Divider(color: Colors.white),
              sectionOne("Home", Icons.home, const HomePage()),
              const SizedBox(height: 5),
              sectionOne("Income", Icons.add, const IncomePage()),
              const SizedBox(height: 5),
              sectionOne("Expense", Icons.remove, const ExpensePage()),
              const SizedBox(height: 5),
              clearAll(),
              const SizedBox(height: 5),
              signOut(),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionOne(name, icon, pageContaxt) {
    return Container(
        margin: const EdgeInsets.only(right: 10),
        child: TextButton(
            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50)),
                ),
              ),
            ),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => pageContaxt));
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 27,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 27,
                  ),
                  Text(
                    name,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            )));
  }

  Widget signOut() {
    return Container(
        margin: const EdgeInsets.only(right: 10),
        child: TextButton(
            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50)),
                ),
              ),
            ),
            onPressed: () {
              {
                showCupertinoDialog(
                  context: context,
                  // barrierDismissible: false,
                  builder: (context) =>
                      AlertDialog(
                        title: Text(
                          "Sign Out?",
                          style: commonTextStyletitle(),
                        ),
                        content: Text(
                          "Are You Sure?",
                          style: commonTextStyle16(),
                        ),
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
                                  FirebaseAuth.instance.signOut();
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                      LoginPage()), (Route<dynamic> route) => false);
                                  showToast(message: "Successfully signed out");
                                },
                                child: Text(
                                    "Sign Out", style: commonTextStyle18()),
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
            child: Container(
              padding: const EdgeInsets.all(5),
              child: const Row(
                children: [
                  Icon(
                    Icons.power_settings_new,
                    size: 27,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 27,
                  ),
                  Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            )));
  }

  Widget clearAll() {
    return Container(
        margin: const EdgeInsets.only(right: 10),
        child: TextButton(
            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50)),
                ),
              ),
            ),
            onPressed: () {
              showCupertinoDialog(
                context: context,
                // barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: Text(
                    "Clear All Data?",
                    style: commonTextStyletitle(),
                  ),
                  content: Text(
                    "Are You Sure?\nClear All Income and Expense?",
                    style: commonTextStyle16(),
                  ),
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
                            mIncomeDatabase.remove();
                            mExpenseDatabase.remove();
                            Navigator.of(context).pop();
                            showToast(message: "Clear All Income and Expense");
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
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              child: const Row(
                children: [
                  Icon(
                    Icons.clear_all,
                    size: 27,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 27,
                  ),
                  Text(
                    "Clear All",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            )));
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
