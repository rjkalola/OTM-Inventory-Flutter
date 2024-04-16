import 'package:flutter/material.dart';

class TextFieldPhoneExtensionWidget extends StatelessWidget {
  const TextFieldPhoneExtensionWidget(
      {super.key, this.mFlag = "",
      this.mExtension = "",
      this.onPressed});

  final String? mFlag, mExtension;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(children: [
        Container(
          margin: const EdgeInsets.fromLTRB(14, 0, 0, 0),
          child: Image.network(
            mFlag ?? "",
            width: 32,
            height: 32,
          ),
        ),
        const Icon(
          Icons.arrow_drop_down,
          size: 24,
          color: Color(0xff000000),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
          child: Text(mExtension ?? "",
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              )),
        ),
      ]),
      onTap: () {
        onPressed!();
      },
    );
  }
}
