import 'package:flutter/material.dart';

import '../../../../res/colors.dart';
class SearchProductWidget extends StatelessWidget {
  const SearchProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: TextField(
        onChanged: (value) {
          // setModalState(() {
          //   filterSearchResults(value, list);
          // });
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 14, 0),
          prefixIcon: Icon(Icons.search, color: primaryTextColor),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffcccccc), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(45)),
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffcccccc), width: 1),
              borderRadius: BorderRadius.all(Radius.circular(45))
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffcccccc), width: 1),
              borderRadius: BorderRadius.all(Radius.circular(45))
          ),
          hintText: 'Search',
        ),
      ),
    );
  }

}
