import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/providers/chat_provider.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/utils/utils.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/inbox/data/chat_list_model.dart';
import 'package:provider/provider.dart';

import '../../../services/socket_service.dart';
import '../../../utils/app_constants.dart'; 
import '../../../utils/asset_paths.dart';
import '../widgets/me_chat_container.dart';
import '../widgets/you_chat_container.dart';

class ChatScreen extends StatefulWidget {
  final bool? isFriend;
  final String friendID;
  final String? friendName;
  final int? currentIndex;
  final bool isFiltered;
  const ChatScreen(
      {super.key,
      this.isFriend = false,
      this.isFiltered = false,
      required this.friendID,
      this.currentIndex,
      this.friendName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController chatController = ScrollController();
  TextEditingController chatTextController = TextEditingController();
  AuthProvider? _authProvider;
  @override
  void initState() {
    super.initState();
    // chatController = ScrollController();
    if (chatController.hasClients) {
      chatController.animateTo(
        chatController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }

    _authProvider = context.read<AuthProvider>();
    socketmethodcall();
  }

  void socketmethodcall() {
    SocketService.instance?.initializeSocket();
    SocketService.instance?.connectSocket(context);
    SocketService.instance?.socketResponseMethod(context, widget.currentIndex);
    SocketService.instance?.socketEmitMethod(
      eventName: "get_messages",
      eventParamaters: {
        "sender_id": _authProvider!.userdata!.data!.Id,
        "receiver_id": widget.friendID
      },
    );
  }

  void _sendMessage() {
    String messageText = chatTextController.text.trim();
    print("Fiend Name ${widget.friendID}");
    print(
      "My Name ${_authProvider!.userdata!.data!.Id!}",
    );

    if (messageText.isNotEmpty) {
      FocusScope.of(context).unfocus();
      SocketService.instance?.socketSendEmitMethod(
        eventName: "send_message",
        eventParamaters: {
          "sender_id": _authProvider!.userdata!.data!.Id,
          "receiver_id": widget.friendID,
          "message": messageText,
        },
      );
      chatTextController.clear();

      setState(() {});
    }
  }

  @override
  void dispose() {
    SocketService.instance?.dispose();
    super.dispose();
  }

  Widget _buildChatContainer(ChatData chat) {
    return _authProvider?.userdata!.data!.Id != chat.senderId!.sId
        ? MeChatContainer(chat: chat)
        : YouChatContainer(chat: chat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppStyles.pinkAppBar(
          context, widget.friendName != null ? widget.friendName! : "Messages"),
      body: SafeArea(
        child: Consumer<ChatProvider>(builder: (context, val, _) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppDimen.SCREEN_PADDING),
            child: val.isWaiting
                ? const CustomLoadingBarWidget()
                : Column(
                    children: [
                      Flexible(
                        child: ListView.builder(
                            itemCount: val.singleChatModel?.data?.length ?? 0,
                            reverse: true,
                            controller: chatController,
                            itemBuilder: (context, index) {
                              return _buildChatContainer(
                                  val.singleChatModel!.data![index]);
                            }

                            // _authProvider?.userdata!.data!.Id !=
                            //         val.singleChatModel!.data?[index]
                            //             .senderId!.sId
                            //     ? MeChatContainer(
                            //         chat: val.singleChatModel!.data![index],
                            //       )
                            //     : YouChatContainer(
                            //         chat: val.singleChatModel!.data![index],
                            //       ),
                            ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        height: 80,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 0)
                        ]),
                        child: TextFormField(
                          controller: chatTextController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            fillColor: AppColor.COLOR_WHITE,
                            filled: true,
                            hintText: "Type Message",
                            prefixIcon: IconButton(
                                onPressed: () {
                                  Utils.pickImage(
                                      source: ImageSource.gallery,
                                      context: context,
                                      setFile: (p0) {
                                        val.attachment(context, p0, () {
                                          SocketService.instance
                                              ?.socketSendEmitMethod(
                                            eventName: "send_message",
                                            eventParamaters: {
                                              "sender_id": _authProvider!
                                                  .userdata!.data!.Id,
                                              "receiver_id": widget.friendID,
                                              "attachment":
                                                  val.currentAttachmentURL,
                                            },
                                          );
                                        });
                                      });
                                },
                                icon: const Icon(Icons.attach_file)),
                            hintStyle: const TextStyle(
                              color: AppColor.COLOR_GREY1,
                              fontSize: 14,
                            ),
                            suffixIcon: InkWell(
                                onTap: () {
                                  // chatList.insert(
                                  //     0,
                                  //     Chat(AssetPath.PERSON, "08:00 AM",
                                  //         chatTextController.text, "2"));

                                  _sendMessage();
                                },
                                child: Image.asset(AssetPath.SEND_MESSAGE,
                                    scale: 4)),
                            suffixIconConstraints:
                                BoxConstraints.tight(const Size(80, 20)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        }),
      ),
    );
  }
}

class DateTextWidget extends StatelessWidget {
  const DateTextWidget({super.key, required this.date});
  final String date;

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: date,
    );
  }
}
