import 'package:flutter/material.dart';
import 'package:myapp/appconfig.dart';
import 'package:myapp/pages/login.dart';
import 'package:myapp/utils/customer_route.dart';
import 'package:myapp/utils/storage_util.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    //_clearninfo();
    _getUserinfo();
    super.initState();
  }

  // _clearninfo() async {
  //   StorageUtil.clearAll();
  // }

  _getUserinfo() async {
    final userInfoJson = await StorageUtil.getString("userinfo");
    if (userInfoJson == null) {
      Navigator.of(context).push(CustomerRoute(const Login()));
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const Login()),
      // );

    } else {
      //Map<String, dynamic> data = json.decode(userInfoJson);
      // print(data['user_id']);
      // print(data['user_name']);
      // print(data['user_email']);
      // print(data['token']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        automaticallyImplyLeading: false,
        title: Text(
          Config.appname,
          style: const TextStyle(
            fontSize: 22.0,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        elevation: 4.0,
      ),
      body: const Center(
        child: Text("主页面"),
      ),
    );
  }
}
