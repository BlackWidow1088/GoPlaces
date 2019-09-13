import 'package:flutter/material.dart';

class AppRangeSlider extends StatefulWidget {
  @override
  _RangeSliderState createState() {
    return _RangeSliderState();
  }
}

class _RangeSliderState extends State<AppRangeSlider> {
  double _value = 6.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: 110.0,
          // padding: EdgeInsets.symmetric(
          //   vertical: 16.0,
          //   horizontal: 16.0,
          // ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // In a row, column, listview, etc., a Flexible widget is a wrapper
              // that works much like CSS's flex-grow property.
              //
              // Any room left over in the main axis after
              // the widgets are given their width
              // will be distributed to all the flexible widgets
              // at a ratio based on the flex property you pass in.
              // Because this is the only Flexible widget,
              // it will take up all the extra space.
              //
              // In other words, it will expand as much as it can until
              // the all the space is taken up.
              Flexible(
                flex: 1,
                // A slider, like many form elements, needs to know its
                // own value and how to update that value.
                //
                // The slider will call onChanged whenever the value
                // changes. But it will only repaint when its value property
                // changes in the state using setState.
                //
                // The workflow is:
                // 1. User drags the slider.
                // 2. onChanged is called.
                // 3. The callback in onChanged sets the sliderValue state.
                // 4. Flutter repaints everything that relies on sliderValue,
                // in this case, just the slider at its new value.
                child: 
                Slider(
                  activeColor: Colors.indigoAccent,
                  min: 0.0,
                  max: 15.0,
                  onChanged: (newRating) {
                    setState(() => _value = newRating);
                  },
                  value: _value,
                )),
              // ),

              // This is the part that displays the value of the slider.
              Container(
                width: 30.0,
                alignment: Alignment.centerLeft,
                child: Text('${_value.toInt()}',
                style: new TextStyle(
                      fontSize: 13.0,
                      fontFamily: 'Roboto',
                      color: new Color(0xFF212121),
                      fontWeight: FontWeight.bold,
                    ),
              )),
            ],
          ),
        );
  }
}
