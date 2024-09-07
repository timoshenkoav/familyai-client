import 'dart:async';

import 'package:familyai/ui/kit/loading_button/view.dart';
import 'package:familyai/ui/kit/theme.dart';
import 'package:flutter/material.dart';
class LoadingTextButton extends StatelessWidget {
  final Widget child;
  final FutureOr<void> Function()? onPressed;
  final EdgeInsets? contentPadding;
  final bool enabled;
  const LoadingTextButton({super.key, this.onPressed, required this.child, this.contentPadding, this.enabled=true});
  @override
  Widget build(BuildContext context) {
   return LoadingButtonPage(

     content: Row(
       crossAxisAlignment: CrossAxisAlignment.center,
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         child
       ],
     ),
     contentPadding: contentPadding,
     color: Colors.transparent,
     enabled: enabled,
     onClick: onPressed,
   );
  }
}
class SimpleLabelledButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final FutureOr<void> Function()? onClick;
  final Color? color;
  final EdgeInsets? contentPadding;

  const SimpleLabelledButton(
      {super.key,
      required this.label,
      this.enabled = true,
      this.onClick,
      this.color,
      this.contentPadding});

  @override
  Widget build(BuildContext context) {
    return LoadingButtonPage(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppStyles.black_16_500,
          )
        ],
      ),
      contentPadding: contentPadding,
      color: color,
      enabled: enabled,
      onClick: onClick,
    );
  }
}

