import 'package:familyai/gen/assets.gen.dart';
import 'package:familyai/ui/kit/theme.dart';
import 'package:flutter/material.dart';

import 'stub.dart';

/// Renders a SIGN IN button that calls `handleSignIn` onclick.
Widget buildSignInButton(String label,{HandleSignInFn? onPressed}) {
  return Material(
    color: AppColors.lightSmoke,
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    child: InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.padding1),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.images.signinGoogle.svg(),
            SizedBox(
              width: AppSizes.padding2,
            ),
            Text(
              label,
              style: AppStyles.black_17_500,
            )
          ],
        ),
      ),
    ),
  );
}