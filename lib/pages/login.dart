import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/appconfig.dart';
import 'package:myapp/generated/l10n.dart';
import 'package:myapp/models/login_model.dart';
import 'package:myapp/pages/register.dart';
import 'package:myapp/pages/webview.dart';
import 'package:myapp/utils/customer_route.dart';
import 'package:myapp/utils/local_lang.dart';
import 'package:myapp/utils/storage_util.dart';
import 'dart:ui' as ui;

import 'package:myapp/utils/progresshub.dart';
import 'package:myapp/utils/toast_util.dart';

class Login extends StatefulWidget {
  final Map? tologin;
  const Login({Key? key, this.tologin}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //获取Key用来获取Form表单组件q
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  //初始化登录表单
  String? _email;
  String? _password;
  bool isShowPassWord = false;
  bool isApiCallProcess = false;
  String? registerJson;

  @override
  void initState() {
    final registerJson = widget.tologin;
    if (widget.tologin != null) {
      Map? registerInfo = registerJson;
      if (registerInfo!['userEmail'] != null) {
        setState(() {
          _userController.text = registerInfo['userEmail'];
        });
      }
    }

    super.initState();
  }

  // _getUserInfo() async {
  //   final userInfoJson = await StorageUtil.getString("userinfo");
  //   if (userInfoJson != null) {
  //     Map<String, dynamic> data = json.decode(userInfoJson);
  //     if (data['user_id'] != null) {
  //       var userName = data["user_email"] ?? data["user_name"];
  //       dologin(userName, data['user_password']);
  //     }
  //   }
  // }

  void login() {
    var loginForm = _formkey.currentState;
    //验证Form表单
    if (loginForm!.validate()) {
      loginForm.save();
      //debugPrint('Email: ' + _email! + ' password: ' + _password!);
      //执行登录
      dologin(_email!, _password!);
      setState(() {
        isShowPassWord = false;
        isApiCallProcess = true;
      });
    }
  }

  void dologin(String email, String pwd) async {
    try {
      Dio dio = Dio();
      Response response = await dio.post(
        Config.loginURL,
        data: {
          'username': email,
          'password': pwd,
        },
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(
          () {
            isApiCallProcess = false;
          },
        );

        final responseJson = jsonDecode(response.data);
        LoginMoel _loginModel = LoginMoel.fromJson(responseJson);
        Data? data = _loginModel.data;
        if (_loginModel.statusCode == 200) {
          if (data == null) {
            ToastUtil.showInfo(S.of(context).loginException, false);
          } else {
            StorageUtil.setString("userinfo", jsonEncode(data.toJson()));
            Navigator.of(context).push(CustomerRoute(const WebViewPage()));
            // Future.delayed(const Duration(milliseconds: 500), () {
            //   Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(builder: (context) => const WebViewPage()),
            //     (route) => false,
            //   );
            // });
          }
        } else {
          ToastUtil.showInfo(S.of(context).wrongUserNameOrPassword, false);
        }

        //print(LoginMoel.fromJson(responseJson));
      }
    } on DioError {
      //debugPrint(e.message);
      setState(() {
        isApiCallProcess = false;
      });
      ToastUtil.showInfo(S.of(context).networkConnectionError, false);
    }
  }

  //苹果ID登录
  void loginApple(
      String firstName, String lastName, String email, String userID) async {
    setState(() {
      isApiCallProcess = true;
    });
    try {
      Dio dio = Dio();
      Response response = await dio.post(
        Config.loginAppleURL,
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'appleUserID': userID
        },
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(
          () {
            isApiCallProcess = false;
          },
        );

        final responseJson = jsonDecode(response.data);
        LoginMoel _loginModel = LoginMoel.fromJson(responseJson);
        Data? data = _loginModel.data;
        if (_loginModel.statusCode == 200) {
          if (data == null) {
            ToastUtil.showInfo(S.of(context).loginException, false);
          } else {
            StorageUtil.setString("userinfo", jsonEncode(data.toJson()));
            Navigator.of(context).push(CustomerRoute(const WebViewPage()));
          }
        } else {
          ToastUtil.showInfo(S.of(context).wrongUserNameOrPassword, false);
        }

        //print(LoginMoel.fromJson(responseJson));
      }
    } on DioError {
      //debugPrint(e.message);
      setState(() {
        isApiCallProcess = false;
      });
      ToastUtil.showInfo(S.of(context).networkConnectionError, false);
    }
  }

  //显示隐藏密码
  void showPassWord() {
    setState(() {
      isShowPassWord = !isShowPassWord;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _loginUI(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _loginUI(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        //automaticallyImplyLeading: true, //自动返回图标
        leading: InkWell(
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.blue,
          ),
          onTap: () {
            Navigator.of(context).push(CustomerRoute(const WebViewPage()));
          },
        ),
        title: Text(
          S.of(context).login,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 22.0,
          ),
        ),
        centerTitle: true,
        elevation: 4.0, //appbar与body整合度
        actions: <Widget>[
          LocalLang.langList(context, _changeLanguage, false)
          // PopupMenuButton<String>(
          //   icon: const Icon(
          //     Icons.more_horiz_rounded,
          //     color: Colors.blue,
          //     size: 30.0,
          //   ),
          //   itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
          //     selectView("lib/images/zh-hans.png", '简体', 'CN'),
          //     selectView("lib/images/zh-hant.png", '繁体', 'HK'),
          //     selectView("lib/images/en.png", 'English', 'EN'),
          //   ],
          //   onSelected: (String action) {
          //     _changeLanguage(action);
          //   },
          // )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          //padding: const EdgeInsets.only(top: 50.0, bottom: 10.0),
          child: Platform.isIOS ? iosUI(context) : androidUI(context),
          //边框设置
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
            border: Border.all(
              width: 1.0,
              color: const Color.fromARGB(255, 196, 199, 206),
            ),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10.0, //延伸距离,会有模糊效果
                color: Color.fromARGB(255, 196, 199, 206), //阴影颜色
                spreadRadius: 5.0, //延伸距离,不会有模糊效果
                offset: Offset(5.0, 5.0), //向右下偏移的距离
              )
            ],
          ),
          width: 400.0,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
            top: 20.0,
            left: 10.0,
            right: 10.0,
          ),
        ),
      ),
    );
  }

  iosUI(contxt) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Text(
            Config.logintext,
            style: TextStyle(
              fontSize: 30,
              foreground: Paint()
                ..shader = ui.Gradient.linear(
                  const Offset(30, 20),
                  const Offset(200, 20),
                  <Color>[Colors.red, Colors.orange.shade500],
                ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    controller: _userController,
                    decoration: InputDecoration(
                      labelText: S.of(context).emailOrUserName,
                      labelStyle: const TextStyle(
                        fontSize: 15.0,
                        color: Color.fromARGB(255, 93, 93, 93),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).hintColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffD5D5D5),
                          width: 1,
                        ),
                      ),
                      // focusedBorder: UnderlineInputBorder(
                      //     borderSide: BorderSide(
                      //         color: Theme.of(context).focusColor)),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.cancel,
                          color: Color.fromARGB(255, 126, 126, 126),
                          size: 20.0,
                        ),
                        onPressed: () {
                          _userController.clear();
                        },
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      _email = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return S.of(context).pleaseEnterEmailOrUsername;
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: S.of(context).password,
                        labelStyle: const TextStyle(
                          fontSize: 15.0,
                          color: Color.fromARGB(255, 93, 93, 93),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffD5D5D5),
                            width: 1,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isShowPassWord
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color.fromARGB(255, 126, 126, 126),
                            size: 20.0,
                          ),
                          onPressed: showPassWord,
                        )),
                    obscureText: !isShowPassWord,
                    onSaved: (value) {
                      _password = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return S.of(context).pleaseEnterPassword;
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  height: 45.0,
                  margin: const EdgeInsets.only(top: 40.0),
                  child: SizedBox.expand(
                    child: MaterialButton(
                      onPressed: login,
                      color: const Color.fromARGB(255, 61, 203, 128),
                      child: Text(
                        S.of(context).login,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Color.fromARGB(255, 255, 255, 255),
                          wordSpacing: 10.0,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 20.0,
                // ),
                // SignInWithAppleButton(
                //   //apple id login
                //   onPressed: () async {
                //     final credential =
                //         await SignInWithApple.getAppleIDCredential(
                //       scopes: [
                //         AppleIDAuthorizationScopes.email,
                //         AppleIDAuthorizationScopes.fullName,
                //       ],
                //     );
                //     print("=========>${credential}");
                //     // ignore: unnecessary_null_comparison
                //     // if (credential != null) {
                //     //   final Map<String, dynamic> data = <String, dynamic>{};
                //     //   final fristName = credential.givenName;
                //     //   final lastName = credential.familyName;
                //     //   final email = credential.email;
                //     //   final userID = credential.userIdentifier;
                //     //   if (fristName != null && lastName != null) {
                //     //     data['userId'] = userID;
                //     //     data['firstName'] = fristName;
                //     //     data['lastName'] = lastName;
                //     //     data['email'] = email;
                //     //     StorageUtil.setString("appleIDLogin", jsonEncode(data));
                //     //     loginApple(
                //     //         fristName, lastName, email!, userID.toString());
                //     //   } else {
                //     //     loginApple("", "", "", userID.toString());
                //     //   }
                //     // }
                //   },
                //   text: S.of(context).appleLogin,
                //   style: SignInWithAppleButtonStyle.black,
                // ),
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        child: Text(
                          S.of(context).signUp,
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Color.fromARGB(255, 132, 134, 137),
                          ),
                        ),
                        onTap: () async {
                          await _auth.signOut();
                          Navigator.push(
                            context,
                            // MaterialPageRoute(
                            //   builder: (context) => const Register(),
                            // ),
                            CustomerRoute(const Register()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  androidUI(contxt) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Text(
            Config.logintext,
            style: TextStyle(
              fontSize: 30,
              foreground: Paint()
                ..shader = ui.Gradient.linear(
                  const Offset(30, 20),
                  const Offset(200, 20),
                  <Color>[Colors.red, Colors.orange.shade500],
                ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: TextFormField(
                    controller: _userController,
                    decoration: InputDecoration(
                      labelText: S.of(context).emailOrUserName,
                      labelStyle: const TextStyle(
                        fontSize: 15.0,
                        color: Color.fromARGB(255, 93, 93, 93),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).hintColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffD5D5D5),
                          width: 1,
                        ),
                      ),
                      // focusedBorder: UnderlineInputBorder(
                      //     borderSide: BorderSide(
                      //         color: Theme.of(context).focusColor)),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.cancel,
                          color: Color.fromARGB(255, 126, 126, 126),
                          size: 20.0,
                        ),
                        onPressed: () {
                          _userController.clear();
                        },
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      _email = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return S.of(context).pleaseEnterEmailOrUsername;
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: S.of(context).password,
                        labelStyle: const TextStyle(
                          fontSize: 15.0,
                          color: Color.fromARGB(255, 93, 93, 93),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffD5D5D5),
                            width: 1,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isShowPassWord
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color.fromARGB(255, 126, 126, 126),
                            size: 20.0,
                          ),
                          onPressed: showPassWord,
                        )),
                    obscureText: !isShowPassWord,
                    onSaved: (value) {
                      _password = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return S.of(context).pleaseEnterPassword;
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  height: 45.0,
                  margin: const EdgeInsets.only(top: 40.0),
                  child: SizedBox.expand(
                    child: MaterialButton(
                      onPressed: login,
                      color: const Color.fromARGB(255, 61, 203, 128),
                      child: Text(
                        S.of(context).login,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Color.fromARGB(255, 255, 255, 255),
                          wordSpacing: 10.0,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        child: Text(
                          S.of(context).signUp,
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Color.fromARGB(255, 132, 134, 137),
                          ),
                        ),
                        onTap: () async {
                          await _auth.signOut();
                          Navigator.push(
                            context,
                            // MaterialPageRoute(
                            //   builder: (context) => const Register(),
                            // ),
                            CustomerRoute(const Register()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _changeLanguage(String landcode) async {
    if (landcode == "EN") {
      await S.load(const Locale("en"));
    } else if (landcode == 'CN') {
      await S.load(const Locale('zh', 'CN'));
    } else {
      await S.load(const Locale('zh', 'HK'));
    }
    setState(() {});
  }
}
