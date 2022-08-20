
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/widgets/video_player_item.dart';
import 'package:flutter/material.dart';

import '../common/enums/messages_enums.dart';



class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGIF({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;


    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          ) : type == MessageEnum.video
        ? VideoPlayerItem(
      videoUrl: message,
    ):CachedNetworkImage(
      imageUrl: message,
    );

    Future<void> getcontact(){

    }







  }
}
