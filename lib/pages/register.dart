import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/appconfig.dart';
import 'package:myapp/generated/l10n.dart';
import 'package:myapp/models/customer.dart';
import 'package:myapp/pages/login.dart';
import 'package:myapp/utils/form_helper.dart';
import 'package:myapp/utils/local_lang.dart';
import 'package:myapp/utils/progresshub.dart';
import 'package:myapp/utils/toast_util.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
//获取Key用来获取Form表单组件
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final phoneController = TextEditingController();
  final optController = TextEditingController();
  String verificationId = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();
  CustomerModel model = CustomerModel();

  String? _email;
  String? _password;
  String? _userName;
  String _selectedLocation = "HK+852";
  String _prefix = "+852";
  bool isShowPassWord = false;
  bool isApiCallProcess = false;
  bool isverify = false;
  bool inputEnable = true;
  List phoneFormat = [
    {"id": "AD", "name": "AD+376"},
    {"id": "AE", "name": "AE+971"},
    {"id": "AF", "name": "AF+93"},
    {"id": "AG", "name": "AG+1268"},
    {"id": "AI", "name": "AI+1264"},
    {"id": "AL", "name": "AL+355"},
    {"id": "AM", "name": "AM+374"},
    {"id": "AO", "name": "AO+244"},
    {"id": "AR", "name": "AR+54"},
    {"id": "AS", "name": "AS+1684"},
    {"id": "AT", "name": "AT+43"},
    {"id": "AU", "name": "AU+61"},
    {"id": "AW", "name": "AW+297"},
    {"id": "AX", "name": "AX+35818"},
    {"id": "AZ", "name": "AZ+994"},
    {"id": "BA", "name": "BA+387"},
    {"id": "BB", "name": "BB+1246"},
    {"id": "BD", "name": "BD+880"},
    {"id": "BE", "name": "BE+32"},
    {"id": "BF", "name": "BF+226"},
    {"id": "BG", "name": "BG+359"},
    {"id": "BH", "name": "BH+973"},
    {"id": "BI", "name": "BI+257"},
    {"id": "BJ", "name": "BJ+229"},
    {"id": "BL", "name": "BL+590"},
    {"id": "BM", "name": "BM+1441"},
    {"id": "BN", "name": "BN+673"},
    {"id": "BO", "name": "BO+591"},
    {"id": "BQ", "name": "BQ+599"},
    {"id": "BR", "name": "BR+55"},
    {"id": "BS", "name": "BS+1242"},
    {"id": "BT", "name": "BT+975"},
    {"id": "BW", "name": "BW+267"},
    {"id": "BY", "name": "BY+375"},
    {"id": "BZ", "name": "BZ+501"},
    {"id": "CA", "name": "CA+1"},
    {"id": "CC", "name": "CC+61"},
    {"id": "CD", "name": "CD+243"},
    {"id": "CF", "name": "CF+236"},
    {"id": "CG", "name": "CG+242"},
    {"id": "CH", "name": "CH+41"},
    {"id": "CI", "name": "CI+225"},
    {"id": "CK", "name": "CK+682"},
    {"id": "CL", "name": "CL+56"},
    {"id": "CM", "name": "CM+237"},
    {"id": "CN", "name": "CN+86"},
    {"id": "CO", "name": "CO+57"},
    {"id": "CR", "name": "CR+506"},
    {"id": "CU", "name": "CU+53"},
    {"id": "CV", "name": "CV+238"},
    {"id": "CW", "name": "CW+599"},
    {"id": "CX", "name": "CX+61"},
    {"id": "CY", "name": "CY+357"},
    {"id": "CZ", "name": "CZ+420"},
    {"id": "DE", "name": "DE+49"},
    {"id": "DJ", "name": "DJ+253"},
    {"id": "DK", "name": "DK+45"},
    {"id": "DM", "name": "DM+1767"},
    {"id": "DO", "name": "DO+1809"},
    {"id": "DZ", "name": "DZ+213"},
    {"id": "EC", "name": "EC+593"},
    {"id": "EE", "name": "EE+372"},
    {"id": "EG", "name": "EG+20"},
    {"id": "EH", "name": "EH+212"},
    {"id": "ER", "name": "ER+291"},
    {"id": "ES", "name": "ES+34"},
    {"id": "ET", "name": "ET+251"},
    {"id": "FI", "name": "FI+358"},
    {"id": "FJ", "name": "FJ+679"},
    {"id": "FK", "name": "FK+500"},
    {"id": "FM", "name": "FM+691"},
    {"id": "FO", "name": "FO+298"},
    {"id": "FR", "name": "FR+33"},
    {"id": "GA", "name": "GA+241"},
    {"id": "GB", "name": "GB+44"},
    {"id": "GD", "name": "GD+1473"},
    {"id": "GE", "name": "GE+995"},
    {"id": "GF", "name": "GF+594"},
    {"id": "GG", "name": "GG+441481"},
    {"id": "GH", "name": "GH+233"},
    {"id": "GI", "name": "GI+350"},
    {"id": "GL", "name": "GL+299"},
    {"id": "GM", "name": "GM+220"},
    {"id": "GN", "name": "GN+224"},
    {"id": "GP", "name": "GP+590"},
    {"id": "GQ", "name": "GQ+240"},
    {"id": "GR", "name": "GR+30"},
    {"id": "GT", "name": "GT+502"},
    {"id": "GU", "name": "GU+1671"},
    {"id": "GW", "name": "GW+245"},
    {"id": "GY", "name": "GY+592"},
    {"id": "HK", "name": "HK+852"},
    {"id": "HN", "name": "HN+504"},
    {"id": "HR", "name": "HR+385"},
    {"id": "HT", "name": "HT+509"},
    {"id": "HU", "name": "HU+36"},
    {"id": "ID", "name": "ID+62"},
    {"id": "IE", "name": "IE+353"},
    {"id": "IL", "name": "IL+972"},
    {"id": "IM", "name": "IM+441624"},
    {"id": "IN", "name": "IN+91"},
    {"id": "IO", "name": "IO+246"},
    {"id": "IQ", "name": "IQ+964"},
    {"id": "IR", "name": "IR+98"},
    {"id": "IS", "name": "IS+354"},
    {"id": "IT", "name": "IT+39"},
    {"id": "JE", "name": "JE+441534"},
    {"id": "JM", "name": "JM+1876"},
    {"id": "JO", "name": "JO+962"},
    {"id": "JP", "name": "JP+81"},
    {"id": "KE", "name": "KE+254"},
    {"id": "KG", "name": "KG+996"},
    {"id": "KH", "name": "KH+855"},
    {"id": "KI", "name": "KI+686"},
    {"id": "KM", "name": "KM+269"},
    {"id": "KN", "name": "KN+1869"},
    {"id": "KP", "name": "KP+850"},
    {"id": "KR", "name": "KR+82"},
    {"id": "KW", "name": "KW+965"},
    {"id": "KY", "name": "KY+1345"},
    {"id": "KZ", "name": "KZ+7"},
    {"id": "LA", "name": "LA+856"},
    {"id": "LB", "name": "LB+961"},
    {"id": "LC", "name": "LC+1758"},
    {"id": "LI", "name": "LI+423"},
    {"id": "LK", "name": "LK+94"},
    {"id": "LR", "name": "LR+231"},
    {"id": "LS", "name": "LS+266"},
    {"id": "LT", "name": "LT+370"},
    {"id": "LU", "name": "LU+352"},
    {"id": "LV", "name": "LV+371"},
    {"id": "LY", "name": "LY+218"},
    {"id": "MA", "name": "MA+212"},
    {"id": "MC", "name": "MC+377"},
    {"id": "MD", "name": "MD+373"},
    {"id": "ME", "name": "ME+382"},
    {"id": "MF", "name": "MF+590"},
    {"id": "MG", "name": "MG+261"},
    {"id": "MH", "name": "MH+692"},
    {"id": "MK", "name": "MK+389"},
    {"id": "ML", "name": "ML+223"},
    {"id": "MM", "name": "MM+95"},
    {"id": "MN", "name": "MN+976"},
    {"id": "MO", "name": "MO+853"},
    {"id": "MP", "name": "MP+1670"},
    {"id": "MQ", "name": "MQ+596"},
    {"id": "MR", "name": "MR+222"},
    {"id": "MS", "name": "MS+1664"},
    {"id": "MT", "name": "MT+356"},
    {"id": "MU", "name": "MU+230"},
    {"id": "MV", "name": "MV+960"},
    {"id": "MW", "name": "MW+265"},
    {"id": "MX", "name": "MX+52"},
    {"id": "MY", "name": "MY+60"},
    {"id": "MZ", "name": "MZ+258"},
    {"id": "NA", "name": "NA+264"},
    {"id": "NC", "name": "NC+687"},
    {"id": "NE", "name": "NE+227"},
    {"id": "NF", "name": "NF+672"},
    {"id": "NG", "name": "NG+234"},
    {"id": "NI", "name": "NI+505"},
    {"id": "NL", "name": "NL+31"},
    {"id": "NO", "name": "NO+47"},
    {"id": "NP", "name": "NP+977"},
    {"id": "NR", "name": "NR+674"},
    {"id": "NU", "name": "NU+683"},
    {"id": "NZ", "name": "NZ+64"},
    {"id": "OM", "name": "OM+968"},
    {"id": "PA", "name": "PA+507"},
    {"id": "PE", "name": "PE+51"},
    {"id": "PF", "name": "PF+689"},
    {"id": "PG", "name": "PG+675"},
    {"id": "PH", "name": "PH+63"},
    {"id": "PK", "name": "PK+92"},
    {"id": "PL", "name": "PL+48"},
    {"id": "PM", "name": "PM+508"},
    {"id": "PN", "name": "PN+870"},
    {"id": "PR", "name": "PR+1787"},
    {"id": "PS", "name": "PS+970"},
    {"id": "PT", "name": "PT+351"},
    {"id": "PW", "name": "PW+680"},
    {"id": "PY", "name": "PY+595"},
    {"id": "QA", "name": "QA+974"},
    {"id": "RE", "name": "RE+262"},
    {"id": "RO", "name": "RO+40"},
    {"id": "RS", "name": "RS+381"},
    {"id": "RU", "name": "RU+7"},
    {"id": "RW", "name": "RW+250"},
    {"id": "SA", "name": "SA+966"},
    {"id": "SB", "name": "SB+677"},
    {"id": "SC", "name": "SC+248"},
    {"id": "SD", "name": "SD+249"},
    {"id": "SE", "name": "SE+46"},
    {"id": "SG", "name": "SG+65"},
    {"id": "SH", "name": "SH+290"},
    {"id": "SI", "name": "SI+386"},
    {"id": "SJ", "name": "SJ+47"},
    {"id": "SK", "name": "SK+421"},
    {"id": "SL", "name": "SL+232"},
    {"id": "SM", "name": "SM+378"},
    {"id": "SN", "name": "SN+221"},
    {"id": "SO", "name": "SO+252"},
    {"id": "SR", "name": "SR+597"},
    {"id": "SS", "name": "SS+211"},
    {"id": "ST", "name": "ST+239"},
    {"id": "SV", "name": "SV+503"},
    {"id": "SX", "name": "SX+599"},
    {"id": "SY", "name": "SY+963"},
    {"id": "SZ", "name": "SZ+268"},
    {"id": "TC", "name": "TC+1649"},
    {"id": "TD", "name": "TD+235"},
    {"id": "TG", "name": "TG+228"},
    {"id": "TH", "name": "TH+66"},
    {"id": "TJ", "name": "TJ+992"},
    {"id": "TK", "name": "TK+690"},
    {"id": "TL", "name": "TL+670"},
    {"id": "TM", "name": "TM+993"},
    {"id": "TN", "name": "TN+216"},
    {"id": "TO", "name": "TO+676"},
    {"id": "TR", "name": "TR+90"},
    {"id": "TT", "name": "TT+1868"},
    {"id": "TV", "name": "TV+688"},
    {"id": "TW", "name": "TW+886"},
    {"id": "TZ", "name": "TZ+255"},
    {"id": "UA", "name": "UA+380"},
    {"id": "UG", "name": "UG+256"},
    {"id": "US", "name": "US+1"},
    {"id": "UY", "name": "UY+598"},
    {"id": "UZ", "name": "UZ+998"},
    {"id": "VA", "name": "VA+379"},
    {"id": "VC", "name": "VC+1784"},
    {"id": "VE", "name": "VE+58"},
    {"id": "VG", "name": "VG+1284"},
    {"id": "VI", "name": "VI+1340"},
    {"id": "VN", "name": "VN+84"},
    {"id": "VU", "name": "VU+678"},
    {"id": "WF", "name": "WF+681"},
    {"id": "WS", "name": "WS+685"},
    {"id": "YE", "name": "YE+967"},
    {"id": "YT", "name": "YT+262"},
    {"id": "ZA", "name": "ZA+27"},
    {"id": "ZM", "name": "ZM+260"},
    {"id": "ZW", "name": "ZW+263"}
  ];
  @override
  void initState() {
    super.initState();
  }

  void register() {
    if (isverify == false) {
      FormHelper.showMessage(
        context,
        S.of(context).registrationMessages,
        S.of(context).pleaseVerifyYourPhoneFirst,
        S.of(context).close,
        () {
          Navigator.of(context).pop();
        },
      );
    } else {
      var loginForm = _formkey.currentState;
      //验证Form表单
      if (loginForm!.validate()) {
        loginForm.save();
        setState(() {
          isShowPassWord = false;
          isApiCallProcess = true;
        });
        // //执行注册
        doRegister();
        // model.email = _email;
        // model.firstName = _userName;
        // model.lastName = _userName;
        // model.password = _password;
        // model.phoneCode = _prefix;
        // model.phoneNo = phoneController.text;
        // model.phoneDisplay = _prefix + phoneController.text;
        // apiService.creatCustomer(model).then(
        //   (res) {
        //     setState(() {
        //       isApiCallProcess = false;
        //     });
        //     if (res == true) {
        //       ToastUtil.showInfo(S.of(context).registrationSuccese, true);
        //       Navigator.of(context).push(
        //         MaterialPageRoute(
        //           builder: (context) => Login(
        //             tologin: registertoJson(),
        //           ),
        //         ),
        //       );
        //     } else {
        //       setState(() {
        //         isverify = false;
        //       });
        //       ToastUtil.showInfo(S.of(context).registrationFailed, false);
        //     }
        //   },
        // );
      }
    }
  }

  void doRegister() async {
    try {
      Dio dio = Dio();
      Response response = await dio.post(
        Config.registerURL,
        data: {
          'user_name': _userName,
          'user_pwd': _password,
          'user_email': _email,
          'xoo_ml_phone_no': phoneController.text,
          'xoo_ml_phone_code': _prefix
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

        final ret = response.data;
        Map<String, dynamic> data = jsonDecode(ret);
        if (data['code'] == 403) {
          ToastUtil.showInfo(S.of(context).userAlreadyExists, false);
        } else if (data['code'] == 404) {
          ToastUtil.showInfo(S.of(context).emailAlreadyExists, false);
        } else if (data['code'] == 405) {
          ToastUtil.showInfo(S.of(context).registrationFailed, false);
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Login(
                tologin: registertoJson(),
              ),
              //builder: (context) => const Login(),
            ),
          );
        }
      }
    } on DioError catch (e) {
      debugPrint(e.message);
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

  Map<String, dynamic> registertoJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = _userName;
    data['userEmail'] = _email;
    data['userPwd'] = _password;
    return data;
  }

  //弹出sms对话框
  Future smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(S.of(context).pleaseEnterSmsVerificationCode),
            content: SizedBox(
                height: 85,
                child: Column(
                  children: [
                    TextField(
                      controller: optController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        debugPrint(value);
                      },
                    ),
                  ],
                )),
            contentPadding: const EdgeInsets.all(10),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  S.of(context).close,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  PhoneAuthCredential phoneAuthCredential =
                      PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: optController.text,
                  );
                  signInWithPhoneAuthCredential(phoneAuthCredential);
                },
                child: Text(
                  S.of(context).done,
                  style: const TextStyle(fontSize: 20.0, color: Colors.blue),
                ),
              ),
            ],
          );
        });
  }

  //登录验证SMS码是否正确
  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      if (authCredential.user != null) {
        setState(() {
          isverify = true;
          inputEnable = false;
        });
        optController.clear();
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(e.message.toString()),
      //   duration: const Duration(seconds: 3),
      // ));
      FormHelper.showMessage(
        context,
        S.of(context).optMessages,
        e.message.toString(),
        S.of(context).close,
        () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        //automaticallyImplyLeading: true, //返回图标
        leading: InkWell(
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.blue,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          S.of(context).registration,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 22.0,
          ),
        ),
        centerTitle: true,
        elevation: 4.0,
        actions: [
          LocalLang.langList(context, _changeLanguage, false)
        ], //appbar与body整合度
      ),
      body: ProgressHUD(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                DropdownButton(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 30,
                                  iconEnabledColor:
                                      Colors.green.withOpacity(0.7),
                                  value: _selectedLocation,
                                  //items: _items,
                                  items: phoneFormat
                                      .map(
                                        (item) => DropdownMenuItem(
                                          value: item['name'],
                                          child: Text(
                                            item['name'],
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        _selectedLocation = value.toString();
                                        _prefix = "+" +
                                            value.toString().split("+")[1];
                                      },
                                    );
                                  },
                                  underline: Container(color: Colors.white),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: TextFormField(
                                      enabled: inputEnable,
                                      controller: phoneController,
                                      decoration: InputDecoration(
                                        hintText: S.of(context).phoneNumber,
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xffD5D5D5),
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      keyboardType: TextInputType.phone,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return S
                                              .of(context)
                                              .pleaseEnterPhoneNumber;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: MaterialButton(
                                    onPressed: () async {
                                      await _auth.verifyPhoneNumber(
                                        phoneNumber:
                                            _prefix + phoneController.text,
                                        verificationCompleted:
                                            (phoneAuthCredential) async {
                                          debugPrint(
                                              phoneAuthCredential.toString());
                                        },
                                        verificationFailed:
                                            (verificationFailed) async {
                                          //print(verificationFailed.message);
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(SnackBar(
                                          //   content: Text(verificationFailed
                                          //       .message
                                          //       .toString()),
                                          //   duration:
                                          //       const Duration(seconds: 3),
                                          // ));
                                          FormHelper.showMessage(
                                            context,
                                            S.of(context).optMessages,
                                            verificationFailed.message
                                                .toString(),
                                            S.of(context).close,
                                            () {
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        },
                                        codeSent: (verificationId,
                                            resendingToken) async {
                                          smsOTPDialog(context);
                                          setState(() {
                                            this.verificationId =
                                                verificationId;
                                          });
                                        },
                                        codeAutoRetrievalTimeout:
                                            (verficationId) async {},
                                      );
                                    },
                                    child: Text(S.of(context).send),
                                    color:
                                        const Color.fromARGB(255, 61, 203, 128),
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                  ),
                                  width: 70.0,
                                )
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: S.of(context).userName,
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
                                      _usernameController.clear();
                                    },
                                  ),
                                ),
                                keyboardType: TextInputType.name,
                                onSaved: (value) {
                                  _userName = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return S.of(context).pleaseEnterUserName;
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) {},
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: S.of(context).email,
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
                                      _emailController.clear();
                                    },
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (value) {
                                  _email = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return S.of(context).pleaseEnterEmail;
                                  }
                                  var emailReg = RegExp(
                                      r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
                                  if (!emailReg.hasMatch(value)) {
                                    return S
                                        .of(context)
                                        .pleaseEnterTheCorrectEmail;
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) {},
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
                                        color: const Color.fromARGB(
                                            255, 126, 126, 126),
                                        size: 20.0,
                                      ),
                                      onPressed: showPassWord,
                                    )),
                                obscureText: !isShowPassWord,
                                onSaved: (value) {
                                  _password = value;
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
                              height: 55.0,
                              margin: const EdgeInsets.only(top: 35.0),
                              child: SizedBox.expand(
                                child: MaterialButton(
                                  onPressed: register,
                                  color:
                                      const Color.fromARGB(255, 61, 203, 128),
                                  child: Text(
                                    S.of(context).registration,
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
                          ],
                        )),
                  ),
                ],
              ),
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
          inAsyncCall: isApiCallProcess,
          opacity: 0.3),
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
