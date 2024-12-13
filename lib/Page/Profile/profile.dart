import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Commons/widgets.dart';
import '../../main.dart';
import '../Auth/login_page.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: careaAppBarWidget(
        context,
        titleText: "Profile",
        // actionWidget: IconButton(onPressed: () {}, icon: Icon(Icons.chat, color: context.iconColor)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            SizedBox(height: 16),
            Stack(
              children: [
                Image.asset("assets/images/userImage.jpg", height: 100, width: 100, fit: BoxFit.cover).cornerRadiusWithClipRRect(60),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    alignment: Alignment.center,
                    padding:const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.black.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.edit, color: white, size: 16),
                  ).onTap(() {

                  }),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Irfan Priyadi Nurfauzi', style: GoogleFonts.poppins(
                textStyle: boldTextStyle(size: 18)
            )),
            const SizedBox(height: 8),
            Text('+62 5694 1182 11', style: GoogleFonts.poppins(
                textStyle: secondaryTextStyle()
            )),
            const SizedBox(height: 16),
            const Divider(height: 0),
            const SizedBox(height: 16),
            SettingItemWidget(
              leading: Icon(Icons.security, color: context.iconColor),
              title: "Security",
              titleTextStyle: GoogleFonts.poppins(
                  textStyle: boldTextStyle()
              ),
              onTap: () {
                //
              },
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18, color: context.iconColor),
            ),
            SettingItemWidget(
              leading: Icon(Icons.wb_sunny_outlined, color: context.iconColor),
              title: "Dark Mode",
              titleTextStyle: GoogleFonts.poppins(
                  textStyle: boldTextStyle()
              ),
              onTap: () async {
                if (appStore.isDarkModeOn) {
                  appStore.toggleDarkMode(value: false);
                } else {
                  appStore.toggleDarkMode(value: true);
                }
              },
              trailing: SizedBox(
                height: 20,
                width: 30,
                child: Switch(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: appStore.isDarkModeOn,
                  onChanged: (bool value) {
                    appStore.toggleDarkMode(value: value);
                    setState(() {

                    });
                  },
                ),
              ),
            ),
            SettingItemWidget(
              leading: Icon(Icons.lock_outline, color: context.iconColor),
              title: "Privacy Policy",
              titleTextStyle: GoogleFonts.poppins(
                  textStyle: boldTextStyle()
              ),
              onTap: () {
                //
              },
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18, color: context.iconColor),
            ),
            SettingItemWidget(
              leading: Icon(Icons.login, color: context.iconColor),
              title: "Logout",
              titleTextStyle: GoogleFonts.poppins(
                  textStyle: boldTextStyle()
              ),
              onTap: () {
                showConfirmDialogCustom(context, onAccept: (c) {
                  const LoginPage().launch(context, isNewTask: true);
                }, dialogType: DialogType.CONFIRMATION);
              },
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 18, color: context.iconColor),
            ),
          ],
        ),
      ),
    );
  }
}
