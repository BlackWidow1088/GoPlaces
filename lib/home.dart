import 'package:GoPlaces/components/google_map_page.dart';
import 'package:flutter/material.dart';
import 'image_post.dart';
import 'feed.dart';
import 'main.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'post_screen.dart';

class Home extends StatefulWidget {
  _Home createState() => _Home();
}
PageController pageController;
class _Home extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
int _page = 0;
  @override
  Widget build(BuildContext context) {
    bool direction = true;
    double value = 0.0;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if(value> details.globalPosition.dx) 
          direction = true;
        else 
          direction = false;
        value= details.globalPosition.dx;
      },
      onHorizontalDragEnd: (details) {
        if(direction == false) 
          onPageChanged(1);
        else 
        onPageChanged(0);
      },
      child:
      Scaffold(
            body: PageView(
              children: [
                Container(
                  color: Colors.white,
                  child: Feed(),
                ),
                Container(color: Colors.white, child: GoogleMapPage()),
              ],
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: onPageChanged,
            ),
    ));
  }
  // ensures state is kept when switching pages
  @override
  bool get wantKeepAlive => true;
   @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

    void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    pageController.jumpToPage(page);
    setState(() {
      this._page = page;
    });
  }
}
