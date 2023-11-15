import 'package:fluttertoast/fluttertoast.dart';
import 'package:translator/translator.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:translator/translator.dart';

class LanguageTransulate {
  String langcode = 'en';
  List<String> LabelStrings = [
    "Login",
    "User name",
    "Password",
    "Sign In",
    "Seedling Reception",
    "Home",
    "Profile",
    "Logout",
    "Language"
  ];

  Future<List<String>> transulat() async {
    final translator = GoogleTranslator();
    List<String> TransulatedStrings = [];
    translator.baseUrl = "translate.google.cn";
    for (var i = 0; i < LabelStrings.length; i++) {
      var translation = await translator.translate(LabelStrings[i].toString(),
          from: 'en', to: langcode);
      TransulatedStrings.add(translation.toString());
    }

    return TransulatedStrings;
  }
}
