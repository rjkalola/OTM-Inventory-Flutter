import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../res/colors.dart';

class HomeTabHeaderView extends StatelessWidget {
  const HomeTabHeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 9, 16, 0),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl:
            "https://www.pngmart.com/files/22/User-Avatar-Profile-PNG-Isolated-Transparent-Picture.png",
            fit: BoxFit.scaleDown,
            height: 48,
            width: 48,
          ),
          const Padding(
            padding:  EdgeInsets.only(left: 4),
            child:  Text("Welcome, Ravi Kalola",
                style: TextStyle(
                  color: primaryTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                )),
          )
        ],
      ),
    );
  }
}
