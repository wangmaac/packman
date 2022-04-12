import 'package:http/http.dart' as http;

class WellivService {
  Future setServer() async {
    Uri url = Uri(
        fragment: 'http',
        host: 'm.welliv.co.kr',
        path: '/android_app/w/packman/ranking_insert.jsp',
        queryParameters: {'pEmpNo': '', 'pRecord': ''});
    http.Response _response = await http.get(url);
  }
}
