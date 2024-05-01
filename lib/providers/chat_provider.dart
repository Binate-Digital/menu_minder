import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/inbox/data/message_list_model.dart';
import 'package:provider/provider.dart';

import '../repo/implementation/i_core.dart';
import '../utils/actions.dart';
import '../utils/enums.dart';
import '../utils/utils.dart';
import '../view/inbox/data/chat_list_model.dart';

class ChatProvider extends ChangeNotifier {
  final ICoreModule _coreRepo;
  ChatProvider(this._coreRepo);

  File? currentAttachment;
  String? currentAttachmentURL;

  ///ALL RECENT CHATS OF USER
  RecentChatsList? _chats;
  RecentChatsList? get getChats => _chats;

  bool isSearching = false;

  ///ALL RECENT CHATS OF USER
  RecentChatsList? _filteredChats;
  RecentChatsList? get getFilteredChats => _filteredChats;

  ///SINGLE CHAT OF USER
  ChatModel? _singleChatModel;
  ChatModel? get singleChatModel => _singleChatModel;

  final TextEditingController searchController = TextEditingController();

  //SINGLE MESSAGE
  ChatData? _chatMessage;

  States _chatsLoadState = States.init;
  States get chatLoadState => _chatsLoadState;

  addSearchListener(String userID) {
    _filteredChats = RecentChatsList(status: 1, data: []);

    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        _filteredChats?.data?.clear();
        isSearching = true;
        if (_chats?.data != null) {
          _filteredChats?.data?.addAll(_chats!.data!.where((element) =>
              (element.senderId?.sId == userID
                      ? element.receiverId?.userName
                      : element.senderId!.userName)!
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase().trim())));
        }

        log("Filtered Chats Length: ${_filteredChats?.data?.length}");
        notifyListeners();
      } else {
        _filteredChats?.data?.clear();
        // _filteredChats?.data = _chats?.data`;
        isSearching = false;
        notifyListeners();
      }
    });
  }

  iniSearch() {
    isSearching = false;
    searchController.clear();
    _filteredChats?.data?.clear();
    // notifyListeners();
    // _filteredChats.
  }

  initState() {
    _chatsLoadState = States.init;
  }

  loadAllChats(BuildContext context) async {
    try {
      _changeBlockedUsersStates(States.loading); //--- (STEP 5) ---//
      Response? response = await _coreRepo.getChatList();

      try {
        _chats = RecentChatsList.fromJson(response?.data);
        _changeBlockedUsersStates(States.success);
      } catch (e) {
        _changeBlockedUsersStates(States.failure);
        initState();
        Utils.showToast(message: response?.statusMessage ?? '');
      }
    } on DioException catch (_) {
      _changeBlockedUsersStates(States.failure);
      initState();
    }
  }

  initLoading() {
    isWaiting = true;
    notifyListeners();
  }

  bool isWaiting = true;

  void setSingleChatModel({dynamic singleChatData}) {
    log("singleChatData.toString()");
    log(singleChatData.toString());

    if (singleChatData != null) {
      _singleChatModel = ChatModel.fromJson(singleChatData);
    } else {
      _singleChatModel = null;
    }
    isWaiting = false;
    notifyListeners();
  }

  void appendSingleChat({dynamic singleData}) {
    log("singleData.toString()");
    log(singleData.toString());

    if (singleData != null) {
      _chatMessage = ChatData.fromJson(singleData);
      _singleChatModel?.data?.insert(0, _chatMessage!);
    }

    notifyListeners();
  }

  ///DELETE CHAT
  deletChat({
    required RecentMessage chatData,
    required BuildContext context,
  }) async {
    try {
      final val = context.read<AuthProvider>();
      setProgressBar(context);
      Response? response = await _coreRepo.deleteChat(
          chatData.senderId!.sId == val.userdata!.data!.Id
              ? chatData.receiverId!.sId!
              : chatData.senderId!.sId!);

      log("resojse " + response!.data.toString());
      try {
        _chats?.data?.remove(chatData);
        cancelProgressBar(context);
        Utils.showToast(message: response?.data['message'] ?? '');
        notifyListeners();
        Future.delayed(const Duration(milliseconds: 200), () {
          AppNavigator.pop(context);
        });
      } catch (e) {
        Utils.showToast(message: response?.statusMessage);
        cancelProgressBar(context);
      }
    } on DioException catch (e) {
      AppMessage.showMessage(e.message.toString());
      cancelProgressBar(context);
    }
  }

  attachment(BuildContext context, File file, Function()? onSuccess) {
    currentAttachment = file;
    notifyListeners();
    sendImage(context, file, onSuccess);
  }

  sendImage(BuildContext context, File file, Function()? onSuccess) async {
    AppDialog.showPorgressBar(context);
    MultipartFile image = await MultipartFile.fromFile(
      file.path,
    );

    final Map<String, dynamic> data = {};

    data["messageImage"] = image;
    final fromData = FormData.fromMap(data);

    try {
      final response = await _coreRepo.sendImage(fromData);
      currentAttachmentURL = response?.data['data'];
      print("Attachments $currentAttachmentURL");
      AppMessage.showMessage('Image Attached');
      AppNavigator.pop(context);
      onSuccess?.call();
    } on DioException catch (_) {
      AppNavigator.pop(context);
    }
  }

  ////-------------CHANGE Load STATUS--------------\\\\\\\
  _changeBlockedUsersStates(States state) {
    _chatsLoadState = state;
    notifyListeners();
  }

  void setProgressBar(BuildContext context) {
    AppDialog.showPorgressBar(context);
  }

  void cancelProgressBar(BuildContext context) {
    AppNavigator.pop(context);
  }
}
