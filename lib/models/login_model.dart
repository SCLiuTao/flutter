class LoginMoel {
  //自定义API使用
  int? statusCode;
  String? msg;
  Data? data;

  LoginMoel({
    this.statusCode,
    this.msg,
    this.data,
  });
  factory LoginMoel.fromJson(Map<String, dynamic> json) {
    return LoginMoel(
      statusCode: json["code"],
      msg: json["msg"],
      data: json['user_info'] != null ? Data.formJson(json['user_info']) : null,
    );
  }
}

class Data {
  String? token;
  String? userid;
  String? userName;
  String? userEmail;
  String? userPwd;
  String? userRegistered;
  String? userHash;
  String? hashValue;

  Data({
    this.userid,
    this.userName,
    this.userEmail,
    this.userPwd,
    this.userRegistered,
    this.userHash,
    this.hashValue,
  });

  Data.formJson(Map<String, dynamic> json) {
    token = json['token'];
    userid = json['user_id'].toString();
    userName = json['user_name'];
    userEmail = json['user_email'];
    userPwd = json['user_password'];
    userRegistered = json['user_registered'];
    userHash = json['user_cookieHash'];
    hashValue = json['hashValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['user_id'] = userid;
    data['user_name'] = userName;
    data['user_email'] = userEmail;
    data['user_password'] = userPwd;
    data['user_registered'] = userRegistered;
    data['user_cookieHash'] = userHash;
    data['hashValue'] = hashValue;
    return data;
  }
}
