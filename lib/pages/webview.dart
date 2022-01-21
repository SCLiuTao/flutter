import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/appconfig.dart';
import 'package:myapp/generated/l10n.dart';
import 'package:myapp/models/pushnotification_model.dart';
import 'package:myapp/notification_badge.dart';
import 'package:myapp/pages/login.dart';
import 'package:myapp/utils/customer_route.dart';
import 'package:myapp/utils/local_lang.dart';
import 'package:myapp/utils/progresshub.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:intl/intl.dart';

import '../utils/storage_util.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;
  final CookieManager cookieManager = CookieManager();
  String _title = "";
  bool isApiCallProcess = false;
  String initUrl = Config.baseUrl;
  String _currentUrl = "";
  String currentLang = "";
  final _bottomNavigationColor = Colors.grey;
  final _bottomNavigationColorActive = Colors.blueAccent;
  int _currentIndex = 0;

  //初始化push

  late final FirebaseMessaging _messaging;
  late int _totalCount;
  PushNotification? _notificationInfo;
//注册通知
  void regsterNotification() async {
    await Firebase.initializeApp();
    //初始化消息
    _messaging = FirebaseMessaging.instance;
    //通知中的三种状态
    //不确定、不同意、不拒绝

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint("用户授予权限");
      //主要消息
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        PushNotification notification = PushNotification(
          title: message.notification!.title,
          body: message.notification!.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );
        //debugPrint("========>${notification.title}");
        setState(() {
          _totalCount++;
          _notificationInfo = notification;
        });
        // ignore: unnecessary_null_comparison
        if (notification != null) {
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            leading: NotificationBadge(totalNotification: _totalCount),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.cyan.shade700,
            duration: const Duration(seconds: 10),
          );
        }
      });
    } else {
      //debugPrint('用户拒绝权限');
    }
  }

  // 用于在应用程序处于终止状态时处理通知
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
        _totalCount++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _totalCount = 0;
    // 用于在应用程序处于后台时处理通知
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
        _totalCount++;
      });
    });
    //普通通知
    regsterNotification();
    //当应用程序终止状态
    checkForInitialMessage();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    if (Intl.getCurrentLocale() != "") {
      if (Intl.getCurrentLocale() == "zh_CN" ||
          Intl.getCurrentLocale() == "zh_HK") {
        initUrl = initUrl + "?lang=zh-hant";
      } else {
        initUrl = initUrl + "?lang=en";
      }
    } else {
      initUrl = initUrl + "?lang=zh-hant";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              leading: InkWell(
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.blue,
                  size: 24.0,
                ),
                onTap: () {
                  Future<bool> canGoBack = _controller.canGoBack();
                  canGoBack.then(
                    (str) {
                      if (str) {
                        _controller.goBack();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(S.current.noHistoricalRecord),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
              // trailing: LocalLang.langList(context, _changeLanguage),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      _controller.reload();
                    },
                    icon: const Icon(
                      Icons.refresh,
                      size: 25.0,
                      color: Colors.blue,
                    ),
                  ),
                  LocalLang.langList(context, _changeLanguage, true)
                ],
              ),
              middle: Text(
                _title == "" ? Config.apptitle : _title,
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            child: SafeArea(
              child: ProgressHUD(
                child: WebView(
                  userAgent: "flutter",
                  //initialCookies: [WebViewCookie(name: "123", value: value, domain: domain)],
                  initialUrl: initUrl,
                  //JS执行模式 是否允许JS执行
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (controller) {
                    _controller = controller;
                  },
                  onPageStarted: (url) async {
                    debugPrint('Page started loading: $url');
                    if (url.contains("customer-logout") == true) {
                      await StorageUtil.removeString("userinfo");
                      cookieManager.clearCookies();
                      setState(() {
                        _currentIndex = 0;
                        initUrl = Config.navaigationbarUrl0;
                        if (Intl.getCurrentLocale() != "") {
                          if (Intl.getCurrentLocale() == "zh_CN" ||
                              Intl.getCurrentLocale() == "zh_HK") {
                            initUrl = initUrl + "?lang=zh-hant";
                          } else {
                            initUrl = initUrl + "?lang=en";
                          }
                        } else {
                          initUrl = initUrl + "?lang=zh-hant";
                        }
                        _controller.loadUrl(initUrl);
                      });
                    }
                    setState(() {
                      isApiCallProcess = true;
                    });
                  },
                  onProgress: (int progress) {
                    //debugPrint("WebView is loading (progress : $progress%)");
                  },
                  onPageFinished: (url) async {
                    _onSetCookie(_controller);
                    _controller
                        .runJavascriptReturningResult("document.title")
                        .then((result) {
                      setState(() {
                        //print("网页标题：" + result);
                        if (result != "") {
                          _title = result.replaceAll('"', "").split("-")[0];
                        }
                        isApiCallProcess = false;
                        _currentUrl = url;
                      });
                    });
                  },
                  navigationDelegate: (NavigationRequest request) {
                    if (request.url.startsWith("myapp://")) {
                      //debugPrint("即将打开 ${request.url}");
                      return NavigationDecision.prevent;
                    }
                    return NavigationDecision.navigate;
                  },
                  onWebResourceError: (error) {
                    setState(() {
                      isApiCallProcess = false;
                    });
                  },
                  javascriptChannels: <JavascriptChannel>{
                    _toasterJavascriptChannel(context),
                  },
                ),
                inAsyncCall: isApiCallProcess,
                opacity: 0.7,
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _bottomNavigationBarUI(),
    );
  }

  Widget _bottomNavigationBarUI() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: _bottomNavigationColor,
          ),
          activeIcon: Icon(
            Icons.home,
            color: _bottomNavigationColorActive,
          ),
          label: S.current.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.menu_book_sharp,
            color: _bottomNavigationColor,
          ),
          activeIcon: Icon(
            Icons.menu_book_sharp,
            color: _bottomNavigationColorActive,
          ),
          label: S.current.shop,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.shopping_cart,
            color: _bottomNavigationColor,
          ),
          activeIcon: Icon(
            Icons.shopping_cart,
            color: _bottomNavigationColorActive,
          ),
          label: S.current.cart,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.supervised_user_circle,
            color: _bottomNavigationColor,
          ),
          activeIcon: Icon(
            Icons.supervised_user_circle,
            color: _bottomNavigationColorActive,
          ),
          label: S.current.profile,
        ),
      ],
      type: BottomNavigationBarType.fixed,
      onTap: (int index) async {
        //print(index);
        if (_currentIndex != index) {
          setState(() {
            _currentIndex = index;
          });
          if (_currentIndex == 0) {
            setState(() {
              initUrl = Config.navaigationbarUrl0;
            });
          } else if (index == 1) {
            setState(() {
              initUrl = Config.navaigationbarUrl1;
            });
          } else if (index == 2) {
            // final userInfoJson = await StorageUtil.getString("userinfo");

            // if (userInfoJson == null) {
            //   Navigator.of(context).push(
            //       CustomerRoute(Login(webUrl: Config.navaigationbarUrl2)));
            // } else {
            setState(() {
              initUrl = Config.navaigationbarUrl2;
            });
            //}
          } else {
            final userInfoJson = await StorageUtil.getString("userinfo");
            if (userInfoJson == null) {
              Navigator.of(context).push(CustomerRoute(const Login()));
            } else {
              setState(() {
                initUrl = Config.navaigationbarUrl3;
              });
            }
          }
          if (Intl.getCurrentLocale() != "") {
            if (Intl.getCurrentLocale() == "zh_CN" ||
                Intl.getCurrentLocale() == "zh_HK") {
              initUrl = initUrl + "?lang=zh-hant";
            } else {
              initUrl = initUrl + "?lang=en";
            }
          } else {
            initUrl = initUrl + "?lang=zh-hant";
          }
          // final userInfoJson = await StorageUtil.getString("userinfo");

          _controller.loadUrl(initUrl);
        }
      },
      currentIndex: _currentIndex,
    );
  }

  void _changeLanguage(String landcode) async {
    if (_currentUrl.contains("?lang=")) {
      setState(() {
        _currentUrl = _currentUrl.split("?lang=")[0];
      });
    }
    //debugPrint('修改前语言环境:${Intl.getCurrentLocale()}');
    if (landcode == "EN") {
      await S.load(const Locale("en"));
      setState(() {
        _currentUrl = _currentUrl + "?lang=en";
      });
    } else if (landcode == 'CN') {
      await S.load(const Locale('zh', 'CN'));
      setState(() {
        _currentUrl = _currentUrl + "?lang=zh-hant";
      });
    } else if (landcode == 'HK') {
      await S.load(const Locale('zh', 'HK'));
      setState(() {
        _currentUrl = _currentUrl + "?lang=zh-hant";
      });
    } else {
      StorageUtil.removeString('userinfo');
      cookieManager.clearCookies();
      _currentUrl = Config.baseUrl;
      setState(() {
        _currentIndex = 0;
      });
      // Future.delayed(
      //   const Duration(milliseconds: 500),
      //   () {
      //     Navigator.of(context).pushAndRemoveUntil(
      //       MaterialPageRoute(builder: (context) => const Login()),
      //       (route) => false,
      //     );
      //   },
      // );
    }
    _controller.loadUrl(_currentUrl);
    //debugPrint('修改后语言环境:${Intl.getCurrentLocale()}');
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'jsCallFlutter',
      onMessageReceived: (JavascriptMessage message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message.message.toString()),
            duration: const Duration(seconds: 3),
          ),
        );
      },
    );
  }

  //设置webviewcookies
  Future<void> _onSetCookie(WebViewController webViewController) async {
    final userInfoJson = await StorageUtil.getString("userinfo");
    if (userInfoJson != null) {
      Map<String, dynamic> data = json.decode(userInfoJson);
      if (Platform.isIOS) {
        await webViewController.runJavascriptReturningResult(
            "document.cookie = 'wordpress_logged_in_${data['user_cookieHash']}=${data['hashValue']}'");
      } else {
        await webViewController.runJavascript(
            'document.cookie = "wordpress_logged_in_${data['user_cookieHash']}=${data['hashValue']}; path=/"');
      }
    }
  }
}
