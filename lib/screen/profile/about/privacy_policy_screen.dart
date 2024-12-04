import 'package:flutter/material.dart';
import 'package:todo/utils/common.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: Common.isMediumScreen(context) ? 24 : 8,
            vertical: Common.isMediumScreen(context) ? 16 : 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            data(
                "Floran built the Todo app as a Freemium app. This SERVICE is provided by Floran at no cost and is intended for use as is. This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service. If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy. The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at Passx unless otherwise defined in this Privacy Policy."),
            size20h(),
            header("Infomation Collection and use"),
            size15h(),
            data(
                "For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to Username, email. The information that we request will be retained by us and used as described in this privacy policy.\n\nThe app does use third-party services that may collect information used to identify you."),
            size20h(),
            header("Third-Party Services"),
            size15h(),
            data("1. Google Play Service"),
            data("2. Google Analytics for Firebase"),
            data("3. Firebase Crashlytics"),
            size20h(),
            header("Log Data"),
            size15h(),
            data(
                "We want to inform you that whenever you use our Service, in a case of an error in the app, we collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics."),
            size20h(),
            header("Security"),
            size15h(),
            data(
                "We value your trust in providing us with your Personal Information, thus we strive to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage, is 100% secure and reliable, and we cannot guarantee its absolute security."),
            size20h(),
            header("Changes to This Privacy Policy"),
            size15h(),
            data(
                "We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page. This policy is effective as of 2023-12-25."),
            size20h(),
            header("Contact Us"),
            size15h(),
            data(
                "If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at floran.bot@gmail.com."),
            size20h(),
          ],
        ),
      ),
    );
  }

  SizedBox size20h() => const SizedBox(
        height: 20,
      );

  SizedBox size15h() {
    return const SizedBox(
      height: 15,
    );
  }

  Text data(String text) {
    return Text(
      text,
      textAlign: TextAlign.justify,
    );
  }

  Text header(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
    );
  }
}
