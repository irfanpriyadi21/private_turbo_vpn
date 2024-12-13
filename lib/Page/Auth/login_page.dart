import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:vpn_mobile/Page/index.dart';
import '../../Commons/alert.dart';
import '../../Commons/widgets.dart';
import '../../Model/http_exceptions.dart';
import '../../Provider/Auth/auth.dart';
import '../../commons/images.dart';
import '../../main.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

enum LoginStatus{notSignIn, signIn}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  bool isIconTrue = true;
  bool isChecked = false;
  DateTime pre_backpress = DateTime.now();
  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();

  final _formKey = GlobalKey<FormState>();
  var userinfo;

  bool? checkBoxValue = false;
  late String _authorized = 'Not Authorized';
  late bool _isAuthenticating = false;
  bool isLoading = false;
  LoginStatus _loginStatus = LoginStatus.notSignIn;

  getPref()async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    setState(() {
      String? status = preferences.getString('loginStatus');
      _loginStatus = status == 'success'
          ? LoginStatus.signIn
          : LoginStatus.notSignIn;
    });
  }

  login()async{
    setState(() {
      isLoading = true;
    });
    try{
      await Provider.of<Auth>(context,listen: false).authenticate(
          _emailController.text, _passwordController.value.text);
    }on StringHttpException catch(e){
      var errorMessage = e.toString();
      AlertFail(errorMessage);
      setState(() {
        isLoading = false;
      });
    }catch(error, s){
      print(error);
      print(s);
      AlertFail("Login Failed !! $s");
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
      bool login = Provider.of<Auth>(context,listen: false).login!;

      if(login == true){
        _loginStatus = LoginStatus.signIn;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }



  @override
  Widget build(BuildContext context) {
    switch(_loginStatus){
      case LoginStatus.notSignIn:
        return PopScope(
          canPop: false,
          onPopInvoked : (didPop){
            final timegap = DateTime.now().difference(pre_backpress);
            final cantExit = timegap >= const Duration(seconds: 2);

            print(cantExit);
            pre_backpress = DateTime.now();
            if(cantExit){
              // show snackbar
              final snack = SnackBar(content: Text('Press Back button again to Exit'),duration: Duration(seconds: 2),);
              ScaffoldMessenger.of(context).showSnackBar(snack);
              return ;
            }else{
              SystemNavigator.pop();
              return ;
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image(height: 130, width: 130, fit: BoxFit.fitWidth, image: AssetImage('assets/images/logo.png'), color:
                        // appStore.isDarkModeOn ? context.iconColor : Colors.black),
                        Text('Login',
                            style: GoogleFonts.poppins(
                                textStyle: boldTextStyle(size: 24)
                            )
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          focusNode: f1,
                          style: GoogleFonts.poppins(),
                          onFieldSubmitted: (v) {
                            f1.unfocus();
                            FocusScope.of(context).requestFocus(f2);
                          },
                          validator: (k) {
                            if (k!.isEmpty) {
                              return 'Isikan dengan Email yang Sesuai';
                            }
                            return null;
                          },
                          controller: _emailController,
                          decoration: inputDecoration(context, prefixIcon: Icons.mail_rounded, hintText: "Email"),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: isIconTrue,
                          style: GoogleFonts.poppins(),
                          focusNode: f2,
                          validator: (value) {
                            if(value!.isEmpty){
                              return 'Please enter password';
                            }
                          },
                          onFieldSubmitted: (v) {
                            // f2.unfocus();
                            // if (_formKey.currentState!.validate()) {
                            //   Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                            // }
                          },
                          decoration: inputDecoration(
                            context,
                            prefixIcon: Icons.lock,
                            hintText: "Password",
                            suffixIcon: Theme(
                              data: ThemeData(splashColor: Colors.transparent, highlightColor: Colors.transparent),
                              child: IconButton(
                                highlightColor: Colors.transparent,
                                onPressed: () {
                                  setState(() {
                                    isIconTrue = !isIconTrue;
                                  });
                                },
                                icon: Icon(
                                  (isIconTrue) ? Icons.visibility_rounded : Icons.visibility_off,
                                  size: 16,
                                  color: appStore.isDarkModeOn ? white : gray,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Theme(
                          data: ThemeData(unselectedWidgetColor: appStore.isDarkModeOn ? Colors.white : black),
                          child: CheckboxListTile(
                            contentPadding:const EdgeInsets.all(0),
                            title: Text("Ingat Saya", style: GoogleFonts.poppins(
                                textStyle: primaryTextStyle(
                                    size: 14
                                )
                            )),
                            value: checkBoxValue,
                            dense: true,
                            onChanged: (newValue) {
                              setState(() {
                                checkBoxValue = newValue;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              login();
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: boxDecorationWithRoundedCorners(
                              borderRadius: const BorderRadius.all(Radius.circular(45)),
                              backgroundColor: appStore.isDarkModeOn ? cardDarkColor : black,
                            ),
                            child: Text('Login', style: GoogleFonts.poppins(
                                textStyle: boldTextStyle(color: white)
                            )),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {

                          },
                          child: Text('Lupa password ?', style: GoogleFonts.poppins(
                              textStyle: boldTextStyle()
                          )),
                        ),
                        const SizedBox(height: 8),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      case LoginStatus.signIn :
        return IndexPage();
    }
  }
}
