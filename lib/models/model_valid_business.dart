class ValidBusiness {
  final bool success;
  final String message;
  final dynamic data;
  final int code;

  ValidBusiness(
      this.success,
      this.message,
      this.data,
      this.code,
      );

  factory ValidBusiness.fromJson(Map<String, dynamic> json) {
    return ValidBusiness(
      json['status'] == 200,
      json['msg'] ?? 'Unknown',
      json['data'],
      json['code'] ?? 0,
    );
    /*return ResultApiModel(
      json['success'] ?? false,
      json['message'] ?? 'Unknown',
      json['data'],
      json['code'] ?? 0,
    );*/
  }
}
