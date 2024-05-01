import 'package:flutter/material.dart';

import '../../../common/dropdown_widget.dart';
import '../../../utils/asset_paths.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({
    super.key,
  });

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  String? location = "Home";
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          AssetPath.NAVIGATION,
          scale: 3,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: DropDownField(
            onValueChanged: (v) {
              location = v;
              setState(() {});
            },
            selected_value: location,
            items: const ["Home", "Dine In"],
            hint: "Home",
            borderColor: Colors.grey.shade300,
          ),
        )
      ],
    );
  }
}
