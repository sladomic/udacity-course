// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'unit.dart';

import 'dart:math';

const _padding = EdgeInsets.all(16.0);

/// [ConverterRoute] where users can input amounts to convert in one [Unit]
/// and retrieve the conversion in another [Unit] for a specific [Category].
///
/// While it is named ConverterRoute, a more apt name would be ConverterScreen,
/// because it is responsible for the UI at the route's destination.
class ConverterRoute extends StatefulWidget {
  /// This [Category]'s name.
  final String name;

  /// Color for this [Category].
  final Color color;

  /// Units for this [Category].
  final List<Unit> units;

  /// This [ConverterRoute] requires the name, color, and units to not be null.
  const ConverterRoute({
    @required this.name,
    @required this.color,
    @required this.units,
  })  : assert(name != null),
        assert(color != null),
        assert(units != null);

  @override
  _ConverterRouteState createState() => _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterRoute> {
  // TODO: Set some variables, such as for keeping track of the user's input
  // value and units
  String _inputUnit;
  String _outputUnit;

  double _inputValue;
  double _outputValue;

  // TODO: Determine whether you need to override anything, such as initState()
  @override
  void initState() {
    super.initState();
    _inputUnit = widget.units[0].name;
    _outputUnit = widget.units[1].name;
    _inputValue = 1.0;
    _outputValue = widget.units
            .singleWhere((unit) => unit.name == _outputUnit)
            .conversion *
        _inputValue;
  }

  // TODO: Add other helper functions. We've given you one, _format()

  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Create the 'input' group of widgets. This is a Column that includes
    // includes the output value, and 'from' unit [Dropdown].
    var inputGroup = new Padding(
      padding: new EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _inputValue = double.parse(_format(double.parse(value)));
                _outputValue = widget.units
                        .singleWhere((unit) => unit.name == _outputUnit)
                        .conversion *
                    _inputValue;
              });
            },
            decoration: InputDecoration(
              labelText: 'Input',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(
              text: _inputValue.toString(),
            ),
          ),
          new DropdownButton(
            items: widget.units.map((unit) {
              return new DropdownMenuItem(
                  value: unit.name, child: new Text(unit.name));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _inputUnit = value;
                _outputValue = widget.units
                        .singleWhere((unit) => unit.name == _outputUnit)
                        .conversion *
                    _inputValue;
              });
            },
            value: _inputUnit,
          ),
        ],
      ),
    );

    // TODO: Create a compare arrows icon.
    var compareArrows = Transform(
      transform: new Matrix4.rotationZ(PI / 2),
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
        color: widget.color,
      ),
      origin: new Offset(20.0, 20.0),
    );

    // TODO: Create the 'output' group of widgets. This is a Column that
    var outputGroup = new Padding(
      padding: new EdgeInsets.all(16.0),
      child: new Column(
        children: <Widget>[
          new TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Output',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(
              text: _outputValue.toString(),
            ),
          ),
          new Padding(
            padding: new EdgeInsets.symmetric(vertical: 8.0),
            child: new DropdownButton(
              items: widget.units.map((unit) {
                return new DropdownMenuItem(
                    value: unit.name, child: new Text(unit.name));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _outputUnit = value;
                  _outputValue = widget.units
                          .singleWhere((unit) => unit.name == _outputUnit)
                          .conversion *
                      _inputValue;
                });
              },
              value: _outputUnit,
            ),
          )
        ],
      ),
    );

    // TODO: Return the input, arrows, and output widgets, wrapped in
    return Column(
        children: <Widget>[inputGroup, compareArrows, outputGroup],
        crossAxisAlignment: CrossAxisAlignment.center);

    // TODO: Delete the below placeholder code
    /* final unitWidgets = widget.units.map((Unit unit) {
      return Container(
        color: widget.color,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              unit.name,
              style: Theme.of(context).textTheme.headline,
            ),
            Text(
              'Conversion: ${unit.conversion}',
              style: Theme.of(context).textTheme.subhead,
            ),
          ],
        ),
      );
    }).toList();

    return ListView(
      children: unitWidgets,
    ); */
  }
}
