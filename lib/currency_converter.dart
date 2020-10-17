import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_crud/keys/api_keys.dart';
import 'package:http/http.dart' as http;

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final _controlINR = TextEditingController();
  final _controlUSD = TextEditingController();
  final url = "http://data.fixer.io/api/latest?access_key=" +
      APIKeys.fixerKey +
      "&symbols=INR,USD&format=1";
  List data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('INR to USD via API call'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 30),
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: Column(children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: "INR",
            ),
            controller: _controlINR,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: "USD",
            ),
            controller: _controlUSD,
            enabled: false,
          ),
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: ButtonTheme(
              minWidth: 100,
              height: 50,
              child: RaisedButton(
                child: Text("Convert"),
                color: Colors.lightGreen,
                onPressed: () {
                  setState(() {
                    var text = _fetchJSONData();
                  });
                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: Text("API from Fixer.io"),
          ),
        ]),
      ),
    );
  }

  Future<String> _fetchJSONData() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var jsonData = jsonDecode(response.body);
    var inr = jsonData['rates']['INR'];
    var usd = jsonData['rates']['USD'];
    setState(() {
      var amount = int.parse(_controlINR.text);
      if (amount < 0) {
        _controlUSD.text = "Amount cannot be negative";
      } else if (amount == 0) {
        _controlUSD.text = "0.00";
      } else {
        _controlUSD.text = ((amount / inr) * usd).toStringAsFixed(2);
      }
    });
  }
}
