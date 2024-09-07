import 'package:familyai/ui/kit/theme.dart';
import 'package:flutter/material.dart';

class HorizontalSeparatorText extends StatelessWidget{
  final String text;

  const HorizontalSeparatorText({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(
          height: 1,
          color: AppColors.lightSmoke,
        )),
        const SizedBox(width: 8,),
        Text(text,style: AppStyles.grey_14_400),
        const SizedBox(width: 8,),
        Expanded(child: Container(
          height: 1,
          color: AppColors.lightSmoke,
        ))
      ],
    );
  }

}