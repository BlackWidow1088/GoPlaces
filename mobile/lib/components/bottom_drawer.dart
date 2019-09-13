import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "dart:async";
import '../image_post.dart';

class BottomDrawer extends StatefulWidget {
  BottomDrawer({Key key, this.callback}) : super(key: key);
  var callback;
  @override
  BottomDrawerState createState() => BottomDrawerState(this.callback);
}

class BottomDrawerState extends State<BottomDrawer> {
  String view = "normal"; // default view
  bool isVisible = false;
  var callback;
  BottomDrawerState(this.callback);
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(elevation: 0, child: Container(height: 1.0));
    // color: Color(0xff344955),        // child: Container(
    //   padding: EdgeInsets.symmetric(horizontal: 10.0),
    //   height: 1.0,
    //   child: Stack(
    //       alignment: Alignment(0, 0),
    //       overflow: Overflow.visible,
    //       children: <Widget>[
    //         Positioned(
    //           top: -40,
    //           child: Container(
    //               decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.all(Radius.circular(50)),
    //                   border:
    //                       Border.all(color: Color(0xff232f34), width: 2)),
    //               child: GestureDetector(
    //                 onTap: showMenu,
    //                 child: Center(
    //                   child: ClipOval(
    //                     child: Image.network(
    //                       "https://i.stack.imgur.com/S11YG.jpg?s=64&g=1",
    //                       fit: BoxFit.cover,
    //                       height: 36,
    //                       width: 36,
    //                     ),
    //                   ),
    //                 ),
    //               )),
    //         ),
    //         // IconButton(
    //         //   onPressed: showMenu,
    //         //   icon: Icon(Icons.menu),
    //         //   color: Colors.white,
    //         // ),
    //         // Spacer(),
    //         // IconButton(
    //         //   onPressed: () {},
    //         //   icon: Icon(Icons.add),
    //         //   color: Colors.white,
    //         // )
    //       ]),
    // ));
  }

  Row buildImageViewButtonBar() {
    Color isActiveButtonColor(String viewName) {
      if (view == viewName) {
        return Colors.blueAccent;
      } else {
        return Colors.black26;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.grid_on, color: isActiveButtonColor("normal")),
          onPressed: () {
            changeView("normal");
          },
        ),
        IconButton(
          icon: Icon(Icons.list, color: isActiveButtonColor("food")),
          onPressed: () {
            changeView("food");
          },
        ),
      ],
    );
  }

  changeView(String viewName) {
    setState(() {
      view = viewName;
    });
    showMenu();
  }

  Container buildRelatedView() {
    Future<List<ImagePost>> getPosts() async {
      List<ImagePost> posts = [];
      var snap = await Firestore.instance
          .collection('insta_posts')
          .where('group', isEqualTo: 'related')
          .where('category', isEqualTo: view)
          .orderBy("timestamp")
          .getDocuments();
      print('snapshots');
      print(snap);
      for (var doc in snap.documents) {
        posts.add(ImagePost.fromDocument(doc, 'open', callback));
      }
      // setState(() {
      //   postCount = snap.documents.length;
      // });

      return posts.reversed.toList();
    }

    // TODO: for now, given fixed height.

    return Container(
      height:100.0,
            child: FutureBuilder<List<ImagePost>>(
              future: getPosts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Container(
                      alignment: FractionalOffset.center,
                      padding: const EdgeInsets.only(top: 10.0),
                      child: CircularProgressIndicator());
                else {
                  // build the grid
                  print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
                  print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
                  print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
                  print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');

                  print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
                  print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
                  print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
                  print(snapshot.data);
                  return
                  ListView(
                    scrollDirection: Axis.horizontal,
                children: snapshot.data.map((ImagePost imagePost) {
              return imagePost;
            }).toList()
            );
                      // SingleChildScrollView(
                      // child: Column(
                      //   crossAxisAlignment: CrossAxisAlignment.stretch,
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: <Widget>[

                      // new ListView(
                      //     scrollDirection: Axis.horizontal,
                      //     children: snapshot.data);

                  // StaggeredGridView.countBuilder(
                  //   shrinkWrap: true,
                  //   crossAxisCount: 3,
                  //   itemCount: snapshot.data.length,
                  //   itemBuilder: (BuildContext context, int index) =>
                  //       snapshot.data[index],
                  //   staggeredTileBuilder: (int index) {
                  //     int count = (index - 1) % 6 == 0 ? 2 : 1;
                  //     return new StaggeredTile.count(count, count);
                  //   },
                  //   mainAxisSpacing: 1.0,
                  //   crossAxisSpacing: 1.0,
                  // );
                  // ]));
                }
              },
            ));
  }

  showMenu() {
    print('showing menu');
    setState(() {
      isVisible = true;
    });
    showBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 200.0,
              child: ListView(
                children: <Widget>[
                  buildImageViewButtonBar(),
                  Divider(),
                  buildRelatedView()
                ],
              ));

          ;
        });
  }

  popMenu() {
    if (isVisible) {
      Navigator.pop(context);
    }
    setState(() {
      isVisible = false;
    });
  }
  // showMenu() {
  //   print('showing menu');
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Container(
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(16.0),
  //               topRight: Radius.circular(16.0),
  //             ),
  //             color: Color(0xff232f34),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.end,
  //             children: <Widget>[
  //               Container(
  //                 height: 36,
  //               ),
  //               SizedBox(
  //                   height: (56 * 6).toDouble(),
  //                   child: Container(
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.only(
  //                           topLeft: Radius.circular(16.0),
  //                           topRight: Radius.circular(16.0),
  //                         ),
  //                         color: Color(0xff344955),
  //                       ),
  //                       child: Stack(
  //                         alignment: Alignment(0, 0),
  //                         overflow: Overflow.visible,
  //                         children: <Widget>[
  //                           // Positioned(
  //                           //   top: -36,
  //                           //   child: Container(
  //                           //     decoration: BoxDecoration(
  //                           //         borderRadius:
  //                           //             BorderRadius.all(Radius.circular(50)),
  //                           //         border: Border.all(
  //                           //             color: Color(0xff232f34), width: 10)),
  //                           //     child: Center(
  //                           //       child: ClipOval(
  //                           //         child: Image.network(
  //                           //           "https://i.stack.imgur.com/S11YG.jpg?s=64&g=1",
  //                           //           fit: BoxFit.cover,
  //                           //           height: 36,
  //                           //           width: 36,
  //                           //         ),
  //                           //       ),
  //                           //     ),
  //                           //   ),
  //                           // ),
  //                           Positioned(
  //                             child: ListView(
  //                               physics: NeverScrollableScrollPhysics(),
  //                               children: <Widget>[
  //                                 ListTile(
  //                                   title: Text(
  //                                     "Inbox",
  //                                     style: TextStyle(color: Colors.white),
  //                                   ),
  //                                   leading: Icon(
  //                                     Icons.inbox,
  //                                     color: Colors.white,
  //                                   ),
  //                                   onTap: () {},
  //                                 ),
  //                                 ListTile(
  //                                   title: Text(
  //                                     "Starred",
  //                                     style: TextStyle(color: Colors.white),
  //                                   ),
  //                                   leading: Icon(
  //                                     Icons.star_border,
  //                                     color: Colors.white,
  //                                   ),
  //                                   onTap: () {},
  //                                 ),
  //                                 ListTile(
  //                                   title: Text(
  //                                     "Sent",
  //                                     style: TextStyle(color: Colors.white),
  //                                   ),
  //                                   leading: Icon(
  //                                     Icons.send,
  //                                     color: Colors.white,
  //                                   ),
  //                                   onTap: () {},
  //                                 ),
  //                                 ListTile(
  //                                   title: Text(
  //                                     "Trash",
  //                                     style: TextStyle(color: Colors.white),
  //                                   ),
  //                                   leading: Icon(
  //                                     Icons.delete_outline,
  //                                     color: Colors.white,
  //                                   ),
  //                                   onTap: () {},
  //                                 ),
  //                                 ListTile(
  //                                   title: Text(
  //                                     "Spam",
  //                                     style: TextStyle(color: Colors.white),
  //                                   ),
  //                                   leading: Icon(
  //                                     Icons.error,
  //                                     color: Colors.white,
  //                                   ),
  //                                   onTap: () {},
  //                                 ),
  //                                 ListTile(
  //                                   title: Text(
  //                                     "Drafts",
  //                                     style: TextStyle(color: Colors.white),
  //                                   ),
  //                                   leading: Icon(
  //                                     Icons.mail_outline,
  //                                     color: Colors.white,
  //                                   ),
  //                                   onTap: () {},
  //                                 ),
  //                               ],
  //                             ),
  //                           )
  //                         ],
  //                       ))),
  //               Container(
  //                 height: 56,
  //                 color: Color(0xff4a6572),
  //               )
  //             ],
  //           ),
  //         );
  //       });
  // }
}
