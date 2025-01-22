import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiHelper {
  static String baseUrl = dotenv.env['BASE_URL'] ?? "";
  static String mobileNumVerification = "$baseUrl/checkMobile";
  static String newPatient = "$baseUrl/newPatient";
  static String getBranch = "$baseUrl/branches";
  static String verifyPassword = "$baseUrl/checkPassword";
  static String allDiseases = "$baseUrl/diseases";
  static String updateLang = "$baseUrl/updateLang";
}
