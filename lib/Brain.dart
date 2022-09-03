import 'dart:convert';
import 'package:http/http.dart' as http;
class cryptobrain{
  cryptobrain(this.url);
  String url;

  Future getcryptodata() async {
    var cryptodata = await http.get(Uri.parse(url));
    if(cryptodata.statusCode == 200) {
      var data = cryptodata.body;
      print(cryptodata.statusCode);
      print(cryptodata.body);
      return jsonDecode(data);
    }
    else{
      print(cryptodata.statusCode);
    }
  }
}