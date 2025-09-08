class BaseResponse<T> {
  late final int statusCode;
  late final String message;
  late final T? data;
  late final DateTime? timestamp;

  BaseResponse({
    required this.statusCode,
    required this.message,
    this.data,
    this.timestamp,
  });
  factory BaseResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic> json) fromJsonT) {
    return BaseResponse(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
    );
  }
}