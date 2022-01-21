import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class LocalLang {
  static Widget langList(
      BuildContext context, Function changeLanguage, bool isShowOut) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_horiz_rounded,
        color: Colors.blue,
        size: 30.0,
      ),
      itemBuilder: (BuildContext context) => isShowOut
          ? <PopupMenuItem<String>>[
              selectView("lib/images/zh-hans.png", '简体', 'CN'),
              selectView("lib/images/zh-hant.png", '繁体', 'HK'),
              selectView("lib/images/en.png", 'English', 'EN'),
              selectView(
                  "lib/images/signout.png", S.of(context).signout, 'OUT'),
            ]
          : <PopupMenuItem<String>>[
              selectView("lib/images/zh-hans.png", '简体', 'CN'),
              selectView("lib/images/zh-hant.png", '繁体', 'HK'),
              selectView("lib/images/en.png", 'English', 'EN'),
            ],
      onSelected: (String langCode) {
        // 点击选项的时候
        changeLanguage(langCode);
      },
    );
  }

  static selectView(String imgpath, String text, String id) {
    return PopupMenuItem<String>(
      value: id,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            imgpath,
            fit: BoxFit.cover,
            width: 24.0,
          ),
          SizedBox(
            width: 70.0,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
