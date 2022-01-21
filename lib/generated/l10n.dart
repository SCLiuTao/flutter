// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Email or username`
  String get emailOrUserName {
    return Intl.message(
      'Email or username',
      name: 'emailOrUserName',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUp {
    return Intl.message(
      'Sign up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Please enter email or username`
  String get pleaseEnterEmailOrUsername {
    return Intl.message(
      'Please enter email or username',
      name: 'pleaseEnterEmailOrUsername',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the correct email`
  String get pleaseEnterTheCorrectEmail {
    return Intl.message(
      'Please enter the correct email',
      name: 'pleaseEnterTheCorrectEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter password`
  String get pleaseEnterPassword {
    return Intl.message(
      'Please enter password',
      name: 'pleaseEnterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Login exception`
  String get loginException {
    return Intl.message(
      'Login exception',
      name: 'loginException',
      desc: '',
      args: [],
    );
  }

  /// `Wrong user name or password`
  String get wrongUserNameOrPassword {
    return Intl.message(
      'Wrong user name or password',
      name: 'wrongUserNameOrPassword',
      desc: '',
      args: [],
    );
  }

  /// `Network connection error`
  String get networkConnectionError {
    return Intl.message(
      'Network connection error',
      name: 'networkConnectionError',
      desc: '',
      args: [],
    );
  }

  /// `Registration messages`
  String get registrationMessages {
    return Intl.message(
      'Registration messages',
      name: 'registrationMessages',
      desc: '',
      args: [],
    );
  }

  /// `Please verify your phone first`
  String get pleaseVerifyYourPhoneFirst {
    return Intl.message(
      'Please verify your phone first',
      name: 'pleaseVerifyYourPhoneFirst',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `User already exists`
  String get userAlreadyExists {
    return Intl.message(
      'User already exists',
      name: 'userAlreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `Email already exists`
  String get emailAlreadyExists {
    return Intl.message(
      'Email already exists',
      name: 'emailAlreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed, try again later`
  String get registrationFailed {
    return Intl.message(
      'Registration failed, try again later',
      name: 'registrationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Registration success`
  String get registrationSuccese {
    return Intl.message(
      'Registration success',
      name: 'registrationSuccese',
      desc: '',
      args: [],
    );
  }

  /// `Please enter SMS verification code`
  String get pleaseEnterSmsVerificationCode {
    return Intl.message(
      'Please enter SMS verification code',
      name: 'pleaseEnterSmsVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `OPT messages`
  String get optMessages {
    return Intl.message(
      'OPT messages',
      name: 'optMessages',
      desc: '',
      args: [],
    );
  }

  /// `Registration`
  String get registration {
    return Intl.message(
      'Registration',
      name: 'registration',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phoneNumber {
    return Intl.message(
      'Phone number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter phone number`
  String get pleaseEnterPhoneNumber {
    return Intl.message(
      'Please enter phone number',
      name: 'pleaseEnterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Please enter user name`
  String get pleaseEnterUserName {
    return Intl.message(
      'Please enter user name',
      name: 'pleaseEnterUserName',
      desc: '',
      args: [],
    );
  }

  /// `please enter email`
  String get pleaseEnterEmail {
    return Intl.message(
      'please enter email',
      name: 'pleaseEnterEmail',
      desc: '',
      args: [],
    );
  }

  /// `User name`
  String get userName {
    return Intl.message(
      'User name',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `No historical record.`
  String get noHistoricalRecord {
    return Intl.message(
      'No historical record.',
      name: 'noHistoricalRecord',
      desc: '',
      args: [],
    );
  }

  /// `Sign out`
  String get signout {
    return Intl.message(
      'Sign out',
      name: 'signout',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Shop`
  String get shop {
    return Intl.message(
      'Shop',
      name: 'shop',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get cart {
    return Intl.message(
      'Cart',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Apple `
  String get appleLogin {
    return Intl.message(
      'Sign in with Apple ',
      name: 'appleLogin',
      desc: '',
      args: [],
    );
  }

  /// `Login failed, please go to Settings->Apple ID->Password & Security->Apps using AppleID to stop using this app, and then log in again`
  String get appleLoginFaild {
    return Intl.message(
      'Login failed, please go to Settings->Apple ID->Password & Security->Apps using AppleID to stop using this app, and then log in again',
      name: 'appleLoginFaild',
      desc: '',
      args: [],
    );
  }

  /// `Apple ID login messages`
  String get appleIDLoginMessages {
    return Intl.message(
      'Apple ID login messages',
      name: 'appleIDLoginMessages',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'HK'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
