import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/utils/customer_route.dart';
import 'package:myapp/utils/progresshub.dart';

import 'login.dart';

enum MobileVerificationState {
  showMobloeFormState,
  showOptFormState,
}

class OptLogin extends StatefulWidget {
  const OptLogin({Key? key}) : super(key: key);
  @override
  _OptLoginState createState() => _OptLoginState();
}

CupertinoNavigationBar _cupertinoNavigationBar(context) {
  return CupertinoNavigationBar(
    leading: InkWell(
      child: const Icon(
        Icons.arrow_back_ios_new,
        color: Colors.blue,
        size: 24.0,
      ),
      onTap: () {
        Navigator.of(context).pushAndRemoveUntil(
          // MaterialPageRoute(builder: (context) => const Login()),
          CustomerRoute(const Login()),
          (route) => false,
        );
      },
    ),
    middle: const Text("OPT登錄"),
  );
}

class _OptLoginState extends State<OptLogin> {
  bool isApiCallProcess = false;
  MobileVerificationState currentState =
      MobileVerificationState.showMobloeFormState;
  final phoneController = TextEditingController();
  final optController = TextEditingController();
  String verificationId = "";
  bool showloading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();
  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showloading = true;
    });
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      showloading = false;
      if (authCredential.user != null) {
        Navigator.of(context).pushAndRemoveUntil(
          // MaterialPageRoute(builder: (context) => const Login()),
          CustomerRoute(const Login()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString()),
        duration: const Duration(seconds: 1),
      ));
    }
  }

  getMobileFormWidget(contxt) {
    return Column(
      children: <Widget>[
        const Spacer(),
        TextField(
          controller: phoneController,
          decoration: const InputDecoration(
            hintText: "手機號",
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
        MaterialButton(
          onPressed: () async {
            setState(() {
              showloading = true;
            });
            await _auth.verifyPhoneNumber(
              phoneNumber: phoneController.text,
              verificationCompleted: (phoneAuthCredential) async {
                setState(() {
                  showloading = false;
                });
              },
              verificationFailed: (verificationFailed) async {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(verificationFailed.message.toString()),
                  duration: const Duration(seconds: 1),
                ));
              },
              codeSent: (verificationId, resendingToken) async {
                setState(() {
                  showloading = false;
                  currentState = MobileVerificationState.showOptFormState;
                  this.verificationId = verificationId;
                });
              },
              codeAutoRetrievalTimeout: (verficationId) async {},
            );
          },
          child: const Text("發送"),
          color: const Color.fromARGB(255, 61, 203, 128),
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  getOptFormWidget(contxt) {
    return Column(
      children: <Widget>[
        const Spacer(),
        TextField(
          controller: optController,
          decoration: const InputDecoration(
            hintText: "手機號",
          ),
        ),
        const SizedBox(
          height: 16.0,
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
          child: const Text("驗證"),
          color: const Color.fromARGB(255, 61, 203, 128),
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: CupertinoPageScaffold(
        navigationBar: _cupertinoNavigationBar(context),
        child: SafeArea(
          child: ProgressHUD(
            child: Container(
              padding: const EdgeInsets.all(22.0),
              child: showloading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : currentState == MobileVerificationState.showMobloeFormState
                      ? getMobileFormWidget(context)
                      : getOptFormWidget(context),
            ),
            inAsyncCall: isApiCallProcess,
            opacity: 0.7,
          ),
        ),
      ),
    );
  }
}
