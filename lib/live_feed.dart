import 'package:GoPlaces/components/feed_header.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'image_post.dart'; //needed to open image when clicked
import 'profile_page.dart'; // to open the profile page when username clicked
import 'main.dart'; //needed for currentuser id
import 'image_post.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'post_screen.dart';

class LiveFeedPage extends StatefulWidget {
  @override
  _LiveFeedPageState createState() => _LiveFeedPageState();
}

class _LiveFeedPageState extends State<LiveFeedPage> with AutomaticKeepAliveClientMixin<LiveFeedPage> {
    List<ImagePost> feedData;
  List<String> urls = [];
  @override
  Widget build(BuildContext context) {
    super.build(context); // reloads state when opened again

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0), // here the desired height
          child: AppBar(
            title: FeedHeader(type: 'Live'),
            // title: const Text('GoPlaces',
            //     style: const TextStyle(
            //         fontFamily: "Billabong", color: Colors.black, fontSize: 35.0)),
            centerTitle: true,
            backgroundColor: Colors.white,
          )),
      body: buildLiveFeed(),
    );
  }

  buildLiveFeed() {
    return Container(
      child: FutureBuilder(
          future: getFeed(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  alignment: FractionalOffset.center,
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CircularProgressIndicator());
            else {
              // return ListView(children: snapshot.data);
              return buildFeed(snapshot.data);
            }
          }),
    );
  }

  buildFeed(feedData) {
    if (feedData != null) {
      // return ListView(
      //   children: feedData,
      // );
      return new Container(
          // padding: const EdgeInsets.only(top: 0.0),

          child: new StaggeredGridView.countBuilder(
        crossAxisCount: 3,
        itemCount: feedData.length,
        // itemBuilder: (BuildContext context, int index) => new Container(
        //     color: Colors.green,
        //     child: new Center(
        //       child: new CircleAvatar(
        //         backgroundColor: Colors.white,
        //         child: new Text('$index'),
        //       ),
        //     )),
        itemBuilder: (BuildContext context, int index) => feedData[index],
        staggeredTileBuilder: (int index) {
          int count = (index - 1) % 6 == 0 ? 2 : 1;
          return new StaggeredTile.count(count, count);
        },
        mainAxisSpacing: 1.0,
        crossAxisSpacing: 1.0,
      ));
    } else {
      return Container(
          alignment: FractionalOffset.center,
          child: CircularProgressIndicator());
    }
  }
  getFeed() async {
    List<ImagePost> items = [];
    var snap = await Firestore.instance
        .collection('insta_live')
        .document(currentUserModel.id)
        .collection("items")
        .orderBy("timestamp")
        .getDocuments();

    for (var doc in snap.documents) {
      items.add(ImagePost.fromDocument(doc, 'open', goToPost));
    }
    return items;
  }
    void goToPost({String postId, String ownerId, String mediaUrl}) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return PostScreen(
          postId: postId,
          postOwner: ownerId,
          postMediaUrl: mediaUrl,
          urls: urls);
    }));
  }

  // ensures state is kept when switching pages
  @override
  bool get wantKeepAlive => true;

}

// class LiveFeedItem extends StatelessWidget {
//   final String username;
//   final String userId;
//   final String type; // types include liked photo, follow user, comment on photo
//   final String mediaUrl;
//   final String mediaId;
//   final String userProfileImg;
//   final String commentData;

//   LiveFeedItem(
//       {this.username,
//       this.userId,
//       this.type,
//       this.mediaUrl,
//       this.mediaId,
//       this.userProfileImg,
//       this.commentData});

//   factory LiveFeedItem.fromDocument(DocumentSnapshot document) {
//     return LiveFeedItem(
//       username: document['username'],
//       userId: document['userId'],
//       type: document['type'],
//       mediaUrl: document['mediaUrl'],
//       mediaId: document['postId'],
//       userProfileImg: document['userProfileImg'],
//       commentData: document["commentData"],
//     );
//   }

//   Widget mediaPreview = Container();
//   String actionText;

//   void configureItem(BuildContext context) {
//     if (type == "like" || type == "comment") {
//       mediaPreview = GestureDetector(
//         onTap: () {
//           openImage(context, mediaId);
//         },
//         child: Container(
//           height: 45.0,
//           width: 45.0,
//           child: AspectRatio(
//             aspectRatio: 487 / 451,
//             child: Container(
//               decoration: BoxDecoration(
//                   image: DecorationImage(
//                 fit: BoxFit.fill,
//                 alignment: FractionalOffset.topCenter,
//                 image: NetworkImage(mediaUrl),
//               )),
//             ),
//           ),
//         ),
//       );
//     }

//     if (type == "like") {
//       actionText = " liked your post.";
//     } else if (type == "follow") {
//       actionText = " starting following you.";
//     } else if (type == "comment") {
//       actionText = " commented: $commentData";
//     } else {
//       actionText = "Error - invalid LiveFeed type: $type";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//   }
// }

// openImage(BuildContext context, String imageId) {
//   print("the image id is $imageId");
//   Navigator.of(context)
//       .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
//     return Center(
//       child: Scaffold(
//           appBar: AppBar(
//             title: Text('Photo',
//                 style: TextStyle(
//                     color: Colors.black, fontWeight: FontWeight.bold)),
//             backgroundColor: Colors.white,
//           ),
//           body: ListView(
//             children: <Widget>[
//               Container(
//                 child: ImagePostFromId(id: imageId),
//               ),
//             ],
//           )),
//     );
//   }));
// }
