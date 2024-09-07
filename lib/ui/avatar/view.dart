import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class AvatarPage extends StatelessWidget {
  final String avatarId;
  const AvatarPage({super.key, required this.avatarId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ObjectKey(avatarId),
      create: (BuildContext context) => AvatarBloc(avatarId),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }


  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<AvatarBloc>(context);

    return BlocBuilder<AvatarBloc, AvatarState>(builder: (context, state) {
      if (state is AvatarStateData) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              child: RTCVideoView(
                bloc.remoteRenderer, placeholderBuilder: (context) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),);
              },),
            ),
            Row(
              children: [
                Expanded(child: TextField(
                  controller: bloc.text,
                )),
                ValueListenableBuilder(valueListenable: bloc.processing, builder: (context, value, child) {
                  if (value){
                    return const Center(child: CircularProgressIndicator.adaptive(),);
                  }
                  return ElevatedButton(onPressed: () {
                    bloc.repeat();
                  }, child: const Text("Send"));
                },)
              ],
            )
          ],
        );
      }
      return const Center(child: CircularProgressIndicator.adaptive(),);
    },);
  }
}

