 
 import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
 sendGettingstartedmail(String receiverEmail,String name) async {
String username = 'mkhosi.app@gmail.com';
    String password = "Mkhosi2020";

    final smtpServer = gmail(username, password);
    // Creating the Gmail server

    // Create our email message.
    final message = Message()
      ..from =Address(username)
      ..recipients.add(receiverEmail) //recipent email
      // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com']) //cc Recipents emails
      // ..bccRecipients.add(Address('bccAddress@example.com')) //bcc Recipents emails
      ..subject =
          'Welcome!' //subject of the email
      ..text = '' //body of the email
      ..html ="<p>I would like to take this opportunity thank you for signing up on the Mkhosi App, and becoming part of the Mkhosi Community, whether as a Potential Customer or a Service Provider. Mkhosi is shortened from “Hlaba umkhosi” which comes from the isiZulu language of South Africa which has multiple meanings including to send an SOS or to call for help or assistance or the clarion call. On its own, “Mkhosi” can mean a ceremony or festival as well as an army battalion. </p><p>Applying this name to the App is because when you run a small business on your own, there are times when you feel like you need an army to assist you just to get through the daily tasks and to make sense of the do’s and don’ts of running your business. With that, when you have success, it does feel like there is a cause for a celebration, a festival. Our hope is that Mkhosi is able to support you in your journey to a sustainable business, being the support, you need when the going gets tough and the community that is always there to celebrate with you when the plan falls into place. </p><p>The app is free for all Users who are joining or registration as Customers. As a Mkhosi Customer you have access to many service providers ranging from Traditional Healers to Mechanics. You will also have access to their work calendar which will enable you to seamlessly book for consultations either virtually or physically (or both). Additionally, we have also added a calling (video and voice) and payment feature for those who might want to purchase goods from the service providers.</p><p>Service Providers have three subscription options available for them, which are i. start-up, ii. Setup and iii. shine packages. These packages are based on access to some functionalities on the app which will enable you to set up your business digitally. There are also many benefits of signing up as a Service Provider on the app, and you can find out more about this on the website:<a href='www.mkhosi.com'> www.mkhosi.com</a></p><p>Should have any questions or would like to engage with one of our team members, please do email us at:<a href='support@mkhosi.com'>support@mkhosi.com<a></p><p>Regards,</p>\n\n<p>Amanda Gcabashe</p><p>Founder & CEO</p>";
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
 sendmail(String receiverEmail,String name) async {
    String username = 'mkhosi.app@gmail.com';
    String password = "Mkhosi2020";

    final smtpServer = gmail(username, password);
    // Creating the Gmail server

    // Create our email message.
    final message = Message()
      ..from =Address(username)
      ..recipients.add(receiverEmail) //recipent email
      // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com']) //cc Recipents emails
      // ..bccRecipients.add(Address('bccAddress@example.com')) //bcc Recipents emails
      ..subject =
          'Successful Registration:: ${DateTime.now()}' //subject of the email
      ..text = 'Dear $name,' //body of the email
      ..html =
          "<h3>Dear $name</h3>\n<p>This is a confirmation email that you have successfully registered on the Mkhosi App. As a Customer/Client you will have access to many service providers in your area and any location you are at.</p><p>The primary goal of the app is to give you the best experience, and as such we would like to refer you to out Community Guidelines, which can be also be found on our website:<a href='www.mkhosi.com'> www.mkhosi.com</a></p><p>In the event that you do go through any trouble contact our support team:<a href='support@mkhosi.com'> support@mkhosi.com</a></p><p>Please also do not forget to also follow us on all our social media accounts @Mkhosi</p><p>Regards,</p>\n\n<p>Mkhosi Team</p>";
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
