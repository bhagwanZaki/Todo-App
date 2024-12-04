import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/component/setting/delete_account_item.dart';
import 'package:todo/component/setting/logout_item.dart';
import 'package:todo/provier/auth_provider.dart';
import 'package:todo/screen/profile/edit_profile.dart';
import 'package:todo/stream/auth_stream.dart';
import 'package:todo/theme/app_color.dart';
import 'package:todo/utils/common.dart';
import 'package:todo/constant/routes.dart';
import 'package:todo/utils/preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Preferences prefs = Preferences();
  bool showDeleteOTPContainer = false;
  String? username = "";
  String? email = "";
  String? fullname = "";

  @override
  Widget build(BuildContext context) {
    username = context.watch<AuthProvider>().username;
    email = context.watch<AuthProvider>().email;
    fullname = context.watch<AuthProvider>().fullname;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Common.isMediumScreen(context) ? 16 : 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullname!,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        userDetailChip(username!),
                        userDetailChip(email!),
                      ],
                    )
                  ],
                ),
                InkWell(
                  radius: 50,
                  borderRadius: BorderRadius.circular(100),
                  onTap: () => Navigator.push(
                      context,
                      Common.pageRouteBuilder(EditProfile(
                        username: username!,
                        email: email!,
                        fullname: fullname!,
                      ))),
                  child: Ink(
                    decoration: BoxDecoration(
                        color: AppColor.card,
                        borderRadius: BorderRadius.circular(100)),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                    ),
                  ),
                )
              ],
            ),
            size25(),
            const Text("Security"),
            size15(),
            settingInkWell(
                Icons.lock_outline,
                "Change Password",
                () =>
                    Navigator.pushNamed(context, Routes.verifyPasswordScreen)),
            size8(),
            LogoutItem(logoutFromALLdevice: false),
            size8(),
            LogoutItem(logoutFromALLdevice: true),
            size8(),
            DeleteAccountItem(username: username!, email: email!),
            size25(),
            const Text("About Us"),
            size15(),
            settingInkWell(Icons.info_outline, "About Us",
                () => Navigator.pushNamed(context, Routes.aboutScreen)),
            size8(),
            settingInkWell(Icons.help_outline, "Privacy policy",
                () => Navigator.pushNamed(context, Routes.privacyPolicyScreen)),
            size8(),
            settingInkWell(
                Icons.description,
                "Term and condition",
                () => Navigator.pushNamed(
                    context, Routes.termAndConditionScreen)),
            size8(),
            settingDoubleRowInkWell(Icons.hive, "Version", "v1.0.0", () {}),
            size8(),
            settingDoubleRowInkWell(
                Icons.thumb_up_alt_outlined,
                "Leave Feedback",
                "Let us know how you like the app or report any bug",
                () => Navigator.pushNamed(context, Routes.feedbackScreen)),
            size25()
          ],
        ),
      ),
    );
  }

  Container userDetailChip(String text) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.textInput,
        borderRadius: BorderRadius.circular(100),
      ),
      margin: const EdgeInsets.only(right: 4, top: 4),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, height: 0),
        ),
      ),
    );
  }

  InkWell logoutBtn(BuildContext context, bool logoutFromAllDevice) {
    return InkWell(
      // onTap: () => _authStream?.logout(context, logoutFromAllDevice),
      onTap: () {},
      child: Ink(
        child: const Text(
          'Logout',
          style: TextStyle(color: AppColor.red, fontSize: 14),
        ),
      ),
    );
  }

  InkWell logoutLoadingBtn() {
    return InkWell(
      onTap: () {},
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const CircularProgressIndicator(),
      ),
    );
  }

  SizedBox size15() {
    return const SizedBox(
      height: 15,
    );
  }

  SizedBox size8() => const SizedBox(
        height: 8,
      );

  InkWell settingInkWell(IconData icon, String text, Function onTap,
      {Color iconColor = AppColor.white, Color textColor = AppColor.white}) {
    return InkWell(
      onTap: () => onTap(),
      borderRadius: BorderRadius.circular(9),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
            color: AppColor.card, borderRadius: BorderRadius.circular(9)),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: textColor,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 12, color: textColor),
            )
          ],
        ),
      ),
    );
  }

  InkWell settingDoubleRowInkWell(
      IconData icon, String text, String subText, Function onTap,
      {Color iconColor = AppColor.white, Color textColor = AppColor.white}) {
    return InkWell(
      onTap: () => onTap(),
      borderRadius: BorderRadius.circular(9),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
            color: AppColor.card, borderRadius: BorderRadius.circular(9)),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: textColor,
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(fontSize: 14, color: textColor),
                ),
                Text(
                  subText,
                  style: const TextStyle(color: AppColor.grey, fontSize: 10),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  SizedBox size25() {
    return const SizedBox(
      height: 25,
    );
  }
}
