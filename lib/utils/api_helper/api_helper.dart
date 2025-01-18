import 'package:flutter_dotenv/flutter_dotenv.dart' ;

class ApiHelper {
  static String baseUrl = dotenv.env['BASE_URL'] ?? "";
  static String mobileNumVerification = "$baseUrl/checkMobile";
}
