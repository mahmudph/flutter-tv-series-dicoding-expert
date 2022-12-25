import 'package:flutter/material.dart';

import '../commons/constants.dart';

class SubheadingWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  const SubheadingWidget({
    Key? key,
    required this.title,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onPress,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Text('See More'),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
