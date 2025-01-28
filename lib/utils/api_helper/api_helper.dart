import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiHelper {
  static String baseUrl = dotenv.env['BASE_URL'] ?? "";
  static String mobileNumVerification = "$baseUrl/checkMobile";
  static String newPatient = "$baseUrl/newPatient";
  static String getBranch = "$baseUrl/branches";
  static String verifyPassword = "$baseUrl/checkPassword";
  static String allDiseases({required int currentPage, int? perPage}) =>
      "$baseUrl/diseases?current_page=$currentPage&per_page=$perPage";
  static String getDiseases = "$baseUrl/diseases";
  static String updateLang = "$baseUrl/updateLang";
  static String createAppointment = "$baseUrl/appointment/store";
  static String getMedicalHistory({required int currentPage,int? perPage = 5}) => "$baseUrl/medicalHistory?current_page=$currentPage&per_page=$perPage";
}
