import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:makhosi_app/contracts/i_outlined_button_clicked.dart';
import 'package:makhosi_app/contracts/i_rounded_button_clicked.dart';
import 'package:makhosi_app/enums/click_type.dart';
import 'package:makhosi_app/helpers/auth/register/register_helper.dart';
import 'package:makhosi_app/helpers/others/preferences_helper.dart';
import 'package:makhosi_app/main_ui/general_ui/register_success_screen.dart';
import 'package:makhosi_app/main_ui/practitioners_ui/auth/traditional_healers/practitioner_register_screen_second.dart';
import 'package:makhosi_app/ui_components/app_buttons.dart';
import 'package:makhosi_app/ui_components/app_labels.dart';
import 'package:makhosi_app/ui_components/app_status_components.dart';
import 'package:makhosi_app/ui_components/app_text_fields.dart';
import 'package:makhosi_app/ui_components/settings/terms_policy.dart';
import 'package:makhosi_app/utils/app_colors.dart';
import 'package:makhosi_app/utils/app_keys.dart';
import 'package:makhosi_app/utils/app_toast.dart';
import 'package:makhosi_app/utils/navigation_controller.dart';
import 'package:makhosi_app/utils/others.dart';
import 'package:makhosi_app/utils/string_constants.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class ServiceProviderFourthScreen extends StatefulWidget {
  Map<String, Object> _userData;
  PickedFile pickedFile;
  ServiceProviderFourthScreen(this._userData, this.pickedFile);

  @override
  _PractiotnerRegisterScreenFourthState createState() =>
      _PractiotnerRegisterScreenFourthState();
}

class _PractiotnerRegisterScreenFourthState
    extends State<ServiceProviderFourthScreen>
    implements IRoundedButtonClicked {
  var _additionalServiceController = TextEditingController();

  bool _isLoading = false, _verificationAllowed = false;
  PickedFile _pickedFile;
  //check box parameters
  bool isBuisnessOwner = false;
  bool understandGuidliness = true;
  bool ownBuisness = false;
  sendGettingstartedmail() async {
    String username = 'mkhosi.app@gmail.com';
    String password = "Mkhosi2020";

    final smtpServer = gmail(username, password);
    // Creating the Gmail server

    // Create our email message.
    final message = Message()
      ..from = Address(username)
      ..recipients.add(AppKeys.EMAIL) //recipent email
      // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com']) //cc Recipents emails
      // ..bccRecipients.add(Address('bccAddress@example.com')) //bcc Recipents emails
      ..subject = 'Welcome!' //subject of the email
      ..text = '' //body of the email
      ..html =
          "<p>I would like to take this opportunity thank you for signing up on the Mkhosi App, and becoming part of the Mkhosi Community, whether as a Potential Customer or a Service Provider. Mkhosi is shortened from “Hlaba umkhosi” which comes from the isiZulu language of South Africa which has multiple meanings including to send an SOS or to call for help or assistance or the clarion call. On its own, “Mkhosi” can mean a ceremony or festival as well as an army battalion. </p><p>Applying this name to the App is because when you run a small business on your own, there are times when you feel like you need an army to assist you just to get through the daily tasks and to make sense of the do’s and don’ts of running your business. With that, when you have success, it does feel like there is a cause for a celebration, a festival. Our hope is that Mkhosi is able to support you in your journey to a sustainable business, being the support, you need when the going gets tough and the community that is always there to celebrate with you when the plan falls into place. </p><p>The app is free for all Users who are joining or registration as Customers. As a Mkhosi Customer you have access to many service providers ranging from Traditional Healers to Mechanics. You will also have access to their work calendar which will enable you to seamlessly book for consultations either virtually or physically (or both). Additionally, we have also added a calling (video and voice) and payment feature for those who might want to purchase goods from the service providers.</p><p>Service Providers have three subscription options available for them, which are i. start-up, ii. Setup and iii. shine packages. These packages are based on access to some functionalities on the app which will enable you to set up your business digitally. There are also many benefits of signing up as a Service Provider on the app, and you can find out more about this on the website:<a href='www.mkhosi.com'> www.mkhosi.com</a></p><p>Should have any questions or would like to engage with one of our team members, please do email us at:<a href='support@mkhosi.com'>support@mkhosi.com<a></p><p>Regards,</p>\n\n<p>Amanda Gcabashe</p><p>Founder & CEO</p>";
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' +
          sendReport.toString()); //print if the email is sent
    } on MailerException catch (e) {
      print('Message not sent. \n' +
          e.toString()); //print if the email is not sent
      // e.toString() will show why the email is not sending
    }
  }

  sendmail() async {
    print(AppKeys.EMAIL);
    String username = 'mkhosi.app@gmail.com';
    String password = "Mkhosi2020";

    final smtpServer = gmail(username, password);
    // Creating the Gmail server

    // Create our email message.
    final message = Message()
      ..from = Address('username')
      ..recipients.add(AppKeys.EMAIL) //recipent email
      // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com']) //cc Recipents emails
      // ..bccRecipients.add(Address('bccAddress@example.com')) //bcc Recipents emails
      ..subject =
          'Successful Registration:: 😀 :: ${DateTime.now()}' //subject of the email
      ..text = 'Dear ${AppKeys.FIRST_NAME},' //body of the email
      ..html =
          "<h3>Dear ${AppKeys.FIRST_NAME},</h3>\n<p>This is a confirmation email that you have successfully registered on the Mkhosi App. As a Service Provider you will be able to setup your business accordingly.</p><p>The primary goal of the app is to give you the best experience, and as such we would like to refer you to out Community Guidelines, which can be also be found on our website:<a href='www.mkhosi.com'> www.mkhosi.com</a></p><p>In the event that you do go through any trouble contact our support team:<a href='support@mkhosi.com'> support@mkhosi.com</a></p><p>Please also do not forget to also follow us on all our social media accounts @Mkhosi</p><p>Regards,</p>\n\n<p>Mkhosi Team</p>";
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' +
          sendReport.toString()); //print if the email is sent
    } on MailerException catch (e) {
      print('Message not sent. \n' +
          e.toString()); //print if the email is not sent
      // e.toString() will show why the email is not sending
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget._userData);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            _getForm(),
            _isLoading
                ? AppStatusComponents.loadingContainer(AppColors.COLOR_PRIMARY)
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _getForm() {
    return ListView(
      padding: EdgeInsets.all(16),
      shrinkWrap: true,
      children: [
        _getBackButton(),
        Text(
          'Additional',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        //do you have business owner check boxes
        CheckboxListTile(
          title: Text(
            "Are you the Business Owner?",
            style: TextStyle(fontSize: 15.0),
          ),
          value: isBuisnessOwner,
          onChanged: (newValue) {
            setState(() {
              isBuisnessOwner = newValue;
            });
          },
          controlAffinity:
              ListTileControlAffinity.trailing, //  <-- leading Checkbox
        ),
        Others.getSizedBox(boxHeight: 16, boxWidth: 0),
        //do you have business owner check boxes
        CheckboxListTile(
          title: Text(
            "I understand Mkhosi’s Community Guidelines",
            style: TextStyle(fontSize: 15.0),
          ),
          value: understandGuidliness,
          onChanged: (newValue) {
            setState(() {
              understandGuidliness = newValue;
            });
          },
          controlAffinity:
              ListTileControlAffinity.trailing, //  <-- leading Checkbox
        ),
        Others.getSizedBox(boxHeight: 16, boxWidth: 0),
        //warning
        RichText(
          // textAlign: TextAlign.right,
          text: new TextSpan(
            text: 'By selecting yes you are required to act according to the ',
            // style: DefaultTextStyle.of(context).style,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black87,
            ),
            children: <TextSpan>[
              new TextSpan(
                text: 'Mkhosi Community Guidelines.',
                style: new TextStyle(fontWeight: FontWeight.bold),
                recognizer: new TapGestureRecognizer()
                  ..onTap = () => NavigationController.push(
                        context,
                        WebViewPage(
                          link: StringConstants.COMMUNITY_GUIDLINES,
                          title: 'Community Guidelines',
                        ),
                      ),
              ),
              new TextSpan(
                  text:
                      ' Failure to do so will result in the deactivation of your account and possible criminal charges'),
            ],
          ),
        ),
        Others.getSizedBox(boxHeight: 16, boxWidth: 0),
        //do you have delivery service check boxes
        CheckboxListTile(
          title: Text(
            "Do you own any other business?",
            style: TextStyle(fontSize: 15.0),
          ),
          value: ownBuisness,
          onChanged: (newValue) {
            setState(() {
              ownBuisness = newValue;
            });
          },
          controlAffinity:
              ListTileControlAffinity.trailing, //  <-- leading Checkbox
        ),
        Others.getSizedBox(boxHeight: 16, boxWidth: 0),
        Visibility(
          visible: true,
          child: AppTextFields.getTextField(
            controller: _additionalServiceController,
            label: 'Choose additional service...',
            isPassword: false,
            isNumber: false,
          ),
        ),

        Others.getSizedBox(boxHeight: 16, boxWidth: 0),
        AppButtons.getRoundedButton(
          context: context,
          iRoundedButtonClicked: this,
          label: 'SIGN UP',
          clickType: ClickType.DUMMY,
        ),
      ],
    );
  }

  Widget _getBackButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 16, top: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              // NavigationController.pushReplacement(
              //     context, PractitionerRegisterScreenSecond(widget._userData));
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.grey,
            ),
          ),
          Others.getSizedBox(boxHeight: 0, boxWidth: 8),
          AppLabels.getLabel(
            labelText: 'Personal Info',
            size: 21,
            labelColor: Colors.black,
            isBold: false,
            isUnderlined: false,
            alignment: TextAlign.left,
          ),
        ],
      ),
    );
  }

// var _additionalServiceController = TextEditingController();

//   bool _isLoading = false, _verificationAllowed = false;
//   PickedFile _pickedFile;
//   //check box parameters
//   bool isBuisnessOwner = false;
//   bool understandGuidliness = true;
//   bool ownBuisness = false;
  @override
  onClick(ClickType clickType) async {
    // print('service type: ' + widget._userData[AppKeys.SERVICE_TYPE].toString());
    String additional_services = _additionalServiceController.text.trim();
    if (!understandGuidliness) {
      AppToast.showToast(message: 'Pleases agree with community guideliness');
    } else {
      widget._userData.addAll({
        AppKeys.BUSINESS_OWNER: ownBuisness,
        AppKeys.OTHER_BUSINESS_OWNER: ownBuisness,
        AppKeys.ADDITIONAL_SERVICES: additional_services,
      });
      RegisterHelper helper = RegisterHelper();
      setState(() {
        _isLoading = true;
      });
      bool registerStatus = await helper.registerUser(
        email: widget._userData[AppKeys.EMAIL],
        password: widget._userData[AppKeys.PASSWORD],
      );
      if (registerStatus) {
        //upload id image first
        print(widget._userData);
        bool firestoreResult = await helper.savePatientDataToFirestore2(
          userInfoMap: widget._userData,
          //userType: ClickType.PRACTITIONER,
        );
        if (firestoreResult) {
          bool imageUploadResult = await helper.uploadImage(
            pickedFile: widget.pickedFile,
            userType: ClickType.PRACTITIONER,
          );
          if (imageUploadResult) {
            PreferencesHelper preferencesHelper = PreferencesHelper();
            await preferencesHelper.setUserType(ClickType.PRACTITIONER);
            sendmail();
            sendGettingstartedmail();
            AppToast.showToast(message: 'Registration success!');
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);

            NavigationController.pushReplacement(
                context,
                RegisterSuccessScreen(
                  ClickType.PRACTITIONER,
                  serviceType:
                      widget._userData[AppKeys.SERVICE_TYPE].toString(),
                ));
          } else {
            setState(() {
              _isLoading = false;
              AppToast.showToast(
                  message: 'There was an error saving your ID image');
            });
          }
        } else {
          setState(() {
            _isLoading = false;
            AppToast.showToast(message: 'There was an error saving your data');
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          AppToast.showToast(
              message: 'There was an error registering this practitioner');
        });
      }
    }

    // Navigator.pop(context);
    //         Navigator.pop(context);
    //         Navigator.pop(context);
    // NavigationController.pushReplacement(
    //     context, RegisterSuccessScreen(ClickType.PRACTITIONER));
  }
}
