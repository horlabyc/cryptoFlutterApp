import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List currencies;
  final List<MaterialColor> _colors = [Colors.blue, Colors.indigo, Colors.red];

  @override
  void initState() {
    super.initState();
    this.getCurrencies();
  }

  Future<List> getCurrencies() async {
    String url =
        "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest";
    var response = await http.get(url,
        headers: {"X-CMC_PRO_API_KEY": "15aaea24-29d9-4334-8271-7c9c86b7614c"});
    var responseJson = json.decode(response.body);
    setState(() {
      currencies = responseJson['data'];
    });
    print(currencies);
    return responseJson['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CryptoApp'),
      ),
      body: _cryptoWidget(),
    );
  }

  Widget _cryptoWidget() {
    return Container(
      child: Column(
        children: [
          Flexible(
              child: ListView.builder(
                  itemCount: currencies == null ? 0 : currencies.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Map currency = currencies[index];
                    final MaterialColor color = _colors[index % _colors.length];
                    return _getListItemUi(currency, color);
                  })),
        ],
      ),
    );
  }

  ListTile _getListItemUi(Map currency, MaterialColor color) {
    Map quote = currency['quote'];
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Text(
          currency['name'][0],
          style: TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        currency['name'],
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: _getSubTitleText(
          quote['USD']['price'], quote['USD']['percent_change_1h']),
    );
  }

  Widget _getSubTitleText(double priceUSD, double percentageChange) {
    TextSpan priceTextWidget =
        TextSpan(text: "\$$priceUSD\n", style: TextStyle(color: Colors.black));
    String percentageChangeText = "1 hour: $percentageChange";
    TextSpan percentageTextWidget;
    if (percentageChange > 0) {
      percentageTextWidget = TextSpan(
          text: percentageChangeText, style: TextStyle(color: Colors.green));
    } else {
      percentageTextWidget = TextSpan(
          text: percentageChangeText, style: TextStyle(color: Colors.red));
    }
    return RichText(
      text: TextSpan(children: [priceTextWidget, percentageTextWidget]),
    );
  }
}
