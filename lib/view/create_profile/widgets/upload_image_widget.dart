import 'package:flutter/material.dart';

import '../../../common/enums.dart';
import '../../../services/image_chooser.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/asset_paths.dart';
import '../../../utils/dummy.dart';
import '../../../utils/rounded_image.dart';

class UploadImageWidget extends StatelessWidget {
  const UploadImageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: profile,
        builder: (context, val, _) {
          return InkWell(
            onTap: () {
              ImageChooser().pickImage(context, (path) {
                if (path.isNotEmpty) {
                  profile.value!.image = path;
                  profile.notifyListeners();
                }
              });
            },
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 1),
                  child: RoundedImage(
                    backgroundColor: AppColor.COLOR_WHITE,
                    image: val!.image ?? AssetPath.CAMERA,
                    radius: 60,
                    borderWidth: 10,
                    imageType: val.image != null
                        ? ImageType.TYPE_FILE
                        : ImageType.TYPE_ASSET,
                  ),
                ),
                const CircleAvatar(
                  backgroundColor: AppColor.THEME_COLOR_SECONDARY,
                  radius: 20,
                  child: CircleAvatar(
                    backgroundColor: AppColor.COLOR_WHITE,
                    radius: 17,
                    child: Icon(
                      Icons.add,
                      color: AppColor.THEME_COLOR_PRIMARY1,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
