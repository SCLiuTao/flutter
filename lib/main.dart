import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:myapp/appconfig.dart';
import 'package:myapp/generated/l10n.dart';
import 'package:myapp/pages/webview.dart';
import 'package:overlay_support/overlay_support.dart';

//import 'homepage.dart';

//void main() => runApp(const MyApp() );
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  if (Platform.isAndroid) {
    //设置状态栏与Appbar同一色
    SystemUiOverlayStyle systemUiOverlayStyle =
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        localizationsDelegates: const [
          S.delegate, //intl的delegate
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales, //支持的国际化语言
        //locale: const Locale('en'), //当前的语言
        localeListResolutionCallback: (locales, supportedLocales) {
          debugPrint('当前系统语言环境$locales');
          return;
        },
        title: Config.appname,
        home: const WebViewPage(),
        // initialRoute: '/',
        // routes: {
        //   '/': (context) => const Login(),
        //   'register': (context) => const Register(),
        // },
      ),
    );
  }
}
