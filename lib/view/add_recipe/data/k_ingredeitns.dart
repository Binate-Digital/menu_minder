import 'package:flutter/material.dart';

class KIngredeint {
  TextEditingController itemController;
  TextEditingController valueController;
  String? dropdownValue;
  KIngredeint({
    required this.itemController,
    required this.valueController,
    this.dropdownValue,
  });
}
  