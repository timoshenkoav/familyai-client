import 'dart:async';

import 'package:familyai/ui/kit/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class LoadingButtonPage extends StatelessWidget {
  final Widget content;
  final bool enabled;
  final FutureOr<void> Function()? onClick;
  final Color? color;
  final EdgeInsets? contentPadding;

  const LoadingButtonPage(
      {super.key,
      required this.content,
      this.enabled = true,
      this.onClick,
      this.color,
      this.contentPadding});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoadingButtonBloc(),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<LoadingButtonBloc>(context);

    return IgnorePointer(
      ignoring: !enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Container(
          height: 50,
          child: Material(
              color: color ?? AppColors.lemon,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: BlocBuilder<LoadingButtonBloc, LoadingButtonState>(
                builder: (context, state) {
                  if (state.loading) {
                    return const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8),
                      child: Center(
                          child: CircularProgressIndicator.adaptive()),
                    );
                  }
                  return InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      onTap: () {
                        if (!state.loading) {
                          final action = onClick;
                          if (action != null) {
                            bloc.onClick(action);
                          }
                        }
                      },
                      child: Padding(
                          padding: contentPadding ??
                              const EdgeInsets.symmetric(
                                  horizontal: 8),
                          child: content));
                },
              )),
        ),
      ),
    );
  }
}
