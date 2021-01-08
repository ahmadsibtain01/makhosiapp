import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:makhosi_app/utils/app_colors.dart';
import 'package:makhosi_app/utils/app_keys.dart';

class PaidFee extends StatelessWidget {
  final String sender, amount;

  PaidFee({this.sender, this.amount});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('patients').doc(sender).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: null,
              body: Container(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.COLOR_PRIMARY,
                        child: Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'You have received funds!',
                        style: TextStyle(
                            color: AppColors.COLOR_PRIMARY, fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'From Customer',
                        style: TextStyle(color: AppColors.LIGHT_GREY),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50,
                        backgroundImage: NetworkImage(
                          snapshot.data.get(AppKeys.PROFILE_IMAGE) == null
                              ? 'https://image.freepik.com/free-vector/follow-me-social-business-theme-design_24877-52233.jpg'
                              : snapshot.data.get(AppKeys.PROFILE_IMAGE),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        snapshot.data.get('full_name'),
                        style: TextStyle(
                            color: AppColors.COLOR_PRIMARY, fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'R$amount',
                            style: TextStyle(
                                color: AppColors.COLOR_PRIMARY, fontSize: 30),
                          ),
                          Text(
                            'ZAR',
                            style: TextStyle(
                                color: AppColors.COLOR_PRIMARY, fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                color: AppColors.COLOR_PRIMARY,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: Text(
                                  'DONE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Container(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [],
              ),
            ),
          );
        });
  }
}
