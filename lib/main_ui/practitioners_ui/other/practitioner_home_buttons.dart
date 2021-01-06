import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:makhosi_app/Screens/clients_records.dart';
import 'package:makhosi_app/Screens/mypersonal_drive.dart';
import 'package:makhosi_app/contracts/i_info_dialog_clicked.dart';
import 'package:makhosi_app/contracts/i_outlined_button_clicked.dart';
import 'package:makhosi_app/enums/click_type.dart';
import 'package:makhosi_app/main_ui/blog_screens/blog_home_screen.dart';
import 'package:makhosi_app/main_ui/general_ui/login_screen.dart';
import 'package:makhosi_app/main_ui/practitioners_ui/other/practitioner_bookings_screen.dart';
import 'package:makhosi_app/main_ui/practitioners_ui/other/consultations.dart';
import 'package:makhosi_app/ui_components/app_buttons.dart';
import 'package:makhosi_app/utils/navigation_controller.dart';
import 'package:makhosi_app/utils/others.dart';
import 'package:makhosi_app/utils/app_colors.dart';
import 'package:makhosi_app/secondMain.dart';
import 'package:makhosi_app/main_ui/administration/admin.dart';
import 'package:makhosi_app/main_ui/business_card/businessCard.dart';
import '../../../enums/click_type.dart';

class PractitionerHomeButtons extends StatefulWidget {
  @override
  _PractitionerHomeButtonsState createState() =>
      _PractitionerHomeButtonsState();
}

class _PractitionerHomeButtonsState extends State<PractitionerHomeButtons>
    implements IOutlinedButtonClicked, IInfoDialogClicked {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 35, right: 35, top: 15),
          child: FlatButton(
            height: 45,
            //minWidth: 50,
            onPressed: () {
              NavigationController.push(
                context,
                app(),
              );
            },
            child: Row(
              children: [
                Text('MKHOSI KNOWLEDGE HUB',
                    style: TextStyle(color: AppColors.COLOR_PRIMARY)),
                SizedBox(
                  width: 20,
                ),
                Image.asset(
                  'images/arrow.png',
                )
              ],
            ),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: AppColors.COLOR_PRIMARY,
                    width: 1,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(50)),
          ),
        ),

        Container(
          margin: EdgeInsets.only(left: 35, right: 35, top: 8),
          child: FlatButton(
            height: 45,
            //minWidth: 50,
            onPressed: () {
              NavigationController.push(
                context,
                Consultations(),
              );
            },
            child: Row(
              children: [
                Text('CONSULTATIONS',
                    style: TextStyle(
                      color: AppColors.COLOR_PRIMARY,
                    )),
                SizedBox(
                  width: 82,
                ),
                Image.asset(
                  'images/arrow.png',
                )
              ],
            ),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: AppColors.COLOR_PRIMARY,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(50)),
          ),
        ),

        Container(
          margin: EdgeInsets.only(left: 35, right: 35, top: 8),
          child: FlatButton(
            height: 45,
            //minWidth: 50,
            onPressed: () {
              NavigationController.push(
                context,
                PractitionerBookingsScreen(),
              );
            },
            child: Row(
              children: [
                Text('APPOINTMENTS',
                    style: TextStyle(
                      color: AppColors.COLOR_PRIMARY,
                    )),
                SizedBox(
                  width: 97,
                ),
                Image.asset(
                  'images/arrow.png',
                )
              ],
            ),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: AppColors.COLOR_PRIMARY,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(50)),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 35, right: 35, top: 8),
          child: FlatButton(
            height: 45,
            //minWidth: 50,
            onPressed: () {
              NavigationController.push(
                context,
                Admin(),
              );
            },
            child: Row(
              children: [
                Text('ADMINSTRATION',
                    style: TextStyle(color: AppColors.COLOR_PRIMARY)),
                SizedBox(
                  width: 82,
                ),
                Image.asset(
                  'images/arrow.png',
                )
              ],
            ),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: AppColors.COLOR_PRIMARY,
                    width: 1,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(50)),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 35, right: 35, top: 8),
          child: FlatButton(
            height: 45,
            //minWidth: 50,
            onPressed: () {
              NavigationController.push(
                context,
                BusinessCard(),
              );
            },
            child: Row(
              children: [
                Text('BUSINESS INFO',
                    style: TextStyle(color: AppColors.COLOR_PRIMARY)),
                SizedBox(
                  width: 96,
                ),
                Image.asset(
                  'images/arrow.png',
                )
              ],
            ),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: AppColors.COLOR_PRIMARY,
                    width: 1,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(50)),
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 35, right: 35, top: 8),
          child: FlatButton(
            height: 45,

            //minWidth: 50,
            onPressed: null,
            child: Row(
              children: [
                Text('CONSULTATION FEES',
                    style: TextStyle(color: AppColors.COLOR_PRIMARY)),
                SizedBox(
                  width: 56,
                ),
                Image.asset(
                  'images/arrow.png',
                )
              ],
            ),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: AppColors.COLOR_PRIMARY,
                    width: 1,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(50)),
          ),
        ),
        //
        SizedBox(height: 20.0),
        //row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                NavigationController.push(
                  context,
                  ClientRecords(),
                );
              },
              child: Icon(Icons.storage, color: AppColors.COLOR_PRIMARY),
            ),
            GestureDetector(
              onTap: () {
                //logout
              },
              child: Icon(Icons.logout, color: AppColors.COLOR_PRIMARY),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void onOutlineButtonClicked(ClickType clickType) {
    if (clickType == ClickType.APPOINTMENTS) {
      NavigationController.push(
        context,
        PractitionerBookingsScreen(),
      );
    } else if (clickType == ClickType.CONSULTATIONS) {
      NavigationController.push(
        context,
        Consultations(),
      );
    } else if (clickType == ClickType.LOGOUT) {
      Others.showInfoDialog(
        context: context,
        title: 'Log Out?',
        message: 'Are youn sure you want to log out of the app?',
        positiveButtonLabel: 'LOG OUT',
        negativeButtonLabel: 'CANCEL',
        iInfoDialogClicked: this,
        isInfo: false,
      );
    } else {
      NavigationController.push(
        context,
        BLogHomeScreen(
          FirebaseAuth.instance.currentUser.uid,
          false,
        ),
      );
    }
  }

  @override
  void onNegativeClicked() {
    Navigator.pop(context);
  }

  @override
  void onPositiveClicked() async {
    Navigator.pop(context);
    await FirebaseFirestore.instance
        .collection('practitioners')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({
      'online': false,
    }, SetOptions(merge: true));
    await Others.signOut();
    NavigationController.pushReplacement(
      context,
      LoginScreen(ClickType.PRACTITIONER),
    );
  }
}
