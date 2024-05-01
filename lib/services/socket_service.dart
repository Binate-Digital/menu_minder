import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:menu_minder/providers/chat_provider.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  static Socket? _socket;

  SocketService._();

  static SocketService? _instance;

  static SocketService? get instance {
    // if (_instance == null) {
    //   _instance = SocketService._();
    // }
    //
    _instance ??= SocketService._();
    return _instance;
  }

  Socket? get socket => _socket;

  void initializeSocket() {
    _socket = io(dotenv.get("WEB_SOCKET_BASE_URL"), <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
  }

  void connectSocket(context) {
    // _socket = io(NetworkStrings.SOCKET_API_BASE_URL, <String, dynamic>{
    //   'autoConnect': false,
    //   'transports': ['websocket'],
    // });

    _socket?.connect();

    _socket?.on("connect", (data) {
      log('Connected socket ');
      // socketResponseMethod(context);
      // checkSocketConnection(true);
    });

    _socket?.on("disconnect", (data) {
      log('Disconnected $data');
    });

    _socket?.on("connect_error", (data) {
      log('Connect Error $data');
    });

    _socket?.on("error", (data) {
      log('Error $data');
      // SocketNavigationClass.instance
      //     ?.socketErrorMethod(errorResponseData: data);
    });

    //log("Socket Connect:${socket?.connected}");
  }

  void socketEmitMethod(
      {required String eventName, required dynamic eventParamaters}) {
    _socket?.emit(
      eventName,
      eventParamaters,
    );
  }

  void socketSendEmitMethod(
      {required String eventName, required dynamic eventParamaters}) {
    _socket?.emit(
      eventName,
      eventParamaters,
    );
  }

  ChatProvider? singleChatProvider;

  void socketResponseMethod(context, int? index, {bool isFiltered = false}) {
    _socket?.on("response", (data) {
      // log("socket!.on function chal rha hai");
      // log(jsonEncode(data));

      if (data["object_type"] == "get_messages") {
        // log("get_messages");
        // print("data.runtimeType.toString()");
        // print(data.runtimeType.toString());

        singleChatProvider = Provider.of<ChatProvider>(context, listen: false);
        singleChatProvider!.setSingleChatModel(singleChatData: data);
      } else if (data["object_type"] == "get_message") {
        log("SEND MESSAGE");

        log(jsonEncode(data));

        singleChatProvider!.appendSingleChat(singleData: data["data"]);

        ///Appending in Recent  Chats
        if (singleChatProvider?.getChats?.data != null && index != null) {
          if (isFiltered) {
            singleChatProvider?.getFilteredChats?.data![index].message =
                data['data']['message'];
          } else {
            singleChatProvider?.getChats?.data![index].message =
                data['data']['message'];
          }
        }

        // singleChatProvider!.appendSingleChat(singleData: data["data"]);
      }
    });

    //log("response data ha:$data");
    // SocketNavigationClass.instance?.socketResponseMethod(responseData: data);
  }

  void appendSingleChat({dynamic singleData}) {
    if (singleData != null) {
      log("singleData.toString()");
      log(singleData.toString());

      // GetOneToOneData? _getOneToOneData = GetOneToOneData.fromJson(singleData);
      // ContentCreatorController.i.getOneToOneData.value.data?.insert(0,_getOneToOneData);
      // ContentCreatorController.i.getOneToOneData.refresh();
    }
  }

  void dispose() {
    _socket?.dispose();
  }
}
