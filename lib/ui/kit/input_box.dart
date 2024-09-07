
import 'package:familyai/ui/kit/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final nameInputFormatter =
    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z-. ]"));

class InputBoxWrapper extends StatelessWidget {
  final EdgeInsets contentPadding;
  final EdgeInsets containerPadding;
  final BorderRadiusGeometry? borderRadius;
  final Widget child;
  final double? height;

  const InputBoxWrapper(
      {super.key,
      this.contentPadding = EdgeInsets.zero,
      this.borderRadius,
      required this.child,
      this.height,
      this.containerPadding = const EdgeInsets.symmetric(horizontal: 16)});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        alignment: Alignment.centerLeft,
        padding: containerPadding,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: borderRadius),
        child: child);
  }
}

class LabeledInputBox extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final List<TextInputFormatter> formatters;
  final Widget? error;
  final Widget? trailing;
  final TextStyle? labelStyle;
  final FocusNode? focusNode;

  const LabeledInputBox(
      {super.key,
      required this.hint,
      this.error,
      this.trailing,
      this.labelStyle,
      required this.controller,
      required this.formatters,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      inputFormatters: formatters,
      focusNode: focusNode,
      decoration: InputDecoration(
          label: Text(
            hint,
            style: labelStyle ?? AppStyles.grey_16_400,
          ),
          isDense: true,
          error: error,
          suffix: trailing,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          )),
    );
  }
}

class InputBox extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int? maxLines;
  final int? minLines;
  final double? height;
  final EdgeInsets contentPadding;
  final EdgeInsets containerPadding;
  final BorderRadiusGeometry? borderRadius;
  final FocusNode? focusNode;
  final Widget? trailing;
  final List<TextInputFormatter>? formatters;
  final void Function()? onSend;

  const InputBox(
      {super.key,
      required this.hint,
      required this.controller,
      this.obscureText = false,
      this.keyboardType = TextInputType.text,
      this.contentPadding = EdgeInsets.zero,
      this.containerPadding = const EdgeInsets.symmetric(horizontal: 16),
      this.maxLines,
      this.minLines,
      this.borderRadius = const BorderRadius.all(Radius.circular(10)),
      this.height,
      this.focusNode,
      this.trailing,
      this.formatters,
      this.onSend});

  @override
  Widget build(BuildContext context) {
    return InputBoxWrapper(
      contentPadding: contentPadding,
      containerPadding: containerPadding.copyWith(
          right: trailing == null ? containerPadding.right : 0),
      borderRadius: borderRadius,
      height: height,
      child: Row(
        children: [
          Expanded(
              child: TextField(
            focusNode: focusNode,
            controller: controller,
            style: const TextStyle(),
            obscureText: obscureText,
            keyboardType: keyboardType,
            maxLines: obscureText ? 1 : maxLines,
            minLines: minLines,
            inputFormatters: formatters,
            onEditingComplete: () {
              if (controller.text.trim().isNotEmpty) {
                final send = onSend;
                if (send != null) {
                  send();
                }
              }
            },
            decoration: InputDecoration(
                constraints: const BoxConstraints(),
                contentPadding: contentPadding,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: AppStyles.grey_17_400),
          )),
          trailing
        ].nonNulls.toList(growable: false),
      ),
    );
  }
}
