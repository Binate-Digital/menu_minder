import 'package:flutter/material.dart';
import 'package:menu_minder/common/custom_loading_bar.dart';
import 'package:menu_minder/common/custom_text.dart';
import 'package:menu_minder/common/search_widget.dart';
import 'package:menu_minder/providers/chat_provider.dart';
import 'package:menu_minder/utils/actions.dart';
import 'package:menu_minder/utils/app_constants.dart';
import 'package:menu_minder/utils/bottom_bar.dart';
import 'package:menu_minder/utils/enums.dart';
import 'package:menu_minder/utils/styles.dart';
import 'package:menu_minder/view/auth/bloc/provider/auth_provider.dart';
import 'package:menu_minder/view/chat/screens/chat_screen.dart';
import 'package:menu_minder/view/notifications/custom_slidable.dart';
import 'package:menu_minder/view/show_family_members/screens/show_family_member_screen.dart';
import 'package:provider/provider.dart';
import '../../../common/primary_button.dart';
import '../widgets/inbox_container_widget.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key, this.isFromNotifications = false});
  final bool isFromNotifications;
  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ChatProvider>().iniSearch();
      context.read<ChatProvider>().loadAllChats(context);
      context
          .read<ChatProvider>()
          .addSearchListener(context.read<AuthProvider>().userdata!.data!.Id!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthProvider>().userdata!.data!.Id!;
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: GestureDetector(
          onTap: () async {
            final user = await AppNavigator.pushAndReturn(
                context,
                const ShowFamilyMemberScreen(
                  isFromInbox: true,
                ));

            if (user != null) {
              final data = await AppNavigator.pushAndReturn(
                  context,
                  ChatScreen(
                    currentIndex: 0,
                    friendID: user['id'],
                    friendName: user['name'],
                  ));

              context.read<ChatProvider>().loadAllChats(context);
            }
          },
          child: Container(
            height: 60,
            padding: const EdgeInsets.all(8),
            // backgroundColor: AppColor.THEME_COLOR_PRIMARY1,
            // onPressed: () async {},
            decoration: BoxDecoration(
              color: AppColor.THEME_COLOR_PRIMARY1,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: const [
                Icon(
                  Icons.add,
                  color: AppColor.BG_COLOR,
                ),
                SizedBox(
                  height: 5,
                ),
                CustomText(
                  text: 'New Chat',
                  fontSize: 12,
                  fontColor: AppColor.BG_COLOR,
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppStyles.pinkAppBar(
        context,
        "Messages",
        onleadingTap: () {
          if (widget.isFromNotifications) {
            AppNavigator.pushAndRemoveUntil(context, const BottomBar());
          } else {
            AppNavigator.pop(context);
          }
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<ChatProvider>().loadAllChats(context);
        },
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: constraints.maxHeight,
              child: Consumer<ChatProvider>(builder: (context, val, _) {
                if (val.chatLoadState == States.loading) {
                  return const CustomLoadingBarWidget();
                } else if (val.chatLoadState == States.success) {
                  return Container(
                    margin: AppStyles.screenPadding(),
                    child: Column(
                      children: [
                        SearchWidget(controller: val.searchController),
                        AppStyles.height16SizedBox(),
                        val.isSearching && val.getFilteredChats!.data!.isEmpty
                            ? const Flexible(
                                child: Center(
                                  child: CustomText(
                                    text: 'No Chats Found',
                                  ),
                                ),
                              )
                            : Flexible(
                                child: val.isSearching
                                    ? ListView.separated(
                                        itemBuilder:
                                            (innerContext, index) => InkWell(
                                                  onTap: () {
                                                    context
                                                        .read<ChatProvider>()
                                                        .isWaiting = true;
                                                    AppNavigator.push(
                                                        context,
                                                        ChatScreen(
                                                          currentIndex: index,
                                                          friendName: val
                                                                      .getFilteredChats!
                                                                      .data![
                                                                          index]
                                                                      .senderId!
                                                                      .sId ==
                                                                  userId
                                                              ? val
                                                                  .getFilteredChats!
                                                                  .data![index]
                                                                  .receiverId!
                                                                  .userName!
                                                              : val
                                                                  .getFilteredChats!
                                                                  .data![index]
                                                                  .senderId!
                                                                  .userName!,
                                                          friendID: val
                                                                      .getFilteredChats!
                                                                      .data![
                                                                          index]
                                                                      .senderId!
                                                                      .sId ==
                                                                  userId
                                                              ? val
                                                                  .getFilteredChats!
                                                                  .data![index]
                                                                  .receiverId!
                                                                  .sId!
                                                              : val
                                                                  .getFilteredChats!
                                                                  .data![index]
                                                                  .senderId!
                                                                  .sId!,
                                                        ));
                                                  },
                                                  child: CustomSlidableWidget(
                                                    isenable: true,
                                                    onTap: () {
                                                      AppDialog.showDialogs(
                                                          Column(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8.0,
                                                                    horizontal:
                                                                        48),
                                                                child: AppStyles.headingStyle(
                                                                    "Are you sure you want to delete this Chat?",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                      child: PrimaryButton(
                                                                          text: "Cancel",
                                                                          buttonColor: Colors.grey.shade600,
                                                                          onTap: () {
                                                                            AppNavigator.pop(context);
                                                                          })),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Expanded(
                                                                    child: PrimaryButton(
                                                                        text: "Delete",
                                                                        buttonColor: AppColor.COLOR_RED1,
                                                                        onTap: () {
                                                                          context.read<ChatProvider>().deletChat(
                                                                              context: context,
                                                                              chatData: val.getFilteredChats!.data![index]);
                                                                        }),
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          "Delete Chat",
                                                          context);
                                                    },
                                                    child: MessageTile(
                                                      inbox: val
                                                          .getFilteredChats!
                                                          .data![index],
                                                    ),

                                                    // child: SizedBox(),
                                                  ),
                                                ),
                                        separatorBuilder: (context, index) =>
                                            AppStyles.horizontalDivider(),
                                        itemCount: val.getFilteredChats?.data
                                                ?.length ??
                                            0)
                                    : val.getChats?.data == null ||
                                            val.getChats?.data != null &&
                                                val.getChats!.data!.isEmpty
                                        ? const Center(
                                            child: CustomText(
                                              text: 'No Chats Found',
                                            ),
                                          )
                                        : ListView.separated(
                                            itemBuilder: (innerContext,
                                                    index) =>
                                                InkWell(
                                                  onTap: () {
                                                    context
                                                        .read<ChatProvider>()
                                                        .isWaiting = true;
                                                    AppNavigator.push(
                                                        context,
                                                        ChatScreen(
                                                          isFiltered: true,
                                                          currentIndex: index,
                                                          friendName: val
                                                                      .getChats!
                                                                      .data![
                                                                          index]
                                                                      .senderId!
                                                                      .sId ==
                                                                  userId
                                                              ? val
                                                                  .getChats!
                                                                  .data![index]
                                                                  .receiverId!
                                                                  .userName!
                                                              : val
                                                                  .getChats!
                                                                  .data![index]
                                                                  .senderId!
                                                                  .userName!,
                                                          friendID: val
                                                                      .getChats!
                                                                      .data![
                                                                          index]
                                                                      .senderId!
                                                                      .sId ==
                                                                  userId
                                                              ? val
                                                                  .getChats!
                                                                  .data![index]
                                                                  .receiverId!
                                                                  .sId!
                                                              : val
                                                                  .getChats!
                                                                  .data![index]
                                                                  .senderId!
                                                                  .sId!,
                                                        ));
                                                  },
                                                  child: CustomSlidableWidget(
                                                    isenable: true,
                                                    onTap: () {
                                                      AppDialog.showDialogs(
                                                          Column(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8.0,
                                                                    horizontal:
                                                                        48),
                                                                child: AppStyles.headingStyle(
                                                                    "Are you sure you want to delete this Chat?",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                      child: PrimaryButton(
                                                                          text: "Cancel",
                                                                          buttonColor: Colors.grey.shade600,
                                                                          onTap: () {
                                                                            AppNavigator.pop(context);
                                                                          })),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Expanded(
                                                                    child: PrimaryButton(
                                                                        text: "Delete",
                                                                        buttonColor: AppColor.COLOR_RED1,
                                                                        onTap: () {
                                                                          context.read<ChatProvider>().deletChat(
                                                                              context: context,
                                                                              chatData: val.getChats!.data![index]);
                                                                        }),
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          "Delete Chat",
                                                          context);
                                                    },
                                                    child: MessageTile(
                                                      inbox: val.getChats!
                                                          .data![index],
                                                    ),

                                                    // child: SizedBox(),
                                                  ),
                                                ),
                                            separatorBuilder: (context,
                                                    index) =>
                                                AppStyles.horizontalDivider(),
                                            itemCount:
                                                val.getChats?.data?.length ??
                                                    0),
                              ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: CustomText(
                      text: 'Not Chats Found',
                    ),
                  );
                }
              }),
            ),
          );
        }),
      ),
    );
  }
}
