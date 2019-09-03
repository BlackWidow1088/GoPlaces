import 'package:flutter/material.dart';
import './data.service.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Topics extends StatelessWidget {
  List<Topic> topicData = [];
  List<String> topics = [
    'Nature',
    'Animals',
    'Travel',
    'Home Decor',
    'Insects',
    'Hiking',
    'Road Trips',
    'Home Renovation',
    'Food and Drink',
    'House Architecture',
    'Beautiful Places',
    'Landscape photography',
    'Hotels and Restaurents',
    'Interior Design',
    'Flowers',
    'Modern Architecture',
    'Furniture',
    'Hangout',
    'Events'
  ];
  Topics();

  @override
  Widget build(BuildContext context) {
    
    return new Container(
        // padding: const EdgeInsets.only(top: 0.0),

        child: new StaggeredGridView.countBuilder(
      crossAxisCount: 3,
      itemCount: topicData.length,
      // itemBuilder: (BuildContext context, int index) => new Container(
      //     color: Colors.green,
      //     child: new Center(
      //       child: new CircleAvatar(
      //         backgroundColor: Colors.white,
      //         child: new Text('$index'),
      //       ),
      //     )),
      itemBuilder: (BuildContext context, int index) => topicData[index],
      staggeredTileBuilder: (int index) {
        return new StaggeredTile.count(1, 1);
      },
      mainAxisSpacing: 1.0,
      crossAxisSpacing: 1.0,
    ));
  }
}

class Topic extends StatelessWidget {
  bool active = false;
  String text;
  Topic({this.text, this.active});
  @override
  Widget build(BuildContext context) {
    return Container(color: active ? Colors.lightBlueAccent : Colors.white, child:Text(text,
        overflow: TextOverflow.ellipsis,
        style: new TextStyle(
          fontSize: 13.0,
          fontFamily: 'Roboto',
          color: new Color(0xFF212121),
          fontWeight: FontWeight.bold,
        )));
  }
}
