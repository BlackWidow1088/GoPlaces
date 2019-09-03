import 'package:flutter/material.dart';
import './data.service.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './app_range_slider.dart';

class FeedHeader extends StatefulWidget {
  String type;
  FeedHeader({this.type});
  @override
  State<FeedHeader> createState() => FeedHeaderState(this.type);
}

class FeedHeaderState extends State<FeedHeader> {
  String dropdownValue = 'General';
  String type;
FeedHeaderState(this.type);
  @override
  Widget build(BuildContext context) {
        return new ListView(scrollDirection: Axis.horizontal, children: [
          SizedBox(
            width: 50.0,
            height: 50.0,
            child: Padding(
                padding: EdgeInsets.fromLTRB(1.0, 15.0, 1.0, 15.0),
                child: Text(dataService.origin,
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(
                      fontSize: 13.0,
                      fontFamily: 'Roboto',
                      color: new Color(0xFF212121),
                      fontWeight: FontWeight.bold,
                    ))),
          ),
          // Padding(
          //     padding: EdgeInsets.fromLTRB(15.0, 15.0, 1.0, 15.0),
          //     child: Text('0.6km',
          //         overflow: TextOverflow.ellipsis,
          //         style: new TextStyle(
          //           fontSize: 13.0,
          //           fontFamily: 'Roboto',
          //           color: new Color(0xFF212121),
          //           fontWeight: FontWeight.bold,
          //         ))),
          // Padding(
          //   padding: EdgeInsets.fromLTRB(1.0, 15.0, 15.0, 15.0),
          //   child: new LinearPercentIndicator(
          //     width: 100.0,
          //     animation: true,
          //     lineHeight: 20.0,
          //     animationDuration: 2000,
          //     percent: 0.9,
          //     center: Text("0.6km"),
          //     linearStrokeCap: LinearStrokeCap.roundAll,
          //     progressColor: Colors.greenAccent,
          //   ),
          // ),
          AppRangeSlider(),
      dataService.destination != null ? 
         SizedBox(
            width: 50.0,
            height: 50.0,
            child: 
      Padding(
            padding: EdgeInsets.fromLTRB(1.0, 15.0, 1.0, 15.0),
            child: Text(dataService.destination,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(
                  fontSize: 13.0,
                  fontFamily: 'Roboto',
                  color: new Color(0xFF212121),
                  fontWeight: FontWeight.bold,
                )))): Container(),
      DropdownButton<String>(
        value: dropdownValue,
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: <String>['General', 'Travel', 'Food']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
            Padding(
        padding: EdgeInsets.fromLTRB(1.0, 10.0, 15.0, 15.0),
        child: Icon(
                    FontAwesomeIcons.cloudSun,
                    size: 25.0,
                    color: Colors.greenAccent,
                  ),
      )
    ]);
  }
}
