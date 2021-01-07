import 'package:flutter/material.dart';
import 'package:makhosi_app/utils/app_colors.dart';

Future showPaymentSuccess(
    BuildContext context, Map profile, String amount) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: CircleAvatar(
        backgroundColor: AppColors.COLOR_PRIMARY,
        radius: 25,
        child: Center(
          child: Icon(
            Icons.done,
            size: 28,
            color: Colors.white,
          ),
        ),
      ),
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You sent money ',
                style: TextStyle(color: AppColors.PAY_SUBTITLE, fontSize: 14),
              ),
              Text(
                'successfully',
                style: TextStyle(color: AppColors.COLOR_PRIMARY, fontSize: 14),
              ),
            ],
          ),
          Text(
            'to',
            style: TextStyle(color: AppColors.PAY_SUBTITLE, fontSize: 14),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0XFFF6F7FB),
              borderRadius: BorderRadius.circular(30),
            ),
            height: 60,
            width: 170,
            padding: EdgeInsets.all(2),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: profile != null
                      ? NetworkImage(
                          profile['id_picture'],
                        )
                      : AssetImage('images/circleavater.png'),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      profile['first_name'],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.PAY_SUBTITLE,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$amount ZAR',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.COLOR_PRIMARY,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Reject'),
        ),
        FlatButton(
          onPressed: () {},
          child: Text('Accept'),
        ),
      ],
    ),
  );
}
