import 'package:GoPlaces/components/bottom_drawer.dart';
import 'package:GoPlaces/components/media_player.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import "dart:async";
// import 'image_post.dart';
import "main.dart"; //for current user
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PostScreen extends StatefulWidget {
  final String postId;
  final String postOwner;
  final String postMediaUrl;
  final List<String> urls;

  const PostScreen({this.postId, this.postOwner, this.postMediaUrl, this.urls});
  @override
  _PostScreenState createState() => _PostScreenState(
      postId: this.postId,
      postOwner: this.postOwner,
      postMediaUrl: this.postMediaUrl,
      urls: this.urls);
}

class _PostScreenState extends State<PostScreen> {
  final String postId;
  final String postOwner;
  String postMediaUrl;
  final List<String> urls;
  final TextEditingController _commentController = TextEditingController();
  GlobalKey<BottomDrawerState> _keyBottomDrawer = GlobalKey();

  _PostScreenState({this.postId, this.postOwner, this.postMediaUrl, this.urls});


  // Row buildImageViewButtonBar() {
  //   Color isActiveButtonColor(String viewName) {
  //     if (view == viewName) {
  //       return Colors.blueAccent;
  //     } else {
  //       return Colors.black26;
  //     }
  //   }

  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: <Widget>[
  //       IconButton(
  //         icon: Icon(Icons.grid_on, color: isActiveButtonColor("normal")),
  //         onPressed: () {
  //           changeView("normal");
  //         },
  //       ),
  //       IconButton(
  //         icon: Icon(Icons.list, color: isActiveButtonColor("food")),
  //         onPressed: () {
  //           changeView("food");
  //         },
  //       ),
  //     ],
  //   );
  // }

  // changeView(String viewName) {
  //   setState(() {
  //     view = viewName;
  //   });
  // }

  slidePost(mediaUrl, direction) {
    int index = 0;
    for (int i = 0; i < urls.length; i++) {
      if (urls[i] == mediaUrl) {
        if (direction == false)
          index = i - 1;
        else if (direction == true)
          index = i + 1;
        else
          index = i;
        if (index < 0) {
          index = urls.length - 1;
        }
        if (index >= urls.length) {
          index = 0;
        }
        break;
      }
    }
    setState(() {
      postMediaUrl = urls[index];
    });
  }

  // Container buildRelatedView() {
  //   Future<List<ImagePost>> getPosts() async {
  //     List<ImagePost> posts = [];
  //     var snap = await Firestore.instance
  //         .collection('insta_posts')
  //         .where('group', isEqualTo: 'related')
  //         .where('category', isEqualTo: view)
  //         .orderBy("timestamp")
  //         .getDocuments();
  //     print('snapshots');
  //     print(snap);
  //     for (var doc in snap.documents) {
  //       posts.add(ImagePost.fromDocument(doc, 'open', (
  //           {String postId, String ownerId, String mediaUrl}) {
  //         slidePost(mediaUrl, null);
  //       }));
  //     }
  //     // setState(() {
  //     //   postCount = snap.documents.length;
  //     // });

  //     return posts.reversed.toList();
  //   }

  //   // TODO: for now, given fixed height.
  //   return new Container(
  //       height: 400.0,
  //       child: FutureBuilder(
  //         future: getPosts(),
  //         builder: (context, snapshot) {
  //           if (!snapshot.hasData)
  //             return Container(
  //                 alignment: FractionalOffset.center,
  //                 padding: const EdgeInsets.only(top: 10.0),
  //                 child: CircularProgressIndicator());
  //           else {
  //             // build the grid
  //             print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
  //             print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
  //             print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
  //             print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');

  //             print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
  //             print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
  //             print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
  //             print(snapshot.data);
  //             return StaggeredGridView.countBuilder(
  //               crossAxisCount: 3,
  //               itemCount: snapshot.data.length,
  //               itemBuilder: (BuildContext context, int index) =>
  //                   snapshot.data[index],
  //               staggeredTileBuilder: (int index) {
  //                 int count = (index - 1) % 6 == 0 ? 2 : 1;
  //                 return new StaggeredTile.count(count, count);
  //               },
  //               mainAxisSpacing: 1.0,
  //               crossAxisSpacing: 1.0,
  //             );
  //           }
  //         },
  //       ));
  // }

  GestureDetector buildMedia() {
    // showMedia();
    double value = 0.0;
    bool direction = true;
    return GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.globalPosition.dy > value) 
            direction = true;
          else 
            direction = false;
          value = details.globalPosition.dy;
        },
        onVerticalDragEnd: (details) {
          // double position =
          //     MediaQuery.of(context).size.height - details.globalPosition.dy;
          if (direction == false)
            _keyBottomDrawer.currentState.showMenu();
          else 
            _keyBottomDrawer.currentState.popMenu();
      
        },
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          if (details.globalPosition.dx > value) 
            direction = true;
          else 
            direction = false;
          value = details.globalPosition.dx;
        },
        onHorizontalDragEnd: (details) {
        _keyBottomDrawer.currentState.popMenu();
          direction == true
              ? slidePost(postMediaUrl, true)
              : slidePost(postMediaUrl, false);
        },
        // onHorizontalDragEnd: (details) {
        //   slidePost(postMediaUrl, direction);
        // },
        child:  MediaPlayer(mediaUrl: postMediaUrl, showHeart: false));
  }

  @override
  Widget build(BuildContext context) {
    // final media = MediaBinding.of(context).media;

    print('---------------------------------------------------');
    print('---------------------------------------------------');
    print(
        'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    print(
        'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    print(
        'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    // print(media);
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     "Posts",
        //     style: const TextStyle(color: Colors.black),
        //   ),
        //   backgroundColor: Colors.white,
        // ),
        body: buildMedia(),
            // ListView(children: <Widget>[
        // Divider(),
        // buildImageViewButtonBar(),
        // Divider(),
        // buildRelatedView()
        // ]),
        bottomNavigationBar: BottomDrawer(
            key: _keyBottomDrawer,
            callback: ({String postId, String ownerId, String mediaUrl}) {
              slidePost(mediaUrl, null);
            }));
  }

  // Widget buildPage() {
  //   return Column(
  //     children: [
  //       Expanded(
  //         child: buildComments(),
  //       ),
  //       Divider(),
  //       ListTile(
  //         title: TextFormField(
  //           controller: _commentController,
  //           decoration: InputDecoration(labelText: 'Write a comment...'),
  //           onFieldSubmitted: addComment,
  //         ),
  //         trailing: OutlineButton(
  //           onPressed: () {
  //             addComment(_commentController.text);
  //           },
  //           borderSide: BorderSide.none,
  //           child: Text("Post"),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget buildComments() {
  //   return FutureBuilder<List<Comment>>(
  //       future: getComments(),
  //       builder: (context, snapshot) {
  //         if (!snapshot.hasData)
  //           return Container(
  //               alignment: FractionalOffset.center,
  //               child: CircularProgressIndicator());

  //         return ListView(
  //           children: snapshot.data,
  //         );
  //       });
  // }

  // Future<List<Comment>> getComments() async {
  //   List<Comment> comments = [];

  //   QuerySnapshot data = await Firestore.instance
  //       .collection("insta_comments")
  //       .document(postId)
  //       .collection("comments")
  //       .getDocuments();
  //   data.documents.forEach((DocumentSnapshot doc) {
  //     comments.add(Comment.fromDocument(doc));
  //   });

  //   return comments;
  // }

  // addComment(String comment) {
  //   _commentController.clear();
  //   Firestore.instance
  //       .collection("insta_comments")
  //       .document(postId)
  //       .collection("comments")
  //       .add({
  //     "username": currentUserModel.username,
  //     "comment": comment,
  //     "timestamp": DateTime.now().toString(),
  //     "avatarUrl": currentUserModel.photoUrl,
  //     "userId": currentUserModel.id
  //   });

  //   //adds to postOwner's activity feed
  //   Firestore.instance
  //       .collection("insta_a_feed")
  //       .document(postOwner)
  //       .collection("items")
  //       .add({
  //     "username": currentUserModel.username,
  //     "userId": currentUserModel.id,
  //     "type": "comment",
  //     "userProfileImg": currentUserModel.photoUrl,
  //     "commentData": comment,
  //     "timestamp": DateTime.now().toString(),
  //     "postId": postId,
  //     "mediaUrl": postMediaUrl,
  //   });
  // }
}

// class Comment extends StatelessWidget {
//   final String username;
//   final String userId;
//   final String avatarUrl;
//   final String comment;
//   final String timestamp;

//   Comment(
//       {this.username,
//       this.userId,
//       this.avatarUrl,
//       this.comment,
//       this.timestamp});

//   factory Comment.fromDocument(DocumentSnapshot document) {
//     return Comment(
//       username: document['username'],
//       userId: document['userId'],
//       comment: document["comment"],
//       timestamp: document["timestamp"],
//       avatarUrl: document["avatarUrl"],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         ListTile(
//           title: Text(comment),
//           leading: CircleAvatar(
//             backgroundImage: NetworkImage(avatarUrl),
//           ),
//         ),
//         Divider(),
//       ],
//     );
//   }
// }
