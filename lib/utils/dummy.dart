import 'package:flutter/material.dart';
import 'package:menu_minder/utils/asset_paths.dart';

import '../common_model/chat.dart';
import '../common_model/profile.dart';
// import '../view/inbox/model/inbox.dart';

String otpText =
    "We have sent you a six-digit verification code to verify your account";
String longText =
    "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites";
String terms1 =
    "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, Lorem ipsum dolor sit amet.., comes from a line in section.";
String terms2 =
    "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, Lorem ipsum dolor sit amet.., comes from a line in section.";
String LOREMSMALL = "Your 7 Day free trial is Activated.";
String LOREM_UTLRA_SMALL = "Lorem ipsum dolor sit amet, conse.";
ValueNotifier<Profile?> profile = ValueNotifier(Profile());
ValueNotifier<int> bottomIndex = ValueNotifier(0);

List<Chat> chatList = [
  Chat(AssetPath.PERSON, "08:00 AM", longText, "1"),
  Chat(AssetPath.PERSON, "08:00 AM", longText, "2"),
  Chat(AssetPath.PERSON, "08:00 AM", longText, "2"),
  Chat(AssetPath.PERSON, "08:00 AM", longText, "1"),
  Chat(AssetPath.PERSON, "08:00 AM", longText, "1"),
  Chat(AssetPath.PERSON, "08:00 AM", longText, "1"),
  Chat(AssetPath.PERSON, "08:00 AM", longText, "1"),
  Chat(AssetPath.PERSON, "08:00 AM", longText, "2"),
];
List<Chat> youChatList = [
  Chat(AssetPath.PERSON, "08:00 AM", longText, "1"),
  Chat(AssetPath.PERSON, "08:00 AM", longText, "2"),
  Chat(AssetPath.PERSON, "08:00 AM", longText, "2"),
  Chat(AssetPath.PERSON, "08:00 AM", longText, "1"),
  Chat(AssetPath.PERSON, "08:00 AM", longText, "1"),
  Chat(AssetPath.PERSON, "08:00 AM", longText, "1"),
  Chat(AssetPath.PERSON, "08:00 AM", longText, "1"),
  Chat(AssetPath.PERSON, "08:00 AM", longText, "2"),
];
bool isEmail = true;

// List<Inbox> inboxList = [
//   Inbox(AssetPath.PERSON, LOREM_UTLRA_SMALL, "Erik", "9:45 PM", "1"),
//   Inbox(AssetPath.PERSON, LOREM_UTLRA_SMALL, "Maev", "9:20 PM", "2"),
//   Inbox(AssetPath.PERSON, LOREM_UTLRA_SMALL, "Ruby", "6:37 PM", "10"),
//   Inbox(AssetPath.PERSON, LOREM_UTLRA_SMALL, "Mathew", "4:50 PM", "1"),
//   Inbox(AssetPath.PERSON, LOREM_UTLRA_SMALL, "Adam", "5:45 PM", "1"),
// ];
List<bool> postList = [true, false];
