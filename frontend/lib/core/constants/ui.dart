import 'package:flutter/material.dart';

abstract class UiConstants {
  static const navBarData = [
    {
      "index": 0,
      "label": "Home",
      "icon": Icons.home_outlined,
      "selected_icon": Icons.home,
    },
    {
      "index": 1,
      "label": "Upload",
      "icon": Icons.upload_outlined,
      "selected_icon": Icons.upload,
    },
    {
      "index": 2,
      "label": "Chat",
      "icon": Icons.chat_outlined,
      "selected_icon": Icons.chat,
    },
    {
      "index": 3,
      "label": "Profile",
      "icon": Icons.person,
      "selected_icon": Icons.lock_person_outlined,
    },
    {
      "index": 4,
      "label": "Analysis",
      "icon": Icons.analytics_outlined,
      "selected_icon": Icons.analytics,
    },
  ];
  
}
