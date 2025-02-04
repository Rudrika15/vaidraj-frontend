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
  static String getMedicalHistory(
          {required int currentPage, int? perPage = 5}) =>
      "$baseUrl/medicalHistory?current_page=$currentPage&per_page=$perPage";
  static String contact = "$baseUrl/contact";
  static String feedback = "$baseUrl/feedback";
  static String appointments = "$baseUrl/appointments";
  static String getPrescriptionPdf({required int prescriptionId}) =>
      "$baseUrl/generatePdf/$prescriptionId";
  static String getProductsWithPagination(
          {required int currentPage, int? perPage = 5}) =>
      "$baseUrl/products?current_page=$currentPage&per_page=$perPage";
  static String getProductsDiseaseWise({required int diseaseId}) =>
      "$baseUrl/products/$diseaseId";
  static String getAllProducts = "$baseUrl/products";
  static String getHomeScreenVideo = "$baseUrl/videos";
  static String getAllYTVideos({required int currentPage, int? perPage = 3}) =>
      "$baseUrl/videos?q=all&current_page=$currentPage&per_page=$perPage";
  static String createPrescription = '$baseUrl/prescription';
  static String updatePrescription({required int pId}) =>
      "$baseUrl/prescription/$pId";
  static String getAllArticle({required int currentPage, int? perPage = 3}) =>
      "$baseUrl/articles?q=all&current_page=$currentPage&per_page=$perPage";
}
