// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:course14/coin_data.dart';
import 'dart:io';
import 'package:course14/Brain.dart';

const apikey = '?apikey=BA8F972C-7A56-43C2-9B67-58DD41546FD7';

class pricescreen extends StatefulWidget {
  @override
  _pricescreenstate createState() => _pricescreenstate();
}

class _pricescreenstate extends State<pricescreen> {
  List<int> cryptoRatelist = [
    0,
    0,
    0,
  ];
  late int btcprice = 0;
  late int ethprice = 0;
  late int ltcprice = 0;

  Map<String, String> cryptoPrices = {};

  String selectedcurrency = 'USD';


//   Map<String,int> rates = {
//     'btcprice' : 0,
//     'ethprice' : 0,
//     'ltcprice' : 0,
// };

  @override
  void initState(){
    super.initState();
    getprice(selectedcurrency);
    // for (String crypto in cryptoList){
    //   print(crypto);
    //   cryptoPrices[crypto] = 'ab';
    //   print(cryptoPrices);
    // }
  }

  void getprice(String currency) async {
    for (String crypto in cryptoList) {
      cryptobrain brain = cryptobrain(
          'https://rest.coinapi.io/v1/exchangerate/$crypto/$currency$apikey');
      var cryptodata = await brain.getcryptodata();
      updateprice(cryptodata);
    }
  }

  void updateprice(dynamic cryptodata){
    setState((){
      var btcrate = cryptodata ['rate'];
      cryptoRatelist.add(btcrate.toInt());
    });
  }


  DropdownButton<String> androiddropdown() {
    List<DropdownMenuItem<String>> dropdownitem = [];

    for (String currency in currenciesList) {
      var newitem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownitem.add(newitem);
    }
    return DropdownButton<String>(
        value: selectedcurrency,
        items: dropdownitem,
        onChanged: (value) {
          setState(() {
            selectedcurrency = value!;
            getprice(value);
          });
        }

        );
  }

  CupertinoPicker iospicker(){
    List<Text> pickeritems = [];
    for (String currency in currenciesList) {
      pickeritems.add(Text(currency));
    }
    return CupertinoPicker(
      itemExtent: 30,
      onSelectedItemChanged: (selectedindex) {
        print(selectedindex);
      },
      children: pickeritems,
    );
  }

  Card makecard(String crypto,String price){
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.lightBlue,
      child: Padding(
        padding:
        const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0),
        child: Text(
          '1 $crypto = $price $selectedcurrency',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Column card (){
    List<Card> cards = [];
    for(String crypto in cryptoList){
      var currency = cryptoList[crypto].toInt();
      var price = cryptoRatelist[crypto];
        cards.add(makecard(currency, price));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children:
      cards,
    );
  }


  //============================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coin Ticker'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          card(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iospicker() : androiddropdown(),
          ),
        ],
      ),
    );
  }
}


