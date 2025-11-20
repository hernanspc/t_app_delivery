import 'user_company_info.dart';

class LoginResponse {
  final bool success;
  final dynamic message;
  final dynamic? type;
  final List<UserCompanyInfo> data;

  LoginResponse({
    required this.success,
    required this.message,
    this.type,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      type: json["type"],
      data: (json["data"] as List? ?? [])
          .map((e) => UserCompanyInfo.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "type": type,
    "data": data.map((e) => e.toJson()).toList(),
  };
}
