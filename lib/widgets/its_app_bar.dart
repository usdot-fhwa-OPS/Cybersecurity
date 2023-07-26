import 'package:flutter/material.dart';

class SamplePageDynamicAppBar extends AppBar {
  SamplePageDynamicAppBar({Key? key}) :
    super(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      centerTitle: true,
      key: key,
    );
}