import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/provider/theme_provider.dart';
import 'package:video_chat/util/app_constants.dart';
import 'package:video_chat/util/app_theme.dart';
import 'SplashScreen.dart';
import 'Auth/logsignin_page.dart';
import 'Auth/auth.dart';
import 'Model/user.dart';
import 'Auth/login.dart';
import 'Auth/register.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  prefs.then((value) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: value != null ? Color(0xff000000) : Color(0xffffffff),
        systemNavigationBarIconBrightness: value != null ? Brightness.light : Brightness.dark)
    );

    runApp(
      ChangeNotifierProvider<ThemeNotifier>(
        create: (BuildContext context) {
          String theme = value.getString(Constants.APP_THEME);
          if (theme == null ||
              theme == "" ||
              theme == Constants.SYSTEM_DEFAULT) {
            value.setString(Constants.APP_THEME, Constants.SYSTEM_DEFAULT);
            return ThemeNotifier(ThemeMode.system);
          }
          return ThemeNotifier(
              theme == Constants.DARK ? ThemeMode.dark : ThemeMode.light);
        },
        child: MyApp(),
      ),
    );
  });
}


class MyApp extends StatelessWidget {

  final PageController pageController = new PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme().lightTheme,
        darkTheme: AppTheme().darkTheme,
        themeMode: themeNotifier.getThemeMode(),
        home:SplashScreen(),
        routes: {
          LogsignIn.id: (context) => LogsignIn(),
          Login.id: (context) => Login(),
          Register.id: (context) => Register(),
        },
      ),
    );
  }
}
