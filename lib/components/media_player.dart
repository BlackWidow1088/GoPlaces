import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:GoPlaces/components/video_player_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MediaPlayer extends StatelessWidget {
  String mediaUrl;
  bool showHeart;
  MediaPlayer({this.mediaUrl, this.showHeart});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(alignment: Alignment.center, children: <Widget>[
      mediaUrl.contains('mp4')
          ? Container(
              height: 400.0,
              child: Center(child: new VideoPlayerScreen(url: mediaUrl)))
          : CachedNetworkImage(
              imageUrl: mediaUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => loadingPlaceHolder,
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
      showHeart
          ? Positioned(
              child: Opacity(
                  opacity: 0.85,
                  child: Icon(
                    FontAwesomeIcons.solidHeart,
                    size: 80.0,
                    color: Colors.white,
                  )),
            )
          : Container()
    ]);
  }

    Container loadingPlaceHolder = Container(
    height: 400.0,
    child: Center(child: CircularProgressIndicator()),
  );
}
