class PageResponse <T>{
  late final int pageNo;
  late final int pageSize;
  late final int totalElements;
  late final int totalPages;
  late final bool hasNextPage;
  late final bool hasPreviousPage;
  late final List<T> data;

  PageResponse({
    required this.pageNo,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.data,
  });
  factory PageResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic> json) fromJsonT) {
    return PageResponse(
      pageNo: json['pageNo'] as int,
      pageSize: json['pageSize'] as int,
      totalElements: json['totalElements'] as int,
      totalPages: json['totalPages'] as int,
      hasNextPage: json['hasNextPage'] as bool,
      hasPreviousPage: json['hasPreviousPage'] as bool,
      data: (json['data'] as List<dynamic>).map((item) => fromJsonT(item as Map<String, dynamic>)).toList(),
    );
  }
}