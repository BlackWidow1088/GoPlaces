import 'package:flutter/material.dart';
import 'components/feed_header.dart';
import 'image_post.dart';
import 'dart:async';
import 'main.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'post_screen.dart';

class Feed extends StatefulWidget {
  _Feed createState() => _Feed();
}

class _Feed extends State<Feed> with AutomaticKeepAliveClientMixin<Feed> {
  List<ImagePost> feedData;
  List<String> urls = [];

  @override
  void initState() {
    super.initState();
    this._loadFeed();
  }

  buildFeed() {
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

  void goToPost({String postId, String ownerId, String mediaUrl}) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return PostScreen(
          postId: postId,
          postOwner: ownerId,
          postMediaUrl: mediaUrl,
          urls: urls);
    }));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // reloads state when opened again
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0), // here the desired height
          child: AppBar(
            title: FeedHeader(type: 'Feed'),
            // title: const Text('GoPlaces',
            //     style: const TextStyle(
            //         fontFamily: "Billabong", color: Colors.black, fontSize: 35.0)),
            centerTitle: true,
            backgroundColor: Colors.white,
          )),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: buildFeed(),
      ),
    );
  }

  Future<Null> _refresh() async {
    await _getFeed();

    setState(() {});

    return;
  }

  _loadFeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString("feed");

    if (json != null) {
      List<Map<String, dynamic>> data =
          jsonDecode(json).cast<Map<String, dynamic>>();
      List<ImagePost> listOfPosts = _generateFeed(data);
      setState(() {
        feedData = listOfPosts;
      });
    } else {
      _getFeed();
    }
  }

  _getFeed() async {
    print("Staring getFeed");

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userId = googleSignIn.currentUser.id.toString();
    var url =
        'https://us-central1-ghumiyo-2a806.cloudfunctions.net/getFeed?uid=' +
            userId;
    var httpClient = HttpClient();

    List<ImagePost> listOfPosts;
    String result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        String json = await response.transform(utf8.decoder).join();
        prefs.setString("feed", json);
        List<Map<String, dynamic>> data =
            jsonDecode(json).cast<Map<String, dynamic>>();
        listOfPosts = _generateFeed(data);
        result = "Success in http request for feed";
      } else {
        result =
            'Error getting a feed: Http status ${response.statusCode} | userId $userId';
      }
    } catch (exception) {
      result = 'Failed invoking the getFeed function. Exception: $exception';
    }
    print(result);

    setState(() {
      feedData = listOfPosts;
    });
  }

  List<ImagePost> _generateFeed(List<Map<String, dynamic>> feedData) {
    List<ImagePost> listOfPosts = [];

    for (var postData in feedData) {
      urls.add(postData['mediaUrl']);
      listOfPosts.add(ImagePost.fromJSON(postData, 'open', goToPost));
    }

    return listOfPosts;
  }

  // ensures state is kept when switching pages
  @override
  bool get wantKeepAlive => true;
}
