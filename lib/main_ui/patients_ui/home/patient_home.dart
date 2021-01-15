import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:makhosi_app/main_ui/general_ui/audio_call.dart';
import 'package:makhosi_app/main_ui/general_ui/call_page.dart';
import 'package:makhosi_app/main_ui/patients_ui/other/patient_chat_screen.dart';
import 'package:makhosi_app/providers/notificaton.dart';
import 'package:makhosi_app/main_ui/patients_ui/other/patient_inbox_screen.dart';

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
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:makhosi_app/main_ui/general_ui/settingpage2.dart';

import 'package:shared_preferences/shared_preferences.dart';
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
final keyIsPatientHomeFirstLoaded = 'is_first_loaded';
     showDialogIfFirstLoaded(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLoaded = prefs.getBool(keyIsPatientHomeFirstLoaded);
    if (isFirstLoaded == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
                      title: new Text("Welcome!"),
            content: SingleChildScrollView(
              child: new Text(
          "I would like to take this opportunity thank you for signing up on the Mkhosi App, and becoming part of the Mkhosi Community, whether as a Potential Customer or a Service Provider. Mkhosi is shortened from “Hlaba umkhosi” which comes from the isiZulu language of South Africa which has multiple meanings including to send an SOS or to call for help or assistance or the clarion call. On its own, “Mkhosi” can mean a ceremony or festival as well as an army battalion.\n Applying this name to the App is because when you run a small business on your own, there are times when you feel like you need an army to assist you just to get through the daily tasks and to make sense of the do’s and don’ts of running your business. With that, when you have success, it does feel like there is a cause for a celebration, a festival. Our hope is that Mkhosi is able to support you in your journey to a sustainable business, being the support, you need when the going gets tough and the community that is always there to celebrate with you when the plan falls into place.\n The app is free for all Users who are joining or registration as Customers. As a Mkhosi Customer you have access to many service providers ranging from Traditional Healers to Mechanics. You will also have access to their work calendar which will enable you to seamlessly book for consultations either virtually or physically (or both). Additionally, we have also added a calling (video and voice) and payment feature for those who might want to purchase goods from the service providers.\nService Providers have three subscription options available for them, which are i. start-up, ii. Setup and iii. shine packages. These packages are based on access to some functionalities on the app which all will enable you to setup your business digitally. There are also many benefits of signing up as a Service Provider on the app, and you can find out more about this on the website: www.mkhosi.com\n Should have any questions or would like to engage with one of our team members, please do email us at: support@mkhosi.com  \nRegards\n\n,Amanda Gcabashe \nFounder & CEO",
          style: TextStyle(fontSize: 14),
        ),
      ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Dismiss"),
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                  prefs.setBool(keyIsPatientHomeFirstLoaded, false);
                },
              ),
            ],
          );
        },
      );
    }
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
  int currentIndex = 0;
  PageController _pageController;

  Widget decide()
  {
    if(currentIndex==0)
    {
      return PageView(
          controller: _pageController,
          onPageChanged: (_index) {
            setState(() => currentIndex = _index);
          },
          children: [
            AllTab(_userProfileSnapshot),
          ]
      );
    }
    else if(currentIndex==1)
    {
      return NearbyPractitionersTab();
    }
    else if(currentIndex==2)
    {
      return PractitionerInboxScreen();
    }
    else if(currentIndex==3)
    {
      return SettingPage();
    }
  }
  @override
  Widget build(BuildContext context) {
  Future.delayed(Duration.zero, () => showDialogIfFirstLoaded(context));
    return SafeArea(
          child: Scaffold(
        body:
        decide(),
        bottomNavigationBar: BottomNavyBar(
          backgroundColor: AppColors.COLOR_PRIMARY,
          selectedIndex: currentIndex,
          showElevation: true, // use this to remove appBar's elevation
          onItemSelected: (_index) => setState(() {
            currentIndex = _index;
          }),
          items: [

            BottomNavyBarItem(
                icon: Image.asset('images/a.png'),
                title: Text('Home'),
                activeColor: Colors.white,
                inactiveColor: Colors.black

            ),

            BottomNavyBarItem(
                icon: Image.asset('images/nearby businesses white.png', height: 28,width: 28,),
                title: Text('Nearby'),
                activeColor: Colors.white,
                inactiveColor: Colors.black

            ),
            BottomNavyBarItem(
              icon: Image.asset('images/wallet white.png',height: 28,width: 28),
              title: Text('Inbox'),
              activeColor: Colors.white,
              // inactiveColor: Colors.black

            ),
            BottomNavyBarItem(
              icon: Image.asset('images/profile white.png', height: 28,width: 28),
              title: Text('profile'),
              activeColor: Colors.white,
              // inactiveColor: Colors.black
            ),


          ],
        ),
      ),
    );

   /* return DefaultTabController(
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
    );*/
  }
}