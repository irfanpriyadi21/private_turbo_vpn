import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Commons/colors.dart';
import '../../main.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 50,
        backgroundColor: appStore.isDarkModeOn ? scaffoldDarkColor : white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Irfan Priyadi Nurfauzi", style: GoogleFonts.poppins(
                textStyle: boldTextStyle(size: 14)
            )),
            Row(
              children: [
                Icon(Icons.location_on, size: 15, color: Colors.grey[400],),
                Text("Sumur Batu, Kemayoran ", style: GoogleFonts.poppins(
                    textStyle: secondaryTextStyle(size: 12)
                )),
              ],
            )
          ],
        ),
        leading: GestureDetector(
          child: const Padding(
            padding: EdgeInsets.only(top: 6, bottom: 6, left: 15),
            child: CircleAvatar(
              radius: 5,
              backgroundImage: AssetImage("assets/images/userImage.jpg"),
              backgroundColor: Colors.transparent,
            ),
          ),
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => ProfileScreen()),
            // );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_rounded, size: 22, color: context.iconColor),
            onPressed: () {

            },
          ),
          // IconButton(
          //   icon: Icon(Icons.favorite_border_rounded, size: 22, color: context.iconColor),
          //   onPressed: () {
          //
          //   },
          // )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                focusNode: searchFocus,
                controller: searchController,
                style: primaryTextStyle(),
                onFieldSubmitted: (val) {

                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Search',
                  hintStyle: secondaryTextStyle(),
                  fillColor: appStore.isDarkModeOn ? cardDarkColor : editTextBgColor,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: radius(defaultRadius),
                    borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: radius(defaultRadius),
                    borderSide:  const BorderSide(color: Colors.transparent, width: 0.0),
                  ),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.search, size: 20, color: appStore.isDarkModeOn ? white : gray.withOpacity(0.5)),
                    onPressed: () {

                    },
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.filter_alt_outlined,
                      size: 20,
                      color: appStore.isDarkModeOn ? white : gray.withOpacity(0.5),
                    ),
                    onPressed: () {

                    },
                  ),
                ),
              ),
            ).paddingSymmetric(horizontal: 8),

          ],
        ),
      ),
    );
  }
}
