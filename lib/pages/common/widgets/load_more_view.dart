import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadMoreView extends StatelessWidget {
  const LoadMoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          const SizedBox(
              width: 20, height: 20, child: CircularProgressIndicator()),
          const SizedBox(
            width: 14,
          ),
          Text(
            'loading_more_'.tr,
            style: const TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
