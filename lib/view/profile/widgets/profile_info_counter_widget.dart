import 'package:flutter/material.dart';

class ProfileInfoWidget extends StatelessWidget {
  final String heading;
  final String quantity;
  const ProfileInfoWidget({
    Key? key,
    required this.heading,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            heading,
            style: const TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            quantity,
            style: const TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}
