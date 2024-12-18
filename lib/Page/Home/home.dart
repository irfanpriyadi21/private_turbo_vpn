import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:vpn_mobile/Commons/loading.dart';
import 'package:vpn_mobile/Model/ModelConfig.dart';
import 'package:vpn_mobile/Provider/Config/getConfig.dart';
import 'package:wireguard_flutter/wireguard_flutter.dart';

import '../../Commons/alert.dart';
import '../../Commons/colors.dart';
import '../../Model/http_exceptions.dart';
import '../../main.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  String name = "";
  ModelConfig? dataConfig;
  bool isLoading = false;
  String statusInitialized = "";
  final wireguard = WireGuardFlutter.instance;
  bool statVpn = false;

  late String nameVpn;

  getPref()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("username")!;
    });
  }

  getDataConfig()async{
    setState(() {
      isLoading = true;
    });
    try{
      dataConfig = await Provider
          .of<GetConfig>(context, listen: false)
          .config();
    }on StringHttpException catch(err){
      var errorMessage = err.toString();
      AlertFail(errorMessage);
    }catch(e, s){
      print(s);
      AlertFail("Something Went Wrong! $e");
    }
    setState(() {
      isLoading = false;
      if(dataConfig!.status!){
        initialize();
      }
    });
  }

  Future<void> initialize() async {
    try {
      await wireguard.initialize(interfaceName: nameVpn);
      debugPrint("initialize success $name");
      setState(() {
        statusInitialized = "initialize success";
        startVpn();
      });
    } catch (error, stack) {
      debugPrint("failed to initialize: $error\n$stack");
      setState(() {
        statusInitialized = "failed to initialize: $error\n$stack";
      });
    }
  }

  void startVpn() async {
    try {
      await wireguard.startVpn(
        serverAddress: '167.235.55.239:51820',
        wgQuickConfig: dataConfig!.config!,
        providerBundleIdentifier: 'com.vpn.mobileapps.vpn_mobile',
      );
      setState(() {
        statVpn = true;
      });
    } catch (error, stack) {
      debugPrint("failed to start $error\n$stack");
      setState(() {
        statVpn = false;
      });
    }
  }

  void getStatus() async {
    debugPrint("getting stage");
    final stage = await wireguard.stage();
    debugPrint("stage: ${stage.code}");

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('stage: $stage'),
      ));
    }
  }

  void disconnect() async {
    try {
      await wireguard.stopVpn();
      setState(() {
        statVpn = false;
      });
    } catch (e, str) {
      debugPrint('Failed to disconnect $e\n$str');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    getDataConfig();
    wireguard.vpnStageSnapshot.listen((event) {
      debugPrint("status changed $event");
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('status changed: $event'),
        ));
      }
    });
    nameVpn = 'my_wg_vpn';
  }

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
            Text("$name", style: GoogleFonts.poppins(
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
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
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
            SizedBox(height: 30),
            isLoading
            ? Loading()
            : Text(dataConfig!.status! ? "Data Config Status : Success" : "Data Config Status : Failed", style: GoogleFonts.poppins(
                textStyle: secondaryTextStyle(size: 12)
            )).paddingSymmetric(horizontal: 10),
            Text("Status Initialized : $statusInitialized", style: GoogleFonts.poppins(
                textStyle: secondaryTextStyle(size: 12)
            )).paddingSymmetric(horizontal: 10),
            statVpn
            ? Lottie.asset('assets/images/Lottie_Animation.json')
            : SizedBox(),
            const SizedBox(height: 20),
            TextButton(
              onPressed: startVpn,
              style: ButtonStyle(
                  minimumSize:
                  MaterialStateProperty.all<Size>(const Size(100, 50)),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.fromLTRB(20, 15, 20, 15)),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blueAccent),
                  overlayColor: MaterialStateProperty.all<Color>(
                      Colors.white.withOpacity(0.1))),
              child: const Text(
                'Connect',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: disconnect,
              style: ButtonStyle(
                  minimumSize:
                  MaterialStateProperty.all<Size>(const Size(100, 50)),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.fromLTRB(20, 15, 20, 15)),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blueAccent),
                  overlayColor: MaterialStateProperty.all<Color>(
                      Colors.white.withOpacity(0.1))),
              child: const Text(
                'Disconnect',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: getStatus,
              style: ButtonStyle(
                  minimumSize:
                  MaterialStateProperty.all<Size>(const Size(100, 50)),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.fromLTRB(20, 15, 20, 15)),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blueAccent),
                  overlayColor: MaterialStateProperty.all<Color>(
                      Colors.white.withOpacity(0.1))),
              child: const Text(
                'Get status',
                style: TextStyle(color: Colors.white),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
