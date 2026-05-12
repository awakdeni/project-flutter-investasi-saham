class News {
  final int id;
  final String headline;
  final String summary;
  final String image;
  final String url;
  final int datetime;
  final String source;

  News({
    required this.id,
    required this.headline,
    required this.summary,
    required this.image,
    required this.url,
    required this.datetime,
    required this.source,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] ?? 0,
      headline: json['headline'] ?? '',
      summary: json['summary'] ?? '',
      image: json['image'] ?? '',
      url: json['url'] ?? '',
      datetime: json['datetime'] ?? 0,
      source: json['source'] ?? '',
    );
  }
}
