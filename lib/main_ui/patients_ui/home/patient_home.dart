import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:makhosi_app/main_ui/general_ui/audio_call.dart';
import 'package:makhosi_app/main_ui/general_ui/call_page.dart';
import 'package:makhosi_app/main_ui/patients_ui/other/patient_chat_screen.dart';
import 'package:makhosi_app/providers/notificaton.dart';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:makhosi_app/main_ui/patients_ui/profile_screens/patient_profile_screen.dart';
import 'package:makhosi_app/tabs/all_tab.dart';
import 'package:makhosi_app/tabs/bookings_tab.dart';
import 'package:makhosi_app/tabs/favorites_tab.dart';
import 'package:makhosi_app/tabs/nearby_practitioners_tab.dart';
import 'package:makhosi_app/tabs/patient_inbox_tab.dart';
import 'package:makhosi_app/utils/app_colors.dart';
import 'package:makhosi_app/utils/app_keys.dart';
import 'package:makhosi_app/utils/navigation_controller.dart';
import 'package:makhosi_app/utils/others.dart';
import 'package:makhosi_app/utils/pickup_call_screen.dart';
import 'package:provider/provider.dart';
import 'package:makhosi_app/utils/app_dialogues.dart';


class PatientHome extends StatefulWidget {
  @override
  _PatientHomeState createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  DocumentSnapshot _userProfileSnapshot;
  String _uid;

  void initState() {
    Others.clearImageCache();
    _getUserProfileData();
    super.initState();

    context.read<NotificationProvider>().firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        List msgArr = message['notification']['title'].split(" ");

        if (Platform.isIOS) {
        } else {
          switch (message['data']['type']) {
            case 'voice':
              NavigationController.push(
                  context,
                  PickupCall(
                      title: 'Incoming Voice Call',
                      label: msgArr.last,
                      type: 'voice'));

              break;
            case 'video':
              NavigationController.push(
                  context,
                  PickupCall(
                      title: 'Incoming Video Call',
                      label: msgArr.last,
                      type: 'video'));

              break;
            case 'text':
              context.read<NotificationProvider>().showNotification(
                  message['notification']['title'],
                  message['notification']['body']);

              break;
            default:
          }
        }

        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        if (Platform.isIOS) {
        } else {
          switch (message['data']['type']) {
            case 'voice':
              NavigationController.push(
                  context,
                  AudioCall(
                      channelName: 'voice_call', role: ClientRole.Broadcaster));
              break;
            case 'video':
              NavigationController.push(
                  context,
                  CallPage(
                    channelName: 'voice_call',
                    role: ClientRole.Broadcaster,
                  ));
              break;
            case 'text':
              NavigationController.push(context,
                  PatientChatScreen(message['data']['practitionerUid']));

              break;
            default:
          }
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

        if (Platform.isIOS) {
        } else {
          switch (message['data']['type']) {
            case 'voice':
              NavigationController.push(
                  context,
                  AudioCall(
                      channelName: 'voice_call', role: ClientRole.Broadcaster));
              break;
            case 'video':
              NavigationController.push(
                  context,
                  CallPage(
                    channelName: 'voice_call',
                    role: ClientRole.Broadcaster,
                  ));
              break;
            case 'text':
              NavigationController.push(context,
                  PatientChatScreen(message['data']['practitionerUid']));

              break;
            default:
          }
        }
      },
    );
  }

  onMessageDialog(
      {BuildContext context, String title, String label, Function onAccept}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(label),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Reject'),
          ),
          FlatButton(
            onPressed: onAccept,
            child: Text('Accept'),
          ),
        ],
      ),
    );
  }

  Future<void> _getUserProfileData() async {
    _uid = FirebaseAuth.instance.currentUser.uid;
    _userProfileSnapshot =
        await FirebaseFirestore.instance.collection('patients').doc(_uid).get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            _userProfileSnapshot == null
                ? 'Customer Dashboard'
                : _userProfileSnapshot.get(AppKeys.FULL_NAME),
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                if (_userProfileSnapshot != null)
                  NavigationController.push(
                    context,
                    PatientProfileScreen(_userProfileSnapshot, false),
                  );
              },
              child: Container(
                padding: EdgeInsets.only(top: 12, bottom: 12),
                margin: EdgeInsets.only(right: 16),
                child: _userProfileSnapshot != null &&
                    _userProfileSnapshot.get(AppKeys.PROFILE_IMAGE) != null
                    ? CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    _userProfileSnapshot.get(AppKeys.PROFILE_IMAGE),
                  ),
                )
                    : Icon(Icons.person),
              ),
            ),
          ],
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          bottom: TabBar(
            isScrollable: true,
            indicator: BubbleTabIndicator(
              indicatorHeight: 25.0,
              indicatorColor: AppColors.COLOR_PRIMARY,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
            ),
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(
                child: Text('All'),
              ),
              Tab(
                child: Text('Nearby Businesses'),
              ),
              Tab(
                child: Text('Favorites'),
              ),
              Tab(
                child: Text('Inbox'),
              ),
              Tab(
                child: Text('Appointments'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            AllTab(),
            NearbyPractitionersTab(),
            FavoritesTab(),
            PatientInboxTab(),
            BookingsTab(),
          ],
        ),
      ),
    );
  }
}