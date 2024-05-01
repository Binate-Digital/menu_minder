import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:menu_minder/common/custom_extended_image_with_loading.dart';
import 'package:menu_minder/common/dotted_image.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/utils.dart';
import '../../inbox/data/chat_list_model.dart';

class YouChatContainer extends StatelessWidget {
  final ChatData chat;
  const YouChatContainer({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 250,
              margin: const EdgeInsets.only(top: 10, right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50)),
                  color: AppColor.THEME_COLOR_PRIMARY1),
              child: chat.attachment != null
                  ? MyCustomExtendedImage(
                      imageUrl: dotenv.get('IMAGE_URL') + chat.attachment)
                  : Text(
                      chat.message ?? '',
                      style: const TextStyle(color: Colors.white),
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
        ),
        DottedImage(
          netWorkUrl: chat.senderId?.userImage,
          radius: 20,
          color: AppColor.THEME_COLOR_PRIMARY1,
          // r: chat.image,
        ),
      ],
    );
  }
}
