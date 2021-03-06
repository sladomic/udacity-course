// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// TODO: Import relevant packages
import 'unit.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert' show json, utf8;

/// The REST API retrieves unit conversions for [Categories] that change.
///
/// For example, the currency exchange rate, stock prices, the height of the
/// tides change often.
/// We have set up an API that retrieves a list of currencies and their current
/// exchange rate (mock data).
///   GET /currency: get a list of currencies
///   GET /currency/convert: get conversion from one currency amount to another
class Api {
  // TODO: Add any relevant variables and helper functions
  final url = 'flutter.udacity.com';
  final httpClient = HttpClient();

  // TODO: Create getUnits()
  /// Gets all the units and conversion rates for a given category.
  ///
  /// The `category` parameter is the name of the [Category] from which to
  /// retrieve units. We pass this into the query parameter in the API call.
  ///
  /// Returns a list. Returns null on error.
  Future<List<Unit>> getUnits(String category) async {
    final uri = Uri.https(url, '/$category');
    Map<String, dynamic> jsonResponse = await _getResponse(uri);
    final data = jsonResponse['units'];
    return data.map<Unit>((dynamic data) => Unit.fromJson(data)).toList();
  }

  // TODO: Create convert()
  /// Given two units, converts from one to another.
  ///
  /// Returns a double, which is the converted amount. Returns null on error.
  Future<double> convert (
      String category, String amount, String fromUnit, String toUnit) async {
    final uri = Uri.https(url, '/$category/convert',
        {'amount': amount, 'from': fromUnit, 'to': toUnit});
    Map<String, dynamic> jsonResponse = await _getResponse(uri);
    return jsonResponse['conversion'].toDouble();
  }

    Future<Map<String, dynamic>> _getResponse(Uri uri) async {
    final HttpRequest = await httpClient.getUrl(uri);
    final HttpResponse = await HttpRequest.close();
    if (HttpResponse.statusCode != HttpStatus.OK) {
      return null;
    }
    final responseBody = await HttpResponse.transform(utf8.decoder).join();
    final jsonResponse = json.decode(responseBody);
    return jsonResponse;
  }
}
