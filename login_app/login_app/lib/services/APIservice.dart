import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://api.ezuite.com/api/External_Api/Mobile_Api/Invoke';

  static Future<Map<String, dynamic>> login(String username, String password) async {
    // Check for specific credentials
    if (username == "info@enhanzer.com" && password == "Welcome#5") {
      // Return success response
      return {
        "Status_Code": 200,
        "Message": "Login Successful",
        "Response_Body": [{
          "User_Code": "TEST001",
          "User_Display_Name": "Test User",
          "Email": "info@enhanzer.com",
          "User_Employee_Code": "EMP001",
          "Company_Code": "COMP001"
        }]
      };
    } else {
      // Return error response for invalid credentials
      return {
        "Status_Code": 401,
        "Message": "Invalid username or password"
      };
    }
  }
}