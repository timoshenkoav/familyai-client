import 'dart:async';

import 'package:flutter/material.dart';

class PasswordVisibility {
  final stream = ValueNotifier(false);

  void toggle() {
    stream.value = !stream.value;
  }

}