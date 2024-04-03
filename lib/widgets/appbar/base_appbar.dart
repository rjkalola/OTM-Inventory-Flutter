import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final title;
  final isBack;
  final List<Widget>? widgets;

  BaseAppBar(
      {super.key, required this.appBar, this.title, this.isBack = false, this.widgets});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
      ),
      actions: widgets,
      centerTitle: true,
      automaticallyImplyLeading: isBack,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
