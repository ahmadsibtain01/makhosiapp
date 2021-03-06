import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:makhosi_app/main_ui/blog_screens/blog_home_screen.dart';
import 'package:makhosi_app/main_ui/patients_ui/other/patient_chat_screen.dart';
import 'package:makhosi_app/main_ui/patients_ui/other/patients_booking_screen.dart';
import 'package:makhosi_app/main_ui/practitioners_ui/auth/update.dart';
import 'package:makhosi_app/main_ui/practitioners_ui/chat/practitioner_inbox_screen.dart';
import 'package:makhosi_app/main_ui/practitioners_ui/other/practitioner_home_buttons.dart';
import 'package:makhosi_app/ui/ratingstaticpage.dart';
import 'package:makhosi_app/ui_components/app_status_components.dart';
import 'package:makhosi_app/utils/app_colors.dart';
import 'package:makhosi_app/utils/app_dialogues.dart';
import 'package:makhosi_app/utils/app_keys.dart';
import 'package:makhosi_app/utils/navigation_controller.dart';
import 'package:makhosi_app/utils/others.dart';
import 'package:makhosi_app/utils/screen_dimensions.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:makhosi_app/contracts/i_info_dialog_clicked.dart';
import 'package:makhosi_app/Screens/account_screen.dart';
import 'package:makhosi_app/Screens/notification_screen.dart';
import 'package:makhosi_app/main_ui/general_ui/setting_page.dart';
import 'package:makhosi_app/main_ui/general_ui/login_screen.dart';
import 'package:makhosi_app/enums/click_type.dart';

class PractitionersProfileScreen extends StatefulWidget {
  bool _isViewer;
  dynamic _snapshot;

  PractitionersProfileScreen(this._isViewer, this._snapshot);

  @override
  _PractitionersProfileScreenState createState() =>
      _PractitionersProfileScreenState();
}

class _PractitionersProfileScreenState
    extends State<PractitionersProfileScreen> {
  dynamic _snapshot;
  bool _isLoading = false, _isFavorite = false;
  String _userId;
  int totalClient;

  @override
  void initState() {
    _snapshot = widget._snapshot;
    _checkFavorite();
    getData();
    super.initState();
  }

  Future<void> _checkFavorite() async {
    try {
      _userId = FirebaseAuth.instance.currentUser.uid;
      DocumentSnapshot favoriteSnapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .doc(_userId)
          .collection('my_favorites')
          .doc(_snapshot.id)
          .get();
      if (favoriteSnapshot.exists) {
        setState(() {
          _isFavorite = true;
        });
      }
    } catch (exc) {
      setState(() {
        _isFavorite = false;
      });
      print(exc);
    }
  }

  getData() async {
    String id = FirebaseAuth.instance.currentUser.uid;

    await FirebaseFirestore.instance
        .collection('bookings')
        .where('appointment_to', isEqualTo: id)
        .get()
        .then((value) {
      setState(() {
        totalClient = value.docs.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? AppStatusComponents.loadingContainer(Colors.white)
          : _snapshot == null
              ? AppStatusComponents.errorBody(message: 'No profile data')
              : Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        'images/Gradientbg.png',
                        width: ScreenDimensions.getScreenWidth(context),
                        height: ScreenDimensions.getScreenWidth(context) / 1.85,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: 0,
                          height: ScreenDimensions.getScreenWidth(context) / 10,
                        ),
                        Expanded(
                          child: _getBody(),
                        ),
                      ],
                    ),
                    Container(
                        height: 50,
                        width: 50,
                        margin: EdgeInsets.only(right: 290, top: 600),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        new AccountsScreen()));
                          },
                          child: Image.asset('images/account.png'),
                        )),
                    Container(
                        height: 50,
                        width: 50,
                        margin: EdgeInsets.only(left: 314, top: 600),
                        child: GestureDetector(
                          onTap: () {
                            showAlertDialog(context);
                          },
                          child: Image.asset('images/logout.png'),
                        )),
                  ],
                ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("CANCEL"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("LOG OUT"),
      onPressed: () async {
        Navigator.pop(context);
        await FirebaseFirestore.instance
            .collection(AppKeys.PRACTITIONERS)
            .doc(FirebaseAuth.instance.currentUser.uid)
            .set({
          'online': false,
        }, SetOptions(merge: true));
        await Others.signOut();
        NavigationController.pushReplacement(
          context,
          LoginScreen(ClickType.PRACTITIONER),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Log Out?"),
      content: Text("Are you sure you want to log out of the app?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _getBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 12, right: 12, bottom: 13, top: 25),
      child: Stack(
        children: [
          _getContentSection(),
          _getImageSection(),
        ],
      ),
    );
  }

  Widget _getContentSection() {
    // bool isOnline = _snapshot.get(AppKeys.ONLINE);
    String firstName = " ";
    String secondName = " ";
    String location = " ";

    firstName = _snapshot[AppKeys.FIRST_NAME];
    secondName = _snapshot[AppKeys.LAST_NAME];
    location = _snapshot[AppKeys.ADDRESS];

    if (firstName == null) {
      firstName = " ";
    }
    ;
    if (secondName == null) {
      secondName = " ";
    }
    ;
    if (location == null) {
      location = " ";
    }
    ;
    return Column(
      children: [
        Card(
          elevation: 5,
          margin: EdgeInsets.only(top: 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 32,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 89,
                          ),
                          Text(
                            '${firstName}${secondName}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 21,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            height: 15,
                            width: 18,
                            child: Image.asset(
                              "images/Vector.png",
                              height: 12,
                              width: 12,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${location}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                      Others.getSizedBox(boxHeight: 8, boxWidth: 0),
//                  _getRattingBar(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              AppDialogues.showNoOfClientsPopup(context);
                            },
                            child: Column(
                              children: [
                                Text(
                                  (totalClient != null)
                                      ? totalClient.toString()
                                      : '0',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 21,
                                    color: Colors.black,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'N0. OF CLIENTS',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            height: 45,
                            width: 2,
                            color: Colors.black38,
                          ),
                          GestureDetector(
                            onTap: () {
                              NavigationController.push(
                                  context, RatingInfoPage());
                            },
                            child: Column(
                              children: [
                                Text(
                                  '0',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 21,
                                    color: Colors.black,
                                    //  fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'YOUR RATING',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            height: 45,
                            width: 2,
                            color: Colors.black38,
                          ),
                          GestureDetector(
                            onTap: () {
                              AppDialogues.showEarningPopup(context);
                            },
                            child: Column(
                              children: [
                                Text(
                                  '0',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 21,
                                    color: Colors.black,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'TOTAL EARNINGS (ZAR)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      FlatButton(
                        height: 60,
                        minWidth: 210,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        color: AppColors.COLOR_PRIMARY,
                        onPressed: () {
                          NavigationController.push(
                            context,
                            ServiceProviderUpdateScreen(),
                          );
                        },
                        child: Text(
                          'EDIT PROFILE',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ),

                      // _getNamesSection(),
                      // widget._isViewer ? Container() : PractitionerHomeButtons(),
                      // SizedBox(
                      // height: 16,
                      //),
                      // Text(
                      //   'Timing',
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 15,
                      //   ),
                      // ),
                      SizedBox(
                        height: 7,
                      ),
                      // _getTimingSection(),
                      // SizedBox(
                      // height: 16,
                      //),
                      // _getButtonsSection(),
                    ],
                  ),
                ),
              ),
              widget._isViewer
                  ? Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: _isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          _saveFavorite();
                        },
                      ),
                    )
                  : Container(),
              !widget._isViewer
                  ? Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 45,
                        height: 45,
                        margin: EdgeInsets.all(8),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                child: Image.asset('images/setting.png'),
                                onTap: () {
                                  NavigationController.push(
                                    context,
                                    SettingPage(),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 45,
                  height: 45,
                  margin: EdgeInsets.all(8),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          child: Image.asset('images/notification.png'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        new NotificationScreen()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        widget._isViewer ? Container() : PractitionerHomeButtons(),
      ],
    );
  }

  Widget _getButtonsSection() {
    return widget._isViewer
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.mail_outline,
                  color: Colors.blue,
                ),
                onPressed: () {
                  NavigationController.push(
                    context,
                    PatientChatScreen(_snapshot.id),
                  );
                },
              ),
              SizedBox(
                width: 8,
              ),
              _getBookingButton(),
              SizedBox(
                width: 8,
              ),
              widget._isViewer ? _getBlogButton() : Container(),
            ],
          )
        : Container();
  }

  Widget _getBlogButton() {
    return Expanded(
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        color: AppColors.COLOR_PRIMARY,
        onPressed: () {
          NavigationController.push(
            context,
            BLogHomeScreen(_snapshot.id, true),
          );
        },
        child: Text(
          'Blog',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _getBookingButton() {
    return Expanded(
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        color: AppColors.COLOR_PRIMARY,
        onPressed: () async {
          NavigationController.push(
            context,
            PatientsBookingScreen(_snapshot),
          );
        },
        child: Text(
          'BOOK NOW',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _getTimingSection() {
    return Container(
      child: Column(
        children: [
          _getTimingRow(0, 'Sunday'),
          SizedBox(
            height: 4,
          ),
          _getTimingRow(1, 'Monday'),
          SizedBox(
            height: 4,
          ),
          _getTimingRow(2, 'Tuesday'),
          SizedBox(
            height: 4,
          ),
          _getTimingRow(3, 'Wednesday'),
          SizedBox(
            height: 4,
          ),
          _getTimingRow(4, 'Thursday'),
          SizedBox(
            height: 4,
          ),
          _getTimingRow(5, 'Friday'),
          SizedBox(
            height: 4,
          ),
          _getTimingRow(6, 'Saturday'),
        ],
      ),
    );
  }

  Widget _getTimingRow(int index, String day) {
    String timingString;
    switch (index) {
      case 0:
        {
          if (_snapshot.get('timings')['sunday_open'] == '00:00' &&
              _snapshot.get('timings')['sunday_close'] == '00:00') {
            timingString = 'closed';
          } else {
            timingString =
                '${_snapshot.get('timings')['sunday_open']} to ${_snapshot.get('timings')['sunday_close']}';
          }

          break;
        }
      case 1:
        {
          if (_snapshot.get('timings')['monday_open'] == '00:00' &&
              _snapshot.get('timings')['monday_close'] == '00:00') {
            timingString = 'closed';
          } else
            timingString =
                '${_snapshot.get('timings')['monday_open']} to ${_snapshot.get('timings')['monday_close']}';
          break;
        }
      case 2:
        {
          if (_snapshot.get('timings')['tuesday_open'] == '00:00' &&
              _snapshot.get('timings')['tuesday_close'] == '00:00') {
            timingString = 'closed';
          } else
            timingString =
                '${_snapshot.get('timings')['tuesday_open']} to ${_snapshot.get('timings')['tuesday_close']}';
          break;
        }
      case 3:
        {
          if (_snapshot.get('timings')['wednesday_open'] == '00:00' &&
              _snapshot.get('timings')['wednesday_close'] == '00:00') {
            timingString = 'closed';
          } else
            timingString =
                '${_snapshot.get('timings')['wednesday_open']} to ${_snapshot.get('timings')['wednesday_close']}';
          break;
        }
      case 4:
        {
          if (_snapshot.get('timings')['thursday_open'] == '00:00' &&
              _snapshot.get('timings')['thursday_close'] == '00:00') {
            timingString = 'closed';
          } else
            timingString =
                '${_snapshot.get('timings')['thursday_open']} to ${_snapshot.get('timings')['thursday_close']}';
          break;
        }
      case 5:
        {
          if (_snapshot.get('timings')['friday_open'] == '00:00' &&
              _snapshot.get('timings')['friday_close'] == '00:00') {
            timingString = 'closed';
          } else
            timingString =
                '${_snapshot.get('timings')['friday_open']} to ${_snapshot.get('timings')['friday_close']}';
          break;
        }
      case 6:
        {
          if (_snapshot.get('timings')['saturday_open'] == '00:00' &&
              _snapshot.get('timings')['saturday_close'] == '00:00') {
            timingString = 'closed';
          } else
            timingString =
                '${_snapshot.get('timings')['saturday_open']} to ${_snapshot.get('timings')['saturday_close']}';
          break;
        }
    }
    return Row(
      children: [
        Expanded(
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
        Expanded(
          child: Text(
            timingString,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  Widget _getNamesSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                'Dlozi Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              Text(
                _snapshot.get(AppKeys.DLOZI_NAME),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                'Ughobela Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              Text(
                _snapshot.get(AppKeys.UGHOBELA_NAME),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getRattingBar() {
    return RatingBar.readOnly(
      initialRating: 4.5,
      filledIcon: Icons.star,
      emptyIcon: Icons.star_border,
      emptyColor: Colors.orange,
      filledColor: Colors.orange,
      halfFilledIcon: Icons.star_half,
      isHalfAllowed: true,
      halfFilledColor: Colors.orange,
      maxRating: 5,
      size: 18,
    );
  }

  Widget _getImageSection() {
    String pic = " ";

    pic = _snapshot[AppKeys.ID_PICTURE];
    return GestureDetector(
      onTap: !widget._isViewer
          ? () async {
              PickedFile pickedFile = await ImagePicker().getImage(
                source: ImageSource.gallery,
                imageQuality: 25,
              );
              if (pickedFile != null) {
                StorageReference ref = FirebaseStorage.instance
                    .ref()
                    .child('profile_images/${_snapshot.id}.jpg');
                StorageUploadTask task = ref.putFile(File(pickedFile.path));
                task.onComplete.then((_) async {
                  await FirebaseFirestore.instance
                      .collection('practitioners')
                      .doc(_snapshot.id)
                      .set({'profile_image': await _.ref.getDownloadURL()},
                          SetOptions(merge: true));
                  NavigationController.pushReplacement(
                      context,
                      PractitionersProfileScreen(
                          widget._isViewer,
                          await FirebaseFirestore.instance
                              .collection('practitioners')
                              .doc(_snapshot.id)
                              .get()));
                }).catchError((error) {
                  print(error);
                });
              }
            }
          : null,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: Colors.white,
              width: 12,
            ),
          ),
          child: _snapshot == null
              ? Others.getProfilePlaceHOlder()
              : pic == null
                  ? Others.getProfilePlaceHOlder()
                  : CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(
                        pic,
                      ),
                    ),
        ),
      ),
    );
  }

  Future<void> _saveFavorite() async {
    if (!_isFavorite) {
      FirebaseFirestore.instance
          .collection('favorites')
          .doc(_userId)
          .collection('my_favorites')
          .doc(_snapshot.id)
          .set({
        AppKeys.PRACTITIONER_UID: _snapshot.id,
      });
    } else {
      FirebaseFirestore.instance
          .collection('favorites')
          .doc(_userId)
          .collection('my_favorites')
          .doc(_snapshot.id)
          .delete();
    }
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }
}
