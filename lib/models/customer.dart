class CustomerModel {
  String? email;
  String? firstName;
  String? lastName;
  String? password;
  String? phoneNo;
  String? phoneCode;
  String? phoneDisplay;

  CustomerModel({
    this.email,
    this.firstName,
    this.lastName,
    this.password,
    this.phoneNo,
    this.phoneCode,
    this.phoneDisplay,
  });
  Map<String, dynamic> tojosn() {
    Map<String, dynamic> map = {};
    map.addAll({
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
      'username': email,
      'meta': {
        'xoo_ml_phone_no': phoneNo,
        'xoo_ml_phone_code': phoneCode,
        'xoo_ml_phone_display': phoneDisplay
      }
    });

    return map;
  }
}
