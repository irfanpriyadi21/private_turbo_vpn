import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vpn_mobile/Provider/Config/getConfig.dart';
import 'package:vpn_mobile/Provider/app_provider.dart';
import 'Commons/AppStore.dart';
import 'Commons/AppTheme.dart';
import 'Commons/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import 'Commons/navigatorKey.dart';
import 'Page/Auth/login_page.dart';
import 'Provider/Auth/auth.dart';

AppStore appStore = AppStore();

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialize();
  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then((_) {
    return runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => AppProvider()
          ),
        ],
        child: const MyApp(),
      )
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: Auth()
        ),
        ChangeNotifierProvider.value(
            value: GetConfig()
        )
      ],
      child: ScreenUtilInit(
        builder: (context, child){
          return Consumer<AppProvider>(
            builder: (context, value, child){
              return Observer(
                builder: (_) => MaterialApp(
                  scrollBehavior: SBehavior(),
                  navigatorKey: NavigationService.navigatorKey,
                  title: APP_NAME,
                  debugShowCheckedModeBanner: false,
                  theme: AppThemeData.lightTheme,
                  darkTheme: AppThemeData.darkTheme,
                  themeMode: appStore.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
                  home:const LoginPage(),
                ),
              );
            },
          );
        },
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
