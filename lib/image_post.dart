import 'package:GoPlaces/components/media_player.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'main.dart';
import 'dart:async';
import 'profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'comment_screen.dart';
import './components/media_player.dart';

class ImagePost extends StatefulWidget {
  ImagePost(
      {this.mediaUrl,
      this.username,
      this.location,
      this.description,
      this.likes,
      this.postId,
      this.ownerId,
      this.category,
      this.group,
      this.gesture,
      this.callback});

  factory ImagePost.fromDocument(
      DocumentSnapshot document, var gesture, var callback) {
    return ImagePost(
        username: document['username'],
        location: document['location'],
        mediaUrl: document['mediaUrl'],
        likes: document['likes'],
        description: document['description'],
        postId: document.documentID,
        ownerId: document['ownerId'],
        gesture: gesture,
        callback: callback);
  }

  factory ImagePost.fromJSON(Map data, var gesture, var callback) {
    return ImagePost(
        username: data['username'],
        location: data['location'],
        mediaUrl: data['mediaUrl'],
        likes: data['likes'],
        description: data['description'],
        ownerId: data['ownerId'],
        postId: data['postId'],
        gesture: gesture,
        callback: callback);
  }

  int getLikeCount(var likes) {
    if (likes == null) {
      return 0;
    }
// issue is below
    var vals = likes.values;
    int count = 0;
    for (var val in vals) {
      if (val == true) {
        count = count + 1;
      }
    }

    return count;
  }

  final String gesture;
  final callback;
  final String mediaUrl;
  final String username;
  final String location;
  final String description;
  final likes;
  final String postId;
  final String ownerId;
  final String category;
  final String group;
  Widget media;

  _ImagePost createState() => _ImagePost(
      mediaUrl: this.mediaUrl,
      username: this.username,
      location: this.location,
      description: this.description,
      likes: this.likes,
      likeCount: getLikeCount(this.likes),
      ownerId: this.ownerId,
      postId: this.postId,
      callback: this.callback,
      gesture: this.gesture);
}

class _ImagePost extends State<ImagePost> {
  final String mediaUrl;
  final String username;
  final String location;
  final String description;
  Map likes;
  int likeCount;
  final String postId;
  bool liked;
  final String ownerId;
  final callback;
  final gesture;

  bool showHeart = false;

  TextStyle boldStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  var reference = Firestore.instance.collection('insta_posts');

  _ImagePost(
      {this.mediaUrl,
      this.username,
      this.location,
      this.description,
      this.likes,
      this.postId,
      this.likeCount,
      this.ownerId,
      this.callback,
      this.gesture});

  GestureDetector buildLikeIcon() {
    Color color;
    IconData icon;

    if (liked) {
      color = Colors.pink;
      icon = FontAwesomeIcons.solidHeart;
    } else {
      icon = FontAwesomeIcons.heart;
    }

    return GestureDetector(
        child: Icon(
          icon,
          size: 25.0,
          color: color,
        ),
        onTap: () {
          _likePost(postId);
        });
  }


  GestureDetector buildLikeableImage() {
    // showMedia();
    return GestureDetector(
        onPanUpdate: (details) {
          print('called details');
          if (gesture == 'swipe_horizontal') {
            if (details.delta.dx > 0)
              callback(mediaUrl, true);
            else
              callback(mediaUrl, false);

            // if (details.delta.dy > 0)
            //   print("Dragging in +Y direction");
            // else
            //   print("Dragging in -Y direction");
          }
          return true;
        },
        onDoubleTap: () => _likePost(postId),
        onTap: () {
          if (gesture == 'open')
            callback(
                postId: postId,
                ownerId: ownerId,
                mediaUrl: mediaUrl);
        },
        child: MediaPlayer(mediaUrl: mediaUrl, showHeart: showHeart));
  }

  buildPostHeader({String ownerId}) {
    if (ownerId == null) {
      return Text("owner error");
    }

    return FutureBuilder(
        future: Firestore.instance
            .collection('insta_users')
            .document(ownerId)
            .get(),
        builder: (context, snapshot) {
          String imageUrl = " ";
          String username = "  ";

          if (snapshot.data != null) {
            imageUrl = snapshot.data.data['photoUrl'];
            username = snapshot.data.data['username'];
          }

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(imageUrl),
              backgroundColor: Colors.grey,
            ),
            title: GestureDetector(
              child: Text(username, style: boldStyle),
              onTap: () {
                openProfile(context, ownerId);
              },
            ),
            subtitle: Text(this.location),
            trailing: const Icon(Icons.more_vert),
          );
        });
  }



  @override
  Widget build(BuildContext context) {
    liked = (likes[googleSignIn.currentUser.id.toString()] == true);
    return Container(child: buildLikeableImage());
    // List View like instagram
    // return Column(
    //   mainAxisSize: MainAxisSize.min,
    //   children: <Widget>[
    //     buildPostHeader(ownerId: ownerId),
    //     buildLikeableImage(),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: <Widget>[
    //         Padding(padding: const EdgeInsets.only(left: 20.0, top: 40.0)),
    //         buildLikeIcon(),
    //         Padding(padding: const EdgeInsets.only(right: 20.0)),
    //         GestureDetector(
    //             child: const Icon(
    //               FontAwesomeIcons.comment,
    //               size: 25.0,
    //             ),
    //             onTap: () {
    //               goToComments(
    //                   context: context,
    //                   postId: postId,
    //                   ownerId: ownerId,
    //                   mediaUrl: mediaUrl);
    //             }),
    //       ],
    //     ),
    //     Row(
    //       children: <Widget>[
    //         Container(
    //           margin: const EdgeInsets.only(left: 20.0),
    //           child: Text(
    //             "$likeCount likes",
    //             style: boldStyle,
    //           ),
    //         )
    //       ],
    //     ),
    //     Row(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         Container(
    //             margin: const EdgeInsets.only(left: 20.0),
    //             child: Text(
    //               "$username ",
    //               style: boldStyle,
    //             )),
    //         Expanded(child: Text(description)),
    //       ],
    //     )
    //   ],
    // );
  }

  void _likePost(String postId2) {
    var userId = googleSignIn.currentUser.id;
    bool _liked = likes[userId] == true;

    if (_liked) {
      print('removing like');
      reference.document(postId).updateData({
        'likes.$userId': false
        //firestore plugin doesnt support deleting, so it must be nulled / falsed
      });

      setState(() {
        likeCount = likeCount - 1;
        liked = false;
        likes[userId] = false;
      });

      removeActivityFeedItem();
    }

    if (!_liked) {
      print('liking');
      reference.document(postId).updateData({'likes.$userId': true});

      addActivityFeedItem();

      setState(() {
        likeCount = likeCount + 1;
        liked = true;
        likes[userId] = true;
        showHeart = true;
      });
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  void addActivityFeedItem() {
    Firestore.instance
        .collection("insta_a_feed")
        .document(ownerId)
        .collection("items")
        .document(postId)
        .setData({
      "username": currentUserModel.username,
      "userId": currentUserModel.id,
      "type": "like",
      "userProfileImg": currentUserModel.photoUrl,
      "mediaUrl": mediaUrl,
      "timestamp": DateTime.now().toString(),
      "postId": postId,
    });
  }

  void removeActivityFeedItem() {
    Firestore.instance
        .collection("insta_a_feed")
        .document(ownerId)
        .collection("items")
        .document(postId)
        .delete();
  }
}

class MediaBinding extends InheritedWidget {
  MediaBinding({
    Key key,
    ImagePost child,
  }) : super(key: key, child: child);

  static ImagePost of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(MediaBinding) as MediaBinding)
        .child;
  }

  @override
  bool updateShouldNotify(MediaBinding oldWidget) => true;
}

class ImagePostFromId extends StatelessWidget {
  final String id;

  const ImagePostFromId({this.id});

  getImagePost() async {
    var document =
        await Firestore.instance.collection('insta_posts').document(id).get();
    return ImagePost.fromDocument(document, null, null);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getImagePost(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                padding: const EdgeInsets.only(top: 10.0),
                child: CircularProgressIndicator());
          return snapshot.data;
        });
  }
}

void goToComments(
    {BuildContext context, String postId, String ownerId, String mediaUrl}) {
  Navigator.of(context)
      .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
    return CommentScreen(
      postId: postId,
      postOwner: ownerId,
      postMediaUrl: mediaUrl,
    );
  }));
}
