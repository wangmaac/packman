import 'package:http/http.dart' as http;

class WellivService {
  Future setServer() async {
    Uri url = Uri(fragment: 'http', host: '', path: '', queryParameters: {});
    http.Response _response = await http.get(url);
  }
}
