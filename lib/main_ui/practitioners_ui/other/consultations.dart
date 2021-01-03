import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:makhosi_app/main_ui/practitioners_ui/chat/practitioner_chat_screen.dart';
import 'package:makhosi_app/utils/app_colors.dart';
import 'package:makhosi_app/utils/navigation_controller.dart';

class Consultations extends StatefulWidget {
  @override
  _ConsultationsState createState() => _ConsultationsState();
}

enum Sort { onlineClient, newClient, oldClient }

class _ConsultationsState extends State<Consultations>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  List<DocumentSnapshot> _newClientList = [];

  Sort _sortBy = Sort.onlineClient;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // _getConsultationsNewClientData();
    // _getConsultationsOldClientData();
    _getConsultationsOnlineData();

    _controller = AnimationController(vsync: this);
  }

  Future<void> _getConsultationsNewClientData() async {
    setState(() {
      isLoading = true;
    });
    // _uid = FirebaseAuth.instance.currentUser.uid;
    var _newClientSnapshot = await FirebaseFirestore.instance
        .collection("consultations")
        .orderBy("creation_date", descending: true)
        .get();

    setState(() {
      _newClientList = _newClientSnapshot.docs;
      isLoading = false;
    });
  }

  Future<void> _getConsultationsOldClientData() async {
    setState(() {
      isLoading = true;
    });
    // _uid = FirebaseAuth.instance.currentUser.uid;
    var _oldClientSnapshot = await FirebaseFirestore.instance
        .collection("consultations")
        .orderBy("creation_date", descending: false)
        .get();

    setState(() {
      _newClientList = _oldClientSnapshot.docs;
      isLoading = false;
    });
  }

  Future<void> _getConsultationsOnlineData() async {
    setState(() {
      isLoading = true;
    });
    // _uid = FirebaseAuth.instance.currentUser.uid;
    var _onlineSnapshot = await FirebaseFirestore.instance
        .collection("consultations")
        .where("online", isEqualTo: true)
        .get();

    setState(() {
      _newClientList = _onlineSnapshot.docs;
      isLoading = false;
    });
  }

  // }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget createbox(DocumentSnapshot client) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            NavigationController.push(
              context,
              PractitionerChatScreen(
                client.get("user_id"),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  spreadRadius: 7,
                  color: Colors.grey[100],
                )
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  client.get("name"),
                  style: TextStyle(
                    color: AppColors.SMALL_TEXT,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0,
                    fontFamily: 'Montserrat',
                  ),
                ),
                Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          leading: IconButton(
            iconSize: 41.0,
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_forward),
              iconSize: 41,
              color: Colors.black,
              tooltip: 'Increase volume by 10',
              onPressed: () {
                setState(() {});
              },
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                child: Text(
                  'Today ‘s sessions',
                  style: TextStyle(
                    color: AppColors.BOLDTEXT_COLOR,
                    fontSize: 26.0,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                title: const Text(
                  'New Clients and In-Person',
                  style: TextStyle(
                    color: AppColors.NORMAL_TEXT,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                    fontFamily: 'Montserrat',
                  ),
                ),
                leading: Radio(
                  value: Sort.newClient,
                  groupValue: _sortBy,
                  onChanged: (newCli) async {
                    await _getConsultationsNewClientData();
                    setState(() {
                      _sortBy = newCli;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text(
                  'Online',
                  style: TextStyle(
                    color: AppColors.NORMAL_TEXT,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                    fontFamily: 'Montserrat',
                  ),
                ),
                leading: Radio(
                  value: Sort.onlineClient,
                  groupValue: _sortBy,
                  onChanged: (onli) async {
                    await _getConsultationsOnlineData();
                    setState(() {
                      _sortBy = onli;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text(
                  'Old Clients',
                  style: TextStyle(
                    color: AppColors.NORMAL_TEXT,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                    fontFamily: 'Montserrat',
                  ),
                ),
                leading: Radio(
                  value: Sort.oldClient,
                  groupValue: _sortBy,
                  onChanged: (old) async {
                    await _getConsultationsOldClientData();
                    setState(() {
                      _sortBy = old;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView(
                        shrinkWrap: true,
                        children: _newClientList
                            .map<Widget>(
                              (client) => createbox(client),
                            )
                            .toList(),
                      ),
              ),
            ],
          ),
        )
        // ],
        // )),
        );
  }
}
