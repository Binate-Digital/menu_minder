import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:menu_minder/common/custom_extended_image_with_loading.dart';
import 'package:menu_minder/common/dotted_image.dart';
import 'package:menu_minder/utils/utils.dart';
import 'package:menu_minder/view/inbox/data/chat_list_model.dart';

import '../../../utils/app_constants.dart';

class MeChatContainer extends StatelessWidget {
  final ChatData chat;
  const MeChatContainer({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DottedImage(
          netWorkUrl: chat.senderId?.userImage,
          radius: 20,
          // image: chat.image,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 250,
              margin: const EdgeInsets.only(top: 10, left: 10),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                      topRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50)),
                  color: AppColor.THEME_COLOR_SECONDARY),
              child: chat.attachment != null
                  ? MyCustomExtendedImage(
                      imageUrl: dotenv.get('IMAGE_URL') + chat.attachment)
                  : Text(
                      chat.message ?? '',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 81, 61, 60)),
                    ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
              child: Text(
                Utils.formatDate(
                    pattern: 'hh:mm a',
                    date: DateTime.parse(chat.createdAt.toString()).toLocal()),
                style:
                    const TextStyle(color: AppColor.COLOR_GREY1, fontSize: 12),
              ),
            )
          ],
        )
      ],
    );
  }
}
