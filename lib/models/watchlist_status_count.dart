class WatchlistStatusCount {
  final int id;
  final String name;
  final int count;

  WatchlistStatusCount({
    required this.id,
    required this.name,
    required this.count,
  });

  factory WatchlistStatusCount.fromJson(Map<String, dynamic> json) {
    return WatchlistStatusCount(
      id: json['id'],
      name: json['name'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'count': count,
    };
  }
}