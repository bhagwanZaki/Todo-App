import 'package:flutter/material.dart';
import 'package:todo/utils/common.dart';

class TermAndConditionScreen extends StatelessWidget {
  const TermAndConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms & Conditions"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: Common.isMediumScreen(context) ? 24 : 8,
            vertical: Common.isMediumScreen(context) ? 16 : 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            data(
                "By downloading or using the Todo app, these terms automatically apply to you. Please read them carefully before using the app. You are not allowed to copy or modify the app, any part of the app, or our trademarks in any way. Attempting to extract the source code, translating the app into other languages, or creating derivative versions is strictly prohibited. All rights, including trademarks, copyright, database rights, and other intellectual property rights related to the app, belong to Floran."),
            size20h(),
            header("1. Use of the Service"),
            size15h(),
            data(
                "1.1 You are responsible for maintaining the security of your account and password. Floran is not liable for any loss or damage resulting from your failure to comply with this security obligation."),
            size5h(),
            data(
                "1.2 You agree not to reproduce, duplicate, copy, sell, resell, or exploit any portion of the Service without Floran's express written permission."),
            size20h(),
            header("2. User Responsibilities"),
            size15h(),
            data(
                "2.1 When creating an account, you must provide accurate and complete information. Keep your account information up-to-date."),
            size5h(),
            data(
                "2.2 You are solely responsible for the activity that occurs on your account and must keep your account password secure."),
            size20h(),
            header("3. Privacy Policy"),
            size15h(),
            data(
                "By using our Service, you agree to the collection and use of information in accordance with our Privacy Policy"),
            size20h(),
            header("4. Third-Party Services"),
            size15h(),
            data(
                "We value your trust in providing us with your Personal Information, thus we strive to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage, is 100% secure and reliable, and we cannot guarantee its absolute security."),
            size20h(),
            header("Changes to This Privacy Policy"),
            size15h(),
            data(
                "4.1 The Service may integrate with third-party services such as Google Play Services, Google Analytics for Firebase, and Firebase Crashlytics. Your use of these services is subject to their respective terms and policies."),
            size5h(),
            data(
                "4.2 Floran is not responsible for the practices or content of third-party websites or services."),
            size20h(),
            header("5. Internet Connection and Mobile Charges"),
            size15h(),
            data(
                "5.1 Certain functions of the app require an active internet connection. Floran is not responsible for the app not working at full functionality without access to Wi-Fi or data."),
            size5h(),
            data(
                "5.2 If using the app outside an area with Wi-Fi, your mobile network provider's terms apply. You may be charged for data or other third-party charges."),
            size20h(),
            header("6. Limitation of Liability"),
            size15h(),
            data(
                "To the fullest extent permitted by applicable law, Floran shall not be liable for any indirect, incidental, special, consequential, or punitive damages."),
            size20h(),
            header("7. App Updates and Termination"),
            size15h(),
            data(
                "7.1 You must accept updates to the application when offered."),
            size5h(),
            data(
                "7.2 Floran may stop providing the app and may terminate use at any time with notice."),
            size20h(),
            header("8. Changes to Terms and Conditions"),
            size15h(),
            data(
                "We may update our Terms and Conditions from time to time. Review this page periodically for any changes. We will notify you of changes by posting the new Terms and Conditions on this page."),
            size20h(),
            header("9. Contact Us"),
            size15h(),
            data(
                "If you have questions or suggestions about our Terms and Conditions, contact us at floran.bot@gmail.com.\n\nThese terms and conditions are effective as of 2023-12-25.")
          ],
        ),
      ),
    );
  }

  SizedBox size20h() => const SizedBox(
        height: 20,
      );
  SizedBox size5h() => const SizedBox(
        height: 5,
      );

  SizedBox size15h() {
    return const SizedBox(
      height: 15,
    );
  }

  Text data(String text) {
    return Text(text);
  }

  Text header(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
    );
  }
}
